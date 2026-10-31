import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/office_notification.dart';

class NotificationStore {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  static const _owner = 'p9_notification_owner';
  String _prefix(String uid) => 'p9_inbox_${uid}_';
  String _key(OfficeNotification item) =>
      '${_prefix(item.ownerUid)}${sha256.convert(utf8.encode(item.id))}';
  Future<String?> get owner => _prefs.getString(_owner);
  Future<void> bind(String uid) => _prefs.setString(_owner, uid);
  Future<void> unbind() => _prefs.remove(_owner);
  Future<bool> enabled(String uid) async =>
      await _prefs.getBool('p9_push_enabled_$uid') ?? false;
  Future<void> setEnabled(String uid, bool value) =>
      _prefs.setBool('p9_push_enabled_$uid', value);
  Future<void> save(OfficeNotification item) async {
    if (await owner != item.ownerUid) return;
    final key = _key(item);
    if (await _prefs.getString(key) == null) {
      await _prefs.setString(key, jsonEncode(item.toMap()));
    }
  }

  Future<void> markRead(OfficeNotification item) async {
    if (await owner != item.ownerUid) return;
    await _prefs.setString(_key(item), jsonEncode(item.asRead().toMap()));
  }

  Future<List<OfficeNotification>> load(String uid) async {
    final items = <OfficeNotification>[];
    for (final key in await _prefs.getKeys()) {
      if (!key.startsWith(_prefix(uid))) continue;
      try {
        final raw = await _prefs.getString(key);
        if (raw == null) continue;
        final item = OfficeNotification.fromMap(
          jsonDecode(raw) as Map<String, dynamic>,
        );
        if (item.ownerUid == uid) items.add(item);
      } catch (_) {
        /* Ignore malformed local entries; never render another account. */
      }
    }
    items.sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
    for (final item in items.skip(100)) {
      await _prefs.remove(_key(item));
    }
    return items.take(100).toList();
  }
}
