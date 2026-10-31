# Firestore — lịch và bản ghi hoàn thành

Danh mục là nội dung sản phẩm được seed vào Firestore bằng tài khoản quản trị có IAM, không phải dữ liệu completion giả. Client chỉ đọc activities có published=true. Không cho client ghi danh mục.

| Collection | Dữ liệu | Quyền |
| --- | --- | --- |
| activities | title, groupId, groupName, minutes, purpose, steps, note, rank, published | Người đăng nhập đọc published; client không ghi |
| users/{uid}/schedules | activityId, title, groupId, dateKey, minuteOfDay nullable, reminderEnabled, createdAt, updatedAt | Chỉ uid chủ đọc/tạo/sửa/xóa; validate schema và dữ liệu catalog |
| users/{uid}/completions | activityId, title, groupId, dateKey, source, durationSeconds nullable, createdAt | Chỉ uid chủ đọc/tạo/xóa; không sửa đè bản ghi; validate source/thời lượng/catalog |

Schedule và completion đều có ID `activityId_yyyy-MM-dd`, nhưng nằm ở hai collection riêng. Retry và hai thiết bị cùng lưu schedule dùng transaction đọc/sửa đúng doc, giữ createdAt. Completion dùng transaction create-if-absent: retry giữ bản ghi đã được server chấp nhận, không sửa đè thời lượng hoặc tạo thêm occurrence. Đổi ngày chưa hỗ trợ cho lịch đã có; đổi giờ không tạo doc mới. Không có test mode/open Rules. Lưu schedule không tự tạo completion; xóa completion không xóa schedule.

`source` là checkin/timer/checklist. Check-in và checklist có durationSeconds=null vì không đo thời gian. Timer có durationSeconds nguyên từ 1 đến minutes*60 theo catalog; kết thúc sớm lưu số giây thực tế. Chưa đủ 1 giây thì không ghi. Ngày của phiên timer được chốt khi bắt đầu; nếu qua nửa đêm, bản ghi vẫn thuộc ngày bắt đầu và Progress mở đúng ngày đó.

Tiến độ là hợp của activityId trong schedule và completion của ngày chọn. Hoạt động hoàn thành ngoài lịch được tính đúng một lần vào mẫu số; do đó done không vượt total. Ngày trống total=0, không có chỉ tiêu 9/9. Undo/delete chỉ xóa occurrence tương ứng; các schedule còn nguyên.

App chỉ báo thành công sau transaction server thành công. Offline transaction thất bại và giữ draft; không coi write đang chờ sync là đã lưu. Query ngày theo dateKey, catalog theo published; chưa cần composite index. DateKey biểu diễn ngày người dùng chọn theo thiết bị; timezone/midnight refresh cần kiểm tra trên Xperia.

`reminderEnabled` hiện lưu lựa chọn người dùng, chưa tự phát thông báo đúng giờ. Cơ chế nhắc thật cần hoàn thiện/kiểm chứng riêng; FCM console không thay thế lịch nhắc.
