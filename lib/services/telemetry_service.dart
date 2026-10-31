enum AppEvent {
  login,
  logout,
  search,
  viewActivity,
  scheduleCreated,
  scheduleUpdated,
  activityCompleted,
  completionUndone,
  configRefreshed,
}

String eventName(AppEvent event) => switch (event) {
  AppEvent.viewActivity => 'view_activity',
  AppEvent.scheduleCreated => 'schedule_created',
  AppEvent.scheduleUpdated => 'schedule_updated',
  AppEvent.activityCompleted => 'activity_completed',
  AppEvent.completionUndone => 'completion_undone',
  AppEvent.configRefreshed => 'config_refreshed',
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
