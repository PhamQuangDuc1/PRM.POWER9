# Kiểm chứng bổ sung ngày 03/11/2026

Phạm vi: Analytics có thể sinh khi giữ billing tắt, Auth trên Xperia, trợ năng và hướng dẫn demo. Không gọi model, không đồng bộ Figma, không bật billing, không tính native smoke thành ARTEMIS.

## Analytics

`evidence/analytics/2026-11-03/native-sdk-events.json` tích lũy kết quả đọc log FA-SVC. Android lọc theo marker tổng hợp của đúng APK trước khi trả log; chỉ lấy thời gian sau lúc bắt đầu kiểm thử. Chỉ xuất tên event và tham số theo whitelist, không xuất raw log, UID/email/token hoặc dữ liệu ứng dụng khác. Số dòng SDK không phải số event duy nhất. Đây là bằng chứng SDK xử lý, không khẳng định server DebugView đã nhận mọi event.

Các thao tác thật gồm tạo lịch đi bộ, sửa10:30, hủy dialog xóa, check-in, xóa lịch giữ completion, hoàn tác completion; tìm kiếm chuỗi không khớp; tạo PDF trên máy; fetch cấu hình hiện hành; logout/login thật. `export_report` vẫn phụ thuộc upload production, không giả sinh bằng lời gọi SDK trực tiếp.

Attempt CRUD đầu bị lỗi đọc exact-document sau check-in, giữ `crud/native-crud-result.json` với assertionsPassed=false. Lượt tiếp tục đọc được schedule/completion, xóa lịch giữ history rồi hoàn tác đúng completion vừa thử; ghi `crud/native-crud-resumed-result.json`, deleted/cleaned snapshots. Lịch/check-in được tạo lúc đầu buổi này đã dọn; kiểm tra cách ly hai tài khoản dùng một tiền điều kiện riêng.

Harness search đầu đã Back dư về launcher; không quy thành app crash. Mở lại Power9 và dùng control Quay lại ở lượt tiếp tục; PDF/config đã thực hiện thành công. Không xóa các kết quả lỗi hoặc chuyển thành pass.

## Auth offline và private route

`evidence/auth/2026-11-03/offline-login.json` assertionsPassed=true:

- Logout về Login; Back và mở lại app không khôi phục Home riêng tư.
- Wi-Fi tắt và `dumpsys connectivity` xác nhận **Active default network: none** trước thao tác đăng nhập.
- Đăng nhập thất bại có lỗi hiển thị, không mở Home, control thử lại khả dụng.
- Khôi phục mạng; đăng nhập lại thành công đúng tài khoản ban đầu do người dùng chỉ định. Không xuất email hoặc ảnh bộ chọn.

Hai attempts tiền điều kiện được giữ riêng. Trên máy này `svc data disable` không làm global `mobile_data` đổi khỏi1; registry cho thấy data disconnected và không có mạng mặc định. Vì thế lượt đạt dựa trên trạng thái kết nối thực của Android, không dùng global setting đó làm chứng cứ offline. Kết nối Wi-Fi/mobile được trả về trạng thái ban đầu.

## Cách ly hai tài khoản — đang chờ người dùng chọn B

Tài khoản A là tài khoản ban đầu do người dùng chỉ định. Đã lấy UID/email chỉ vào file ignored cục bộ, đọc đúng hai document kiểm thử trước khi ghi và xác nhận chưa tồn tại. Sau đó tạo mới move-walk hôm nay và check-in riêng cho lượt thử. Bản ghi bữa trưa có trước do người dùng tạo được giữ nguyên. Các snapshots account-a/before.json và completion-retained.json xác minh tiền điều kiện.

Đã logout A và mở bộ chọn Google cho người dùng chọn B. Không tự chọn một tài khoản khác; chưa ghi assertionsPassed=true cho isolation. Còn cần: xác nhận UID B khác A, đọc đúng doc B và đối chiếu UI lịch/tiến độ/inbox; logout B, đăng nhập lại A, xác nhận dữ liệu A còn nguyên rồi xóa/hoàn tác đúng sentinel vừa tạo. Sentinel cần cleanup sau khi kiểm tra, không xóa dữ liệu có trước. TalkBack hiện tắt, UI automation đã dừng để người dùng chọn.

## Trợ năng

TalkBack đã được bật tạm và xác nhận service bound với spoken feedback. Helper native dùng `FLAG_DONT_SUPPRESS_ACCESSIBILITY_SERVICES` để đọc accessibility focus/cây Android; không thay bằng ảnh hoặc tests bố cục.

Attempt vuốt phải bằng sự kiện chạm inject không làm focus rời logo Login; `evidence/accessibility/2026-11-03/talkback-login-traversal.json` ghi loginButtonReached=false. Chưa kết luận app lỗi hay TalkBack gestures đạt từ harness này. Người dùng báo không nhấn được theo cách cảm ứng thông thường; đã tắt TalkBack và dừng UI automation ngay, xác minh accessibility_enabled=0 và enabled services trở về null. Không có Gemini task nào điều khiển máy trong lượt này.

Đánh giá nghe phát âm bằng người thật và thao tác TalkBack đầy đủ chưa được suy ra từ việc service bound hoặc cây có nhãn. Các tests nhãn/vùng chạm/bố cục 360/412dp chữ1,5× ở mốc trước vẫn có giá trị trong phạm vi đó.

## Hướng dẫn demo

Xem [lab3-demo-guide.md](lab3-demo-guide.md): chuẩn bị, đường đi, F01/F02/F03, CRUD, các màn bổ sung, PDF, Auth/privacy, Firebase, TalkBack, kịch bản8–10phút và cleanup. Đây là hướng dẫn sử dụng trực tiếp, độc lập với video cuối.

## Phụ thuộc giữ riêng

Storage production chưa có upload thật. ARTEMIS giữ30/33 run IDs xác minh; Pro trước có0 bước UI. Không gọi thêm model khi cơ chế duyệt còn chặn. Video và trao đổi với thầy được người dùng để sau. Không khẳng định toàn bộ Lab3 đạt100%.
