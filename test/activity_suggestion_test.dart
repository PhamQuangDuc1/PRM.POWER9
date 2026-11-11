import 'package:flutter_test/flutter_test.dart';
import 'package:power9_office_routine/models/activity.dart';
import 'package:power9_office_routine/services/activity_suggestion_service.dart';

Activity activity(String id) => Activity(
  id: id,
  title: id,
  groupId: 'move',
  groupName: 'Vận động',
  minutes: 3,
  purpose: '',
  steps: const [],
  note: '',
  rank: 1,
);

void main() {
  final candidates = ['a', 'b', 'c', 'd'].map(activity).toList();

  test('keeps allowed IDs in order, removes duplicates and caps results', () {
    final results = decodeSuggestions(
      '{"activity_ids":["b","missing","b",3,"a","c","d"]}',
      candidates,
    );
    expect(results.map((result) => result.id), ['b', 'a', 'c']);
  });

  test('does not render invented activity IDs', () {
    expect(
      decodeSuggestions('{"activity_ids":["missing"]}', candidates),
      isEmpty,
    );
  });

  test('rejects malformed output for fallback', () {
    for (final response in ['not JSON', '{"activity_ids":"a"}', '[]']) {
      expect(
        () => decodeSuggestions(response, candidates),
        throwsFormatException,
      );
    }
  });
}
