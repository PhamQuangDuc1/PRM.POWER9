# Power9 Office Routine

## Lab 3 — ứng dụng đã tích hợp, đang hoàn thiện kiểm chứng

Mốc 04/11/2026: UI có 8 ảnh minh họa, 49 Flutter tests đạt và analyzer sạch. CRUD lịch đã demo Firestore/Xperia: thêm, xem, sửa và xóa, giữ lịch sử đã làm. Hai tài khoản A sang B rồi về A đã đối chiếu dữ liệu. TalkBack sau “Ở lại” có xác nhận nghe/vuốt trực tiếp; các luồng khác chưa kiểm tra hết.

Đã có [video cuối 6 phút 35 giây](output/lab3/Power9_Lab3_Demo_Final.mp4), giọng Hoài My, 1080p, app và Firebase Console thật, kèm [SRT](output/lab3/Power9_Lab3_Demo_Final.srt). [Slide PowerPoint 15 trang](output/lab3/Power9_Lab3_Designer.pptx) và [PDF trình chiếu](output/lab3/Power9_Lab3_Slides.pdf) đã đồng bộ theo buổi quay. Nhánh bàn giao là **OneD**; [metadata PR hiện hành](evidence/code-review/lab3-pr.json) ghi đường dẫn và trạng thái PR. Ba fix commits riêng được bảo toàn, chưa merge.

[Mốc mới nhất](docs/CONTINUE.md), [gói bàn giao](output/lab3/README.md), [checklist nộp](output/lab3/SUBMISSION-CHECKLIST.md). ARTEMIS 32/33, TC10[3] và Pro chưa đạt; DebugView server đã xác minh `view_activity/activity_id=move-walk` sau buổi quay. Checklist TalkBack thủ công ba phần đã được người dùng xác nhận đạt. Giữ Spark/billing tắt, loại Storage production khỏi phạm vi thực hiện theo quyết định chi phí; không coi tiêu chí upload đã đạt. Video/APK giữ cục bộ theo chính sách gói bàn giao; không merge PR hoặc đồng bộ Figma.

Tên Android: **Power9 Office Routine**. Icon dùng logo P9 gốc trên nền trắng. App kế thừa thiết kế Lab 2 ở các mục bên dưới; chưa hoàn thành toàn bộ Lab 3.

- Flutter 3.47.3 / Dart 3.13.3; Android package `vn.power9.power9_office_routine`.
- Firebase project mới `power9-office-se180724`, app Android đã đăng ký và có SHA-1 debug. Không bật billing trong bước khởi tạo.
- Mã app: `lib/screens/` → `lib/viewmodels/` → `lib/services/`; `lib/models/` độc lập SDK; token và widget ở `lib/theme/`, `lib/widgets/`.
- Cách chạy: `flutter pub get`, `flutter run -d <device-id>`; kiểm tra: `flutter analyze lib test`, `flutter test`.
- Xem [kiến trúc](docs/architecture.md), [truy vết Lab 2](docs/design-traceability.md), [kế hoạch hoàn thiện](docs/lab3-completion-plan.md), [Analytics plan](docs/analytics-plan.md).
- Đã chạy trên Sony SOV41 Android 11: đăng nhập, thêm/đổi/hủy lịch, check-in/undo, timer thật pause/resume/background, ghi nhận sớm/đủ phiên và xóa completion giữ schedule; S04 Kết nối, S09 checklist/offline retry, S10 nghỉ tối/đổi giờ đã có flow thật.
- Analytics có bằng chứng SDK cho 11/12 loại event; DebugView trong buổi quay 04/11 chưa nhận event, không dùng log SDK để thay server. Crashlytics server có fatal test crash và non-fatal lỗi mất mạng, Remote Config hai tham số đã đổi hành vi không rebuild ở lượt kiểm chứng trước. Xem [bằng chứng](docs/lab3-verification-2026-11-03.md). Tài khoản → Kiểm thử Firebase chỉ hiện trong bản debug; test crash cần xác nhận và sẽ đóng app.
- Kiểm tra ngày 01/11: analyze sạch, chạy lại 43/43 Flutter tests đạt; 18 Rules tests đạt ở mốc FCM/PDF (chưa chạy lại). FCM Console đã kiểm chứng foreground/background/terminated; PDF đã xuất trên Xperia. Storage production chưa đạt vì giữ Spark và khóa upload. ARTEMIS đã có suite mở rộng, đang xác minh đủ >=10 ca ×3; review PR và video demo còn cần đóng. Xem [tiến độ](docs/lab3-status.md), [test report](docs/test-report.md), [FCM/PDF/Storage](docs/fcm-pdf-storage.md).
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

## Hồ sơ Lab 3 trước hạn nộp 02/11

Báo cáo 10 trang và slide 15 trang nằm trong [gói cục bộ](output/lab3/README.md). [Review mã](ai/code-review/lab3-review.md) có ba sửa runtime và tests tương ứng; [hướng dẫn commit và PR](docs/lab3-commit-and-pr-guide.md) dành cho người dùng tự commit/push. APK/video/ZIP lớn giữ cục bộ, không commit; chưa có link video nộp bài. Kết quả E2E mới nhất ở [summary](evidence/artemis/lab3-summary.json); không suy ra collect/test code là pass.

Hướng dẫn sử dụng và demo từng flow Lab3: [docs/lab3-demo-guide.md](docs/lab3-demo-guide.md). Kiểm chứng bổ sung: [03/11/2026](docs/lab3-verification-2026-11-03.md).
