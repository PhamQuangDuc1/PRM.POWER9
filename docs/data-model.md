# Firestore — mốc F01/F03

Danh mục là nội dung sản phẩm được seed vào Firestore bằng tài khoản quản trị có IAM, không phải dữ liệu completion giả. Client chỉ đọc activities có published=true. Không cho client ghi danh mục.

| Collection | Dữ liệu | Quyền |
| --- | --- | --- |
| activities | title, groupId, groupName, minutes, purpose, steps, note, rank, published | Người đăng nhập đọc published; client không ghi |
| users/{uid}/schedules | activityId, title, groupId, dateKey, minuteOfDay nullable, reminderEnabled, createdAt, updatedAt | Chỉ uid chủ đọc/tạo/sửa/xóa; validate schema và dữ liệu catalog |

Mỗi lịch có ID `activityId_yyyy-MM-dd`, tối đa một lịch/hoạt động/ngày. Retry và hai thiết bị cùng lưu dùng transaction đọc/sửa đúng doc, giữ createdAt. Đổi ngày chưa hỗ trợ cho lịch đã có; đổi giờ không tạo doc mới. Không có test mode/open Rules. Completion là collection riêng sẽ thêm ở F02; chưa tự tạo completion khi lưu schedule.

App chỉ báo thành công sau transaction server thành công. Offline transaction thất bại và giữ draft; không coi write đang chờ sync là đã lưu. Query ngày theo dateKey, catalog theo published; chưa cần composite index. DateKey biểu diễn ngày người dùng chọn theo thiết bị; timezone/midnight refresh cần kiểm tra trên Xperia.

`reminderEnabled` hiện lưu lựa chọn người dùng, chưa tự phát thông báo đúng giờ. Cơ chế nhắc thật cần hoàn thiện/kiểm chứng riêng; FCM console không thay thế lịch nhắc.
