import '../models/activity_report.dart';

abstract interface class ReportGenerator {
  Future<GeneratedReport> generate(ReportSnapshot snapshot);
}

abstract interface class ReportUploadService {
  Future<UploadedReport> upload(
    GeneratedReport report,
    void Function(double progress) onProgress,
  );
}

abstract interface class ReportPresentationService {
  Future<void> preview(GeneratedReport report);
  Future<void> share(GeneratedReport report);
}
