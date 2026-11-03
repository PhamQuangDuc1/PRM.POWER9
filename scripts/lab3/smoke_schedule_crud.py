"""Real Power9 UI + scoped Firestore verification. No model calls or data resets."""
import json,os,re,subprocess,time,xml.etree.ElementTree as ET
from pathlib import Path
import argparse
parser=argparse.ArgumentParser(description='Native schedule CRUD smoke; only own test data, no model calls.')
parser.add_argument('--run-device-writes',action='store_true')
if not parser.parse_args().run_device_writes:raise SystemExit('Explicit --run-device-writes is required')
import uiautomator2 as u2
P='vn.power9.power9_office_routine'
adb=[os.environ['POWER9_ADB'],'-s',os.environ['POWER9_DEVICE_SERIAL']]
ui=u2.connect(os.environ['POWER9_DEVICE_SERIAL'])
folder=Path('evidence/flows/crud');folder.mkdir(exist_ok=True,parents=True)
record={'source':'native UIAutomator2 on real Xperia + exact test-user Firestore document reads','modelCalls':0,'assertionsPassed':False,'steps':[],'privateIdentifiersExported':False}
def sh(*a):return subprocess.check_output(adb+['shell']+list(a),timeout=25).decode(errors='replace').strip()
def nodes():return list(ET.fromstring(ui.dump_hierarchy()).iter('node'))
def labels():return [n.get('text') or n.get('content-desc') or n.get('hint') or '' for n in nodes() if n.get('package')==P]
def wait(predicate,seconds=20):
 end=time.monotonic()+seconds
 while time.monotonic()<end:
  if predicate():return True
  time.sleep(.5)
 return False
def visible(fragment):return any(fragment in s for s in labels())
def tap(label,scroll=True):
 for attempt in range(6 if scroll else 1):
  tree=nodes();assert any(n.get('package')==P for n in tree),'Power9 not foreground; no unrelated input'
  matches=[n for n in tree if n.get('package')==P and n.get('clickable')=='true' and n.get('enabled')=='true' and label in (n.get('text') or n.get('content-desc') or '')]
  if matches:
   matches.sort(key=lambda n:len(n.get('text') or n.get('content-desc') or ''))
   x1,y1,x2,y2=map(int,re.findall(r'\d+',matches[0].get('bounds')))
   if y2>y1 and x2>x1:ui.click((x1+x2)/2,(y1+y2)/2);time.sleep(.6);return
  if scroll:ui.swipe_ext('up',scale=.6);time.sleep(.4)
 raise AssertionError('App control unavailable: '+label)
def home():return visible('Power9 Office Routine') and visible('Khám phá hoạt động')
def screenshot(name):
 ls=labels();assert not any('@' in s or 'Kiểm thử Firebase' in s for s in ls),'Private/debug surface not exported'
 ui.screenshot(str(folder/(name+'-xperia.png')))
def server(phase):
 r=subprocess.run(['node','scripts/lab3/check_crud_server.cjs',phase,day],capture_output=True,text=True,encoding='utf-8',timeout=45)
 assert r.returncode==0,'Scoped server verification unavailable; raw error not exported'
 return json.loads(r.stdout.strip().splitlines()[-1])
assert 'mWakefulness=Awake' in sh('dumpsys','power'),'Unlock phone first'
assert not re.search(r'\bshowing=true\b',sh('dumpsys','window','policy')),'Phone locked'
sh('am','start','-n',P+'/.MainActivity')
for _ in range(4):
 if home():break
 if visible('Quay lại'):tap('Quay lại',scroll=False)
 else:break
assert wait(home),'Open Home first'
day=sh('date','+%F');record['deviceDate']=day
try:
 before=server('before');assert not before['scheduleExists'] and not before['completionExists'],'Preexisting walk data; no writes/deletes permitted'
 assert 'Hoạt động hôm nay · 0' in labels(),'Require empty current-day Home, no test reset'
 screenshot('before')
 tap('Khám phá hoạt động');assert wait(lambda:visible('Tìm hoạt động'))
 tap('Đi bộ giữa giờ');assert wait(lambda:visible('Chi tiết hoạt động'))
 tap('Chọn lịch hoạt động');assert wait(lambda:visible('Lưu lịch'));assert visible(day)
 tap('Lưu lịch');assert wait(home)
 created=server('created');assert created['scheduleExists'] and not created['completionExists']
 record['steps'].append('Create via schedule form, read on Home and Firestore')
 screenshot('created')
 tap('Đi bộ giữa giờ');tap('Đổi lịch');tap('Chọn giờ')
 tap('Chuyển sang chế độ nhập văn bản')
 fields=ui(className='android.widget.EditText',packageName=P)
 assert fields.count==2,'Expected hour/minute fields'
 for index,value in [(0,'10'),(1,'30')]:
  fields[index].click();sh('input','keyevent','123');sh('input','keyevent','67','67','67');sh('input','text',value)
 observed=[n.get('text') for n in nodes() if n.get('package')==P and n.get('class')=='android.widget.EditText']
 assert observed==['10','30'],'Exact hour/minute fields required'
 tap('OK')
 assert wait(lambda:visible('10:30')),'Form does not show requested time'
 tap('Lưu lịch');assert wait(home)
 updated=server('updated');assert updated['minuteOfDay']=='630' or updated['minuteOfDay']==630
 assert updated['createdAt']==created['createdAt'],'Update replaced creation time'
 record['steps'].append('Update to 10:30 via form; same document/createdAt')
 screenshot('updated')
 tap('Đi bộ giữa giờ');tap('Xóa lịch hoạt động');assert visible('Xóa lịch hoạt động này?')
 screenshot('confirmation');tap('Giữ lịch');tap('Quay lại');assert wait(home)
 cancelled=server('cancelled');assert cancelled['scheduleExists'] and cancelled['updatedAt']==updated['updatedAt']
 record['steps'].append('Cancel delete: schedule and updatedAt unchanged')
 tap('Đã thực hiện');assert wait(lambda:visible('Hoàn tác'))
 completed=server('completion-retained');assert completed['scheduleExists'] and completed['completionExists']
 tap('Đi bộ giữa giờ');tap('Xóa lịch hoạt động');assert visible('Xóa lịch hoạt động này?');tap('Xóa lịch',scroll=False)
 assert wait(home)
 deleted=server('deleted');assert not deleted['scheduleExists'] and deleted['completionExists']
 assert visible('Thực hiện ngoài lịch'),'Completion should remain visible without its schedule'
 record['steps'].append('Confirm delete: schedule removed, own test completion retained')
 screenshot('deleted-history-retained')
 tap('Hoàn tác');assert wait(lambda:'Hoạt động hôm nay · 0' in labels())
 cleaned=server('cleaned');assert not cleaned['scheduleExists'] and not cleaned['completionExists']
 record['steps'].append('Undo only this run’s completion; baseline restored')
 record['baselineRestored']=True;record['returnedHome']=home();record['assertionsPassed']=True
finally:
 (folder/'native-crud-result.json').write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 print(json.dumps(record,ensure_ascii=True))
