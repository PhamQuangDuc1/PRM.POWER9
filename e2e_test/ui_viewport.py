"""Native viewport checks; never treat a clipped semantic node as tappable."""
import re

PACKAGE = 'vn.power9.power9_office_routine'


def bounds(node):
    match = re.fullmatch(r'\[(-?\d+),(-?\d+)\]\[(-?\d+),(-?\d+)\]', node.get('bounds', ''))
    return tuple(map(int, match.groups())) if match else None


def label(node):
    return node.get('text', '') or node.get('content-desc', '')


def content_viewport(tree):
    candidates = [bounds(n) for n in tree.iter('node')
                  if n.get('package') == PACKAGE and n.get('scrollable') == 'true']
    candidates = [r for r in candidates if r and r[2] > r[0] and r[3] > r[1]]
    if not candidates:
        raise AssertionError('No verified product scroll viewport')
    return max(candidates, key=lambda r: (r[2]-r[0])*(r[3]-r[1]))


def visible_target(tree, query):
    left, top, right, bottom = content_viewport(tree)
    for node in tree.iter('node'):
        if node.get('package') != PACKAGE or query not in label(node):
            continue
        if node.get('clickable') != 'true' or node.get('enabled', 'true') != 'true':
            continue
        rect = bounds(node)
        if rect and left <= rect[0] < rect[2] <= right and top <= rect[1] < rect[3] <= bottom and rect[3]-rect[1] >= 24:
            return True
    return False


def is_today_home(tree):
    nodes = [n for n in tree.iter('node') if n.get('package') == PACKAGE]
    return any('Power9 Office Routine' in label(n) for n in nodes) and any(
        n.get('selected') == 'true' and label(n).startswith('Hôm nay') for n in nodes)
