"""Opt-in real-device tests. No credential is read by pytest or committed here."""
import asyncio
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time
import unicodedata
import xml.etree.ElementTree as ET

import pytest
from trace_observations import observed_states, terminal_output

ROOT = Path(__file__).resolve().parents[1]
PACKAGE = 'vn.power9.power9_office_routine'
SDK = ROOT / '.build/tools/artemis/packages/artemis-client/src'
sys.path.insert(0, str(SDK))


def pytest_addoption(parser):
    parser.addoption('--run-artemis', action='store_true', help='Call the real ARTEMIS daemon/model on the connected test phone')


def normalized(text):
    return ''.join(c for c in unicodedata.normalize('NFD', text.lower().replace('đ', 'd')) if unicodedata.category(c) != 'Mn')


class Device:
    def __init__(self, serial):
        self.serial = serial
        self.prefix = [os.environ.get('POWER9_ADB', 'adb'), '-s', serial]

    def adb(self, *args):
        return subprocess.check_output(self.prefix + list(args), timeout=25)

    def labels(self):
        # Reuse UIAutomator2's existing instrumentation. Starting a separate
        # `uiautomator dump` can be killed (137) while that service is resident.
        import uiautomator2
        device = uiautomator2.connect(self.serial)
        for attempt in range(12):
            raw = device.dump_hierarchy()
            tree = ET.fromstring(raw)
            if any(n.get('package') == PACKAGE for n in tree.iter('node')):
                return [n.get('text', '') or n.get('content-desc', '') for n in tree.iter('node') if n.get('package') == PACKAGE]
            time.sleep(.5)
        raise AssertionError('No Power9 semantics after bounded wait; unlock/open app, then retry. No model task submitted.')

    def require_unlocked(self):
        # Do not wake/unlock the user's phone or export other apps' hierarchy.
        policy = self.adb('shell', 'dumpsys', 'window', 'policy').decode(errors='replace')
        power = self.adb('shell', 'dumpsys', 'power').decode(errors='replace')
        assert not re.search(r'\bshowing=true\b', policy), 'Device locked; unlock Power9 before running ARTEMIS'
        assert 'mWakefulness=Awake' in power, 'Device asleep; wake/unlock Power9 before running ARTEMIS'

    def home(self):
        # Only discard unsaved navigation/drafts. No app-data reset or backend writes.
        self.require_unlocked()
        self.adb('shell', 'am', 'start', '-n', PACKAGE + '/.MainActivity')
        # Flutter semantics may lag resumed Activity after reopening the app.
        # Never press Back while only a stale SystemUI hierarchy is available.
        time.sleep(2)
        for _ in range(7):
            labels = self.labels()
            if 'Khám phá hoạt động' in labels:
                return
            # The app has a nested Navigator: use its explicit app-bar Back.
            # Android Back may leave the Activity instead of its inner route.
            # Do not keep issuing system Back into the launcher.
            import uiautomator2
            picker_cancel = next((label for label in labels if normalized(label) == 'huy'), None)
            if picker_cancel and 'OK' in labels and any(label.startswith('Chọn phút ') for label in labels):
                # A failed model call can leave this known Flutter dialog open.
                # Cancel only this unsaved picker; never confirm its selected time.
                ui = uiautomator2.connect(self.serial)
                target = ui(text=picker_cancel, packageName=PACKAGE)
                if not target.exists:
                    target = ui(description=picker_cancel, packageName=PACKAGE)
                target.click()
            elif 'Quay lại' in labels:
                uiautomator2.connect(self.serial)(description='Quay lại', packageName=PACKAGE).click()
            elif 'Hôm nay' in labels:
                # A previous case may have ended on another root tab. Only tap
                # a node from the app; never press Android Back into the launcher.
                uiautomator2.connect(self.serial)(description='Hôm nay', packageName=PACKAGE).click()
            else:
                raise AssertionError('No known safe app-bar Back target; keep current UI for inspection')
            time.sleep(1)
        raise AssertionError('Could not establish Today precondition without destructive reset')


