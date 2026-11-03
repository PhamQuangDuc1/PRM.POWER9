"""Native terminal JSON schema, scoped to Power9 goals. Never invent observations."""
import copy
import json
import re

MARKER='POWER9_OBSERVATION_SCHEMA='


def observation_schema(goal):
    match=re.search(re.escape(MARKER)+r'(\{[^\n]+\})',goal)
    if not match: return None
    schema=json.loads(match.group(1))
    assert schema.get('type')=='object' and isinstance(schema.get('properties'),dict)
    assert all(value.get('type') in {'string','integer','boolean'} for value in schema['properties'].values())
    return schema


def structured_tools(tools,goal):
    schema=observation_schema(goal)
    if schema is None: return tools
    result=[]
    for original in tools:
        if original.get('function',{}).get('name')!='report_task_status':
            result.append(original);continue
        tool=copy.deepcopy(original)
        parameters=tool['function']['parameters']
        parameters['properties']['observations']=schema
        parameters['required']=list(dict.fromkeys([*parameters.get('required',[]),'observations']))
        tool['function']['description']+=' For this Power9 test, return the actually observed typed values in observations. Omit any field you did not observe; never invent values or claim an unperformed action. A failed task may use an empty observations object.'
        result.append(tool)
    return result
