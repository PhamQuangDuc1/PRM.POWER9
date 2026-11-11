import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import '../models/activity_report.dart';
import 'report_metadata.dart';
import 'report_service.dart';

final cloudinaryReportEndpoint = _configuredEndpoint();

Uri? _configuredEndpoint() {
  const address = String.fromEnvironment('POWER9_REPORT_UPLOAD_URL');
  final uri = Uri.tryParse(address);
  if (uri == null ||
      uri.path != '/reports' ||
      uri.hasQuery ||
      uri.hasFragment ||
      uri.userInfo.isNotEmpty) {
    return null;
  }
  if (uri.scheme == 'https' && uri.host.isNotEmpty) return uri;
  if (kDebugMode && uri.scheme == 'http' && uri.host == '127.0.0.1') return uri;
  return null;
}

class CloudinaryReportUploadService implements ReportUploadService {
  CloudinaryReportUploadService(this.endpoint);

  final Uri endpoint;

  @override
  Future<UploadedReport> upload(
    GeneratedReport report,
    void Function(double progress) onProgress,
  ) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user == null || user.uid != report.ownerUid) {
      throw StateError('Report owner changed');
    }
    final token = await user.getIdToken().timeout(const Duration(seconds: 15));
    if (token == null || auth.currentUser?.uid != report.ownerUid) {
      throw StateError('Report owner changed');
    }

    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      final uploaded = await _send(
        client,
        report,
        token,
        onProgress,
      ).timeout(const Duration(seconds: 60));
      if (auth.currentUser?.uid != report.ownerUid) {
        throw StateError('Report owner changed');
      }
      await saveReportMetadata(report, uploaded.path);
      return uploaded;
    } finally {
      client.close(force: true);
    }
  }

  Future<UploadedReport> _send(
    HttpClient client,
    GeneratedReport report,
    String token,
    void Function(double progress) onProgress,
  ) async {
    final request = await client.postUrl(endpoint);
    request.followRedirects = false;
    request.headers.contentType = ContentType('application', 'pdf');
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    request.contentLength = report.bytes.length;
    for (var offset = 0; offset < report.bytes.length;) {
      final end = min(offset + 64 * 1024, report.bytes.length);
      request.add(Uint8List.sublistView(report.bytes, offset, end));
      await request.flush();
      offset = end;
      onProgress(offset / report.bytes.length);
    }
    final response = await request.close();
    if (response.statusCode != HttpStatus.created) {
      throw HttpException('Report upload HTTP ${response.statusCode}');
    }
    final data = jsonDecode(
      await utf8.decoder.bind(response).join(),
    ) as Map<String, dynamic>;
    final path = 'reports/${report.ownerUid}/${report.digest}.pdf';
    final url = Uri.tryParse(data['url'] as String? ?? '');
    if (data['path'] != path ||
        url?.scheme != 'https' ||
        url?.host != 'api.cloudinary.com') {
      throw const FormatException('Invalid report upload response');
    }
    return UploadedReport(path: path, url: url.toString());
  }
}
