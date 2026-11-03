# Demo trực tiếp trên máy tính — Android Emulator

Khi không mang Xperia, dùng [kịch bản demo Android Emulator 8–10 phút](../../docs/demo-android-emulator-2026-11-04.md). Có hướng dẫn chuẩn bị APK x86_64, lời nói từng cảnh và phương án dự phòng. Kịch bản chưa được diễn tập trên AVD; bằng chứng Xperia vẫn ghi đúng thiết bị nguồn. Kết quả mới: DebugView server đã xác minh `view_activity/activity_id=move-walk` và người dùng xác nhận ba phần TalkBack thủ công. Video dưới đây giữ nguyên nội dung tại thời điểm quay.

# Video và slide hiện hành — 04/11/2026

Đã có `Power9_Lab3_Demo_Final.mp4` (6 phút 35 giây, Hoài My, 1080p) và SRT cùng tên. Slide chính Designer.pptx/Slides.pdf đã đồng bộ bản Final_Video_20261104. Xem [timeline và lời đọc thực](../../docs/video-script-spark-2026-11-04.md) và README của gói.

DebugView chưa nhận event trong buổi quay; FCM/Crashlytics lịch sử được ghi rõ; Storage production tắt. Dữ liệu thử đã dọn và debug khôi phục. Các chỉ dẫn bên dưới là tư liệu chuẩn bị/lịch sử, không thay metadata video hiện hành.

---

# Kịch bản hiện hành — giữ Spark

Ưu tiên [kịch bản ngày 04/11/2026](../../docs/video-script-spark-2026-11-04.md): UI mới, hai tài khoản đã kiểm chứng, ARTEMIS32/33, Pro189,02giây chưa đạt; không bật billing/upload production. Người dùng chọn chưa tiện quay, hoàn thiện slide và kịch bản trước. Các đoạn bên dưới là runbook mốc cũ.

---

# Demo và hướng dẫn sử dụng Power9

Hướng dẫn thao tác hiện hành: [Sử dụng app và demo từng luồng](../../docs/lab3-demo-guide.md).

Tài liệu đó bao gồm chuẩn bị, F01/F02/F03, CRUD lịch, timer, các màn bổ sung, PDF, Auth/privacy, Firebase, TalkBack và kịch bản demo gọn8–10phút. Có phân biệt phần làm được trên máy với Storage production/ARTEMIS còn phụ thuộc. Video được để sau; không cần quay mới dùng được hướng dẫn.

---

Phần dưới là kịch bản quay video dự kiến trước đó, lưu để dùng sau. Các số liệu/giới hạn phải đối chiếu mốc kiểm chứng hiện hành trước khi quay.

# Demo Lab 3 Power9 Office Routine

Mục tiêu: quay một video liên tục 7–9 phút, cho thấy app thật và Firebase Console. Đây là kịch bản quay, chưa phải minh chứng đã quay. Không dùng ảnh cũ để giả video thao tác hiện tại.

| Thời gian | Màn hình và thao tác | Cần nói hoặc chứng minh |
| --- | --- | --- |
| 00:00–00:35 | Tên app, Xperia, repository, Figma | Phạm vi ba flow và MVVM; không tuyên bố mọi mục đạt |
| 00:35–01:20 | Login/Profile nếu đang quay riêng bằng tài khoản kiểm thử | Google Sign-In thật, thông tin tài khoản chỉ để cục bộ; đăng xuất về Login và Back không lộ route cũ |
| 01:20–02:20 | Home → Khám phá → tìm chuỗi rỗng → reset → Chi tiết → Lịch | Bật nhắc nhưng bỏ giờ: validation; tắt nhắc/lưu; Home cập nhật sau ghi thành công |
| 02:20–03:25 | Thư giãn → bắt đầu → pause → Ở lại → resume → kết thúc sớm → ghi nhận | Thời gian thực, Progress đúng duration; không gán mặc định 180 giây |
| 03:25–04:10 | Home/Progress check-in, undo, xóa rồi Giữ lại | Chỉ thao tác dữ liệu test; completion xóa không mất schedule |
| 04:10–04:55 | Lịch đã có → đổi giờ → Hủy → đổi lại → Lưu | Hủy giữ giờ cũ; lưu không tăng số lịch |
| 04:55–05:35 | Progress → PDF → Tạo → Xem/lưu | Ngày, số hoạt động và duration thật; Android print preview. Cloud upload hiện tắt theo Spark |
| 05:35–06:20 | Firebase Console FCM và app inbox | Người dùng gửi Test message; bằng chứng ba trạng thái đã lưu riêng, không giả làm quay lại cả ba nếu chưa thao tác |
| 06:20–07:15 | Analytics DebugView và Crashlytics Console | Event/params hiện đúng app; fatal/nonfatal/user key có bằng chứng server. Không bấm crash giữa demo flow |
| 07:15–08:10 | Remote Config Console và màn debug (quay riêng, không gửi ARTEMIS) | Đổi hai tham số, fetch hành vi không rebuild, trả defaults sau demo |
| 08:10–08:50 | Kết quả tests/review và giới hạn | Tách pass/fail/skip/audit; chỉ nói PR và commit fixes khi đã có URL/SHA thật |

## Chuẩn bị trước quay

- Dùng APK trong cùng gói nộp; xem SHA256 trong manifest. Đảm bảo app còn Google session và mạng ổn định.
- Tự mở Console bằng tài khoản có quyền, tránh quay key, token, UID, email riêng và notification của app khác. Không nhập mật khẩu khi đang quay.
- Chỉ xóa/hoàn tác completion do lượt demo tạo. Nếu đã có dữ liệu thật, chọn hoạt động/ngày kiểm thử khác và ghi rõ.
- Storage production chưa có; cần chốt với thầy phương án Spark. Không nói PDF local/emulator là upload thật.
- Thêm link video vào README sau khi tải lên và kiểm tra quyền xem. Không tạo link placeholder như đã có video.

## Câu trả lời ngắn khi bị hỏi

- Vì sao xóa completion vẫn còn schedule? Hai collection độc lập, completion biểu thị đã làm, schedule biểu thị đã chọn.
- Vì sao check-in không hiện ba phút? Check-in không đo thời gian; durationSeconds=null để tránh số liệu giả.
- FCM có phải nhắc theo giờ không? Chưa. FCM nhận từ Console/API; giờ nhắc trong schedule hiện mới lưu lựa chọn.
- Vì sao Storage chưa demo được? Dự án giữ Spark, chưa có bucket production; uploader/Rules đã có nhưng chưa đủ minh chứng upload thật.
- ARTEMIS lỗi có phải app lỗi không? Cần xem trace: provider, harness và model observation có thể lỗi riêng; các failed attempts vẫn được báo cáo.
