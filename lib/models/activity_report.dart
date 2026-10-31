import 'dart:typed_data';

import 'today_overview.dart';

class ReportSnapshot {
  const ReportSnapshot({
    required this.ownerUid,
    required this.dateKey,
    required this.overview,
    required this.generatedAt,
  });
  final String ownerUid, dateKey;
  final TodayOverview overview;
  final DateTime generatedAt;
}

class GeneratedReport {
  const GeneratedReport({
    required this.ownerUid,
    required this.dateKey,
    required this.bytes,
    required this.digest,
    required this.itemCount,
  });
  final String ownerUid, dateKey, digest;
  final Uint8List bytes;
  final int itemCount;
  String get fileName => 'Power9-$dateKey-${digest.substring(0, 12)}.pdf';
}

class UploadedReport {
  const UploadedReport({required this.path, required this.url});
  final String path, url;
}
