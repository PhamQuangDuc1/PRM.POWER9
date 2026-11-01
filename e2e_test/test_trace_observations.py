import json
import sqlite3
from unittest.mock import patch

import pytest

from trace_observations import terminal_output


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
