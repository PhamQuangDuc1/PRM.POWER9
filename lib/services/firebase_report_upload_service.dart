import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/activity_report.dart';
import 'report_metadata.dart';
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
      await saveReportMetadata(report, path);
      final url = await reference.getDownloadURL().timeout(
        const Duration(seconds: 15),
      );
      return UploadedReport(path: path, url: url);
    } finally {
      await subscription.cancel();
    }
  }
}
