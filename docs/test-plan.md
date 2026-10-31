# Lab 3 — test plan Power9

Chuẩn Cloud-Enabled và preparation guide v5. Bảng chi tiết hóa kế hoạch đã thống nhất trong `lab3-completion-plan.md`. Trạng thái thực thi nằm ở `test-report.md`, không coi bảng kế hoạch là kết quả pass.

## Chuẩn bị và reset

- Sony Xperia SOV41 Android 11, app `vn.power9.power9_office_routine`; giữ thiết bị mở khóa. Không ghi serial/token/tài khoản mật khẩu vào trace công khai.
- Firebase project thật `power9-office-se180724`; catalog được seed từ `firebase/catalog.json`. Chỉ thao tác trên tài khoản kiểm thử của người dùng.
- Mỗi test có precondition riêng; không dựa vào kết quả test trước. Với test cần rỗng, xóa đúng completion/schedule kiểm thử của ngày chọn trước khi chạy; không xóa toàn bộ database. Không reset bằng client open Rules.
- Case timer dùng thời gian thật. Unit tests clock giả chỉ kiểm chứng thuật toán, không đổi duration app nộp để rút ngắn E2E.
- SDK/model/ARTEMIS commit phải được pin sau preflight; model API key chỉ nằm trong môi trường/local ignored config, không có trong app Flutter.

## Cases cho ARTEMIS

Mỗi instruction phải yêu cầu agent báo giá trị nhìn thấy trong structured output. Assert các giá trị ấy và trạng thái; không chỉ assert SUCCESS. Mỗi case >=3 lần, ghi trace, pass rate, thời gian và giải thích flaky/fail/skip.

| ID | Precondition | Instruction tóm tắt và expected result | Flow |
| --- | --- | --- | --- |
| TC01 | App signed out, tài khoản test có trên máy | Mở Power9, chọn Google test account; xác minh Home có bốn tab. Native account picker; không chép credential | Auth/native |
| TC02 | Signed in, chưa có move-walk ngày kiểm thử | Home → Khám phá → lọc <=5 → đi bộ → chọn lịch ngày/giờ → lưu. Báo tên, giờ và số hoạt động; chỉ tăng 1 | F01 |
| TC03 | Signed in | Tìm chuỗi không có kết quả, xác minh empty; xóa bộ lọc thấy danh sách lại | F01 error/reset |
| TC04 | Form lịch chưa lưu | Bật nhắc nhưng bỏ giờ, Lưu; phải báo lỗi và không thay số lịch. Chọn giờ và thử lại thành công | F01 validation |
| TC05 | Có lịch đúng ngày; mạng được điều khiển rõ ràng | Thử lưu khi mất mạng; draft còn nguyên, không báo thành công. Khôi phục mạng, retry, count không nhân đôi | F01 error/recovery |
| TC06 | Không có completion stress-break ngày bắt đầu | Thư giãn → start → pause → chờ → resume → end early → record; báo duration thực tế, không được tự ghi 180 giây | F02 timer |
| TC07 | Timer paused và chưa ghi | Chọn tab khác → Ở lại; vẫn paused. Chọn lại → Bỏ phiên; không có completion mới | F02 alternate |
| TC08 | Có schedule, chưa có completion tương ứng | Check-in ở Home rồi Undo; count done tăng/giảm đúng, schedule vẫn còn | F02 check-in |
| TC09 | Có completion cùng schedule | Progress → Xóa bản ghi → Giữ lại giữ dữ liệu; xác nhận Xóa chỉ xóa completion, schedule giữ nguyên | F02 delete |
| TC10 | Có schedule cùng ngày | Mở existing detail → đổi giờ → Hủy giữ giờ cũ; đổi lần nữa → Lưu đúng giờ mới, count không tăng | F03 |
| TC11 | Signed in | Mở đủ Hôm nay/Ăn uống/Thư giãn/Kết nối; xác minh nội dung/nhãn đúng. Thử chi tiết nhóm khác và Back giữ filter | Navigation/detail |
| TC12 | Profile/demo và RC đã tích hợp | Báo hai tham số; đổi console, fetch/activate; xác minh hành vi đổi không rebuild, defaults khi fetch lỗi | Remote Config |
| TC13 | Có dữ liệu thật và export đã tích hợp | Xuất PDF/upload; báo tên file, progress/result và URL mở được; metadata/owner đúng | Export/Storage |
| TC14 | FCM đã tích hợp, quyền xác định | Nhận thông báo console foreground/background/terminated, mở từ notification shade vào đúng màn; báo trạng thái từng lần | FCM/native |
| TC15 | Signed in, có màn riêng tư mở | Logout rồi thử Back; chỉ Login, không lộ dữ liệu user cũ. Đăng nhập user khác không thấy lịch user trước | Auth/privacy |
| TC16 | DebugView bật, một action hợp lệ | Thực hiện action đã định, đối chiếu event/params bằng Logcat hoặc DebugView; không gửi tên/email | Analytics |
| TC17 | S02/S09/S10 đã hoàn thiện | Ghi nhận bữa trưa, checklist đầy đủ rồi ghi đúng một activity, đặt lịch ngủ và hủy đúng nguồn; không suy diễn sức khỏe | F02 nhánh |

## Các cấp kiểm chứng khác

- Unit/widget: timer monotonic, pause/resume, background gap, elapsed cap, dưới 1 giây, failed save/retry, stale save sau logout, overview hợp nhất schedule/completion, private route và dialog rời phiên.
- Firestore Emulator: allowed/denied ownership cho schedule/completion; schema/type/source/duration; idempotent ID; completion immutable; delete không ảnh hưởng schedule. Không thay test native bằng emulator backend.
- Manual console: Auth Users, Storage file/Rules, FCM các trạng thái, từng Analytics event DebugView, Crashlytics nonfatal/test crash/user key, Remote Config trước/sau/default/cache.
- Accessibility/fidelity: so ảnh Figma và app cùng kích thước, kiểm tra target >=48 dp, layout 360/412 dp, text scale và TalkBack trên màn thật.
- ARTEMIS Pro exploratory 15–30 phút không script: đi các ngõ chưa biết, ghi issue thật; không tự tạo phát hiện hoặc coi không phát hiện là bằng chứng không có bug.
