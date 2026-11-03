"""Reject clipped cards; verification may scroll but never click to create success."""
from unittest.mock import Mock, patch
import xml.etree.ElementTree as ET

import pytest

from conftest import Device
from ui_viewport import PACKAGE, visible_target, is_today_home


def tree(rect='[0,600][400,790]', selected='true'):
    root = ET.Element('hierarchy')
    def add(**attrs):
        ET.SubElement(root, 'node', {'package': PACKAGE, **attrs})
    add(scrollable='true', bounds='[0,100][400,800]')
    add(text='Đi bộ 11:00', clickable='true', enabled='true', bounds=rect)
    add(text='Power9 Office Routine')
    add(text='Hôm nay', selected=selected, bounds='[0,800][100,900]')
    return root


@pytest.mark.parametrize('rect', ['[0,790][400,850]', '[0,799][400,800]', '[0,800][100,900]'])
def test_clipped_or_navbar_target_is_not_visible(rect):
    assert not visible_target(tree(rect), '11:00')


def test_home_identity_works_when_explore_cta_is_scrolled_away():
    assert is_today_home(tree())
    assert not is_today_home(tree(selected='false'))
    assert visible_target(tree(), '11:00')


def test_reveal_scrolls_only_product_viewport_and_never_clicks():
    ui = Mock()
    ui.dump_hierarchy.side_effect = [ET.tostring(tree('[0,790][400,850]'), encoding='unicode'),
                                    ET.tostring(tree(), encoding='unicode')]
    with patch('uiautomator2.connect', return_value=ui), patch('conftest.time.sleep'):
        Device('offline').reveal('11:00')
    ui.swipe.assert_called_once_with(200, 776, 200, 543, duration=.35)
    ui.assert_not_called()


def test_reveal_stops_at_bound_without_fabricating_result():
    ui = Mock()
    ui.dump_hierarchy.return_value = ET.tostring(tree('[0,790][400,850]'), encoding='unicode')
    with patch('uiautomator2.connect', return_value=ui), patch('conftest.time.sleep'):
        with pytest.raises(AssertionError, match='bounded scroll'):
            Device('offline').reveal('11:00', attempts=3)
    assert ui.swipe.call_count == 2
    ui.assert_not_called()
