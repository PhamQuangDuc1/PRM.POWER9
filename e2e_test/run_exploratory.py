"""Opt-in single Pro exploratory task. Records real duration, never pads time."""
import argparse,asyncio,json,os,subprocess,sys,time
from datetime import datetime,timezone,timedelta
from pathlib import Path
from conftest import Device,ROOT,PACKAGE
sys.path.insert(0,str(ROOT/'.build/tools/artemis/packages/artemis-client/src'))
from artemis_client import ArtemisClient

async def main():
    parser=argparse.ArgumentParser();parser.add_argument('--run-artemis',action='store_true');args=parser.parse_args()
    if not args.run_artemis: raise SystemExit('No model call without --run-artemis and explicit user consent')
    device=Device(os.environ['POWER9_DEVICE_SERIAL']);device.home()
    check=subprocess.run([os.environ.get('POWER9_NODE','node'),str(ROOT/'e2e_test/check_model_billing.cjs')],cwd=ROOT,capture_output=True,text=True,timeout=40)
    assert check.returncode==0 and json.loads(check.stdout)['billingEnabled'] is False,'Billing unverified; task blocked'
    budget_path=ROOT/'.build/artemis-run/deadline-budget.json';budget=json.loads(budget_path.read_text(encoding='utf-8'))
    assert budget['used']<budget['limit'];budget['used']+=1;budget_path.write_text(json.dumps(budget),encoding='utf-8')
    goal=('Conduct a genuine, unscripted PRO exploratory investigation of Power9 Office Routine for 15 to 20 minutes of active exploration. Choose paths based on what you discover, rather than executing a predefined test script. Investigate navigation, search/filter combinations, error/empty states, accessibility of controls, cancelling unsaved schedule drafts, and Android PDF preview cancellation. Do not stop early just because basic navigation works. Do not waste time waiting to satisfy duration. Record only issues actually observed, with screen/action/expected/actual/reproduction and uncertainty; an empty list is allowed when no issue is observed. Never invent findings. Only use Power9 and its Android PDF print preview. Do not open Profile/debug/notification shade, log out, change settings/permissions/connectivity, send/share, print/save files, upload, save valid schedules, record/check-in, delete/undo data, or start timers. Respect preexisting data. Stop if locked or login required. Finish on Home. Return JSON with issues array, areas_explored array and returned_home boolean; put the exact JSON in the terminal report_task_status explanation if needed.')
    local_now=datetime.now(timezone(timedelta(hours=7)))
    earliest=local_now+timedelta(minutes=15)
    goal += ' Session started at Asia/Saigon '+local_now.strftime('%H:%M:%S')+'; do not declare completion before '+earliest.strftime('%H:%M:%S')+'. Continue active investigation rather than waiting for that clock time. If you must stop earlier due to a blocker, report the blocker honestly.'
    client=ArtemisClient('http://127.0.0.1:8019',device_serial=device.serial)
    began=time.monotonic();stamp=datetime.now(timezone.utc).isoformat();handle=await client.submit(goal,profile='pro',expected_output='JSON: issues: array of actual observations, areas_explored: array, returned_home: boolean',enable_outputter=True,locked_app_package=PACKAGE,verification_level='final',explorer_mode='flash')
    try: result=await client.wait_for_task(handle.task_id,timeout=1200)
    except BaseException:
        await client.stop(handle.task_id)
        duration=time.monotonic()-began
        record={'profile':'pro','taskId':handle.task_id,'startedAtUtc':stamp,'elapsedSeconds':round(duration,2),'status':'interrupted_or_timeout','wallClockWithinTimeWindow':900<=duration<=1800,'durationRequirementMet':False,'activeExplorationNeedsTraceReview':True,'issuesVerified':False}
        (ROOT/'evidence/artemis/pro-exploratory.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
        raise
    duration=time.monotonic()-began
    # Raw model narrative/screenshots stay in ignored trace; do not export PII.
    record={'profile':'pro','traceId':result.trace_id,'startedAtUtc':stamp,'elapsedSeconds':round(duration,2),'status':result.status,'wallClockWithinTimeWindow':900<=duration<=1800,'durationRequirementMet':False,'activeExplorationNeedsTraceReview':True,'issuesVerified':False,'note':'Review original Pro trace locally before exporting issue text. No artificial sleep or duration padding. A completed task shorter than 15 minutes does not meet the exploratory requirement.'}
    (ROOT/'evidence/artemis/pro-exploratory.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(record))
if __name__=='__main__':asyncio.run(main())
