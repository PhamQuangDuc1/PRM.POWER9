import '../models/schedule.dart';

class DayClock {
  DayClock({
    DateTime Function()? now,
    this.interval = const Duration(minutes: 1),
  }) : _now = now ?? DateTime.now;
  final DateTime Function() _now;
  final Duration interval;

  Stream<String> watchDay() async* {
    yield dayKey(_now());
    await for (final _ in Stream<void>.periodic(interval)) {
      yield dayKey(_now());
    }
  }
}
