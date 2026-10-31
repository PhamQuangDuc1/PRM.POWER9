import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'telemetry_service.dart';

// Only product metadata is allowed. Never forward free-text search, email or name.
Map<String, Object> safeEventParameters(Map<String, Object> parameters) => {
  for (final entry in parameters.entries)
    if (const {
      'activity_id',
      'group_id',
      'source',
      'duration_seconds',
      'max_minutes',
      'query_length',
      'has_query',
      'method',
      'changed',
      'operation',
    }.contains(entry.key))
      entry.key: entry.value is String
          ? (entry.value as String)
                .replaceAll(RegExp('[^a-zA-Z0-9_-]'), '')
                .substring(
                  0,
                  (entry.value as String)
                      .replaceAll(RegExp('[^a-zA-Z0-9_-]'), '')
                      .length
                      .clamp(0, 64),
                )
          : entry.value,
};

class FirebaseTelemetryService implements TelemetryService {
  bool get _ready => Firebase.apps.isNotEmpty;
  Future<void> _bestEffort(Future<void> Function() action) async {
    if (!_ready) return;
    try {
      await action();
    } catch (_) {
      /* Telemetry cannot break user actions. */
    }
  }

  @override
  Future<void> initialize() async {
    if (!_ready) return;
    await _bestEffort(() async {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      await FirebaseCrashlytics.instance.setCustomKey(
        'app_name',
        'Power9 Office Routine',
      );
      await FirebaseCrashlytics.instance.setCustomKey(
        'platform',
        'flutter_android',
      );
    });
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      unawaited(
        report(
          details.exception,
          details.stack ?? StackTrace.current,
          operation: 'flutter_framework',
          fatal: true,
        ),
      );
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      unawaited(
        report(error, stack, operation: 'unhandled_async', fatal: true),
      );
      return true;
    };
  }

  @override
  Future<void> identify(String? uid) => _bestEffort(() async {
    await FirebaseAnalytics.instance.setUserId(id: uid);
    await FirebaseCrashlytics.instance.setUserIdentifier(uid ?? '');
  });

  @override
  Future<void> event(
    AppEvent event, [
    Map<String, Object> parameters = const {},
  ]) => _bestEffort(
    () => FirebaseAnalytics.instance.logEvent(
      name: eventName(event),
      parameters: safeEventParameters(parameters),
    ),
  );

  @override
  Future<void> report(
    Object error,
    StackTrace stack, {
    required String operation,
    bool fatal = false,
  }) => _bestEffort(() async {
    final rawCode = error is FirebaseException
        ? error.code
        : error.runtimeType.toString();
    final code = rawCode.replaceAll(RegExp('[^a-zA-Z0-9_-]'), '');
    await FirebaseCrashlytics.instance.recordError(
      StateError('$operation failed ($code)'),
      stack,
      reason: operation,
      fatal: fatal,
      information: ['operation=$operation', 'category=$code'],
      printDetails: false,
    );
  });

  @override
  Future<void> testCrash() async {
    if (!kDebugMode || !_ready) return;
    await FirebaseCrashlytics.instance.setCustomKey('test_crash', true);
    FirebaseCrashlytics.instance.crash();
  }
}
