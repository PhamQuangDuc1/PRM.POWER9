# Lab 3 — Analytics plan trước instrumentation

## Cập nhật 01/11/2026

Đã instrument 9 event: login, logout, search, view_activity, schedule_created, schedule_updated, activity_completed, completion_undone, config_refreshed. Bảng params/trigger thực tế và bằng chứng nằm ở docs/firebase-observability.md. DebugView do người dùng cung cấp đã có config_refreshed/view_activity/activity_completed; cần bổ sung đủ ảnh params/event cho bộ nộp. screen_view hiện là auto event Android Activity, chưa phải screen tracking riêng cho từng Flutter route. export_report vẫn chưa triển khai; bảng dưới giữ lại kế hoạch ban đầu, không mô tả tất cả trạng thái hiện tại.

Các event dự kiến cho Power9, 31/10/2026. Chưa instrument và chưa có DebugView evidence. Không ghi tên, email, ghi chú hoặc query tự do; `activity_id` và `group_id` là mã danh mục kiểm soát. `user_id` dùng UID sau sign-in và clear khi sign-out, không dùng email.

| Event | Trigger | Tham số | Flow / câu hỏi |
| --- | --- | --- | --- |
| login | Đăng nhập thật thành công | method: string | Auth: người dùng vào được app? |
| logout | Đăng xuất thành công | Không | Auth: phiên kết thúc ở đâu? |
| screen_view | Mở màn | screen_name: string | Tất cả: màn nào được dùng? |
| search | Chạy tìm/lọc | group_id: string, max_minutes: int, result_count: int | F01: bộ lọc nào không có kết quả? |
| view_activity | Mở chi tiết | activity_id: string, group_id: string | F01/F03: hoạt động nào được xem? |
| schedule_created | Lưu lịch thành công | activity_id: string, reminder_enabled: bool | F01: xem rồi có đặt lịch? |
| activity_completed | Ghi nhận thành công | activity_id: string, duration_seconds: int | F02: hoạt động nào được thực hiện? |
| completion_undone | Undo thành công | activity_id: string | F02: người dùng cần sửa ghi nhận bao nhiêu lần? |
| schedule_updated | Đổi lịch thành công | activity_id: string | F03: nhu cầu điều chỉnh lịch thế nào? |
| export_report | Tạo và upload thành công | item_count: int, file_size_kb: int | Export: người dùng có lấy báo cáo không? |

Mỗi event cần ảnh DebugView; không đánh dấu đạt chỉ vì đã gọi SDK. Analytics không được làm hỏng action chính khi lỗi. Test ít nhất một event qua DebugView hoặc Logcat theo đề.
