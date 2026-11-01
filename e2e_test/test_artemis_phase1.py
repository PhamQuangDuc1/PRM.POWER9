"""Three distinct cases × three real runs. This is only phase 1 of Lab 3."""
import pytest
from conftest import normalized


@pytest.mark.parametrize('repetition', [1, 2, 3])
def test_tc11_four_tabs(artemis_run, repetition):
    out, device = artemis_run('TC11', repetition,
        'Starting on Hôm nay, visit Ăn uống, Thư giãn, Kết nối, then return Hôm nay. Inspect the main content of every tab without performing activities. In food_title report the ACTIVITY title inside the Food page, not the tab heading Ăn uống. In relax_title report the ACTIVITY title inside Relax, not the tab heading Thư giãn.',
        'food_title: observed activity title inside Food page string, relax_title: observed activity title inside Relax page string, connection_heading: string, returned_today: boolean')
    assert 'bua trua' in normalized(out.get('food_title', ''))
    assert 'nghi sau hop' in normalized(out.get('relax_title', ''))
    assert 'ket noi' in normalized(out.get('connection_heading', ''))
    assert out.get('returned_today') is True
    assert 'Khám phá hoạt động' in device.labels()


@pytest.mark.parametrize('repetition', [1, 2, 3])
def test_tc03_search_empty_reset(artemis_run, repetition):
    out, device = artemis_run('TC03', repetition,
        'From Hôm nay open Khám phá hoạt động. In Tìm hoạt động type zzzpower9nomatch, dismiss keyboard if needed, inspect the empty result. Copy the FULL visible empty-state sentence EXACTLY into empty_message, character for character; do not summarize or paraphrase it. Then tap Xóa bộ lọc (or Xóa tìm kiếm và bộ lọc), verify Đi bộ giữa giờ returns and the search field is empty. Report that restored activity title. Remain on Khám phá.',
        'empty_message: string, search_cleared: boolean, restored_activity_title: string')
    assert 'khong tim thay hoat dong phu hop' in normalized(out.get('empty_message', ''))
    assert out.get('search_cleared') is True
    assert 'di bo giua gio' in normalized(out.get('restored_activity_title', ''))
    labels = device.labels()
    assert any('Đi bộ giữa giờ' in label for label in labels)
    assert not any('zzzpower9nomatch' in label for label in labels)


@pytest.mark.parametrize('repetition', [1, 2, 3])
def test_tc04_validation_time_picker_cancel(artemis_run, repetition):
    out, device = artemis_run('TC04', repetition,
        'From Hôm nay open Khám phá hoạt động, open Đi bộ giữa giờ, then Chọn lịch hoạt động to create an UNSAVED new draft. Turn on Nhắc hoạt động but leave time unselected. Tap Lưu lịch ONCE to trigger missing-time validation (do not save any valid draft). Copy the error exactly. Open Chọn giờ and inspect the Flutter Material time picker dialog, CANCEL that picker, verify Chọn giờ remains unselected. Stay on the unsaved schedule form. Do not choose a time or retry saving.',
        'validation_message: string, time_picker_seen: boolean, picker_cancelled: boolean, time_unselected: boolean')
    assert 'chon gio khi bat nhac hoat dong' in normalized(out.get('validation_message', ''))
    assert out.get('time_picker_seen') is True
    assert out.get('picker_cancelled') is True
    assert out.get('time_unselected') is True
    labels = device.labels()
    assert 'Chọn giờ' in labels
    assert any('Chọn giờ khi bật nhắc hoạt động' in label for label in labels)
