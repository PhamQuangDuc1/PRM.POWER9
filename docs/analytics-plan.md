# Lab 3 — Analytics plan trước instrumentation

## Native SDK bổ sung03/11/2026

Đã đối chiếu11/12 loại AppEvent bằng FA-SVC lọc trên thiết bị theo marker Power9 và thời gian thao tác, gồm login/logout, search, view_activity, schedule_created/updated/deleted, activity_completed, completion_undone, config_refreshed và report_generated. Params theo whitelist, không xuất rawlog/tài khoản. export_report chưa xác minh vì Storage production chưa có. Không suy ra server DebugView đã nhận đủ11 loại; xem evidence/analytics/2026-11-03/native-sdk-events.json và docs/lab3-verification-2026-11-03.md. Debug đã tắt và taglogs đã trả lại sau test.

## Bổ sung ngày 02/11

Mã hiện có12AppEvent, thêm schedule_deleted sau khi server xác nhận xóa lịch, tham số activity_id (mã danh mục, không UID/email). Telemetry lỗi không biến delete đã thành công thành failure. Event mới cần bổ sung DebugView evidence; không suy ra mọi event đã xác minh chỉ từ48tests hoặc demo CRUD.

## Cập nhật 01/11/2026

Rà soát tiếp tục tối 01/11: mã hiện có 11 event trong AppEvent, bổ sung `report_generated` sau khi tạo PDF và `export_report` sau khi upload thành công; cả hai gửi item_count/file_size_kb. Upload production đang khóa theo Spark nên chưa có bằng chứng export_report từ upload thật. Các tham số thực tế khác theo bảng trong firebase-observability.md; bảng bên dưới là kế hoạch ban đầu, không dùng để khẳng định đã gửi các params chưa có trong mã. `screen_view` riêng từng Flutter route chưa triển khai. Chưa đủ DebugView evidence cho cả 11 event.

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
