import 'package:flutter_test/flutter_test.dart';
import 'package:power9_office_routine/services/day_clock.dart';

void main() {
  test(
    'day stream switches at midnight instead of keeping yesterday query',
    () async {
      var now = DateTime(2026, 10, 31, 23, 59);
      final clock = DayClock(
        now: () => now,
        interval: const Duration(milliseconds: 1),
      );
      final days = <String>[];
      await for (final day in clock.watchDay().distinct().take(2)) {
        days.add(day);
        now = DateTime(2026, 11, 1);
      }
      expect(days, ['2026-10-31', '2026-11-01']);
    },
  );
}
