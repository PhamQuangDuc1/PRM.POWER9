# Kết nối, Góc làm việc, Ngủ & phục hồi — 01/11/2026

Phạm vi: hoàn thiện ba màn kế thừa Lab 2 và kiểm tra nhánh mất mạng, không bổ sung tính năng Final.

- Kết nối: hai thẻ riêng cho đi bộ và trò chuyện; đọc catalog Firestore; check-in/undo dùng CompletionActionViewModel/CompletionService, không gán thời lượng chưa đo.
- Góc làm việc: route từ hoạt động tư thế/không gian; ChecklistViewModel giữ các mục được tích trong phiên màn hình; chỉ bật ghi nhận khi đủ mục; khóa checklist trong lúc lưu; ghi một completion có source checklist và durationSeconds null. Draft được reset khi đổi user/ngày hoặc provider bị dispose; chưa lưu draft sau khi đóng app.
- Ngủ & phục hồi: S10 là nội dung chuẩn bị nghỉ tối, không phải màn lỗi kết nối. Form dùng đúng activity, Hủy/Back quay về S10; lưu thành công quay về S10 và thông báo đã lưu. activityScheduleProvider đọc lịch hôm nay để hiển thị giờ đã đặt và mở lại form sửa đúng giờ cũ. Chưa tuyên bố thông báo nhắc giờ đã triển khai.
- Lỗi lưu: CTA đổi thành Thử lưu lại; lỗi không tự xóa lựa chọn, không chuyển Progress trước khi server xác nhận; transaction dùng ID activity/ngày để chống trùng.

Kiểm tra mã: flutter analyze không issue; toàn bộ 23 Flutter tests đạt, gồm hai widget tests mới về checklist thất bại/thử lại và Hủy lịch từ S10. Log: `evidence/flutter/unit-widget-workspace-tests.txt`.

Thiết bị Sony Xperia SOV41 / Android 11:

- Cài APK thành công bằng install -r, giữ phiên Google và dữ liệu ngày trước.
- Tab Kết nối hiện hai thẻ; trò chuyện mở đúng detail; ghi nhận mở Progress; Back quay lại detail, Hoàn tác xóa bản ghi thử. Server evidence `evidence/flows/completion-connection-record.json` xác nhận social-chat/source checkin/durationSeconds null.
- S10 mở form đúng hoạt động, Hủy quay lại Ngủ & phục hồi; chọn 21:30 bằng time picker, lưu server thành công và quay lại S10. Server minuteOfDay=1290, reminderEnabled=false; giữ lịch này để xem trên app. Evidence `evidence/flows/sleep-schedule-verification.json`. Không diễn giải việc lưu lịch thành completion hoặc thông báo đã lên lịch.
- APK cuối sau force-stop/restart đọc lại trạng thái Đã đặt lịch hôm nay · 21:30; nút Đổi giờ mở form sửa giữ 21:30, Hủy không đổi dữ liệu. Ảnh `evidence/workspace/recovery-saved-xperia.png`.
- S09 từ Kiểm tra tư thế mở đúng Góc làm việc, 0/3 mục thì CTA không thể bấm. Tắt cả Wi-Fi và mobile data, tích 3/3 và lưu: hiện lỗi, giữ nguyên lựa chọn và CTA thử lại. Khôi phục mạng, thử lại thành công mở Progress. Server chỉ có một posture-check/source checklist/durationSeconds null, không trùng và không ảnh hưởng lịch cũ. Evidence `evidence/workspace/offline-device-log.txt`, ảnh `checklist-offline-xperia.png` và `evidence/flows/completion-checklist-retried.json`.
- Hoàn tác các completion thử social-chat/posture-check qua UI sau khi đối chiếu server. Wi-Fi=1, mobile_data=1, stay_on_while_plugged_in=0 như trước ca thử.

Các lần thao tác ADB này là smoke tests, không tính vào yêu cầu ARTEMIS >=10 cases ×3 runs. Không gọi các màn này hoàn tất pixel-perfect; cần đối chiếu Figma và hoàn thiện bộ Firebase còn thiếu trước nộp.
