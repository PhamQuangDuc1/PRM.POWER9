import asyncio
from unittest.mock import Mock

import pytest

from runtime.ascii_input import type_test_ascii


def test_clear_removes_old_digits_before_typing_without_meta_or_clipboard():
    device = Mock()
    assert asyncio.run(type_test_ascii(device, '11'))
    commands = [call.args[0] for call in device.shell.call_args_list]
    assert commands[0] == 'input keyevent 123'
    assert commands[1].split()[2:] == ['67'] * 80
    assert commands[2] == 'input text 11'


def test_append_does_not_delete_and_spaces_are_encoded():
    device = Mock()
    asyncio.run(type_test_ascii(device, 'walk test', False))
    assert [c.args[0] for c in device.shell.call_args_list] == [
        'input keyevent 123', 'input text walk%stest']


@pytest.mark.parametrize('text', ['', '1' * 81, '$(id)', '11;reboot', 'đi bộ'])
def test_unsupported_text_never_reaches_shell(text):
    device = Mock()
    with pytest.raises(ValueError):
        asyncio.run(type_test_ascii(device, text))
    device.shell.assert_not_called()
