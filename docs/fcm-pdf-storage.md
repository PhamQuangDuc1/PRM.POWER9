# FCM và PDF/Storage — đang triển khai 01/11/2026

## Phạm vi và cấu trúc

- NotificationService/FirebaseNotificationService xử lý FCM, native channel và tương tác. NotificationController quản lý state; màn Thông báo không gọi Firebase trực tiếp.
- NotificationStore lưu từng message theo uid + hash messageId trong SharedPreferencesAsync, tránh ghi đè cả danh sách giữa foreground/background isolates. Load tối đa 100 thông báo mới nhất, đánh dấu đọc và deduplicate theo ID.
- Payload có data yêu cầu recipient_uid trùng tài khoản đang bind. Riêng notification-only không có data từ Console được coi là thông báo công khai của project: bind vào tài khoản đang hoạt động và mở Home. Chỉ dùng nội dung chung cho loại này, không gửi dữ liệu cá nhân. History vẫn nằm riêng theo uid; không hiển thị lịch sử tài khoản khác. Đăng xuất unbind owner, tắt auto-init, unregister FCM, xóa local notifications; phiên Auth vẫn được thoát nếu dọn messaging lỗi.
- Route nhận từ message chỉ hỗ trợ today/progress. date_key phải đúng ngày và nằm trong khoảng DatePicker hỗ trợ; dữ liệu lạ fallback về hôm nay, không mở URL/route tùy ý.
- FCM SDK 17.0.1 dùng register/onRegistered/unregister và Android installation-id opt-in để nhận FID. Không trộn API legacy token với FID. Console hiện chấp nhận cả hai; mã debug dùng trường token của NotificationStatus để chứa FID cho nhánh mới này.
- Chạm thông báo phải qua guard phiên timer; lựa chọn Ở lại không làm mất timer. Background handler có @pragma entry point; chỉ lưu inbox, không tự show trùng notification đã do FCM hiển thị.
- getInitialMessage xử lý cold start, onMessageOpenedApp xử lý background tap; foreground dùng local notification high-importance channel. Mở lại app refresh inbox từ storage. Không đồng nhất app terminated với Android Force stop.

## PDF và upload

- Progress → Xuất báo cáo PDF → ReportScreen(day). ReportController lấy snapshot đúng ngày đang xem, gắn owner nội bộ và bỏ dữ liệu khi đổi tài khoản. Không đưa UID/email/tên Google vào PDF.
- ReportGenerator tách khỏi ReportUploadService để kế thừa Final dễ hơn. PdfReportGenerator nhúng Be Vietnam Pro Regular/Bold và logo P9; không tải font lúc xuất.
- Nội dung: số đã thực hiện/tổng đã chọn, từng hoạt động/giờ/trạng thái/thời lượng thật, chú thích tự ghi nhận. Check-in/checklist không được gán thời lượng ước lượng; ngày rỗng vẫn xuất báo cáo rỗng rõ ràng.
- PrintingReportService mở native print preview để xem/lưu PDF và native share sheet. Không tự gửi báo cáo tới email/người khác.
- Upload dùng path reports/{uid}/{SHA256(bytes)}.pdf; cùng một file khi retry giữ nguyên path. Có tiến độ/cancel timeout 60 giây; metadata Firestore ghi sau khi Storage xác nhận và giữ createdAt nếu đã có.
- Nếu upload thất bại, giữ nguyên bytes PDF để thử lại/lưu trên máy. Thành công trả download URL, UI nhắc người có link có thể mở báo cáo. URL không được ghi vào Analytics hoặc public evidence.
- Rules Storage owner-only cho SDK access, MIME application/pdf, size >0 và <=10 MB, filename SHA256, date/schema metadata hợp lệ. Firestore reports metadata owner-only, đúng path/hash/schema, immutable. Link download có token là bearer link theo cơ chế Firebase, không được mô tả là owner-only khi đã chia sẻ URL.

## Kiểm chứng hiện tại

