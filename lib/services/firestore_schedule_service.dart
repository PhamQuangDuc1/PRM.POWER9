import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/activity.dart';
import '../models/schedule.dart';
import 'schedule_service.dart';

class FirestoreScheduleService implements ScheduleService {
  FirestoreScheduleService(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _schedules(String uid) =>
      _db.collection('users').doc(uid).collection('schedules');

  @override
  Stream<List<Schedule>> watchDay(String uid, String dateKey) => _schedules(uid)
      .where('dateKey', isEqualTo: dateKey)
      .snapshots(includeMetadataChanges: true)
      .where((snapshot) => !snapshot.metadata.hasPendingWrites)
      .map((snapshot) {
        // Do not display pending local writes as successfully saved cloud data.
        final items = snapshot.docs
            .map((doc) => Schedule.fromMap(doc.id, doc.data()))
            .toList();
        items.sort(
          (a, b) => (a.minuteOfDay ?? 1440).compareTo(b.minuteOfDay ?? 1440),
        );
        return items;
      });

  @override
  Future<void> save({
    required String uid,
    required Activity activity,
    required String dateKey,
    required int? minuteOfDay,
    required bool reminderEnabled,
  }) async {
    final document = _schedules(uid).doc(scheduleId(activity.id, dateKey));
    // Deterministic ID and transaction make retries and concurrent taps idempotent.
    // Offline transactions fail without silently queuing a successful-looking save.
    await _db.runTransaction(
      (transaction) async {
        final existing = await transaction.get(document);
        final data = <String, dynamic>{
          'activityId': activity.id,
          'title': activity.title,
          'groupId': activity.groupId,
          'dateKey': dateKey,
          'minuteOfDay': minuteOfDay,
          'reminderEnabled': reminderEnabled,
          'updatedAt': FieldValue.serverTimestamp(),
        };
        if (existing.exists) {
          transaction.update(document, data);
        } else {
          transaction.set(document, {
            ...data,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      },
      timeout: const Duration(seconds: 20),
      maxAttempts: 3,
    );
  }

  @override
  Future<void> delete(String uid, String id) async {
    final document = _schedules(uid).doc(id);
    await _db.runTransaction(
      (transaction) async {
        await transaction.get(document);
        transaction.delete(document);
      },
      timeout: const Duration(seconds: 20),
      maxAttempts: 3,
    );
  }
}
