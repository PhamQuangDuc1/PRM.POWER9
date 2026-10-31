import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../models/app_config.dart';
import 'app_config_service.dart';

class FirebaseAppConfigService extends AppConfigService {
  Future<void> _prepare() async {
    final config = FirebaseRemoteConfig.instance;
    await config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode
            ? Duration.zero
            : const Duration(hours: 1),
      ),
    );
    await config.setDefaults(AppConfig.defaults);
    await config.ensureInitialized();
  }

  AppConfig _read() {
    final config = FirebaseRemoteConfig.instance;
    return AppConfig.fromValues(
      config.getInt('discover_max_minutes'),
      config.getBool('connection_checkin_enabled'),
    );
  }

  @override
  Future<AppConfig> cached() async {
    if (Firebase.apps.isEmpty) return const AppConfig();
    await _prepare();
    return _read();
  }

  @override
  Future<AppConfig> fetch() async {
    if (Firebase.apps.isEmpty) return const AppConfig();
    await _prepare();
    final config = FirebaseRemoteConfig.instance;
    await config.fetchAndActivate();
    return _read();
  }
}
