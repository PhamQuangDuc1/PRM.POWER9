"""Summarize public phase-1 evidence without reading private raw traces."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DIRECTORY = ROOT / 'evidence/artemis/phase1'


def summarize():
    attempts = []
    verified = {}
    rejected = 0
    for path in sorted(DIRECTORY.glob('TC*.json')):
        record = json.loads(path.read_text(encoding='utf-8'))
        case = record['case']
        audited = record.get('delayedTerminalAudit', {}).get('verified') is True
        scope_audit = record.get('phase1ScopeAudit', {}).get('verified') is True
        legacy_rejected = record.get('retrospectiveNativeAudit', {}).get('verified') is False
        accepted = audited or (record.get('assertionsPassed') is True and (not legacy_rejected or scope_audit))
        native = record.get('nativeTraceObservations', {})
        if case == 'TC03' and not audited:
            accepted = accepted and native.get('searchQuerySeen') is True and native.get('emptyMessageSeen') is True
        if case == 'TC04' and not scope_audit:
            accepted = accepted and native.get('missingTimeErrorSeen') is True and native.get('timePickerSeen') is True
        entry = {'case': case, 'repetition': record['repetition'], 'traceId': record['traceId'], 'pytestPassed': record.get('assertionsPassed') is True, 'verified': bool(accepted), 'delayedTerminalAudit': audited}
        attempts.append(entry)
        if accepted:
            verified[(case, record['repetition'])] = entry
        else:
            rejected += 1
    planned = [(case, run) for case in ['TC03', 'TC04', 'TC11'] for run in [1, 2, 3]]
    return {'scope': 'Phase 1 only: search/reset, missing-time validation and Flutter picker cancel, four tabs. Not the full TC04/TC11 test-plan cases or native Android interaction.', 'plannedRuns': 9, 'verifiedUniqueRuns': len(verified), 'remaining': [{'case': case, 'repetition': run} for case, run in planned if (case, run) not in verified], 'recordedAttempts': len(attempts), 'unverifiedOrFailedAttemptsRetained': rejected, 'verified': list(verified.values()), 'attempts': attempts, 'note': 'A delayed-terminal audit does not rewrite the original pytest failure. Setup failures without model trace IDs are excluded from attempt counts. This is not an overall Lab 3 pass rate.'}


if __name__ == '__main__':
    report = summarize()
    (DIRECTORY / 'summary.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({key: report[key] for key in ['plannedRuns', 'verifiedUniqueRuns', 'remaining', 'recordedAttempts', 'unverifiedOrFailedAttemptsRetained']}))
