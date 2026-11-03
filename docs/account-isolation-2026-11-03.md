# Kiểm tra hai tài khoản trên máy — A → B → A đã thực hiện

## Kết quả hiện hành

Người dùng tự chọnB và sau đó tự chọn lạiA, xác nhận vàoHome mỗi lần. Định danh Google/UID khác nhau đã được so sánh cục bộ. Lịch/completion củaA không có trênHome/Progress/đường dẫn serverB. QuayA thấy lại dữ liệu, scheduleCreatedAt/updatedAt và completionCreatedAt/source không đổi. Đã hoàn tác completion và xóa đúng lịch thử; server xác nhận hai document trở lại vắng mặt, app vềHome, UIAutomator dừng. Xem `verify-b.json`, `a-returned.json`, `a-completion-undone.json`, `a-cleaned.json`, `roundtrip.json` trong `evidence/auth/2026-11-03-ui-isolation`.

Đính chính inbox: A rỗng trước/sau; **B có6mục thông báo**, không xuất hiện ởA sau chuyển lại. Nội dung không xuất công khai, chỉ so sánh hash và số lượng. Script ban đầu đánh dấu chưa đủ vìA rỗng; audit bổ sung ghi nhận bằng chứng có dữ liệu theo chiềuB→A trong `inbox-observation-audit.json`. Không gửi thông báo mới, không chỉnh/xóa inboxB. Phạm vi là cách ly quan sát trên lượt đổi tài khoản thật, không thay kiểm tra mọi race hoặc Rules.

Các mục dưới giữ lại kế hoạch và trạng thái chuẩn bị ban đầu; ưu tiên kết quả trên.

APK UI03/11, không gọi model. Người dùng đã có tài khoản B và yêu cầu tiếp tục; người dùng tự chọn tài khoản trong bộ chọn Google. Không lưu ảnh/cây bộ chọn hoặc Profile/debug vào evidence công khai. UID/email chỉ ở ignored `.build/isolation-ui-20261103`; evidence dùng aliasA/B.

## Chuẩn bị A đã thực hiện

- Đọc đúng document `move-walk_<ngày trên máy>` của A: lịch và completion chưa tồn tại. Evidence `evidence/auth/2026-11-03-ui-isolation/a-before.json`.
- Tạo lịch Đi bộ giữa giờ hôm nay trong app, nhắc tắt, không chọn giờ; Firestore xác nhận lịch.
- Lượt chạm check-in đầu không được server xác nhận; giữ `a-sentinel-created.json` với completionExists=false. Không tính thành pass. Đã cuộn card vào vùng nhìn thấy, xác minh lại đúng tài khoảnA và chạm nút của lịch thử; `a-sentinel-confirmed.json` xác nhận schedule+completion tồn tại, source=checkin.
- InboxA đang rỗng. Chưa thể dùng hai inbox rỗng làm bằng chứng cách ly thông báo có dữ liệu.
- Mở bộ chọn Google và dừng UIAutomator. Đang chờ người dùng chọnB và báo đã vàoHome. Chưa xác minh B hoặc quay lạiA; chưa cleanup sentinelA.

## Cần tiếp tục

1. Người dùng chọnB; xác minh UID/email khácA chỉ ở máy cục bộ.
2. Đối chiếu Home, Progress đúng ngày và exact-document serverB: dữ liệu thử củaA không xuất hiện. Không mặc địnhB không có dữ liệu riêng.
3. Người dùng chọn lạiA; đối chiếu createdAt/updatedAt/completion với snapshot đã tạo.
4. Hoàn tác/xóa đúng dữ liệu thử, bảo toàn dữ liệu có trước. Không dùng nút Hoàn tác chung nếu có nhiều bản ghi.
5. Nếu inbox không có dữ liệu để đối chiếu, cần một thông báo thử có owner rõ ràng rồi kiểm tra đổi tài khoản. Chưa gửi thông báo hoặc bật quyền thay người dùng trong lượt này.

Các API quản trị ở đây chỉ đọc exact-document để đối chiếu dữ liệu; không dùng chúng làm bằng chứng Rules của client. Lượt native này không tăng số runARTEMIS và không thay TalkBack thủ công.
