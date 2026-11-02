"""Package only public Lab 3 sources, evidence and deliverables; exclude tool state."""
from pathlib import Path
import hashlib,json,zipfile
ROOT=Path(__file__).resolve().parents[2]
OUT=ROOT/'output/lab3'
DIRS=['lib','test','e2e_test','firebase','android','docs','ai/code-review','scripts/lab3','assets/fonts','assets/brand','evidence']
FILES=['README.md','pubspec.yaml','pubspec.lock','analysis_options.yaml','firebase.json','.gitignore','.gitattributes']
EXCLUDE={'node_modules','.gradle','.kotlin','__pycache__','.pytest_cache','build','debug','profile','release'}

def allowed(path):
    rel=path.relative_to(ROOT)
    if any(part in EXCLUDE or part.startswith('.env') for part in rel.parts): return False
    if path.name=='local.properties' or 'service-account' in path.name or path.suffix in {'.jks','.keystore','.pyc'}: return False
    return path.is_file()

def main():
    selected=set()
    for folder in DIRS:
        for path in (ROOT/folder).rglob('*'):
            if allowed(path): selected.add(path)
    for name in FILES:
        p=ROOT/name
        if p.exists(): selected.add(p)
    for p in OUT.iterdir():
        if p.is_file() and p.suffix in {'.pdf','.pptx','.apk','.mp4','.md','.json','.png'} and p.name!='manifest.json': selected.add(p)
    entries=[]
    for p in sorted(selected):
        entries.append({'path':p.relative_to(ROOT).as_posix(),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
    manifest={'packagedDateLocal':'2026-11-03','evidenceCutoffDateLocal':'2026-11-02','purpose':'Lab 3 submission snapshot; see report for incomplete requirements','containsRawArtemisTraces':False,'containsModelCredentials':False,'files':entries}
    manifest_path=OUT/'manifest.json';manifest_path.write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    selected.add(manifest_path)
    target=OUT/'Power9_Lab3_Bundle.zip'
    with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED,compresslevel=5) as archive:
        for p in sorted(selected): archive.write(p,p.relative_to(ROOT).as_posix())
    with zipfile.ZipFile(target) as archive:
        bad=archive.testzip()
        assert bad is None,bad
        assert not any('/.build/' in name or '/node_modules/' in name or '/.env' in name for name in archive.namelist())
    print(json.dumps({'bundle':str(target),'bytes':target.stat().st_size,'files':len(selected),'integrity':'passed'}))
if __name__=='__main__': main()
