"""Read-only checks of recorded native UI, without exporting other apps' text."""
import json
import sqlite3
import time

PACKAGE = 'vn.power9.power9_office_routine'


def edit_sequence_from_labels(frames, original, target):
    """Require two edited forms separated by an observed unchanged saved value."""
    phase = 0
    for labels in frames:
        form = 'Đổi lịch hoạt động' in labels
        body = any('Đi bộ giữa giờ' in value for value in labels)
        target_seen = any(target in value for value in labels)
        original_seen = any(original in value for value in labels)
        home = 'Power9 Office Routine' in labels
        if phase == 0 and form and target_seen:
            phase = 1
        elif phase == 1 and not form and body and original_seen and not target_seen:
            phase = 2
        elif phase == 2 and form and target_seen:
            phase = 3
        elif phase == 3 and home and body and target_seen and 'Hoạt động hôm nay · 1' in labels:
            phase = 4
    return {'firstEditedFormSeen': phase >= 1, 'cancelPreservedOriginalSeen': phase >= 2,
            'secondEditedFormSeen': phase >= 3, 'savedHomeWithOneScheduleSeen': phase >= 4,
            'verified': phase == 4}


def observed_edit_sequence(database, session_id, original, target):
    with sqlite3.connect(database.as_uri() + '?mode=ro', uri=True) as db:
        rows = db.execute('''SELECT i.ui_tree FROM steps s JOIN images i
            ON i.image_name=s.pre_image_name OR i.image_name=s.post_image_name
            WHERE s.session_id=? ORDER BY s.step_number,
            CASE WHEN i.image_name=s.pre_image_name THEN 0 ELSE 1 END''', (session_id,)).fetchall()
    frames = []
    for (raw,) in rows:
        nodes = json.loads(raw or '[]')
        if not isinstance(nodes, list):
            continue
        frames.append([str(node.get(key, '')) for node in nodes
                       if isinstance(node, dict) and node.get('package') == PACKAGE
                       for key in ('text', 'content-desc')])
    return edit_sequence_from_labels(frames, original, target)


def terminal_output(database, session_id, timeout=10):
    """Wait for the terminal trace commit, which can lag HTTP completion."""
    deadline = time.monotonic() + timeout
    while True:
        with sqlite3.connect(database.as_uri() + '?mode=ro', uri=True) as db:
            rows = db.execute('SELECT action_taken FROM steps WHERE session_id=? ORDER BY step_number DESC', (session_id,)).fetchall()
        for (raw,) in rows:
            action = json.loads(raw or '{}')
            if action.get('action') == 'report_task_status':
                args = action.get('args', {})
                assert args.get('status') == 'completed', 'Terminal ARTEMIS tool did not report completion'
                if isinstance(args.get('observations'), dict):
                    return args['observations']
                return args.get('explanation')
        if time.monotonic() >= deadline:
            return None
        time.sleep(.25)


def observed_states(database, session_id):
    with sqlite3.connect(database.as_uri() + '?mode=ro', uri=True) as db:
        rows = db.execute('''SELECT i.ui_tree FROM steps s JOIN images i
            ON i.image_name=s.pre_image_name OR i.image_name=s.post_image_name
            WHERE s.session_id=?''', (session_id,)).fetchall()
    result = {'searchQuerySeen': False, 'emptyMessageSeen': False,
              'missingTimeErrorSeen': False, 'timePickerSeen': False,
              'nativeTimePickerSeen': False, 'androidPrintPreviewSeen': False,
              'timerPausedSeen': False, 'leaveSessionDialogSeen': False,
              'completionDeleteDialogSeen': False, 'pdfGeneratedSeen': False}
    for (raw,) in rows:
        nodes = json.loads(raw or '[]')
        if not isinstance(nodes, list):
            continue
        app_labels = []
        native_picker = False
        for node in nodes:
            if not isinstance(node, dict):
                continue
            if node.get('package', '').startswith('com.android.printspooler'):
                result['androidPrintPreviewSeen'] = True
            if node.get('package') == PACKAGE:
                app_labels.extend([node.get('text', ''), node.get('content-desc', '')])
            if node.get('package') == 'android' and any(
                word in node.get('resource-id', '').lower()
                for word in ['timepicker', 'time_picker', 'radial_picker', 'hours', 'minutes']
            ):
                native_picker = True
        result['searchQuerySeen'] |= any('zzzpower9nomatch' in value for value in app_labels)
        result['emptyMessageSeen'] |= any('Không tìm thấy hoạt động phù hợp' in value for value in app_labels)
        result['missingTimeErrorSeen'] |= any('Chọn giờ khi bật nhắc hoạt động' in value for value in app_labels)
        result['timePickerSeen'] |= (
            any(value.startswith('Chọn giờ ') for value in app_labels)
            and any(value.startswith('Chọn phút ') for value in app_labels)
            and 'OK' in app_labels
        )
        result['nativeTimePickerSeen'] |= native_picker
        result['timerPausedSeen'] |= 'Đã tạm dừng' in app_labels
        result['leaveSessionDialogSeen'] |= 'Ở lại' in app_labels and 'Bỏ phiên' in app_labels
        result['completionDeleteDialogSeen'] |= 'Xóa bản ghi này?' in app_labels
        result['pdfGeneratedSeen'] |= any('Power9-' in value and '.pdf' in value for value in app_labels)
    return result
