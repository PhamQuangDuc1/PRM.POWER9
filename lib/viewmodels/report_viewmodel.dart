import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity_report.dart';
import '../services/assignment_emulator.dart';
import '../services/report_service.dart';
import '../services/report_metadata.dart';
import '../services/pdf_report_generator.dart';
import '../services/printing_report_service.dart';
import '../services/firebase_report_upload_service.dart';
import '../services/cloudinary_report_upload_service.dart';
import '../services/telemetry_service.dart';
import 'app_providers.dart';
import 'completion_providers.dart';
import 'observability_providers.dart';

final reportGeneratorProvider = Provider<ReportGenerator>(
  (ref) => PdfReportGenerator(),
);
final reportUploadProvider = Provider<ReportUploadService>((ref) {
  final endpoint = cloudinaryReportEndpoint;
  return endpoint == null
      ? FirebaseReportUploadService()
      : CloudinaryReportUploadService(endpoint);
});

final reportUploadEnabledProvider = Provider<bool>(
  (ref) =>
      !assignmentEmulatorEnabled &&
      ((kDebugMode && cloudinaryReportEndpoint?.host == '127.0.0.1') ||
          ref.watch(appConfigProvider).value.reportUploadEnabled),
);
final reportPresentationProvider = Provider<ReportPresentationService>(
  (ref) => PrintingReportService(),
);

class ReportState {
  const ReportState({
    this.report,
    this.uploaded,
    this.operation,
    this.progress = 0,
    this.error,
  });
  final GeneratedReport? report;
  final UploadedReport? uploaded;
  final String? operation, error;
  final double progress;
  bool get busy => operation != null;
}

final reportControllerProvider = NotifierProvider.autoDispose
    .family<ReportController, ReportState, String>(ReportController.new);

class ReportController extends Notifier<ReportState> {
  ReportController(this.day);
  final String day;
  int _generation = 0;
  @override
  ReportState build() {
    ref.watch(sessionProvider.select((session) => session.asData?.value?.uid));
    _generation++;
    return const ReportState();
  }

  Future<void> generate() async {
    if (state.busy) return;
    final uid = ref.read(sessionProvider).asData?.value?.uid;
    final overview = ref.read(todayOverviewProvider(day)).asData?.value;
    if (uid == null || overview == null) {
      state = const ReportState(
        error: 'Chưa tải đủ dữ liệu ngày này. Kiểm tra mạng rồi thử lại.',
      );
      return;
    }
    final generation = _generation;
    state = const ReportState(operation: 'generate');
    try {
      final report = await ref
          .read(reportGeneratorProvider)
          .generate(
            ReportSnapshot(
              ownerUid: uid,
              dateKey: day,
              overview: overview,
              generatedAt: DateTime.now(),
            ),
          );
      if (!ref.mounted || generation != _generation) return;
      var metadataFailed = false;
      // Upload writes the final metadata. A local record would be immutable.
      if (const bool.fromEnvironment('POWER9_ASSIGNMENT') &&
          !ref.read(reportUploadEnabledProvider)) {
        try {
          await saveReportMetadata(report, null);
        } catch (_) {
          metadataFailed = true;
        }
      }
      if (!ref.mounted || generation != _generation) return;
      state = ReportState(
        report: report,
        error: metadataFailed
            ? 'Đã tạo PDF. Chưa đồng bộ được thông tin báo cáo, bạn vẫn có thể lưu hoặc chia sẻ file.'
            : null,
      );
      await ref.read(telemetryProvider).event(AppEvent.reportGenerated, {
        'item_count': report.itemCount,
        'file_size_kb': (report.bytes.length / 1024).ceil(),
      });
    } catch (error, stack) {
      if (!ref.mounted || generation != _generation) return;
      state = const ReportState(
        error: 'Chưa tạo được PDF. Dữ liệu hoạt động vẫn được giữ, bạn có thể thử lại.',
      );
      await ref
          .read(telemetryProvider)
          .report(error, stack, operation: 'report_generate');
    }
  }

  Future<void> present({bool share = false}) async {
    final report = state.report;
    if (state.busy || report == null) return;
    final previous = state;
    final generation = _generation;
    state = ReportState(
      report: report,
      uploaded: previous.uploaded,
      operation: share ? 'share' : 'preview',
    );
    try {
      final service = ref.read(reportPresentationProvider);
      if (share) {
        await service.share(report);
      } else {
        await service.preview(report);
      }
      if (ref.mounted && generation == _generation) {
        state = ReportState(report: report, uploaded: previous.uploaded);
      }
    } catch (error, stack) {
      if (!ref.mounted || generation != _generation) return;
      state = ReportState(
        report: report,
        uploaded: previous.uploaded,
        error: 'Chưa mở được PDF. File đã tạo vẫn được giữ.',
      );
      await ref
          .read(telemetryProvider)
          .report(error, stack, operation: 'report_present');
    }
  }

  Future<void> upload() async {
    final report = state.report;
    if (state.busy || report == null) return;
    if (!ref.read(reportUploadEnabledProvider)) {
      state = ReportState(
        report: report,
        error: 'Lưu đám mây chưa được kích hoạt. Bạn vẫn có thể lưu hoặc chia sẻ PDF trên thiết bị.',
      );
      return;
    }
    if (ref.read(sessionProvider).asData?.value?.uid != report.ownerUid) return;
    final generation = _generation;
    state = ReportState(report: report, operation: 'upload');
    try {
      final uploaded = await ref.read(reportUploadProvider).upload(report, (
        progress,
      ) {
        if (ref.mounted && generation == _generation) {
          state = ReportState(
            report: report,
            operation: 'upload',
            progress: progress.clamp(0, 1),
          );
        }
      });
      if (!ref.mounted || generation != _generation) return;
      state = ReportState(report: report, uploaded: uploaded, progress: 1);
      await ref.read(telemetryProvider).event(AppEvent.exportReport, {
        'item_count': report.itemCount,
        'file_size_kb': (report.bytes.length / 1024).ceil(),
      });
    } catch (error, stack) {
      if (!ref.mounted || generation != _generation) return;
      state = ReportState(
        report: report,
        error: 'Chưa lưu được lên đám mây. Kiểm tra kết nối và thử lại. Bạn vẫn có thể lưu hoặc chia sẻ PDF trên thiết bị.',
      );
      await ref
          .read(telemetryProvider)
          .report(error, stack, operation: 'report_upload');
    }
  }
}
