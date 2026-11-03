import 'package:flutter_test/flutter_test.dart';
import 'package:power9_office_routine/services/firebase_telemetry_service.dart';

void main() {
  test(
    'native SDK correlation marker is opt-in and disabled outside debug',
    () {
      expect(
        analyticsDebugParameters(debug: true, marker: 'p9_20261101_7fc421'),
        {'p9_e2e_build': 'p9_20261101_7fc421'},
      );
      expect(
        analyticsDebugParameters(debug: false, marker: 'p9_20261101_7fc421'),
        isNull,
      );
      expect(analyticsDebugParameters(debug: true, marker: ''), isNull);
    },
  );
  test('debug marker rejects free text and email-shaped values', () {
    for (final marker in ['person@example.com', 'private note', 'x' * 41]) {
      expect(analyticsDebugParameters(debug: true, marker: marker), isNull);
    }
  });
}
