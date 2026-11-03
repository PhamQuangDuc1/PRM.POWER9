import 'package:flutter_test/flutter_test.dart';
import 'package:power9_office_routine/models/activity.dart';
import 'package:power9_office_routine/viewmodels/discover_viewmodel.dart';

void main() {
  const activities = [
    Activity(
      id: 'walk',
      title: 'Đi bộ',
      groupId: 'move',
      groupName: 'Vận động',
      minutes: 3,
      purpose: '',
      steps: [],
      note: '',
      rank: 1,
    ),
    Activity(
      id: 'review',
      title: 'Tổng kết',
      groupId: 'balance',
      groupName: 'Cân bằng',
      minutes: 10,
      purpose: '',
      steps: [],
      note: '',
      rank: 2,
    ),
  ];
  test('combined query and duration exclude the 10-minute activity', () {
    expect(
      filterActivities(
        activities,
        const DiscoverFilter(maxMinutes: 5),
      ).map((item) => item.id),
      ['walk'],
    );
    expect(
      filterActivities(
        activities,
        const DiscoverFilter(query: ' CÂN BẰNG ', maxMinutes: 5),
      ),
      isEmpty,
    );
    expect(
      filterActivities(
        activities,
        const DiscoverFilter(query: 'đi bộ'),
      ).single.id,
      'walk',
    );
    expect(filterActivities(activities, const DiscoverFilter()), hasLength(2));
  });
}
