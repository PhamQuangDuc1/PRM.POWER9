"""Local-only Xperia permission smoke; no model/client/key imports."""
import json,os,subprocess,time,xml.etree.ElementTree as ET
from pathlib import Path
import argparse
parser=argparse.ArgumentParser(description='Local real-device notification permission smoke; temporarily toggles only Power9 notifications and restores original state.')
parser.add_argument('--run-device-permission',action='store_true')
args=parser.parse_args()
if not args.run_device_permission:raise SystemExit('Explicit --run-device-permission is required; no device operation performed')
import uiautomator2 as u2
P='vn.power9.power9_office_routine'
device=u2.connect(os.environ['POWER9_DEVICE_SERIAL'])
adb=[os.environ['POWER9_ADB'],'-s',os.environ['POWER9_DEVICE_SERIAL']]
def shell(*args):return subprocess.check_output(adb+['shell']+list(args),timeout=25).decode(errors='replace')
def tree():return ET.fromstring(device.dump_hierarchy())
def labels(package=P):return [n.get('text') or n.get('content-desc') or '' for n in tree().iter('node') if n.get('package')==package]
def tap(label):
 for mode in ['description','text']:
  target=device(**{mode:label,'packageName':P})
  if target.exists:target.click();time.sleep(1);return
 raise AssertionError('Expected app control unavailable')
assert 'mWakefulness=Awake' in shell('dumpsys','power'),'Unlock/open app first'
assert 'Power9 Office Routine' in labels(),'Must start on Home'
shell('am','start','-a','android.settings.APP_NOTIFICATION_SETTINGS','--es','android.provider.extra.APP_PACKAGE',P)
time.sleep(2)
nodes=list(tree().iter('node'))
assert any('Power9' in (n.get('text','')+' '+n.get('content-desc','')) for n in nodes if n.get('package')=='com.android.settings'),'Wrong settings page'
switches=[n for n in nodes if n.get('package')=='com.android.settings' and n.get('class')=='android.widget.Switch' and n.get('enabled')=='true']
assert len(switches)>=1,'No master notification toggle'
switch=switches[0];rid=switch.get('resource-id');original=switch.get('checked')=='true'
result={'dateLocal':'2026-11-02','source':'local native UIAutomator2 + real Android app settings; no ARTEMIS/model calls','androidApi':30,'originalNotificationsEnabled':original,'modelDataSent':False,'privateContentExported':False,'assertionsPassed':False}
try:
 if original:device(resourceId=rid,packageName='com.android.settings').click();time.sleep(1)
 assert device(resourceId=rid,packageName='com.android.settings').info.get('checked') is False
 result['systemNotificationsDisabled']=True
 shell('am','start','-n',P+'/.MainActivity');time.sleep(2)
 # Flutter's Badge can replace its IconButton description with the unread count.
 t=tree();targets=[n for n in t.iter('node') if n.get('package')==P and n.get('clickable')=='true' and ((n.get('content-desc') or n.get('text') or '')=='Thông báo')]
 if not targets:
  targets=[n for n in t.iter('node') if n.get('package')==P and n.get('clickable')=='true' and (n.get('content-desc') or '').isdigit()]
 assert len(targets)==1,'Notification button not uniquely located'
 import re
 x1,y1,x2,y2=map(int,re.findall(r'\d+',targets[0].get('bounds')));device.click((x1+x2)//2,(y1+y2)//2);time.sleep(2)
 current=labels();assert 'Thông báo' in current
 button=next((s for s in current if s in ['Bật thông báo','Kiểm tra kết nối thông báo']),None);assert button
 tap(button)
 for _ in range(25):
  current=labels()
  if any('quyền Thông báo' in s for s in current):break
  time.sleep(.5)
 result['permissionErrorVisible']=any('quyền Thông báo' in s for s in current)
 result['retryControlAvailable']=any(s in ['Bật thông báo','Kiểm tra kết nối thông báo'] for s in current)
 result['appRemainedResponsive']='Thông báo' in current
 result['assertionsPassed']=all(result.get(k) is True for k in ['systemNotificationsDisabled','permissionErrorVisible','retryControlAvailable','appRemainedResponsive'])
finally:
 shell('am','start','-a','android.settings.APP_NOTIFICATION_SETTINGS','--es','android.provider.extra.APP_PACKAGE',P);time.sleep(1)
 target=device(resourceId=rid,packageName='com.android.settings')
 assert target.exists,'Restore toggle unavailable'
 if target.info.get('checked')!=original:target.click();time.sleep(1)
 result['systemPermissionRestored']=target.info.get('checked')==original
 shell('am','start','-n',P+'/.MainActivity');time.sleep(1)
 if 'Quay lại' in labels():tap('Quay lại')
 result['returnedHome']='Khám phá hoạt động' in labels()
 out=Path('evidence/fcm/permission-denied-xperia-2026-11-02.json');out.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 print(json.dumps(result,ensure_ascii=True))
assert result['assertionsPassed'] and result['systemPermissionRestored'] and result['returnedHome'],'Native permission smoke failed; see boolean evidence'
