# AI code review Lab 3

Baseline đã review: `616f83e`. Công cụ: Codex trong chat hiện hành. Theo yêu cầu mới ngày 02/11, review và năm dispositions đã được đưa vào [draft PR #3](https://github.com/PhamQuangDuc1/PRM.POWER9/pull/3). Ba fixes runtime có commit riêng: R01 `ac4b35b`, R02 `38b52bc`, R03 `e595956`. Đây là review AI và hồ sơ xử lý trên PR, không phải human approval hoặc merge. Các phần output dưới giữ lại phát hiện ban đầu tại baseline.

## Output review ban đầu

### R01 P3 Độ bền payload

Vị trí baseline: `lib/services/firebase_notification_service.dart:36`.

date_key không phải String làm cast ném TypeError trước khi fallback ngày. Callback foreground nuốt lỗi nên thông báo hợp lệ về recipient có thể bị bỏ qua.

Đề xuất: Kiểm tra kiểu date_key trước notificationDay; giữ fallback hiện hành.

Giới hạn: đây là phòng vệ tại biên RemoteMessage có kiểu dynamic, chưa quan sát sự cố production; payload data chuẩn của FCM thường là chuỗi. Quyết định triển khai: accepted trong phạm vi sửa lỗi đã được yêu cầu. Regression: `test/notification_payload_regression_test.dart`. Chưa có fix commit ID riêng; không ghi là đã hoàn tất tiêu chí Git/PR.

### R02 P2 Tính đúng dữ liệu bất đồng bộ

Vị trí baseline: `lib/viewmodels/notification_viewmodel.dart:85`.

Các refresh cùng uid chạy đồng thời. Request cũ có thể hoàn tất sau request mới và ghi đè inbox, làm thông báo đã đọc hiện chưa đọc trở lại.

Đề xuất: Dùng generation cho refresh; bỏ cả kết quả và lỗi đến muộn.

Quyết định triển khai: accepted trong phạm vi sửa lỗi đã được yêu cầu. Regression: `test/notification_refresh_regression_test.dart`. Chưa có fix commit ID riêng; không ghi là đã hoàn tất tiêu chí Git/PR.

### R03 P2 Phục hồi phiên

Vị trí baseline: `lib/viewmodels/profile_viewmodel.dart:23`.

disable messaging chạy trước signOut. Nếu signOut ném lỗi, phiên vẫn hoạt động nhưng messaging đã unbind và auto-init bị tắt.

Đề xuất: Khôi phục messaging cho cùng uid nếu đăng xuất thất bại; không che lỗi đăng xuất gốc.

Quyết định triển khai: accepted trong phạm vi sửa lỗi đã được yêu cầu. Regression: `test/profile_signout_regression_test.dart`. Chưa có fix commit ID riêng; không ghi là đã hoàn tất tiêu chí Git/PR.

### R04 P2 Độ tin cậy kiểm thử

Vị trí baseline: `e2e_test/conftest.py:67`.

Tiến độ cũng có CTA Khám phá hoạt động. Chỉ kiểm tra nhãn này có thể nhận nhầm Progress là Home và làm ca sau bắt đầu sai màn.

Đề xuất: Yêu cầu cả CTA và app-bar Power9 Office Routine của Home.

Quyết định triển khai: accepted trong phạm vi sửa lỗi đã được yêu cầu. Regression: `e2e_test/test_device_preconditions.py`. Chưa có fix commit ID riêng; không ghi là đã hoàn tất tiêu chí Git/PR.

### R05 P2 Truy vết lỗi kiểm thử

Vị trí baseline: `e2e_test/conftest.py:132`.

terminal_output có thể assert khi model báo failed. Assertion xảy ra trước khi tạo evidence làm mất record của lần thất bại đó.

Đề xuất: Giữ lỗi terminal vào evidence trước, rồi fail assertion sau khi đã ghi file.

Quyết định triển khai: accepted trong phạm vi sửa lỗi đã được yêu cầu. Regression: `e2e_test/test_trace_observations.py`. Chưa có fix commit ID riêng; không ghi là đã hoàn tất tiêu chí Git/PR.

## Kết quả sửa và giới hạn

R01–R03 đã sửa trong runtime Flutter; thêm ba tests tái hiện. Bộ cuối 43/43 đạt, analyzer sạch. R04–R05 đã sửa trong runner, các regression tests runner được chạy riêng. Không thay đổi Rules hoặc bật billing. Các kết quả thiết bị phải phân biệt APK trước/sau build.

Ngày 02/11 đã commit/push R01, R02, R03 riêng với source và regression tương ứng: ac4b35b / 38b52bc / e595956. Theo yêu cầu mới của người dùng, trợ lý đã tạo draft PR #3 và đưa cả năm findings/dispositions vào PR body. R04/R05 là phần gia cố runner, không dùng thay ba fix runtime. Không có human approval hoặc merge được giả định.
