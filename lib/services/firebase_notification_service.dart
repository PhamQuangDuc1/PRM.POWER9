import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../firebase_options.dart';
import '../models/office_notification.dart';
import 'notification_service.dart';
import 'notification_store.dart';

OfficeNotification? notificationFromMessage(
  RemoteMessage message, {
  String? publicRecipient,
}) {
  // Notification-only Console campaigns are public announcements, not personal data.
  // A data/scoped payload must always carry an explicit recipient.
  final owner =
      message.data['recipient_uid'] ??
      (message.data.isEmpty ? publicRecipient : null);
  if (owner is! String || owner.isEmpty) return null;
  final now = DateTime.now();
  final rawDay = message.data['date_key'];
  return OfficeNotification(
    id:
        message.messageId ??
        jsonEncode([
          message.sentTime?.toIso8601String(),
          message.data,
          message.notification?.title,
        ]),
    ownerUid: owner,
    title: message.notification?.title ?? 'Power9 Office Routine',
    body: message.notification?.body ?? 'Bạn có một thông báo mới.',
    target: message.data['target'] == 'progress' ? 'progress' : 'today',
    dateKey: notificationDay(rawDay is String ? rawDay : null, now),
    receivedAt: now,
  );
}

@pragma('vm:entry-point')
Future<void> power9BackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final store = NotificationStore();
  final item = notificationFromMessage(
    message,
    publicRecipient: await store.owner,
  );
  if (item != null) await store.save(item);
}

class FirebaseNotificationService implements NotificationService {
  late final _store = NotificationStore();
  final _local = FlutterLocalNotificationsPlugin();
  final _changes = StreamController<void>.broadcast();
  final _taps = StreamController<OfficeNotification>.broadcast();
  final _subscriptions = <StreamSubscription<dynamic>>[];
  Future<void>? _hooks;
  Future<void> _binding = Future.value();
  String? _uid;
  String? _token;
  Completer<String>? _registration;
  @override
  String? get currentToken => _token;
  bool get _ready => Firebase.apps.isNotEmpty;
  static const channel = AndroidNotificationChannel(
    'power9_updates',
    'Thông báo Power9',
    description: 'Thông báo từ Power9 Office Routine',
    importance: Importance.high,
  );
  @override
  Stream<void> get changes => _changes.stream;
  @override
  Stream<OfficeNotification> get taps => _taps.stream;

  Future<T> _serialized<T>(Future<T> Function() action) {
    final result = _binding.then((_) => action());
    _binding = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }

  Future<void> _initialize() async {
    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_stat_power9'),
      ),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null) return;
        try {
          final item = OfficeNotification.fromMap(
            jsonDecode(payload) as Map<String, dynamic>,
          );
          if (item.ownerUid == _uid) _taps.add(item);
        } catch (_) {
          /* Unrecognized payload is never used as a route. */
        }
      },
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
    _subscriptions.add(
      FirebaseMessaging.onMessage.listen((message) {
        unawaited(_receive(message, show: true).catchError((Object _) {}));
      }),
    );
    _subscriptions.add(
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        unawaited(_receive(message, tap: true).catchError((Object _) {}));
      }),
    );
    _subscriptions.add(
      FirebaseMessaging.instance.onRegistered.listen(
        (token) {
          if (_uid == null) return;
          _token = token;
          final pending = _registration;
          if (pending != null && !pending.isCompleted) pending.complete(token);
          _changes.add(null);
        },
        onError: (Object error, StackTrace stack) {
          final pending = _registration;
          if (pending != null && !pending.isCompleted) {
            pending.completeError(error, stack);
          }
        },
      ),
    );
  }

  Future<void> _receive(
    RemoteMessage message, {
    bool show = false,
    bool tap = false,
  }) async {
    final item = notificationFromMessage(message, publicRecipient: _uid);
    if (item == null ||
        item.ownerUid != _uid ||
        await _store.owner != item.ownerUid) {
      return;
    }
    await _store.save(item);
    _changes.add(null);
    if (show) {
      await _local.show(
        id: item.id.hashCode & 0x7fffffff,
        title: item.title,
        body: item.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'power9_updates',
            'Thông báo Power9',
            importance: Importance.high,
            priority: Priority.high,
            icon: 'ic_stat_power9',
          ),
        ),
        payload: jsonEncode(item.toMap()),
      );
    }
    if (tap && item.ownerUid == _uid) _taps.add(item);
  }

  Future<NotificationStatus> _start(String uid, bool ask) async {
    if (!_ready) return const NotificationStatus();
    _uid = uid;
    try {
      await (_hooks ??= _initialize());
    } catch (_) {
      _hooks = null;
      rethrow;
    }
    await _store.bind(uid);
    if (!ask && !await _store.enabled(uid)) return const NotificationStatus();
    final settings = ask
        ? await FirebaseMessaging.instance.requestPermission()
        : await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.denied ||
        settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      throw StateError('Notification permission denied');
    }
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    final pending = Completer<String>();
    _registration = pending;
    String token;
    try {
      final result = await Future.wait<Object?>([
        pending.future,
        FirebaseMessaging.instance.register(),
      ]).timeout(const Duration(seconds: 20));
      token = result.first as String;
    } finally {
      _registration = null;
    }
    _token = token;
    await _store.setEnabled(uid, true);
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) await _receive(initial, tap: true);
    final launch = await _local.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp == true &&
        launch?.notificationResponse?.payload != null) {
      try {
        final item = OfficeNotification.fromMap(
          jsonDecode(launch!.notificationResponse!.payload!)
              as Map<String, dynamic>,
        );
        if (item.ownerUid == uid) _taps.add(item);
      } catch (_) {
        /* Invalid local route is ignored. */
      }
    }
    return NotificationStatus(enabled: true, token: token);
  }

  @override
  Future<NotificationStatus> restore(String uid) =>
      _serialized(() => _start(uid, false));
  @override
  Future<NotificationStatus> enable(String uid) =>
      _serialized(() => _start(uid, true));
  @override
  Future<void> disable() => _serialized(() async {
    _uid = null;
    _token = null;
    if (!_ready) return;
    await _store.unbind();
    await FirebaseMessaging.instance.setAutoInitEnabled(false);
    await FirebaseMessaging.instance.unregister().timeout(
      const Duration(seconds: 10),
    );
    await _local.cancelAll();
  });
  @override
  Future<List<OfficeNotification>> load(String uid) async =>
      _ready ? _store.load(uid) : [];
  @override
  Future<void> markRead(OfficeNotification item) async {
    await _store.markRead(item);
    _changes.add(null);
  }

  @override
  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    await _changes.close();
    await _taps.close();
  }
}
