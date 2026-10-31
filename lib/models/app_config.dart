class AppConfig {
  const AppConfig({
    this.discoverMaxMinutes = 60,
    this.connectionCheckinEnabled = true,
  });
  final int discoverMaxMinutes;
  final bool connectionCheckinEnabled;

  static const defaults = {
    'discover_max_minutes': 60,
    'connection_checkin_enabled': true,
  };

  factory AppConfig.fromValues(int maxMinutes, bool checkinEnabled) =>
      AppConfig(
        discoverMaxMinutes: maxMinutes >= 5 && maxMinutes <= 60
            ? maxMinutes
            : 60,
        connectionCheckinEnabled: checkinEnabled,
      );
}