@pytest.fixture
def artemis_run(request):
    if not request.config.getoption('--run-artemis'):
        pytest.skip('Real model/device calls require --run-artemis')
    from artemis_client import ArtemisClient
    serial = os.environ.get('POWER9_DEVICE_SERIAL')
    assert serial, 'Set POWER9_DEVICE_SERIAL to the authorized test device'
    device = Device(serial)
    device.home()

    def run(case, repetition, goal, fields):
        # Fail closed before EVERY model task. Credential remains in daemon only.
        node = os.environ.get('POWER9_NODE', 'node')
        check = subprocess.run([node, str(ROOT / '.build/check-model-billing.cjs')], cwd=ROOT, capture_output=True, text=True, timeout=40)
        assert check.returncode == 0 and json.loads(check.stdout)['billingEnabled'] is False, 'Billing unverified/changed; model task blocked'
        client = ArtemisClient(os.environ.get('ARTEMIS_BASE_URL', 'http://127.0.0.1:8019'), device_serial=serial)
        description = 'Return ONLY a JSON object with these observed fields: ' + fields + '. Use exact visible Vietnamese labels. Never invent observations or set a flag true for an unperformed action. Do not output personal data, IDs, credentials, or notifications.'
        safety = ' Only use Power9 Office Routine and its native Android picker. Do not log out, save a valid schedule, record activities, start timers, change permissions/settings, open Profile/debug tools, or send messages. An explicitly requested invalid save to test validation is allowed. Stop and report if login/unlock is required. '
        started = time.monotonic()
        task_id = None
        async def execute():
            nonlocal task_id
            # This upstream Flash path returns before Outputter and the remote
            # session endpoint omits output. Request explicit observed JSON in
            # the terminal tool; read that exact payload from its trace below.
            terminal_contract = ' When finished, put the requested JSON object in the explanation argument of report_task_status. Do not substitute a prose success summary. ' + description
            handle = await client.submit(goal + safety + terminal_contract, profile='flash', expected_output=description, enable_outputter=True, locked_app_package=PACKAGE)
            task_id = handle.task_id
            try:
                return await client.wait_for_task(task_id, timeout=240)
            except BaseException:
                await client.stop(task_id)
                raise
        result = asyncio.run(execute())
        output = result.output
        output_source = 'SDK result.output'
        if output is None:
            database = ROOT / '.build/artemis-run/traces/data_engine.db'
            output = terminal_output(database, result.trace_id)
            output_source = 'ARTEMIS recorded terminal report_task_status.args.explanation JSON (bounded commit wait)'
        if isinstance(output, str):
            cleaned = re.sub(r'^```(?:json)?\s*|\s*```$', '', output.strip())
            try:
                output = json.loads(cleaned)
            except json.JSONDecodeError:
                pass
        # Whitelist public task output. Raw traces may contain screenshots: keep ignored.
        record = {'case': case, 'repetition': repetition, 'traceId': result.trace_id, 'status': result.status, 'elapsedSeconds': round(time.monotonic()-started, 2), 'outputSource': output_source, 'output': output, 'assertionsPassed': False}
        record['nativeTraceObservations'] = observed_states(ROOT / '.build/artemis-run/traces/data_engine.db', result.trace_id)
        evidence = ROOT / 'evidence/artemis/phase1'
        evidence.mkdir(parents=True, exist_ok=True)
        path = evidence / f'{case}-run{repetition}-{result.trace_id}.json'
        public_fields = set(re.findall(r'([a-z_]+)\s*:', fields))
        if isinstance(output, dict):
            record['output'] = {key: value for key, value in output.items() if key in public_fields}
        else:
            record['output'] = None
        path.write_text(json.dumps(record, ensure_ascii=False, indent=2), encoding='utf-8')
        request.node.artemis_evidence = (path, record)
        assert result.succeeded, f'ARTEMIS task did not succeed: {result.status}; trace={result.trace_id}'
        assert isinstance(output, dict), f'Missing structured JSON output; trace={result.trace_id}'
        if case == 'TC03':
            assert record['nativeTraceObservations']['searchQuerySeen'], 'No native trace showing the entered query; reject AI-only claim'
            assert record['nativeTraceObservations']['emptyMessageSeen'], 'No native trace showing the expected empty state'
        if case == 'TC04':
            assert record['nativeTraceObservations']['missingTimeErrorSeen'], 'No native validation error in trace'
            assert record['nativeTraceObservations']['timePickerSeen'], 'No Flutter time picker dialog in recorded UI'
        return output, device
    return run


@pytest.hookimpl(hookwrapper=True)
def pytest_runtest_makereport(item, call):
    outcome = yield
    report = outcome.get_result()
    if report.when == 'call' and hasattr(item, 'artemis_evidence'):
        path, record = item.artemis_evidence
        record['assertionsPassed'] = report.passed
        path.write_text(json.dumps(record, ensure_ascii=False, indent=2), encoding='utf-8')
