import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/activity_report.dart';
import 'firestore_client.dart';

Future<void> saveReportMetadata(GeneratedReport report, String? path) async {
  final firestore = createFirestoreClient();
  final metadata = firestore
      .collection('users')
      .doc(report.ownerUid)
      .collection('reports')
      .doc(report.digest);
  await firestore.runTransaction(
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
}
