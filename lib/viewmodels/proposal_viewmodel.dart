import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:power9_core/power9_core.dart';

import '../services/firestore_client.dart';
import 'app_providers.dart';

final proposalStoreProvider = Provider(
  (ref) => ProposalStore(createFirestoreClient()),
);

final myProposalsProvider = StreamProvider.autoDispose
    .family<List<ActivityProposal>, String>(
      (ref, uid) => ref.watch(proposalStoreProvider).watchMine(uid),
    );

final proposalSubmissionProvider =
    NotifierProvider.autoDispose<ProposalSubmission, AsyncValue<void>>(
      ProposalSubmission.new,
    );

class ProposalSubmission extends Notifier<AsyncValue<void>> {
  String? _draftId;

  @override
  AsyncValue<void> build() {
    ref.watch(sessionProvider.select((value) => value.asData?.value?.uid));
    _draftId = null;
    return const AsyncData(null);
  }

  Future<bool> submit(
    String title,
    String groupId,
    int minutes,
    String description,
  ) async {
    final uid = ref.read(sessionProvider).asData?.value?.uid;
    if (uid == null || state.isLoading) return false;
    final store = ref.read(proposalStoreProvider);
    final draftId = _draftId ??= store.newId(uid);
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => store.submit(
        id: draftId,
        uid: uid,
        title: title.trim(),
        groupId: groupId,
        minutes: minutes,
        description: description.trim(),
      ),
    );
    if (!ref.mounted || _draftId != draftId) return false;
    state = result;
    if (result.hasError) return false;
    _draftId = null;
    return true;
  }
}
