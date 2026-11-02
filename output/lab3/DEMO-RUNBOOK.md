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
