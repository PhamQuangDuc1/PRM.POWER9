import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/activity_report.dart';
import 'report_service.dart';

class FirebaseReportUploadService implements ReportUploadService {
  @override
  Future<UploadedReport> upload(
    GeneratedReport report,
    void Function(double progress) onProgress,
  ) async {
    if (FirebaseAuth.instance.currentUser?.uid != report.ownerUid) {
      throw StateError('Report owner changed');
    }
    final path = 'reports/${report.ownerUid}/${report.digest}.pdf';
    final reference = FirebaseStorage.instance.ref(path);
    final task = reference.putData(
      report.bytes,
      SettableMetadata(
        contentType: 'application/pdf',
        customMetadata: {'dateKey': report.dateKey, 'schemaVersion': '1'},
      ),
    );
    final subscription = task.snapshotEvents.listen((snapshot) {
      if (snapshot.totalBytes > 0) {
        onProgress(snapshot.bytesTransferred / snapshot.totalBytes);
      }
    }, onError: (Object _) {});
    try {
      await task.timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          unawaited(task.cancel());
          throw TimeoutException('Report upload timed out');
        },
      );
      if (FirebaseAuth.instance.currentUser?.uid != report.ownerUid) {
        throw StateError('Report owner changed');
      }
      final metadata = FirebaseFirestore.instance
          .collection('users')
          .doc(report.ownerUid)
          .collection('reports')
          .doc(report.digest);
      await FirebaseFirestore.instance.runTransaction(
        (transaction) async {
          final existing = await transaction.get(metadata);
          if (!existing.exists) {
            transaction.set(metadata, {
              'dateKey': report.dateKey,
              'fileName': report.fileName,
              'storagePath': path,
              'byteLength': report.bytes.length,
              'sha256': report.digest,
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
        },
        timeout: const Duration(seconds: 20),
        maxAttempts: 3,
      );
      final url = await reference.getDownloadURL().timeout(
        const Duration(seconds: 15),
      );
      return UploadedReport(path: path, url: url);
    } finally {
      await subscription.cancel();
    }
  }
}
