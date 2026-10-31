import '../models/app_config.dart';

abstract class AppConfigService {
  Future<AppConfig> cached() async => const AppConfig();
  Future<AppConfig> fetch();
}
