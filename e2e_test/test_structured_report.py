import json,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent/'runtime'))
from structured_report import structured_tools


def test_native_schema_changes_only_terminal_tool_and_keeps_original_unchanged():
    tools=[{'function':{'name':'click','parameters':{}}},{'function':{'name':'report_task_status','description':'report','parameters':{'type':'object','properties':{'status':{'type':'string'}},'required':['status']}}}]
    schema={'type':'object','properties':{'seen':{'type':'boolean'},'count':{'type':'integer'}}}
    result=structured_tools(tools,'Goal\nPOWER9_OBSERVATION_SCHEMA='+json.dumps(schema))
    assert result[0] is tools[0]
    assert 'observations' not in tools[1]['function']['parameters']['properties']
    assert result[1]['function']['parameters']['properties']['observations']==schema
    assert 'observations' in result[1]['function']['parameters']['required']
    assert not schema.get('required')  # Never force unobserved values to be invented.


def test_non_power9_goals_keep_original_tools():
    tools=[]
    assert structured_tools(tools,'ordinary goal') is tools
