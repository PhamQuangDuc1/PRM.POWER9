"""Export a privacy-filtered local replay from pinned ARTEMIS DataEngine frames."""
import json,re,sqlite3,shutil,sys,uuid
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'e2e_test'))
from summarize_lab3 import CASES,verified
DB=ROOT/'.build/artemis-run/traces/data_engine.db'
SOURCE=ROOT/'.build/artemis-run/traces/images'
OUT=ROOT/'evidence/artemis/replay'
PACKAGE='vn.power9.power9_office_routine'
EMAIL=re.compile(r'[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}',re.I)


def privacy_gate(raw):
    nodes=json.loads(raw or '[]')
    if not isinstance(nodes,list): return False,'invalid_hierarchy'
    nodes=[n for n in nodes if isinstance(n,dict)]
    if not any(n.get('package')==PACKAGE or n.get('package','').startswith('com.android.printspooler') for n in nodes):
        return False,'no_allowed_app_or_print_surface'
    if any(n.get('package')==PACKAGE and n.get('text') in {'Tài khoản','Kiểm thử Firebase'} for n in nodes):
        return False,'private_profile_or_debug'
    if any(EMAIL.search(str(n.get('text',''))+' '+str(n.get('content-desc',''))) for n in nodes):
        return False,'email_in_hierarchy'
    for n in nodes:
        text=str(n.get('text','')).strip()
        if n.get('package')=='com.android.systemui' and text and not re.fullmatch(r'(?:\d{1,2}:\d{2}|\d{1,3}%?)',text):
            return False,'unrecognized_systemui_text'
    return True,None


