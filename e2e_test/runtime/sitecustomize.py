"""Opt-in, process-local compatibility patch for the pinned ARTEMIS checkout."""
import os

if os.environ.get('POWER9_ARTEMIS_ASCII_INPUT') == '1':
    import asyncio
    import re
    from artemis.drivers.android.adb_driver import AndroidAdbDriver
    from artemis.drivers.android.input_ime import AndroidInputIME

    _original_input = AndroidAdbDriver.input_text

    async def _verified_test_input(self, text, clear_existing=True):
        # Only the controlled ASCII test queries bypass clipboard paste.
        # ARTEMIS still selects/focuses the field and performs the action.
        if re.fullmatch(r'[A-Za-z0-9 ]{1,80}', text):
            return await AndroidInputIME(self.device).type_text(text, clear_existing)
        return await _original_input(self, text, clear_existing)

    AndroidAdbDriver.input_text = _verified_test_input

if os.environ.get('POWER9_ARTEMIS_STRUCTURED_REPORT') == '1':
    from artemis.agents.flash.runner import FlashRunner
    from structured_report import structured_tools
    _original_tools = FlashRunner._get_tools

    def _power9_tools(self):
        return structured_tools(_original_tools(self), self.goal)

    FlashRunner._get_tools = _power9_tools
