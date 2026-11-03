import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/office_notification.dart';
import '../services/notification_service.dart';
import '../services/firebase_notification_service.dart';
import 'app_providers.dart';
import 'observability_providers.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = FirebaseNotificationService();
  ref.onDispose(() => unawaited(service.dispose()));
  return service;
});

class NotificationState {
  const NotificationState({
    this.status = const NotificationStatus(),
    this.items = const [],
    this.loading = false,
    this.error,
    this.pending,
  });
  final NotificationStatus status;
  final List<OfficeNotification> items;
  final bool loading;
  final String? error;
  final OfficeNotification? pending;
  int get unread => items.where((item) => !item.read).length;
}

final notificationControllerProvider = NotifierProvider.autoDispose
    .family<NotificationController, NotificationState, String>(
      NotificationController.new,
    );

class NotificationController extends Notifier<NotificationState> {
  NotificationController(this.uid);
  final String uid;
  int _refreshGeneration = 0;
  bool get _valid =>
      ref.mounted && ref.read(sessionProvider).asData?.value?.uid == uid;
  @override
  NotificationState build() {
    final service = ref.read(notificationServiceProvider);
    final changes = service.changes.listen((_) => unawaited(refresh()));
    final taps = service.taps.listen((item) {
      if (_valid && item.ownerUid == uid) open(item);
    });
    ref.onDispose(() {
      unawaited(changes.cancel());
      unawaited(taps.cancel());
    });
    Future.microtask(() => _initialize());
    return const NotificationState();
  }

  Future<void> _initialize() async {
    if (!_valid) return;
    try {
      final status = await ref.read(notificationServiceProvider).restore(uid);
      if (_valid) {
        state = NotificationState(
          status: status,
          items: state.items,
          pending: state.pending,
        );
      }
    } catch (error, stack) {
      if (_valid) {
        state = NotificationState(
          items: state.items,
          error: 'Chưa kết nối được thông báo. Bạn có thể thử lại.',
        );
        unawaited(
          ref
              .read(telemetryProvider)
              .report(error, stack, operation: 'notification_restore'),
        );
      }
    }
    await refresh();
  }

  Future<void> refresh() async {
    if (!_valid) return;
    final generation = ++_refreshGeneration;
    final service = ref.read(notificationServiceProvider);
    List<OfficeNotification> items;
    try {
      items = await service.load(uid);
    } catch (error, stack) {
      if (!_valid || generation != _refreshGeneration) return;
      state = NotificationState(
        status: state.status,
        items: state.items,
        pending: state.pending,
        error: 'Chưa đọc được lịch sử thông báo. Kéo xuống để thử lại.',
      );
      unawaited(
        ref
            .read(telemetryProvider)
            .report(error, stack, operation: 'notification_load'),
      );
      return;
    }
    if (!_valid || generation != _refreshGeneration) return;
    state = NotificationState(
      status: NotificationStatus(
        enabled: state.status.enabled,
        token: service.currentToken ?? state.status.token,
      ),
      items: items,
      loading: state.loading,
      error: state.error,
      pending: state.pending,
    );
  }

  Future<void> enable() async {
    if (!_valid || state.loading) return;
    state = NotificationState(
      status: state.status,
      items: state.items,
      loading: true,
      pending: state.pending,
    );
    try {
      final status = await ref.read(notificationServiceProvider).enable(uid);
      if (_valid) {
        state = NotificationState(
          status: status,
          items: state.items,
          pending: state.pending,
        );
      }
    } catch (error, stack) {
      if (!_valid) return;
      state = NotificationState(
        status: state.status,
        items: state.items,
        error: 'Chưa bật được thông báo. Kiểm tra mạng và quyền Thông báo trong cài đặt Android rồi thử lại.',
      );
      unawaited(
        ref
            .read(telemetryProvider)
            .report(error, stack, operation: 'notification_enable'),
      );
    }
  }

  void open(OfficeNotification item) {
    if (!_valid || item.ownerUid != uid) return;
    state = NotificationState(
      status: state.status,
      items: state.items,
      pending: item,
    );
  }

  OfficeNotification? consumeTap() {
    final item = state.pending;
    state = NotificationState(
      status: state.status,
      items: state.items,
      loading: state.loading,
      error: state.error,
    );
    return item;
  }

  Future<void> markRead(OfficeNotification item) async {
    if (!_valid || item.ownerUid != uid) return;
    await ref.read(notificationServiceProvider).markRead(item);
    await refresh();
  }
}
