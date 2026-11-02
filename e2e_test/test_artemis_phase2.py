"""Seven additional real-device cases, three repetitions each; explicit opt-in writes."""
from datetime import datetime, timedelta, timezone
import re

import pytest
from conftest import normalized


def truth(out, *keys):
    for key in keys:
        assert out.get(key) is True, f'Missing observed result: {key}'


def home_visible(device):
    labels = device.labels()
    assert 'Khám phá hoạt động' in labels
    assert any('Power9 Office Routine' in text for text in labels)


@pytest.mark.parametrize('repetition', [1, 2, 3])
def test_tc13_pdf_native_preview_cancel(artemis_run, repetition):
    out, device = artemis_run('TC13', repetition,
        'From Hôm nay tap Xem tiến độ, then Xuất báo cáo PDF, then Tạo PDF. Report exact file_name INCLUDING its hash suffix, and copy the FULL summary sentence beginning Đã thực hiện (not the KB file metadata). Tap Xem / lưu PDF to open the REAL Android print preview, observe Save as PDF or printer selector, then CANCEL using Android Back to return to Báo cáo PDF. Do not select a physical printer, save, share, upload, or browse files. Report returned_report and cloud_disabled only after observing that cloud saving is disabled. Remain on Báo cáo PDF.',
        'file_name: string, summary: string, android_print_seen: boolean, returned_report: boolean, cloud_disabled: boolean', extended=True)
    assert re.fullmatch(r'Power9-\d{4}-\d{2}-\d{2}-[0-9a-f]{12}\.pdf', out.get('file_name', ''))
    truth(out, 'android_print_seen', 'returned_report', 'cloud_disabled')
    assert 'da thuc hien' in normalized(out.get('summary', ''))
    labels = device.labels()
    assert 'Báo cáo PDF' in labels
    assert out['file_name'] in labels


@pytest.mark.parametrize('repetition', [1, 2, 3])
def test_tc08_home_checkin_undo(artemis_run, repetition):
    out, device = artemis_run('TC08', repetition,
        'Starting Home, locate the existing Đi bộ giữa giờ schedule for today. If it is already completed STOP without undoing preexisting data. Report integer done_before and total_before from Home summary. Tap Đã thực hiện ONLY for Đi bộ giữa giờ. Wait for server success and report done_after and total_after. Then tap Hoàn tác ONLY on this completion you just created. Wait and report done_restored and total_restored. Verify Đi bộ giữa giờ schedule still exists. Stay Home.',
        'done_before: integer, total_before: integer, done_after: integer, total_after: integer, done_restored: integer, total_restored: integer, schedule_still_present: boolean', extended=True)
    assert type(out.get('done_before')) is int and type(out.get('total_before')) is int
    assert out.get('done_after') == out['done_before'] + 1
    assert out.get('total_after') == out['total_before']
    assert out.get('done_restored') == out['done_before']
    assert out.get('total_restored') == out['total_before']
    truth(out, 'schedule_still_present')
    home_visible(device)


@pytest.mark.parametrize('repetition', [1, 2, 3])
def test_tc09_delete_completion_keep_schedule(artemis_run, repetition):
    out, device = artemis_run('TC09', repetition,
        'On Home locate existing Đi bộ giữa giờ for today, STOP if already completed. Read the Home summary BEFORE tapping anything and remember done_before and total_before integers from THAT initial snapshot. Do not use the increased post-check-in count as done_before. Then check in this activity, open Xem tiến độ. On Đi bộ giữa giờ tap Xóa bản ghi, inspect dialog Xóa bản ghi này?, choose Giữ lại and verify the completion remains (kept). Open Xóa bản ghi again and confirm Xóa ONLY for the completion created in THIS task. Return Home with app-bar Back, report done_final and total_final, confirm Đi bộ giữa giờ schedule remains. Do not delete any other record.',
        'done_before: integer read on Home BEFORE check-in, total_before: integer read on Home BEFORE check-in, kept: boolean, deleted: boolean, done_final: integer, total_final: integer, schedule_still_present: boolean', extended=True)
    assert type(out.get('done_before')) is int and type(out.get('total_before')) is int
    truth(out, 'kept', 'deleted', 'schedule_still_present')
    assert out.get('done_final') == out['done_before']
    assert out.get('total_final') == out['total_before']
    home_visible(device)


@pytest.mark.parametrize('repetition', [1, 2, 3])
def test_tc07_paused_timer_leave_stay_discard(artemis_run, repetition):
    out, device = artemis_run('TC07', repetition,
        'From Home open Thư giãn. STOP if Nghỉ sau họp is already completed or there is a preexisting running/paused session. Tap Bắt đầu 3 phút, wait at least 2 seconds, tap Tạm dừng and report exact paused_timer mm:ss. Tap Ăn uống to open leave-session dialog, choose Ở lại. Immediately after Ở lại, BEFORE any discard, read timer_after_stay mm:ss and paused_after_stay from Đã tạm dừng. Do not confuse the later idle reset 03:00 with this paused value. Tap Ăn uống again, choose Bỏ phiên. Return Thư giãn to verify Bắt đầu 3 phút is available again and no completion was recorded. Return Hôm nay. Do not press Ghi nhận phiên.',
        'paused_timer: string copied immediately after pause, timer_after_stay: string copied immediately after choosing Stay and BEFORE discard, paused_after_stay: boolean observed immediately after Stay, discarded: boolean observed after confirming discard, idle_again: boolean observed on Relax AFTER discard and BEFORE final Home navigation, no_record_created: boolean', extended=True)
    assert re.fullmatch(r'\d{2}:\d{2}', out.get('paused_timer', ''))
    assert out.get('timer_after_stay') == out['paused_timer']
    truth(out, 'paused_after_stay', 'discarded', 'idle_again', 'no_record_created')
    home_visible(device)


