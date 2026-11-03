class AppConfig {
  const AppConfig({
    this.discoverMaxMinutes = 60,
    this.connectionCheckinEnabled = true,
    this.reportUploadEnabled = false,
  });
  final int discoverMaxMinutes;
  final bool connectionCheckinEnabled;
  final bool reportUploadEnabled;

  static const defaults = {
    'discover_max_minutes': 60,
    'connection_checkin_enabled': true,
    'report_upload_enabled': false,
  };

  factory AppConfig.fromValues(
    int maxMinutes,
    bool checkinEnabled, {
    bool reportUploadEnabled = false,
  }) => AppConfig(
    discoverMaxMinutes: maxMinutes >= 5 && maxMinutes <= 60 ? maxMinutes : 60,
    connectionCheckinEnabled: checkinEnabled,
    reportUploadEnabled: reportUploadEnabled,
  );
}
