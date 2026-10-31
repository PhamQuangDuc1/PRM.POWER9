import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/activity_report.dart';
import '../models/today_overview.dart';
import 'report_service.dart';

class PdfReportGenerator implements ReportGenerator {
  PdfReportGenerator({Future<ByteData> Function(String path)? loadAsset})
    : _load = loadAsset ?? rootBundle.load;
  final Future<ByteData> Function(String path) _load;
  @override
  Future<GeneratedReport> generate(ReportSnapshot snapshot) async {
    final regular = pw.Font.ttf(
      await _load('assets/fonts/BeVietnamPro-Regular.ttf'),
    );
    final bold = pw.Font.ttf(await _load('assets/fonts/BeVietnamPro-Bold.ttf'));
    final logoData = await _load('assets/brand/power9-logo-3d.png');
    final logo = pw.MemoryImage(
      logoData.buffer.asUint8List(
        logoData.offsetInBytes,
        logoData.lengthInBytes,
      ),
    );
    final overview = snapshot.overview;
    final document = pw.Document(
      title: 'Power9 - Báo cáo hoạt động ${snapshot.dateKey}',
      author: 'Power9 Office Routine',
    );
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        maxPages: 100,
        theme: pw.ThemeData.withFont(base: regular, bold: bold),
        header: (_) => pw.Row(
          children: [
            pw.Image(logo, width: 38, height: 38),
            pw.SizedBox(width: 12),
            pw.Expanded(
              child: pw.Text(
                'Power9 Office Routine',
                style: pw.TextStyle(
                  font: bold,
                  fontSize: 19,
                  color: PdfColor.fromHex('#1E5AA8'),
                ),
              ),
            ),
          ],
        ),
        footer: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(top: 10),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Báo cáo cá nhân • ${snapshot.dateKey}',
                style: const pw.TextStyle(fontSize: 8),
              ),
              pw.Text(
                'Trang ${context.pageNumber}/${context.pagesCount}',
                style: const pw.TextStyle(fontSize: 8),
              ),
            ],
          ),
        ),
        build: (_) => [
          pw.SizedBox(height: 20),
          pw.Text(
            'Báo cáo hoạt động ngày ${snapshot.dateKey}',
            style: pw.TextStyle(font: bold, fontSize: 17),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Tạo lúc: ${snapshot.generatedAt.toLocal().toString().split('.').first}',
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            color: PdfColor.fromHex('#EEF3FF'),
            child: pw.Text(
              'Đã hoàn thành: ${overview.done}/${overview.total} hoạt động đã chọn • Còn lại: ${overview.pending.length}',
              style: pw.TextStyle(font: bold, fontSize: 11),
            ),
          ),
          pw.SizedBox(height: 14),
          if (overview.items.isEmpty)
            pw.Text(
              'Ngày này chưa có lịch hoặc bản ghi hoạt động.',
              style: const pw.TextStyle(fontSize: 11),
            ),
          if (overview.items.isNotEmpty)
            pw.TableHelper.fromTextArray(
              headers: [
                'Hoạt động',
                'Giờ hẹn',
                'Trạng thái',
                'Ghi nhận / thời lượng',
              ],
              data: [
                for (final item in overview.items)
                  [
                    item.title,
                    item.schedule?.timeLabel ?? 'Không đặt lịch',
                    item.isDone ? 'Đã hoàn thành' : 'Chưa hoàn thành',
                    _recordLabel(item),
                  ],
              ],
              columnWidths: {
                0: const pw.FlexColumnWidth(3.3),
                1: const pw.FlexColumnWidth(1.4),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(2.7),
              },
              cellStyle: const pw.TextStyle(fontSize: 9),
              headerStyle: pw.TextStyle(
                font: bold,
                fontSize: 9,
                color: PdfColors.white,
              ),
              headerDecoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#1E5AA8'),
              ),
              cellPadding: const pw.EdgeInsets.all(8),
              cellAlignment: pw.Alignment.topLeft,
            ),
          pw.SizedBox(height: 18),
          pw.Text(
            'Cách đọc báo cáo',
            style: pw.TextStyle(font: bold, fontSize: 11),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            'Một hoạt động chỉ tính một lần trong ngày. Lưu lịch không đồng nghĩa đã thực hiện. Check-in/checklist không được gán thời lượng chưa đo. Không có chỉ tiêu phải hoàn thành cả 9 nhóm mỗi ngày.',
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Đây là nhật ký tự ghi nhận, không phải đánh giá sức khỏe, chất lượng ngủ hoặc hiệu suất công việc.',
            style: const pw.TextStyle(fontSize: 9),
          ),
        ],
      ),
    );
    final bytes = await document.save();
    return GeneratedReport(
      ownerUid: snapshot.ownerUid,
      dateKey: snapshot.dateKey,
      bytes: bytes,
      digest: sha256.convert(bytes).toString(),
      itemCount: overview.total,
    );
  }

  String _recordLabel(TodayItem item) {
    final record = item.completion;
    if (record == null) return 'Chưa ghi nhận';
    if (record.durationSeconds != null) return record.durationLabel;
    return record.source.name == 'checklist'
        ? 'Checklist • không đo thời lượng'
        : 'Check-in • không đo thời lượng';
  }
}
