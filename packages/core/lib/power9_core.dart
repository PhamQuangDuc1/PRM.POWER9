import 'package:cloud_firestore/cloud_firestore.dart';

const activityGroups = {
  'move': 'Vận động',
  'posture': 'Tư thế',
  'eat': 'Ăn uống',
  'sleep': 'Ngủ và phục hồi',
  'stress': 'Thư giãn',
  'space': 'Góc làm việc',
  'social': 'Kết nối',
  'purpose': 'Mục tiêu',
  'balance': 'Cân bằng',
};

enum ProposalStatus { pending, approved, rejected }

class AnnouncementStore {
  AnnouncementStore(FirebaseFirestore firestore)
    : _announcements = firestore.collection('announcements');

  final CollectionReference<Map<String, dynamic>> _announcements;

  Stream<List<({String title, String body})>> watchLatest() => _announcements
      .orderBy('createdAt', descending: true)
      .limit(30)
      .snapshots()
      .map(
        (snapshot) => [
          for (final doc in snapshot.docs)
            (
              title: doc.data()['title'] as String,
              body: doc.data()['body'] as String,
            ),
        ],
      );

  Future<void> send(String title, String body) async {
    await _announcements.add({
      'title': title,
      'body': body,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

class ActivityProposal {
  ActivityProposal.fromDocument(QueryDocumentSnapshot<Map<String, dynamic>> doc)
    : id = doc.id,
      title = doc.data()['title'] as String,
      groupId = doc.data()['groupId'] as String,
      minutes = doc.data()['minutes'] as int,
      description = doc.data()['description'] as String,
      status = ProposalStatus.values.byName(doc.data()['status'] as String),
      reason = doc.data()['reason'] as String?,
      publishedActivityId = doc.data()['publishedActivityId'] as String?,
      createdAt = (doc.data()['createdAt'] as Timestamp?)?.toDate();

  final String id, title, groupId, description;
  final int minutes;
  final ProposalStatus status;
  final String? reason, publishedActivityId;
  final DateTime? createdAt;
}

class ProposalStore {
  ProposalStore(FirebaseFirestore firestore)
    : _proposals = firestore.collection('activityProposals');

  final CollectionReference<Map<String, dynamic>> _proposals;

  String newId(String uid) => '$uid~${_proposals.doc().id}';

  Stream<List<ActivityProposal>> watchMine(String uid) =>
      _watch(_proposals.where('ownerUid', isEqualTo: uid));

  Stream<List<ActivityProposal>> watchPending() => _watch(
    _proposals.where('status', isEqualTo: ProposalStatus.pending.name),
  );

  Stream<List<ActivityProposal>> watchDecided() => _watch(
    _proposals.where(
      'status',
      whereIn: [ProposalStatus.approved.name, ProposalStatus.rejected.name],
    ),
  );

  Future<void> publish(ActivityProposal item) {
    final activity = _proposals.firestore.collection('activities').doc();
    final proposal = _proposals.doc(item.id);
    return _proposals.firestore.runTransaction((transaction) async {
      final data = (await transaction.get(proposal)).data();
      if (data?['status'] != ProposalStatus.approved.name) {
        throw StateError('Proposal must be approved');
      }
      if (data!['publishedActivityId'] != null) return;
      transaction.set(activity, {
        'title': item.title,
        'groupId': item.groupId,
        'groupName': activityGroups[item.groupId]!,
        'minutes': item.minutes,
        'purpose': item.description,
        'steps': <String>[],
        'note': '',
        'rank': 1000,
        'published': true,
      });
      transaction.update(proposal, {'publishedActivityId': activity.id});
    }, timeout: const Duration(seconds: 20));
  }

  Stream<List<ActivityProposal>> _watch(Query<Map<String, dynamic>> query) =>
      query
          .snapshots(includeMetadataChanges: true)
          .where((snapshot) => !snapshot.metadata.hasPendingWrites)
          .map((snapshot) {
            final items = snapshot.docs
                .map(ActivityProposal.fromDocument)
                .toList();
            items.sort(
              (a, b) => (b.createdAt?.millisecondsSinceEpoch ?? 0).compareTo(
                a.createdAt?.millisecondsSinceEpoch ?? 0,
              ),
            );
            return items;
          });

  Future<void> submit({
    required String id,
    required String uid,
    required String title,
    required String groupId,
    required int minutes,
    required String description,
  }) {
    final doc = _proposals.doc(id);
    return _proposals.firestore.runTransaction((transaction) async {
      final existing = await transaction.get(doc);
      if (existing.exists) return;
      transaction.set(doc, {
        'ownerUid': uid,
        'title': title,
        'groupId': groupId,
        'minutes': minutes,
        'description': description,
        'status': ProposalStatus.pending.name,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }, timeout: const Duration(seconds: 20));
  }

  Future<void> decide({
    required String id,
    required String reviewerUid,
    required ProposalStatus status,
    required String reason,
  }) => _proposals.firestore.runTransaction((transaction) async {
    final doc = _proposals.doc(id);
    final existing = await transaction.get(doc);
    if (existing.data()?['status'] != ProposalStatus.pending.name) {
      throw StateError('Proposal already reviewed');
    }
    transaction.update(doc, {
      'status': status.name,
      'reason': reason,
      'reviewerUid': reviewerUid,
      'reviewedAt': FieldValue.serverTimestamp(),
    });
  }, timeout: const Duration(seconds: 20));
}
