"""Process-local observation/action boundary for Power9 model workers."""
import re
import xml.etree.ElementTree as ET

PACKAGE = 'vn.power9.power9_office_routine'
EMAIL = re.compile(r'[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}', re.I)
PRIVATE_LABELS = ('Đăng xuất', 'Kiểm thử Firebase', 'recipient_uid', 'FCM · thông tin gửi thử')
PRIVATE_CONTROLS = {'Tài khoản', 'Account', 'Profile', 'Kiểm thử Firebase'}
KEYBOARDS = {'com.google.android.inputmethod.latin', 'com.android.inputmethod.latin',
             'com.github.uiautomator', 'com.android.adbkeyboard'}


class PrivateSurfaceBlocked(RuntimeError):
    """Contains a reason code only, never the rejected screen or its text."""


def label(node):
    return (str(node.get('text', '')) + ' ' + str(node.get('content-desc', ''))).strip()


def bounds(node):
    raw = node.get('bounds', '')
    if not isinstance(raw, str):
        return None
    match = re.fullmatch(r'\[(-?\d+),(-?\d+)\]\[(-?\d+),(-?\d+)\]', raw)
    return tuple(map(int, match.groups())) if match else None


def validate_screen(screen):
    xml = getattr(screen, 'ui_hierarchy_xml', None)
    if xml:
        try:
            nodes = [dict(n.attrib) for n in ET.fromstring(xml).iter('node')]
        except ET.ParseError:
            raise PrivateSurfaceBlocked('invalid_hierarchy') from None
    else:
        nodes = getattr(screen, 'ui_elements', None)
    if not isinstance(nodes, list) or not nodes:
        raise PrivateSurfaceBlocked('unverified_surface')
    nodes = [n for n in nodes if isinstance(n, dict) and n.get('visible-to-user') != 'false']
    if not any(n.get('package') == PACKAGE or n.get('package', '').startswith('com.android.printspooler') for n in nodes):
        raise PrivateSurfaceBlocked('outside_allowed_app')
    for node in nodes:
        value = label(node)
        if EMAIL.search(value) or any(word in value for word in PRIVATE_LABELS):
            raise PrivateSurfaceBlocked('private_content')
        package = node.get('package', '')
        if package == 'com.android.systemui':
            # Status icons have descriptions; ordinary status TEXT is time/battery.
            text = str(node.get('text', '')).strip()
            if text and not re.fullmatch(r'(?:\d{1,2}:\d{2}|\d{1,3}%?)', text):
                raise PrivateSurfaceBlocked('system_overlay')
        elif package and package != PACKAGE and package not in KEYBOARDS and not package.startswith('com.android.printspooler'):
            raise PrivateSurfaceBlocked('foreign_surface')
    return nodes


def install_privacy_guard(driver_class):
    """Check before frames leave the driver; reject Account taps before input."""
    if driver_class.__dict__.get('_power9_privacy_guard_installed'):
        return
    original_screen = driver_class.get_screen_data
    original_tap = driver_class.tap

    def reject(driver, reason):
        driver._power9_privacy_blocked = True
        raise PrivateSurfaceBlocked(reason) from None

    async def checked_screen(self, *args, **kwargs):
        if getattr(self, '_power9_privacy_blocked', False):
            reject(self, 'privacy_stop_latched')
        screen = await original_screen(self, *args, **kwargs)
        try:
            validate_screen(screen)
        except PrivateSurfaceBlocked as error:
            reject(self, str(error))
        return screen

    async def checked_tap(self, x, y, *args, **kwargs):
        # Local observation only: this frame is not returned to an agent.
        screen = await checked_screen(self, skip_settling=True)
        for node in validate_screen(screen):
            if not any(str(node.get(key, '')).strip() in PRIVATE_CONTROLS
                       for key in ('text', 'content-desc')):
                continue
            rect = bounds(node)
            if rect is None:
                reject(self, 'unverified_private_control_bounds')
            left, top, right, bottom = rect
            if left <= x <= right and top <= y <= bottom:
                reject(self, 'private_navigation')
        return await original_tap(self, x, y, *args, **kwargs)

    driver_class.get_screen_data = checked_screen
    driver_class.tap = checked_tap
    # A rejected frame also stops non-tap actions on this driver instance.
    def checked_action(original):
        async def action(self, *args, **kwargs):
            await checked_screen(self, skip_settling=True)
            return await original(self, *args, **kwargs)
        return action

    for name in ('swipe', 'input_text', 'press_key'):
        if hasattr(driver_class, name):
            setattr(driver_class, name, checked_action(getattr(driver_class, name)))
    driver_class._power9_privacy_guard_installed = True
