enum AppEvent {
  login,
  logout,
  search,
  viewActivity,
  scheduleCreated,
  scheduleUpdated,
  scheduleDeleted,
  activityCompleted,
  completionUndone,
  configRefreshed,
  reportGenerated,
  exportReport,
  aiRequest,
  aiResultAccepted,
  aiError,
}

String eventName(AppEvent event) => switch (event) {
  AppEvent.viewActivity => 'view_activity',
  AppEvent.scheduleCreated => 'schedule_created',
  AppEvent.scheduleUpdated => 'schedule_updated',
  AppEvent.scheduleDeleted => 'schedule_deleted',
  AppEvent.activityCompleted => 'activity_completed',
  AppEvent.completionUndone => 'completion_undone',
  AppEvent.configRefreshed => 'config_refreshed',
  AppEvent.reportGenerated => 'report_generated',
  AppEvent.exportReport => 'export_report',
  AppEvent.aiRequest => 'ai_request',
  AppEvent.aiResultAccepted => 'ai_result_accepted',
  AppEvent.aiError => 'ai_error',
  _ => event.name,
};

abstract class TelemetryService {
  Future<void> initialize();
  Future<void> identify(String? uid);
  Future<void> event(
    AppEvent event, [
    Map<String, Object> parameters = const {},
  ]);
  Future<void> report(
    Object error,
    StackTrace stack, {
    required String operation,
    bool fatal = false,
  });
  Future<void> testCrash();
}
