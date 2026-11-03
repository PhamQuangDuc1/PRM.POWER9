import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity_providers.dart';
import 'app_providers.dart';

final checklistProvider = NotifierProvider.autoDispose
    .family<ChecklistViewModel, Set<int>, String>(ChecklistViewModel.new);

class ChecklistViewModel extends Notifier<Set<int>> {
  ChecklistViewModel(this.activityId);
  final String activityId;

  @override
  Set<int> build() {
    ref.watch(sessionProvider.select((session) => session.asData?.value?.uid));
    ref.watch(currentDayProvider);
    return const {};
  }

  void toggle(int index, bool checked, int itemCount) {
    if (index < 0 || index >= itemCount) return;
    if (checked) {
      state = {...state, index};
    } else {
      state = {...state}..remove(index);
    }
  }
}
