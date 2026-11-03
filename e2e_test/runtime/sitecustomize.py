"""Opt-in, process-local compatibility patch for the pinned ARTEMIS checkout."""
import os

if os.environ.get('POWER9_ARTEMIS_ASCII_INPUT') == '1':
    import asyncio
    import re
    from artemis.drivers.android.adb_driver import AndroidAdbDriver
    from ascii_input import type_test_ascii

    _original_input = AndroidAdbDriver.input_text

    async def _verified_test_input(self, text, clear_existing=True):
        # Only the controlled ASCII test queries bypass clipboard paste.
        # ARTEMIS still selects/focuses the field and performs the action.
        if re.fullmatch(r'[A-Za-z0-9 ]{1,80}', text):
            return await type_test_ascii(self.device, text, clear_existing)
        return await _original_input(self, text, clear_existing)

    AndroidAdbDriver.input_text = _verified_test_input

if os.environ.get('POWER9_ARTEMIS_STRUCTURED_REPORT') == '1':
    from artemis.agents.flash.runner import FlashRunner
    from structured_report import structured_tools
    _original_tools = FlashRunner._get_tools

    def _power9_tools(self):
        return structured_tools(_original_tools(self), self.goal)

    FlashRunner._get_tools = _power9_tools

# Install last so compatibility adapters cannot replace guarded actions.
if os.environ.get('POWER9_ARTEMIS_PRIVACY_GUARD') == '1':
    try:
        from artemis.drivers.android.adb_driver import AndroidAdbDriver
        from privacy_guard import install_privacy_guard
        install_privacy_guard(AndroidAdbDriver)
    except Exception:
        # Python otherwise only warns on sitecustomize errors and continues.
        os._exit(78)
