"""Local-only daemon launcher for the pinned checkout; never prints credentials."""
import argparse
import os
from pathlib import Path
import sys


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--port', type=int, default=8019)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    checkout = root / '.build/tools/artemis'
    config = root / '.build/artemis-run/artemis.jsonc'
    if not checkout.is_dir() or not config.is_file():
        raise SystemExit('Prepare the pinned ARTEMIS checkout and ignored config first; see README.md')
    from dotenv import load_dotenv
    load_dotenv(checkout / '.env', override=True)
    os.environ['ARTEMIS_APP_DIR'] = str(root / '.build/artemis-run')
    os.environ['ARTEMIS_ARTEMIS_JSONC'] = str(config)
    os.environ['ARTEMIS_KEEP_DEVICE_AWAKE'] = 'false'
    os.environ['ARTEMIS_HIERARCHY_BACKEND'] = 'uiautomator'
    os.environ['POWER9_ARTEMIS_ASCII_INPUT'] = '1'
    os.environ['POWER9_ARTEMIS_STRUCTURED_REPORT'] = '1'
    os.environ['POWER9_ARTEMIS_PRIVACY_GUARD'] = '1'
    runtime = str(Path(__file__).resolve().parent / 'runtime')
    os.environ['PYTHONPATH'] = runtime + os.pathsep + os.environ.get('PYTHONPATH', '')
    adb = os.environ.get('POWER9_ADB')
    if adb:
        os.environ['PATH'] = str(Path(adb).parent) + os.pathsep + os.environ['PATH']
    sys.path.insert(0, str(checkout))
    sys.path.insert(0, runtime)
    from privacy_guard import install_privacy_guard
    from artemis.drivers.android.adb_driver import AndroidAdbDriver
    install_privacy_guard(AndroidAdbDriver)
    from apps.admin_console.server import main as serve
    serve(['--host', '127.0.0.1', '--port', str(args.port)])


if __name__ == '__main__':
    main()
