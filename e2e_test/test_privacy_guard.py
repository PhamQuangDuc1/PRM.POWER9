"""Offline checks: no phone, daemon, model, or real account data."""
import asyncio
import os
from pathlib import Path
import subprocess
import sys
from types import SimpleNamespace
from xml.etree.ElementTree import Element, SubElement, tostring

import pytest

from runtime.privacy_guard import PACKAGE, PrivateSurfaceBlocked, install_privacy_guard, validate_screen


def screen(*nodes):
    tree = Element('hierarchy')
    for node in nodes:
        SubElement(tree, 'node', {'package': PACKAGE, **node})
    return SimpleNamespace(ui_hierarchy_xml=tostring(tree, encoding='unicode'))


def test_home_account_label_allowed_but_email_and_profile_content_rejected():
    validate_screen(screen({'text': 'Hôm nay'}, {'content-desc': 'Tài khoản'}))
    for private in ('synthetic@example.invalid', 'Đăng xuất', 'Kiểm thử Firebase'):
        with pytest.raises(PrivateSurfaceBlocked, match='^private_content$') as error:
            validate_screen(screen({'text': private}))
        assert private not in str(error.value)


@pytest.mark.parametrize('candidate', [
    SimpleNamespace(ui_hierarchy_xml='<broken'),
    SimpleNamespace(ui_elements=[]),
    screen({'package': 'com.google.android.gms', 'text': 'Choose account'}),
    screen({'text': 'Hôm nay'}, {'package': 'com.android.systemui', 'text': 'Notification preview'}),
])
def test_unverified_foreign_or_notification_frames_blocked(candidate):
    with pytest.raises(PrivateSurfaceBlocked):
        validate_screen(candidate)


def test_print_preview_and_normal_status_allowed():
    validate_screen(screen({'package': 'com.android.printspooler', 'text': 'Save as PDF'},
                           {'package': 'com.android.systemui', 'text': '10:30'}))


def driver_for(candidate):
    class Driver:
        calls = 0
        async def get_screen_data(self, **kwargs):
            return candidate
        async def tap(self, *args, **kwargs):
            self.calls += 1
            return True
        swipe = tap
        input_text = tap
        press_key = tap
    install_privacy_guard(Driver)
    install_privacy_guard(Driver)  # Reinstallation must not recurse.
    return Driver()


def test_account_tap_blocked_before_input_and_stop_latched_for_other_actions():
    # Both attributes populated: combined-label matching previously missed this.
    driver = driver_for(screen({'text': 'Tài khoản', 'content-desc': 'Tài khoản',
                                'bounds': '[80,0][100,30]'}))
    with pytest.raises(PrivateSurfaceBlocked, match='^private_navigation$'):
        asyncio.run(driver.tap(90, 15))
    for action, args in ((driver.get_screen_data, ()), (driver.swipe, (0, 0, 1, 1)),
                         (driver.input_text, ('query',)), (driver.press_key, ('BACK',))):
        with pytest.raises(PrivateSurfaceBlocked, match='^privacy_stop_latched$'):
            asyncio.run(action(*args))
    assert driver.calls == 0


def test_rejected_frame_never_returned_and_public_tap_still_works():
    blocked = driver_for(screen({'text': 'synthetic@example.invalid'}))
    with pytest.raises(PrivateSurfaceBlocked):
        asyncio.run(blocked.get_screen_data())
    public = driver_for(screen({'content-desc': 'Tài khoản', 'bounds': '[80,0][100,30]'}))
    assert asyncio.run(public.tap(20, 60)) is True
    assert public.calls == 1


def test_missing_private_control_bounds_stops_before_input():
    driver = driver_for(screen({'content-desc': 'Tài khoản'}))
    with pytest.raises(PrivateSurfaceBlocked, match='unverified_private_control_bounds'):
        asyncio.run(driver.tap(20, 60))
    assert driver.calls == 0


def test_real_worker_startup_installs_guard_after_compatibility_adapters():
    root = Path(__file__).resolve().parents[1]
    env = dict(os.environ)
    env.update(POWER9_ARTEMIS_PRIVACY_GUARD='1', POWER9_ARTEMIS_ASCII_INPUT='1',
               POWER9_ARTEMIS_STRUCTURED_REPORT='1')
    env['PYTHONPATH'] = os.pathsep.join((str(root / 'e2e_test/runtime'),
                                       str(root / '.build/tools/artemis')))
    code = ('from artemis.drivers.android.adb_driver import AndroidAdbDriver as D; '
            'assert D._power9_privacy_guard_installed; '
            'assert D.input_text.__name__ == "action"; '
            'assert D.tap.__name__ == "checked_tap"; print("guard-installed")')
    result = subprocess.run([sys.executable, '-c', code], env=env, cwd=root,
                            capture_output=True, text=True, timeout=60)
    assert result.returncode == 0, 'Worker guard startup failed (no model launched)'
    assert 'guard-installed' in result.stdout
