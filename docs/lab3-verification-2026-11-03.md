# Kiểm chứng bổ sung ngày 03/11/2026

Phạm vi: Analytics có thể sinh khi giữ billing tắt, Auth trên Xperia, trợ năng và hướng dẫn demo. Không gọi model, không đồng bộ Figma, không bật billing, không tính native smoke thành ARTEMIS.

## Kết quả hiện hành

- Analytics:11/12 loại event được đối chiếu bằng native SDK log; export_report phụ thuộc Storage production, không giả sinh. Không khẳng định tất cả event đã có trên server DebugView.
- Auth: logout/Back, lỗi mất mạng và online retry đạt trên Xperia. Người dùng xác nhận chỉ có một tài khoản kiểm thử nên chuyển hai tài khoản chưa thực hiện.
- Trợ năng tự động:17/17 kiểm tra hành vi đạt;21/21 request focus/click được Android chấp nhận,20/21 snapshot thấy focus. Còn một điểm focus sau Ở lại chưa đóng; không ghi toàn bộ TalkBack đạt. Người dùng chọn kiểm tra tự động trước, chưa tiện nghe/vuốt thủ công.
- Sửa lỗi thực: nút thông báo có unread badge trước đó chỉ có nhãn “2”. Đã bổ sung semantic label “Thông báo,2chưa đọc” và test chuyển unread2→0/mở inbox. Toàn Flutter49/49 đạt, analyzer0issue; APK mới đã build/cài. Log ở evidence/flutter/lab3-final-accessibility-*.txt.
- Đã trả app về Home, đăng nhập tài khoản ban đầu, dọn đúng dữ liệu thử; bản ghi bữa trưa có trước còn nguyên. TalkBack/debug/mạng đã khôi phục; không gọi model.

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

## Cách ly hai tài khoản — chưa thực hiện

Người dùng xác nhận chỉ có một tài khoản kiểm thử. Không tự chọn tài khoản Google khác đang có trên máy, không tạo tài khoản và không đánh dấu isolation đạt. Đã đăng nhập lại đúng tài khoản được người dùng chỉ định.

Trước khi tạo sentinel ở A, đọc exact-document xác minh move-walk hôm nay chưa có lịch/completion. Sau khi người dùng làm rõ chỉ có một tài khoản, đối chiếu lại createdAt/updatedAt với snapshot commit trước, xóa đúng schedule thử và hoàn tác đúng completion của thẻ đi bộ. Không bấm Hoàn tác chung có thể trúng bữa trưa. account-a/deleted.json, cleaned.json và isolation-skip-and-cleanup.json xác nhận cleanup. post-audit-server.json xác nhận schedule/completion đi bộ và completion timer không có, completion bữa trưa có trước vẫn tồn tại.

## Trợ năng

TalkBack đã được bật tạm và xác nhận service bound với spoken feedback. Helper native dùng `FLAG_DONT_SUPPRESS_ACCESSIBILITY_SERVICES` để đọc accessibility focus/cây Android; không thay bằng ảnh hoặc tests bố cục.

Attempt vuốt phải bằng sự kiện chạm inject không làm focus rời logo Login; `evidence/accessibility/2026-11-03/talkback-login-traversal.json` ghi loginButtonReached=false. Chưa kết luận app lỗi hay TalkBack gestures đạt từ harness này. Người dùng báo không nhấn được theo cách cảm ứng thông thường; đã tắt TalkBack và dừng UI automation ngay, xác minh accessibility_enabled=0 và enabled services trở về null. Không có Gemini task nào điều khiển máy trong lượt này.

Đã sửa nhãn chuông và chạy lại bằng action focus/click của Android. Script đi qua Home, Khám phá/lọc, chi tiết, form/validation live region, hủy form, timer pause/Ở lại/Bỏ phiên, Progress và PDF. automatic-accessibility-result.json giữ strict assertion failed: sau Ở lại, request focus Hôm nay được chấp nhận nhưng snapshot không thấy focus dù đã chờ idle và tối đa1giây. Chưa kết luận nguyên nhân app, bridge hay TalkBack; cần đối chiếu thủ công. automatic-accessibility-assessment.json tách17/17 hành vi và20/21 focus snapshots, không đổi failed result thành pass.

Các attempts foreground khi TalkBack training mở chậm, reader chưa đọc hint và focus timing được giữ riêng. Nguồn tái hiện: scripts/lab3/native_accessibility_audit.py, P9AccessibilityAudit.java và docs/lab3-accessibility-check.md. Helper không đóng vào APK. Đã gỡ jar tạm trên thiết bị.

Đánh giá nghe phát âm bằng người thật và thao tác TalkBack đầy đủ chưa được suy ra từ việc service bound hoặc cây có nhãn. Các tests nhãn/vùng chạm/bố cục 360/412dp chữ1,5× ở mốc trước vẫn có giá trị trong phạm vi đó.

## Hướng dẫn demo

Xem [lab3-demo-guide.md](lab3-demo-guide.md): chuẩn bị, đường đi, F01/F02/F03, CRUD, các màn bổ sung, PDF, Auth/privacy, Firebase, TalkBack, kịch bản8–10phút và cleanup. Đây là hướng dẫn sử dụng trực tiếp, độc lập với video cuối.

## Phụ thuộc giữ riêng

Storage production chưa có upload thật. ARTEMIS giữ30/33 run IDs xác minh; Pro trước có0 bước UI. Không gọi thêm model khi cơ chế duyệt còn chặn. Video và trao đổi với thầy được người dùng để sau. Không khẳng định toàn bộ Lab3 đạt100%.
