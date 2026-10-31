# Power9 Office Routine

## Lab 3 — khung Flutter đang triển khai

Tên Android: **Power9 Office Routine**. Icon dùng logo P9 gốc trên nền trắng. App kế thừa thiết kế Lab 2 ở các mục bên dưới; chưa hoàn thành toàn bộ Lab 3.

- Flutter 3.47.3 / Dart 3.13.3; Android package `vn.power9.power9_office_routine`.
- Firebase project mới `power9-office-se180724`, app Android đã đăng ký và có SHA-1 debug. Không bật billing trong bước khởi tạo.
- Mã app: `lib/screens/` → `lib/viewmodels/` → `lib/services/`; `lib/models/` độc lập SDK; token và widget ở `lib/theme/`, `lib/widgets/`.
- Cách chạy: `flutter pub get`, `flutter run -d <device-id>`; kiểm tra: `flutter analyze lib test`, `flutter test`.
- Xem [kiến trúc](docs/architecture.md), [truy vết Lab 2](docs/design-traceability.md), [kế hoạch hoàn thiện](docs/lab3-completion-plan.md), [Analytics plan](docs/analytics-plan.md).
- Đã build/cài trên Sony SOV41 Android 11; người dùng đăng nhập Google và đã kiểm tra Home trên thiết bị. Có flow thêm lịch/đổi giờ/hủy dựa trên Firestore thật; F02, phần còn lại của 10 màn và sáu dịch vụ chưa hoàn thiện.
- Kiểm tra mới nhất: analyze sạch, 11 test Flutter và 8 test Firestore Rules đạt. Xem [test report](docs/test-report.md); chưa chạy ARTEMIS.
- `pubspec.lock` giữ dependency đã resolve. CLI: FlutterFire 1.4.1. Các lệnh Firebase cần đăng nhập tài khoản có quyền dự án. Không commit token/credential đăng nhập CLI.

Ứng dụng Android tiếng Việt giúp nhân viên văn phòng tự chọn, lên lịch và ghi nhận hoạt động ngắn trong ngày làm việc. Ba persona chính ngang nhau: Huy 28 tuổi, Mai 24 tuổi và Linh 39 tuổi; đều là persona giả định.

Figma: https://www.figma.com/design/MTv5qJbn065VYJQIXausoq

Stitch: https://stitch.withgoogle.com/projects/2176700449127941467

GitHub: https://github.com/PhamQuangDuc1/PRM.POWER9

## Phạm vi hiện hành

9 nhóm: Move Often, Sit Smart, Eat Well, Sleep Well, Manage Stress, Healthy Space, Social Bonds, Purpose, Work–Life Balance. Một ứng dụng chung, không chọn persona và không ép hoàn thành 9/9 mỗi ngày.

Figma có 6 page, 10 màn chức năng, 3 starting point; bản 360 và 412 px. Thư viện có 37 biến, 6 text style, 1 effect style, 10 component families và 53 variants. Cả 9 nhóm Khám phá có mở/thu gọn. Kiểm tra 323 reactions không phát hiện đích hỏng.

## Tài liệu và bằng chứng

- [Persona](ux/persona.md), [IA và ba flow](ux/user-flow.md).
- [Brief](design/DESIGN.md), [10 màn](design/screen-spec.md), [quyết định thiết kế](design/design-decisions.md).
- [AI log](ai/ai-design-log.md), [3 phản biện](ai/critiques/OFFICE-3-MAIN-CRITIQUES.md), [before/after](docs/SLIDE-3-VONG-PHAN-BIEN.md).
- [Design system và component](design/component-spec.md), [audit Figma](docs/FIGMA-FINAL-AUDIT.md).
- [Flutter handoff 10 màn và hai mapping](handoff/flutter-handoff.md).
- [Slide Office hoàn chỉnh](output/presentation/Power9_Office_Lab2_Cap_Nhat/Power9_Office_Lab2_Hoan_Chinh.pptx), [kịch bản thuyết trình, demo và hỏi đáp](output/presentation/Power9_Office_Lab2_Cap_Nhat/Power9_Office_Kich_Ban_Cap_Nhat.docx).
- [Tải toàn bộ gói trình bày](output/presentation/Power9_Office_Lab2_Hoan_Chinh.zip), [hướng dẫn mở](output/presentation/Power9_Office_Lab2_Cap_Nhat/HUONG_DAN.md).

## Xác nhận nguồn và giới hạn

Người dùng xác nhận ngày 27/10/2026 đã gửi nguyên văn 100% các prompt Office do trợ lý cung cấp trên dự án Stitch mới. Giữ nguyên khối prompt trong ai/prompts/OFFICE-*.md; ảnh Stitch, render kiểm chứng Chrome và Figma được ghi nguồn riêng.

Timer/tìm kiếm/giờ nhắc trong prototype Lab 2 là mô phỏng trạng thái. Tại mốc Lab 2 chưa có user test, TalkBack, peer handoff test hoặc ứng dụng Flutter/backend; tiến độ triển khai Lab 3 nằm ở đầu README. Các mục tiêu thời gian là mục tiêu thiết kế, chưa đo thực tế. Thay đổi workspace không tự động được đẩy lên GitHub.

## Bộ trình bày cập nhật ngày 27/10/2026

12 slide theo hai tài liệu hướng dẫn Lab 2. Slide 06 trình bày ba vòng cải tiến và ảnh trước/sau; slide 07 có năm phát hiện, quyết định và lý do. Mỗi slide có nguồn HTTPS bấm được. Các nguồn GitHub gắn commit `aed77f1ccd9b8721816932cc7471992fbb7b7be8` đã push, để giữ nguyên minh chứng khi main cập nhật. Đã kiểm tra 31 URL trả HTTP 200; phản hồi HTTP không thay thế quyền xem nội dung Figma/Stitch.

Kịch bản có lời nói cho 12 slide, phân bổ 10 phút, demo 5 phút, ba flow và phần hỏi đáp. Đã xem bản render của 12 slide và 8 trang kịch bản. Lượt này Figma MCP báo hết hạn mức gói Starter; số liệu thiết kế dựa trên audit và ảnh đã lưu, chưa có kiểm tra trực tiếp Figma mới.