- Analyze sạch; 36 Flutter tests đạt. Thêm 7 tests về payload route/date, recipient isolation/public Console fallback, PDF thật tiếng Việt/long table, retry giữ đúng bytes, logout bỏ kết quả upload đến muộn và chặn uploader khi giữ Spark.
- 18 emulator tests đạt: 16 Firestore (thêm 2 report metadata) + 2 Storage (owner/read/cross-user/anonymous, MIME/name/size). Rules metadata đã compile/deploy production; chưa deploy Storage vì chưa có bucket được bật billing.
- QA PDF fixture do Dart tạo: 1 trang timer 72 giây và 10 trang/120 dòng thử bố cục; text nằm trong page bounds. Đã xem ảnh mẫu 1 trang và trang đầu/cuối bản dài. PyMuPDF extractor bỏ một số khoảng trắng, nên kiểm tra chữ chuẩn hóa whitespace và đối chiếu ảnh; không diễn giải đó là lỗi dấu.
- Các PDF fixture QA không phải báo cáo dữ liệu cloud. Bản riêng evidence/pdf/Power9-2026-11-01-xperia.pdf là PDF thật tạo trong app và lưu qua Android print → Lưu dưới dạng PDF → Downloads; đã pull lại/kiểm tra ngày 01/11, 0/2, lịch 21:30, đi bộ chưa chọn giờ và không có UID. Android Save as PDF có thể rewrite bytes, không dùng hash của file in lại để suy ra hash bytes upload gốc.
- FCM đã gửi qua HTTP API tới duy nhất Xperia: foreground/background/terminated đều thấy thông báo native, tap mở Progress và inbox giữ đủ 3 tin sau restart, đánh dấu đọc. Evidence evidence/fcm/sent-*.json, notification-tap-*.json, inbox-three-messages-xperia.png. API accepted không được dùng riêng để kết luận delivery; đã quan sát SystemUI và app.
- Terminated: HOME + am kill chưa kết thúc process do Android giữ service; dùng run-as chính UID app gửi SIGTERM, xác nhận pidof rỗng trước send. Không Force stop; không tác động app khác. Điều kiện thật được ghi trong terminated-precondition.json.
- Đã phối hợp người dùng gửi Test message từ Firebase Console ở cả foreground/background/terminated. Quan sát đúng tiêu đề Console trong SystemUI, chạm thông báo mở Home và xác nhận lưu inbox. Trước lượt terminated đã xác nhận process vắng mặt sau HOME + SIGTERM bằng UID app, không Force stop. Bằng chứng: evidence/fcm/console-notification-tap-*.json, console-terminated-precondition.json và console-three-states-inbox-xperia.png. Nguồn thao tác Console do người dùng thực hiện/xác nhận; quan sát delivery và route thực hiện trên Xperia. Các lượt API được ghi riêng, không dùng thay Console.

## Storage cần quyết định billing

Firebase yêu cầu Blaze để tạo/sử dụng Cloud Storage; project hiện là Spark. Chưa tự bật billing hoặc tạo bucket. Code uploader/Rules đã chuẩn bị, PDF local và FCM tiếp tục độc lập. Chưa coi local PDF hay emulator upload là thay thế minh chứng upload thật trong Lab 3.

Người dùng quyết định giữ Spark, chưa bật billing. Không đề nghị bật lại khi chưa có chỉ đạo mới. Remote Config report_upload_enabled=false (default local cũng false); UI thông báo lưu đám mây chưa kích hoạt và khóa CTA, controller cũng chặn trước khi gọi uploader. Test riêng kiểm tra không có upload request khi cờ tắt. Các tests uploader/retry dùng fake config bật chỉ trong test, không thay đổi server. Phần Storage production vẫn chưa đạt yêu cầu, cần trao đổi với thầy về phương án được chấp nhận.

Billing API cuối lượt vẫn billingEnabled=false. Gemini key ARTEMIS hiện gắn cùng project; khi bật billing cho Storage phải kiểm tra lại tier/chi phí hoặc tách project AI không billing trước khi chạy model. Không suy ra model vẫn free chỉ vì lần preflight trước chưa bật billing.

Smoke wrapper ARTEMIS cục bộ đã thêm kiểm tra billing trước lời gọi model và từ chối nếu billing đã đổi/không xác minh được. Đây không phải xác nhận mọi công cụ bên ngoài đều được bảo vệ; suite ARTEMIS chính thức phải có preflight tương tự. Không chạy model trong mốc FCM/PDF này.

Nguồn: [FCM Flutter](https://firebase.google.com/docs/cloud-messaging/flutter/get-started), [receive messages](https://firebase.google.com/docs/cloud-messaging/flutter/receive-messages), [FCM HTTP API](https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages), [Storage billing requirements](https://firebase.google.com/docs/storage/faqs-storage-changes-announced-sept-2024), [Dart PDF](https://github.com/DavBfr/dart_pdf).
