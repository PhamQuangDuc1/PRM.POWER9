"""Read sanitized Power9 SDK evidence; never call a model or emit raw Logcat."""
import argparse
import json
import os
from pathlib import Path
import re
import subprocess

EVENTS = (
    'login', 'logout', 'search', 'view_activity', 'schedule_created',
    'schedule_updated', 'schedule_deleted', 'activity_completed',
    'completion_undone', 'config_refreshed', 'report_generated', 'export_report',
)
PARAMETERS = (
    'activity_id', 'group_id', 'source', 'duration_seconds', 'max_minutes',
    'query_length', 'has_query', 'method', 'item_count', 'file_size_kb',
)


def summarize(raw, marker, since):
    observed = {}
    for line in raw.splitlines():
        stamp = re.match(r'\s*(\d+\.\d+)\s', line)
        if not stamp or float(stamp.group(1)) < since or marker not in line:
            continue
        for event in EVENTS:
            if not re.search(r'(?<![a-z_])' + event + r'(?![a-z_])', line):
                continue
            row = observed.setdefault(event, {'matchingSdkLines': 0, 'parameters': {}})
            row['matchingSdkLines'] += 1
            for key in PARAMETERS:
                match = re.search(r'\b' + key + r'=([^,}\s]+)', line)
                if match and re.fullmatch(r'[A-Za-z0-9_.-]{1,64}', match.group(1)):
                    row['parameters'][key] = match.group(1)
    return observed


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--marker', required=True, help='Synthetic marker compiled into this debug APK')
    parser.add_argument('--since-epoch', required=True, type=int, help='Device epoch before real app actions')
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    if not re.fullmatch(r'p9_[A-Za-z0-9_]{1,35}', args.marker) or args.since_epoch < 1:
        parser.error('A valid synthetic marker and positive device epoch are required')
    serial = os.environ['POWER9_DEVICE_SERIAL']
    adb = os.environ.get('POWER9_ADB', 'adb')
    # Filter on Android before shared-service logs cross the USB boundary.
    raw = subprocess.check_output([
        adb, '-s', serial, 'logcat', '-d', '-v', 'epoch', '--regex', args.marker,
        '-s', 'FA-SVC:V',
    ], timeout=25).decode(errors='replace')
    observed = summarize(raw, args.marker, args.since_epoch)
    record = {
        'source': 'native FA-SVC SDK, device-side build marker and start-time filtering',
        'modelCalls': 0, 'rawLogsExported': False,
        'debugViewServerReceiptClaimed': False,
        'events': observed, 'notObserved': [e for e in EVENTS if e not in observed],
        'note': 'Counts are matching log lines, not unique event counts. Missing buffered logs do not prove an event was never sent.',
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(record, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({'eventsObserved': sorted(observed), 'rawLogsExported': False}))


if __name__ == '__main__':
    main()
