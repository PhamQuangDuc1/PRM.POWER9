import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/activity.dart';
import '../models/completion.dart';
import '../models/schedule.dart';
import 'completion_service.dart';

class FirestoreCompletionService implements CompletionService {
  FirestoreCompletionService(this._db);
  final FirebaseFirestore _db;
  CollectionReference<Map<String, dynamic>> _records(String uid) =>
      _db.collection('users').doc(uid).collection('completions');

  @override
  Stream<List<Completion>> watchDay(String uid, String dateKey) => _records(uid)
      .where('dateKey', isEqualTo: dateKey)
      .snapshots(includeMetadataChanges: true)
      .where((snapshot) => !snapshot.metadata.hasPendingWrites)
      .map((snapshot) {
        final records = snapshot.docs
            .map(
              (doc) => Completion.fromMap(
                doc.id,
                doc.data(),
                createdAt: (doc.data()['createdAt'] as Timestamp?)?.toDate(),
              ),
            )
            .toList();
        records.sort(
          (a, b) => (b.createdAt ?? DateTime(1970)).compareTo(
            a.createdAt ?? DateTime(1970),
          ),
        );
        return records;
      });

  @override
  Future<void> record({
    required String uid,
    required Activity activity,
    required String dateKey,
    required CompletionSource source,
    int? durationSeconds,
  }) async {
    if (source == CompletionSource.timer &&
        (durationSeconds == null ||
            durationSeconds < 1 ||
            durationSeconds > activity.minutes * 60)) {
      throw ArgumentError('Invalid measured session duration');
    }
    if (source != CompletionSource.timer && durationSeconds != null) {
      throw ArgumentError('Do not assign unmeasured durations to check-ins');
    }
    final reference = _records(uid).doc(scheduleId(activity.id, dateKey));
    await _db.runTransaction(
      (transaction) async {
        final existing = await transaction.get(reference);
        // Retrying never overwrites a previously acknowledged occurrence.
        if (existing.exists) return;
        transaction.set(reference, {
          'activityId': activity.id,
          'title': activity.title,
          'groupId': activity.groupId,
          'dateKey': dateKey,
          'source': source.name,
          'durationSeconds': durationSeconds,
          'createdAt': FieldValue.serverTimestamp(),
        });
      },
      timeout: const Duration(seconds: 20),
      maxAttempts: 3,
    );
  }

  @override
  Future<void> delete(String uid, String id) async {
    final reference = _records(uid).doc(id);
    await _db.runTransaction(
      (transaction) async {
        await transaction.get(reference);
        transaction.delete(reference);
      },
      timeout: const Duration(seconds: 20),
      maxAttempts: 3,
    );
  }
}