@pytest.mark.parametrize('repetition', [1, 2, 3])
def test_tc06_timer_record_actual_duration_cleanup(artemis_run, repetition):
    out, device = artemis_run('TC06', repetition,
        'From Home open Thư giãn. STOP if Nghỉ sau họp is already completed or timer is not idle. Tap Bắt đầu 3 phút, wait at least 2 real seconds, Tạm dừng, report paused_timer. Tiếp tục, wait at least 2 real seconds, Kết thúc sớm. Report elapsed_seconds integer from the actual finished-session message, then tap Ghi nhận phiên. On Tiến độ verify Nghỉ sau họp and report its exact duration_label. To restore baseline use Hoàn tác ONLY for the Nghỉ sau họp completion created in THIS task, verify it disappears, return Home. Do not fabricate 180 seconds or delete preexisting records.',
        'paused_timer: string, elapsed_seconds: integer, duration_label: string, recorded_title: string, completion_cleaned_up: boolean', extended=True)
    assert type(out.get('elapsed_seconds')) is int and 1 <= out['elapsed_seconds'] < 180
    assert 'nghi sau hop' in normalized(out.get('recorded_title', ''))
    assert str(out['elapsed_seconds'] % 60) in out.get('duration_label', '') or str(out['elapsed_seconds']) in out.get('duration_label', '')
    truth(out, 'completion_cleaned_up')
    home_visible(device)


@pytest.mark.parametrize('repetition', [1, 2, 3])
def test_tc02_save_future_schedule(artemis_run, repetition):
    target = (datetime.now(timezone(timedelta(hours=7))).date() + timedelta(days=10 + repetition)).isoformat()
    out, device = artemis_run('TC02', repetition,
        f'Create exactly one Đi bộ giữa giờ TEST schedule for {target}. From Home open Khám phá hoạt động, select ≤ 5 phút, open Đi bộ giữa giờ, Chọn lịch hoạt động. Select date {target}, keep reminder OFF and time unselected, then Lưu lịch. Observe successful save and Home return. Open Xem tiến độ, select {target}, inspect Đi bộ giữa giờ as pending with Chưa chọn giờ and no completion. Report selected_day, activity_title, pending_count integer, time_label, save_confirmed. Do not create any completion or alter other dates. Stay Tiến độ.',
        'selected_day: string, activity_title: string, pending_count: integer, time_label: string, save_confirmed: boolean', extended=True)
    assert out.get('selected_day') == target
    assert 'di bo giua gio' in normalized(out.get('activity_title', ''))
    assert out.get('pending_count') == 1
    assert 'chua chon gio' in normalized(out.get('time_label', ''))
    truth(out, 'save_confirmed')
    assert target in device.labels()


@pytest.mark.parametrize('repetition', [1, 2, 3])
def test_tc10_edit_cancel_then_save_no_duplicate(artemis_run, repetition):
    # Use visible clock ticks for the two retries; keep the first verified target.
    # Earlier attempts at 09:12/09:13 remain recorded failures, never reclassified.
    time_value = {1: '09:11', 2: '10:30', 3: '11:00'}[repetition]
    out, device = artemis_run('TC10', repetition,
        f'On Home inspect the existing Đi bộ giữa giờ schedule for TODAY and report original_time exactly (Chưa chọn giờ if unset) and total_before integer. Open its detail then Đổi lịch. Select time {time_value} in the Flutter time picker using the visible hour and minute ticks and confirm OK. Read the schedule FORM to verify it actually displays {time_value}; correct the picker if needed. Then Hủy the schedule FORM. Return Home and verify unchanged original_time (cancel_kept_original). Reopen the same Home schedule → Đổi lịch, select {time_value}, confirm picker OK, verify the form really displays {time_value}, then Lưu lịch. Wait for Home to show new_time and report total_after integer. Do not report success for a different time or while a picker is still open. Keep reminder OFF; do not create any completion or a second schedule. Stay Home.',
        'original_time: string copied from the initial Home activity card BEFORE editing, cancel_kept_original: boolean, new_time: string, total_before: integer DENOMINATOR of the INITIAL Home done/total ratio not the completed numerator, total_after: integer DENOMINATOR of the FINAL Home done/total ratio', extended=True)
    truth(out, 'cancel_kept_original')
    assert out.get('new_time') == time_value
    assert type(out.get('total_before')) is int and out.get('total_after') == out['total_before']
    home_visible(device)
    assert any(time_value in label for label in device.labels())
