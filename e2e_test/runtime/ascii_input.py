"""Bounded ASCII input for controlled test fields on Android 11."""
import asyncio
import re


async def type_test_ascii(device, text, clear_existing=True):
    if not re.fullmatch(r'[A-Za-z0-9 ]{1,80}', text):
        raise ValueError('Only bounded ASCII test text is allowed')
    await asyncio.to_thread(device.shell, 'input keyevent 123')
    if clear_existing:
        # Android 11 input does not provide the --meta selection option.
        # Test fields are bounded to 80 characters; delete without clipboard.
        await asyncio.to_thread(device.shell, 'input keyevent ' + ' '.join(['67'] * 80))
    await asyncio.to_thread(device.shell, 'input text ' + text.replace(' ', '%s'))
    return True
