"""Scoped native timer focus audit; never substitutes for human TalkBack use."""
import argparse
import json
import os
from pathlib import Path
import re
import shlex
import subprocess
import time

parser = argparse.ArgumentParser()
parser.add_argument('--run-device-accessibility', action='store_true')
parser.add_argument('--output', required=True, type=Path)
args = parser.parse_args()
if not args.run_device_accessibility:
    raise SystemExit('Explicit device opt-in required')
if args.output.exists():
    raise SystemExit('Use a new output directory; preserve earlier attempts')
adb = os.environ.get('POWER9_ADB', 'adb')
serial = os.environ['POWER9_DEVICE_SERIAL']
package = 'vn.power9.power9_office_routine'
args.output.mkdir(parents=True)
result = {
    'scope': 'timer pause -> Today -> Stay -> focus Today again',
    'modelCalls': 0,
    'humanGesturesAndSpeechAssessed': False,
    'behaviorPassed': False,
    'allActionFocusObserved': False,
    'actions': [],
    'checks': [],
}


def shell(*parts):
    return subprocess.check_output(
        [adb, '-s', serial, 'shell', *parts], timeout=30,
    ).decode(errors='replace').strip()


def native(*parts):
    command = ('CLASSPATH=/data/local/tmp/p9-lab3-a11y.jar '
               'app_process /system/bin P9AccessibilityAudit '
               + ' '.join(shlex.quote(p) for p in parts))
    raw = shell(command)
    return json.loads(raw[raw.index('{'):])


def snapshot(name):
    data = native()
    assert data['power9Nodes'], 'Power9 not foreground; stopping'
    (args.output / (name + '.json')).write_text(
        json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8',
    )
    return data['power9Nodes']


def has(nodes, label):
    return any(label in n['text'] + ' ' + n['description'] for n in nodes)


def check(name, passed):
    result['checks'].append({'name': name, 'passed': bool(passed)})
    assert passed, name


def activate(label):
    action = native('activate', label)
    result['actions'].append({'label': label, **action})
    print(json.dumps({'action': label, 'focused': action['focusedBeforeActivation'],
                      'clicked': action['clickActionAccepted']}, ensure_ascii=True), flush=True)
    assert action['clickActionAccepted'], 'Android rejected click: ' + label
    return action


def timer(nodes):
    values = []
    for node in nodes:
        label = node['text'] + ' ' + node['description']
        if 'Thời gian còn lại' in label:
            values.extend(re.findall(r'(?<!\d)\d{2}:\d{2}(?!\d)', label))
    assert len(set(values)) == 1, 'Expected one observable timer value'
    return values[0]


old_services = shell('settings', 'get', 'secure', 'enabled_accessibility_services')
old_enabled = shell('settings', 'get', 'secure', 'accessibility_enabled')
own_session = False
try:
    check('Device unlocked', 'isKeyguardShowing=true' not in shell('dumpsys', 'window'))
    initial = snapshot('initial-home')
    check('Start at Home', has(initial, 'Khám phá hoạt động'))
    talkback = 'com.google.android.marvin.talkback/com.google.android.marvin.talkback.TalkBackService'
    services = [] if old_services == 'null' else old_services.split(':')
    if talkback not in services:
        services.append(talkback)
    shell('settings', 'put', 'secure', 'enabled_accessibility_services', ':'.join(services))
    shell('settings', 'put', 'secure', 'accessibility_enabled', '1')
    time.sleep(8)
    check('TalkBack bound', 'Service[label=TalkBack' in shell('dumpsys', 'accessibility'))
    # TalkBack may open its own training Activity when enabled. Bring only
    # Power9 back to the front; never inspect or automate that training UI.
    shell('am', 'start', '-n', package + '/.MainActivity')
    time.sleep(2)
    check('Power9 foreground after TalkBack startup', has(snapshot('talkback-ready'), 'Khám phá hoạt động'))
    activate('Thư giãn')
    idle = snapshot('timer-idle')
    check('Timer idle; no existing session altered', has(idle, 'Bắt đầu 3 phút') and not has(idle, 'Tiếp tục'))
    activate('Bắt đầu 3 phút')
    own_session = True
    time.sleep(2)
    activate('Tạm dừng')
    paused = snapshot('timer-paused')
    result['pausedTimer'] = timer(paused)
    check('Timer paused', has(paused, 'Đã tạm dừng') and has(paused, 'Tiếp tục'))
    activate('Hôm nay')
    dialog = snapshot('leave-dialog')
    check('Leave dialog opens', has(dialog, 'Rời phiên thư giãn?') and has(dialog, 'Ở lại'))
    activate('Ở lại')
    stayed = snapshot('timer-after-stay')
    result['timerAfterStay'] = timer(stayed)
    check('Stay retains paused value', has(stayed, 'Đã tạm dừng') and result['timerAfterStay'] == result['pausedTimer'])
    repeated = activate('Hôm nay')
    result['todayAfterStay'] = {
        'focusActionAccepted': repeated['focusActionAccepted'],
        'focusedBeforeActivation': repeated['focusedBeforeActivation'],
        'clickActionAccepted': repeated['clickActionAccepted'],
    }
    again = snapshot('leave-dialog-again')
    check('Today still activates after Stay', has(again, 'Rời phiên thư giãn?') and has(again, 'Bỏ phiên'))
    activate('Bỏ phiên')
    own_session = False
    check('Returned Home', has(snapshot('final-home'), 'Khám phá hoạt động'))
    check('TalkBack remained bound', 'Service[label=TalkBack' in shell('dumpsys', 'accessibility'))
    result['behaviorPassed'] = True
    result['allActionFocusObserved'] = all(a['focusedBeforeActivation'] for a in result['actions'])
except Exception as error:
    result['error'] = type(error).__name__ + ': ' + str(error).replace(serial, '[device]')
finally:
    if own_session:
        try:
            current = snapshot('cleanup-precondition')
            if has(current, 'Bỏ phiên') and has(current, 'Rời phiên thư giãn?'):
                activate('Bỏ phiên')
            else:
                activate('Hôm nay')
                activate('Bỏ phiên')
            own_session = False
            result['ownSessionCleanedAfterFailure'] = True
        except Exception as error:
            result['cleanupError'] = type(error).__name__ + ': ' + str(error).replace(serial, '[device]')
    try:
        if old_services == 'null':
            shell('settings', 'delete', 'secure', 'enabled_accessibility_services')
        else:
            shell('settings', 'put', 'secure', 'enabled_accessibility_services', old_services)
        if old_enabled == 'null':
            shell('settings', 'delete', 'secure', 'accessibility_enabled')
        else:
            shell('settings', 'put', 'secure', 'accessibility_enabled', old_enabled)
        result['originalAccessibilitySettingsRestored'] = (
            shell('settings', 'get', 'secure', 'enabled_accessibility_services') == old_services
            and shell('settings', 'get', 'secure', 'accessibility_enabled') == old_enabled
        )
    finally:
        result['unrecordedTestSessionRemains'] = own_session
        (args.output / 'result.json').write_text(
            json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8',
        )
        print(json.dumps({k: v for k, v in result.items() if k != 'actions'}, ensure_ascii=True), flush=True)
if not result['behaviorPassed'] or not result.get('originalAccessibilitySettingsRestored'):
    raise SystemExit(1)
