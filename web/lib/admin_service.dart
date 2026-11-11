import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:power9_core/power9_core.dart';

class AdminService {
  AdminService(this._auth, this._db, this._analytics)
    : proposals = ProposalStore(_db),
      announcements = AnnouncementStore(_db);

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final ProposalStore proposals;
  final AnnouncementStore announcements;
  final FirebaseAnalytics? _analytics;

  CollectionReference<Map<String, dynamic>> get _catalog =>
      _db.collection('activities');

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> watchCatalog() =>
      _catalog.snapshots().map((snapshot) => snapshot.docs);

  Future<void> saveActivity(String? id, Map<String, dynamic> data) =>
      _catalog.doc(id).set(data, SetOptions(merge: true));

  Future<void> setPublished(String id, bool published) =>
      _catalog.doc(id).update({'published': published});

  Future<({int published, int archived, List<int> proposals})>
  loadDashboard() async {
    final proposals = _db.collection('activityProposals');
    final counts = await Future.wait([
      for (final published in [true, false])
        _catalog.where('published', isEqualTo: published).count().get(),
      for (final status in ProposalStatus.values)
        proposals.where('status', isEqualTo: status.name).count().get(),
    ]);
    return (
      published: counts[0].count ?? 0,
      archived: counts[1].count ?? 0,
      proposals: [for (final count in counts.skip(2)) count.count ?? 0],
    );
  }

  Stream<String?> get session =>
      _auth.authStateChanges().map((user) => user?.uid);

  Stream<bool> watchAdmin(String uid) => _db
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((snapshot) => snapshot.data()?['role'] == 'admin');

  Future<void> signIn() async {
    await _auth.signInWithPopup(GoogleAuthProvider());
    final analytics = _analytics;
    if (analytics != null) {
      unawaited(
        analytics.logLogin(loginMethod: 'google').catchError((Object _) {}),
      );
    }
  }

  Future<void> signOut() => _auth.signOut();
}
