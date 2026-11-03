"""Offline regression checks for setup failures; never connects to a device/model."""
from unittest.mock import Mock, patch

import pytest

from conftest import Device


def test_locked_phone_stops_before_launch():
    device = Device('offline-test')
    device.adb = Mock(side_effect=[b'KeyguardServiceDelegate showing=true', b'mWakefulness=Awake'])
    with pytest.raises(AssertionError, match='Device locked'):
        device.home()
    assert all(call.args[:2] != ('shell', 'am') for call in device.adb.call_args_list)


def test_sleeping_phone_stops_before_launch():
    device = Device('offline-test')
    device.adb = Mock(side_effect=[b'KeyguardServiceDelegate showing=false', b'mWakefulness=Dozing'])
    with pytest.raises(AssertionError, match='Device asleep'):
        device.home()
    assert device.adb.call_count == 2


def test_stale_hierarchy_is_retried_and_foreign_labels_are_filtered():
    device = Device('offline-test')
    foreign = '<hierarchy><node package="other.app" text="PRIVATE"/></hierarchy>'
    app = '<hierarchy><node package="vn.power9.power9_office_routine" text="Hôm nay"/><node package="other.app" text="PRIVATE"/></hierarchy>'
    ui = Mock()
    ui.dump_hierarchy.side_effect = [foreign, app]
    with patch('uiautomator2.connect', return_value=ui), patch('conftest.time.sleep'):
        assert device.labels() == ['Hôm nay']
    assert ui.dump_hierarchy.call_count == 2


def test_missing_app_hierarchy_fails_closed():
    device = Device('offline-test')
    ui = Mock()
    ui.dump_hierarchy.return_value = '<hierarchy><node package="other.app" text="PRIVATE"/></hierarchy>'
    with patch('uiautomator2.connect', return_value=ui), patch('conftest.time.sleep'):
        with pytest.raises(AssertionError, match='No Power9 semantics') as failure:
            device.labels()
    assert 'PRIVATE' not in str(failure.value)
    assert ui.dump_hierarchy.call_count == 12


def test_empty_flutter_semantics_waits_for_readable_product_tree():
    device = Device('offline-test')
    ui = Mock()
    ui.dump_hierarchy.side_effect = [
        '<hierarchy><node package="vn.power9.power9_office_routine"/></hierarchy>',
        '<hierarchy><node package="vn.power9.power9_office_routine" text="Hôm nay"/></hierarchy>',
    ]
    with patch('uiautomator2.connect', return_value=ui), patch('conftest.time.sleep'):
        assert device.labels() == ['Hôm nay']
    assert ui.dump_hierarchy.call_count == 2


def test_home_cancels_known_picker_before_appbar_back():
    device = Device('offline-test')
    device.require_unlocked = Mock()
    device.adb = Mock()
    device.labels = Mock(side_effect=[['Chọn phút 36', 'Huỷ', 'OK'], ['Quay lại'], ['Khám phá hoạt động', 'Power9 Office Routine']])
    ui = Mock()
    with patch('uiautomator2.connect', return_value=ui), patch('conftest.time.sleep'):
        device.home()
    assert ui.call_args_list[0].kwargs['text'] == 'Huỷ'
    assert ui.call_args_list[1].kwargs['description'] == 'Quay lại'
    assert ui.return_value.click.call_count == 2
    assert device.adb.call_count == 1


def test_progress_explore_cta_is_not_mistaken_for_home():
    device = Device('offline-test')
    device.require_unlocked = Mock()
    device.adb = Mock()
    device.labels = Mock(side_effect=[['Khám phá hoạt động', 'Tiến độ', 'Quay lại'], ['Khám phá hoạt động', 'Power9 Office Routine']])
    ui = Mock()
    with patch('uiautomator2.connect', return_value=ui), patch('conftest.time.sleep'):
        device.home()
    ui.assert_called_once_with(description='Quay lại', packageName='vn.power9.power9_office_routine')
    ui.return_value.click.assert_called_once()


def test_home_cancels_time_picker_text_input_mode():
    device = Device('offline-test')
    device.require_unlocked = Mock()
    device.adb = Mock()
    device.labels = Mock(side_effect=[['Nhập thời gian', 'Huỷ', 'OK'], ['Quay lại'], ['Khám phá hoạt động', 'Power9 Office Routine']])
    ui = Mock()
    with patch('uiautomator2.connect', return_value=ui), patch('conftest.time.sleep'):
        device.home()
    assert ui.call_args_list[0].kwargs['text'] == 'Huỷ'
    assert ui.return_value.click.call_count == 2
