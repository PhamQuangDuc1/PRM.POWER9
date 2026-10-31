import 'package:printing/printing.dart';

import '../models/activity_report.dart';
import 'report_service.dart';

class PrintingReportService implements ReportPresentationService {
  @override
  Future<void> preview(GeneratedReport report) async {
    await Printing.layoutPdf(
      name: report.fileName,
      onLayout: (_) async => report.bytes,
    );
  }

  @override
  Future<void> share(GeneratedReport report) async {
    await Printing.sharePdf(bytes: report.bytes, filename: report.fileName);
  }
}
