import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/activity.dart';
import 'activity_service.dart';

class FirestoreActivityService implements ActivityService {
  FirestoreActivityService(this._db);
  final FirebaseFirestore _db;

  @override
  Stream<List<Activity>> watchActivities() => _db
      .collection('activities')
      .where('published', isEqualTo: true)
      .snapshots()
      .map((snapshot) {
        final items = snapshot.docs
            .map((doc) => Activity.fromMap(doc.id, doc.data()))
            .toList();
        items.sort((a, b) => a.rank.compareTo(b.rank));
        return items;
      });
}
