import argparse,json,os,subprocess,time,shlex
from pathlib import Path
parser=argparse.ArgumentParser(description='Native Android accessibility audit; requires test account, idle timer and compiled helper. No model calls.')
parser.add_argument('--run-device-accessibility',action='store_true')
parser.add_argument('--output',required=True,type=Path)
args=parser.parse_args()
if not args.run_device_accessibility:raise SystemExit('Explicit --run-device-accessibility required')
if args.output.exists():raise SystemExit('Use a new output directory to preserve earlier attempts')
ADB=os.environ.get('POWER9_ADB','adb')
P='vn.power9.power9_office_routine'
serial=os.environ['POWER9_DEVICE_SERIAL']
def sh(*args):return subprocess.check_output([ADB,'-s',serial,'shell',*args],timeout=25).decode(errors='replace').strip()
day=sh('date','+%F')
folder=args.output;folder.mkdir(parents=True)
result={'dateLocal':day,'source':'real Android accessibility node focus/click actions while TalkBack bound; FLAG_DONT_SUPPRESS_ACCESSIBILITY_SERVICES','modelCalls':0,'humanGesturesAndSpeechAssessed':False,'automaticChecksPassed':False,'actions':[],'checks':[]}
def native(*args):
 raw=sh('CLASSPATH=/data/local/tmp/p9-lab3-a11y.jar app_process /system/bin P9AccessibilityAudit '+ ' '.join(shlex.quote(a) for a in args))
 return json.loads(raw[raw.index('{'):])
def snapshot(name):
 data=native()
 for attempt in range(3):
  if data['power9Nodes']:break
  sh('am','start','-n',P+'/.MainActivity');time.sleep(2);data=native()
 assert data['power9Nodes'],'Power9 must be foreground'
 (folder/(name+'-nodes.json')).write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 return data['power9Nodes']
def has(ns,part):return any(part in n['text']+' '+n['description']+' '+n.get('hint','') for n in ns)
def activate(label):
 r=native('activate',label);result['actions'].append({'label':label,**r});assert r['clickActionAccepted'],'Accessibility click not accepted'
 print(json.dumps({'accessibilityAction':label,'focused':r['focusedBeforeActivation'],'clicked':r['clickActionAccepted']},ensure_ascii=True),flush=True)
def check(name,condition):
 result['checks'].append({'name':name,'passed':bool(condition)});assert condition,name
old_services=sh('settings','get','secure','enabled_accessibility_services');old_enabled=sh('settings','get','secure','accessibility_enabled')
try:
 sh('settings','put','secure','enabled_accessibility_services','com.google.android.marvin.talkback/com.google.android.marvin.talkback.TalkBackService');sh('settings','put','secure','accessibility_enabled','1');time.sleep(4)
 sh('am','start','-n',P+'/.MainActivity');time.sleep(1)
 check('TalkBack service bound','Bound services:{Service[label=TalkBack' in sh('dumpsys','accessibility'))
 ns=snapshot('startup')
 for _ in range(3):
  if has(ns,'Khám phá hoạt động') and has(ns,'Xem tiến độ'):break
  if has(ns,'Quay lại'):activate('Quay lại');ns=snapshot('startup-back')
  else:break
 result['setupActions']=result['actions'];result['actions']=[]
 ns=snapshot('home');check('Home main actions exposed',has(ns,'Khám phá hoạt động') and has(ns,'Xem tiến độ'))
 check('Notification control has product label',has(ns,'Thông báo'))
 activate('Khám phá hoạt động');ns=snapshot('discover');check('Search field labelled',has(ns,'Tìm hoạt động'))
 activate('≤ 5 phút');ns=snapshot('filter-selected');check('Filter exposes selection',any(n['selected'] and '5 phút' in n['text']+' '+n['description'] for n in ns))
 activate('Đi bộ giữa giờ');ns=snapshot('detail');check('Activity instructions readable',has(ns,'Cách thực hiện'))
 activate('Chọn lịch hoạt động');ns=snapshot('schedule');check('Schedule controls labelled',has(ns,'Ngày thực hiện') and has(ns,'Nhắc hoạt động') and has(ns,'Lưu lịch'))
 activate('Nhắc hoạt động');activate('Lưu lịch');ns=snapshot('schedule-validation');check('Validation error exposed as live region',any(n['liveRegion']!=0 and 'Chọn giờ khi bật nhắc' in n['text']+' '+n['description'] for n in ns))
 activate('Hủy');activate('Quay lại');activate('Quay lại');ns=snapshot('home-after-form-cancel');check('Cancel restores Home',has(ns,'Khám phá hoạt động'))
 activate('Thư giãn');ns=snapshot('timer-idle');check('Timer has accessible name',has(ns,'Thời gian còn lại'))
 activate('Bắt đầu');activate('Tạm dừng');ns=snapshot('timer-paused');check('Paused controls available',has(ns,'Tiếp tục') and has(ns,'Đã tạm dừng'))
 activate('Hôm nay');ns=snapshot('leave-dialog');check('Leave dialog choices labelled',has(ns,'Rời phiên thư giãn?') and has(ns,'Ở lại') and has(ns,'Bỏ phiên'))
 activate('Ở lại');ns=snapshot('timer-after-stay');check('Stay preserves paused timer',has(ns,'Tiếp tục') and has(ns,'Đã tạm dừng'))
 activate('Hôm nay');activate('Bỏ phiên');ns=snapshot('home-after-discard');check('Discard returns Home',has(ns,'Khám phá hoạt động'))
 activate('Xem tiến độ');ns=snapshot('progress');check('Progress date and PDF exposed',has(ns,'Xuất báo cáo PDF') and has(ns,day))
 activate('Xuất báo cáo PDF');activate('Tạo PDF');time.sleep(1);ns=snapshot('report');check('Report controls and disabled cloud action',has(ns,'Xem / lưu PDF') and any(not n['enabled'] and 'Lưu lên đám mây' in n['text']+' '+n['description'] for n in ns))
 activate('Quay lại');activate('Quay lại');ns=snapshot('final-home');check('Returned Home without removing food record',has(ns,'Khám phá hoạt động') and has(ns,'Sắp xếp bữa trưa văn phòng'))
 check('Every tested action retained observable accessibility focus',all(a['focusedBeforeActivation'] for a in result['actions']))
 check('TalkBack remained bound','Bound services:{Service[label=TalkBack' in sh('dumpsys','accessibility'))
 result['automaticChecksPassed']=True
finally:
 if old_services=='null':sh('settings','delete','secure','enabled_accessibility_services')
 else:sh('settings','put','secure','enabled_accessibility_services',old_services)
 sh('settings','put','secure','accessibility_enabled',old_enabled)
 result['originalAccessibilitySettingsRestored']=sh('settings','get','secure','enabled_accessibility_services')==old_services and sh('settings','get','secure','accessibility_enabled')==old_enabled
 (folder/'automatic-accessibility-result.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 print(json.dumps({'automaticChecksPassed':result['automaticChecksPassed'],'settingsRestored':result['originalAccessibilitySettingsRestored'],'checks':result['checks']},ensure_ascii=True),flush=True)