def main():
    OUT.mkdir(parents=True,exist_ok=True);(OUT/'images').mkdir(exist_ok=True)
    selected={}
    with sqlite3.connect(DB.resolve().as_uri()+'?mode=ro',uri=True) as db:
        for phase in ['phase1','phase2']:
            for file in (ROOT/f'evidence/artemis/{phase}').glob('TC*.json'):
                record=json.loads(file.read_text(encoding='utf-8'))
                if record['case'] not in CASES:continue
                uuid.UUID(record['traceId'])
                started=db.execute('SELECT MIN(timestamp) FROM steps WHERE session_id=?',(record['traceId'],)).fetchone()[0] or 0
                quality=2 if verified(record) and record.get('assertionsPassed') is True else 1 if verified(record) else 0
                rank=(quality,started)
                key=(record['case'],record['repetition'])
                if key not in selected or rank>selected[key][0]:selected[key]=(rank,record)
        runs=[];rejected={};copied=set()
        for key,(_,record) in sorted(selected.items()):
            rows=db.execute('SELECT step_number,timestamp,action_taken,pre_image_name,post_image_name FROM steps WHERE session_id=? ORDER BY step_number',(record['traceId'],)).fetchall()
            frames=[];seen=set()
            start=rows[0][1] if rows else 0
            for number,stamp,action,pre,post in rows:
                name=json.loads(action or '{}').get('action','unknown')
                action_name=name if re.fullmatch(r'[a-z_]{1,50}',name) else 'other'
                for role,image_name in [('pre',pre),('post',post)]:
                    if not image_name or image_name in seen or not re.fullmatch(r'[a-f0-9]{64}',image_name):continue
                    seen.add(image_name)
                    row=db.execute('SELECT ui_tree FROM images WHERE image_name=?',(image_name,)).fetchone()
                    if not row:continue
                    safe,why=privacy_gate(row[0])
                    if not safe:rejected[why]=rejected.get(why,0)+1;continue
                    source=next((SOURCE/(image_name+suffix) for suffix in ['.jpg','.png'] if (SOURCE/(image_name+suffix)).is_file()),None)
                    if source is None:continue
                    assert source.resolve().is_relative_to(SOURCE.resolve())
                    target=OUT/'images'/source.name
                    if source.name not in copied:shutil.copy2(source,target);copied.add(source.name)
                    frames.append({'step':number,'seconds':round(stamp-start,2),'action':action_name,'role':role,'image':'images/'+source.name})
            runs.append({'case':record['case'],'repetition':record['repetition'],'traceId':record['traceId'],'status':record['status'],'pytestPassed':record.get('assertionsPassed') is True,'verified':verified(record),'auditOnly':record.get('delayedTerminalAudit',{}).get('verified') is True,'publicOutput':record.get('output'),'failureDiagnosis':record.get('failureDiagnosis'),'analyticsObservation':record.get('analyticsObservation'),'frames':frames})
    data={'source':'Recorded DataEngine images and step metadata; pinned upstream. Not upstream trace compiler output.','selection':'Best verified run per case/repetition; otherwise latest failure. All attempts retained in sibling JSON records.','rawPromptsOrHierarchyExported':False,'privacyRejectedFrameCounts':rejected,'imageCount':len(copied),'runs':runs}
    (OUT/'replay-manifest.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    template='''<!doctype html><html lang="vi"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Power9 Lab 3 Replay</title>
<style>body{font:16px system-ui;margin:24px;background:#f5f7fa;color:#142c45}main{display:grid;grid-template-columns:minmax(260px,420px) 1fr;gap:24px}img{max-height:77vh;max-width:100%;object-fit:contain;background:white}button,select{font:inherit;padding:8px;margin:5px}pre{white-space:pre-wrap;overflow-wrap:anywhere;background:white;padding:16px}small{display:block;max-width:1000px}h1{font-size:25px}@media(max-width:700px){main{display:block}}</style>
<h1>Power9 Lab 3 recorded replay</h1><small>Ảnh gốc đã qua cổng lọc bề mặt ứng dụng, email và Profile/debug. Không chứa raw prompt hoặc UI dump. Đây là viewer cục bộ từ DataEngine, không phải output của trace compiler. Chọn run để xem cả kết quả fail/audit; các attempts khác vẫn được giữ trong JSON.</small>
<select id="run"></select><button id="prev">← Bước trước</button><button id="next">Bước tiếp →</button><span id="position"></span>
<main><section><img id="frame" alt="Recorded app frame"><p id="caption"></p></section><section><h2 id="heading"></h2><pre id="result"></pre></section></main>
<script>const data=__DATA__;const select=document.querySelector('#run');let runIndex=0,frameIndex=0;data.runs.forEach((r,i)=>{const o=document.createElement('option');o.value=i;o.textContent=r.case+' lượt '+r.repetition+' · '+(r.pytestPassed?'PYTEST PASS':r.auditOnly?'AUDIT VERIFIED':'FAIL');select.appendChild(o)});function draw(){const r=data.runs[runIndex],f=r.frames[frameIndex];document.querySelector('#heading').textContent=r.case+' / '+r.repetition;document.querySelector('#result').textContent=JSON.stringify({traceId:r.traceId,status:r.status,pytestPassed:r.pytestPassed,verified:r.verified,auditOnly:r.auditOnly,output:r.publicOutput,failureDiagnosis:r.failureDiagnosis,analytics:r.analyticsObservation},null,2);const image=document.querySelector('#frame');image.hidden=!f;if(f){image.src=f.image;document.querySelector('#caption').textContent='Step '+f.step+' · '+f.action+' · '+f.role+' · '+f.seconds+' s'}else document.querySelector('#caption').textContent='Không có frame được phép xuất cho run này.';document.querySelector('#position').textContent=(frameIndex+1)+' / '+r.frames.length}select.onchange=()=>{runIndex=Number(select.value);frameIndex=0;draw()};document.querySelector('#prev').onclick=()=>{frameIndex=Math.max(0,frameIndex-1);draw()};document.querySelector('#next').onclick=()=>{frameIndex=Math.min(data.runs[runIndex].frames.length-1,frameIndex+1);draw()};if(data.runs.length)draw();</script></html>'''
    (OUT/'index.html').write_text(template.replace('__DATA__',json.dumps(data,ensure_ascii=True).replace('</','<\\/')),encoding='utf-8')
    print(json.dumps({'selectedRuns':len(runs),'images':len(copied),'rejectedFrames':rejected}))
if __name__=='__main__':main()
