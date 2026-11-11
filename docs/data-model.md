# Firestore — lịch và bản ghi hoàn thành

Danh mục được seed từ nội dung sản phẩm và được quản lý trong web Admin. Mobile chỉ đọc các hoạt động có `published: true`.

| Collection | Dữ liệu | Quyền |
| --- | --- | --- |
| activities | `title`, `groupId`, `groupName`, `purpose`, `note` (string), `minutes`, `rank` (int), `steps` (list string), `published` (bool) | User đọc hoạt động hiển thị. Admin đọc, tạo, sửa, lưu trữ và khôi phục. Không xóa từ client. Dùng ở Khám phá, Chi tiết và Danh mục Admin. |
| announcements | `title`, `body` (string), `createdAt` (timestamp của server) | Admin tạo, người đăng nhập đọc. Không sửa hoặc xóa từ client. Dùng trong form web và inbox mobile. |
| users/{uid}/reports/{sha256} | `dateKey`, `fileName`, `sha256` (string), `storagePath` (string hoặc null), `byteLength` (int), `createdAt` (timestamp của server) | Chủ tài khoản tạo và đọc metadata bất biến. Assignment dùng `storagePath: null` cho PDF trên thiết bị. Lab 3 dùng đường dẫn theo UID và SHA-256. |
| users/{uid}/schedules | activityId, title, groupId, dateKey, minuteOfDay nullable, reminderEnabled, createdAt, updatedAt | Chỉ uid chủ đọc/tạo/sửa/xóa; validate schema và dữ liệu catalog |
| users/{uid}/completions | activityId, title, groupId, dateKey, source, durationSeconds nullable, createdAt | Chỉ uid chủ đọc/tạo/xóa; không sửa đè bản ghi; validate source/thời lượng/catalog |

Schedule và completion đều có ID `activityId_yyyy-MM-dd`, nhưng nằm ở hai collection riêng. Retry và hai thiết bị cùng lưu schedule dùng transaction đọc/sửa đúng doc, giữ createdAt. Completion dùng transaction create-if-absent: retry giữ bản ghi đã được server chấp nhận, không sửa đè thời lượng hoặc tạo thêm occurrence. Đổi ngày chưa hỗ trợ cho lịch đã có; đổi giờ không tạo doc mới. Không có test mode/open Rules. Lưu schedule không tự tạo completion; xóa completion không xóa schedule.

`source` là checkin/timer/checklist. Check-in và checklist có durationSeconds=null vì không đo thời gian. Timer có durationSeconds nguyên từ 1 đến minutes*60 theo catalog; kết thúc sớm lưu số giây thực tế. Chưa đủ 1 giây thì không ghi. Ngày của phiên timer được chốt khi bắt đầu; nếu qua nửa đêm, bản ghi vẫn thuộc ngày bắt đầu và Progress mở đúng ngày đó.

Tiến độ là hợp của activityId trong schedule và completion của ngày chọn. Hoạt động hoàn thành ngoài lịch được tính đúng một lần vào mẫu số; do đó done không vượt total. Ngày trống total=0, không có chỉ tiêu 9/9. Undo/delete chỉ xóa occurrence tương ứng; các schedule còn nguyên.

App chỉ báo thành công sau transaction server thành công. Offline transaction thất bại và giữ draft; không coi write đang chờ sync là đã lưu. Query ngày theo dateKey, catalog theo published; chưa cần composite index. DateKey biểu diễn ngày người dùng chọn theo thiết bị; timezone/midnight refresh cần kiểm tra trên Xperia.

`reminderEnabled` hiện lưu lựa chọn người dùng, chưa tự phát thông báo đúng giờ. Cơ chế nhắc thật cần hoàn thiện/kiểm chứng riêng; FCM console không thay thế lịch nhắc.

## Assignment — vai trò và đề xuất

- `users/{uid}` có `role` kiểu string, nhận `user` hoặc `admin`. Người dùng có thể tạo document của mình với role `user` và đọc role của mình. Admin có thể đọc role người khác và thay đổi role của người khác. Không ai đổi role của chính mình. Admin đầu tiên cần được thiết lập từ Console. Các tài khoản cũ chưa có document role vẫn dùng được các luồng mobile hiện có.
- `activityProposals/{uid}~{id}` lưu `ownerUid`, `title`, `groupId`, `description`, `status` dạng string, `minutes` dạng int và `createdAt` dạng timestamp. Mobile chỉ tạo đề xuất của mình ở trạng thái `pending` và xem đề xuất của mình. Admin đọc hàng đợi và quyết định đúng một lần, chuyển `pending` sang `approved` hoặc `rejected`. Quyết định thêm `reason`, `reviewerUid` và `reviewedAt`. Giữ nguyên nội dung gốc. Không cho xóa từ client.
- Mobile dùng màn **Khám phá → Đề xuất hoạt động** để gửi và xem kết quả. Web dùng **Hàng đợi duyệt** để xử lý. Cả hai theo dõi snapshot Firestore. Admin có thể xuất bản đề xuất đã duyệt trong một transaction tạo `activities/{id}` và ghi `publishedActivityId` (string) vào đề xuất. Mỗi đề xuất chỉ được xuất bản một lần.
