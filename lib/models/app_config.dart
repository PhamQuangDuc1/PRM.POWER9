class AppConfig {
  const AppConfig({
    this.discoverMaxMinutes = 60,
    this.connectionCheckinEnabled = true,
    this.reportUploadEnabled = false,
    this.aiEnabled = false,
    this.aiModel = defaultAiModel,
    this.aiPrompt = defaultAiPrompt,
  });
  final int discoverMaxMinutes;
  final bool connectionCheckinEnabled;
  final bool reportUploadEnabled;
  final bool aiEnabled;
  final String aiModel, aiPrompt;

  static const defaultAiModel = 'gemini-3.5-flash-lite';
  static const defaultAiPrompt =
      'Chọn tối đa 3 hoạt động phù hợp cho giờ nghỉ của nhân viên văn phòng. '
      'Chỉ trả về ID có trong danh sách ứng viên.';

  static const defaults = {
    'discover_max_minutes': 60,
    'connection_checkin_enabled': true,
    'report_upload_enabled': false,
    'discover_ai_enabled': false,
    'discover_ai_model': defaultAiModel,
    'discover_ai_prompt': defaultAiPrompt,
  };

  factory AppConfig.fromValues(
    int maxMinutes,
    bool checkinEnabled, {
    bool reportUploadEnabled = false,
    bool aiEnabled = false,
    String aiModel = defaultAiModel,
    String aiPrompt = defaultAiPrompt,
  }) => AppConfig(
    discoverMaxMinutes: maxMinutes >= 5 && maxMinutes <= 60 ? maxMinutes : 60,
    connectionCheckinEnabled: checkinEnabled,
    reportUploadEnabled: reportUploadEnabled,
    aiEnabled: aiEnabled,
    aiModel: aiModel.trim().isEmpty ? defaultAiModel : aiModel.trim(),
    aiPrompt: aiPrompt.trim().isEmpty ? defaultAiPrompt : aiPrompt.trim(),
  );
}
