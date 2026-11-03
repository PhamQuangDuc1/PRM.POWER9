import json
import sqlite3
from unittest.mock import patch

import pytest

from trace_observations import terminal_output, edit_sequence_from_labels


def database(tmp_path):
    path = tmp_path / 'trace.db'
    with sqlite3.connect(path) as db:
        db.execute('CREATE TABLE steps(session_id TEXT, step_number INTEGER, action_taken TEXT)')
    return path


def add_terminal(path, session, status='completed'):
    payload = json.dumps({'action':'report_task_status','args':{'status':status,'explanation':'{"observed":true}'}})
    with sqlite3.connect(path) as db:
        db.execute('INSERT INTO steps VALUES (?,1,?)',(session,payload))


def test_waits_for_commit_and_reads_only_requested_session(tmp_path):
    path = database(tmp_path)
    add_terminal(path, 'unrelated')
    with patch('trace_observations.time.sleep', side_effect=lambda _: add_terminal(path,'target')) as wait:
        assert json.loads(terminal_output(path,'target')) == {'observed': True}
    wait.assert_called_once()


def test_missing_terminal_is_not_invented(tmp_path):
    assert terminal_output(database(tmp_path),'missing',timeout=0) is None


def test_failed_terminal_is_rejected(tmp_path):
    path = database(tmp_path)
    add_terminal(path,'target','failed')
    with pytest.raises(AssertionError,match='did not report completion'):
        terminal_output(path,'target',timeout=0)


def test_native_observations_are_read_verbatim(tmp_path):
    path = database(tmp_path)
    payload = json.dumps({'action':'report_task_status','args':{'status':'completed','explanation':'summary','observations':{'seen':False,'count':0}}})
    with sqlite3.connect(path) as db:
        db.execute('INSERT INTO steps VALUES (?,1,?)',('target',payload))
    assert terminal_output(path,'target',timeout=0)=={'seen':False,'count':0}


def test_edit_sequence_requires_real_cancel_state_between_both_forms():
    form = ['Đổi lịch hoạt động', '11:00']
    old = ['Đi bộ giữa giờ', 'Chưa chọn giờ']
    home = ['Power9 Office Routine', 'Đi bộ giữa giờ\n11:00', 'Hoạt động hôm nay · 1']
    assert edit_sequence_from_labels([form,old,form,home], 'Chưa chọn giờ','11:00')['verified']
    assert not edit_sequence_from_labels([form,home], 'Chưa chọn giờ','11:00')['verified']
    assert not edit_sequence_from_labels([form,old,form,home[:-1]+['Hoạt động hôm nay · 2']], 'Chưa chọn giờ','11:00')['verified']
