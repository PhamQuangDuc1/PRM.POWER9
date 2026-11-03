"""Public Lab 3 execution summary. Failed attempts and audits remain visible."""
import json
from pathlib import Path
from statistics import mean
ROOT=Path(__file__).resolve().parents[1]
CASES=['TC02','TC03','TC04','TC06','TC07','TC08','TC09','TC10','TC11','TC13','TC16']

def verified(record):
    if record.get('delayedTerminalAudit',{}).get('verified') is True:
        return True
    if record.get('retrospectiveNativeAudit',{}).get('verified') is False and not record.get('phase1ScopeAudit',{}).get('verified'):
        return False
    return record.get('assertionsPassed') is True

def summarize():
    attempts=[]
    for phase in ['phase1','phase2']:
        for file in sorted((ROOT/f'evidence/artemis/{phase}').glob('TC*.json')):
            record=json.loads(file.read_text(encoding='utf-8'))
            if record['case'] in CASES:
                attempts.append({'case':record['case'],'repetition':record['repetition'],'traceId':record['traceId'],'status':record['status'],'elapsedSeconds':record['elapsedSeconds'],'pytestPassed':record.get('assertionsPassed') is True,'verified':verified(record),'auditOnly':record.get('delayedTerminalAudit',{}).get('verified') is True,'evidence':file.relative_to(ROOT).as_posix()})
    cases=[]
    for case in CASES:
        rows=[r for r in attempts if r['case']==case]
        seen=sorted({r['repetition'] for r in rows})
        good=sorted({r['repetition'] for r in rows if r['verified']})
        cases.append({'case':case,'attemptedRepetitions':seen,'verifiedRepetitions':good,'remaining':[i for i in [1,2,3] if i not in good],'attempts':len(rows),'meanAttemptSeconds':round(mean(r['elapsedSeconds'] for r in rows),2) if rows else None,'attemptPytestPassRate':round(sum(r['pytestPassed'] for r in rows)/len(rows),4) if rows else None})
    pytest_ids={(r['case'],r['repetition']) for r in attempts if r['verified'] and r['pytestPassed']}
    valid_ids={(r['case'],r['repetition']) for r in attempts if r['verified']}
    return {'pytestVerifiedUniqueRunIds':len(pytest_ids),'auditOnlyUniqueRunIds':len(valid_ids-pytest_ids),'plannedCases':len(CASES),'plannedRunIds':len(CASES)*3,'attemptedUniqueRunIds':sum(len(r['attemptedRepetitions']) for r in cases),'verifiedUniqueRunIds':sum(len(r['verifiedRepetitions']) for r in cases),'fullyVerifiedCases':sum(len(r['verifiedRepetitions'])==3 for r in cases),'attemptsWithEvidence':len(attempts),'cases':cases,'attempts':attempts,'scopeNotes':['TC04 phase1 tests missing-time validation and Flutter picker cancel; not full validation/retry successful save.','TC11 phase1 tests four tabs; not full filter/back persistence.','TC13 phase2 tests PDF/native preview cancel with Spark cloud upload disabled; not production Storage upload.','Original failed attempts remain failed even where later read-only audit verified observations.','Exploratory, Analytics assertion, full auth/privacy/permission coverage and PR review have separate requirements.','No model trace for setup errors or transport exceptions; do not count them as passes.']}
if __name__=='__main__':
    report=summarize()
    target=ROOT/'evidence/artemis/lab3-summary.json'
    target.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({k:report[k] for k in ['plannedCases','attemptedUniqueRunIds','verifiedUniqueRunIds','fullyVerifiedCases','attemptsWithEvidence']}))
