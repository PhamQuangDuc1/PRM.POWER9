"""A real app action plus process-scoped native Analytics evidence, no raw log export."""
import re
import json
from pathlib import Path
import pytest
from conftest import normalized


@pytest.mark.parametrize('repetition', [1,2,3])
def test_tc16_view_activity_native_analytics(artemis_run, repetition, request):
    device = artemis_run.device
    began = int(device.adb('shell','date','+%s').strip())
    out, device = artemis_run('TC16',repetition,
        'From Home open Khám phá hoạt động and open Đi bộ giữa giờ detail. In activity_title copy the ACTIVITY title inside the BODY (Đi bộ giữa giờ), NOT the app-bar heading Chi tiết hoạt động. Report whether Cách thực hiện is visible. Do not schedule or record it. Stay on this detail screen.',
        'activity_title: string naming the BODY activity not the app bar, instructions_visible: boolean observed in the detail body',extended=True)
    assert 'di bo giua gio' in normalized(out.get('activity_title',''))
    assert out.get('instructions_visible') is True
    assert any('Đi bộ giữa giờ' in label for label in device.labels())
    pid = device.adb('shell','pidof','vn.power9.power9_office_routine').decode().strip().split()[0]
    # Read only this app process and time window; never dump FA-SVC shared logs.
    raw = device.adb('logcat','--pid='+pid,'-d','-v','epoch','-s','FA:V').decode(errors='replace')
    lines=[]
    for line in raw.splitlines():
        stamp=re.match(r'\s*(\d+\.\d+)\s',line)
        if stamp and float(stamp.group(1))>=began:
            lines.append(line)
    matching=[line for line in lines if 'view_activity' in line and 'move-walk' in line]
    source='process-scoped logcat FA after task start'
    marker_path=Path(__file__).resolve().parents[1]/'.build/artemis-run/analytics-build-marker.json'
    marker=None
    if not marker_path.exists():
        marker_path=Path(__file__).resolve().parents[1]/'output/lab3/build-config.json'
    if not matching and marker_path.exists():
        marker=json.loads(marker_path.read_text(encoding='utf-8'))['marker']
        assert re.fullmatch(r'p9_[a-zA-Z0-9_]{1,35}',marker)
        # Android filters before returning any log lines. The random synthetic
        # default parameter is compiled only into this debug APK; no other
        # app's FA-SVC entries are read or exported.
        scoped=device.adb('logcat','-d','-v','epoch','--regex',marker,'-s','FA-SVC:V').decode(errors='replace')
        matching=[]
        for line in scoped.splitlines():
            stamp=re.match(r'\s*(\d+\.\d+)\s',line)
            if stamp and float(stamp.group(1))>=began and 'view_activity' in line and 'move-walk' in line and marker in line:
                matching.append(line)
        source='native FA-SVC SDK log filtered by unique Power9 debug build marker and task time'
    _, record = request.node.artemis_evidence
    record['analyticsObservation'] = {'source':source,'event':'view_activity','activityId':'move-walk','observed':bool(matching),'matchingLineCount':len(matching),'rawLogsExported':False,'syntheticBuildMarker':marker}
    assert matching, 'No view_activity(activity_id=move-walk) native Analytics line from this app process/time window; DebugView evidence still required'
