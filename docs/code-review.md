# AI code review Lab 3

Codex rà code tại baseline `616f83e`. [Output review gốc](../ai/code-review/lab3-review.md) giữ nguyên nhận xét tại thời điểm phát hiện. Các quyết định đã được ghi ở [PR #3](https://github.com/PhamQuangDuc1/PRM.POWER9/pull/3). [PR #4](https://github.com/PhamQuangDuc1/PRM.POWER9/pull/4) giữ các commit sửa và đã merge vào main tại `cd74c99`.

## Phát hiện và quyết định

- **R01 · Độ bền payload · Chấp nhận.** `lib/services/firebase_notification_service.dart:36` ở baseline ép kiểu `date_key` trước khi áp dụng fallback. Kiểm tra kiểu trước khi xử lý để dữ liệu đầu vào sai kiểu vẫn mở đúng màn dự phòng. [Commit ac4b35b](https://github.com/PhamQuangDuc1/PRM.POWER9/commit/ac4b35b) · [Regression](../test/notification_payload_regression_test.dart)
- **R02 · Trạng thái bất đồng bộ · Chấp nhận.** `lib/viewmodels/notification_viewmodel.dart:85` cho phép kết quả refresh cũ ghi đè inbox mới, làm tin đã đọc hiện lại như chưa đọc. Bỏ kết quả và lỗi đến muộn theo thế hệ yêu cầu. [Commit 38b52bc](https://github.com/PhamQuangDuc1/PRM.POWER9/commit/38b52bc) · [Regression](../test/notification_refresh_regression_test.dart)
- **R03 · Phục hồi lỗi đăng xuất · Chấp nhận.** `lib/viewmodels/profile_viewmodel.dart:23` ngắt messaging trước khi Auth đăng xuất. Nếu Auth lỗi, khôi phục messaging cho đúng phiên còn hiệu lực để giữ thông báo. [Commit e595956](https://github.com/PhamQuangDuc1/PRM.POWER9/commit/e595956) · [Regression](../test/profile_signout_regression_test.dart)
- **R04 · Tiền điều kiện E2E · Chấp nhận.** `e2e_test/conftest.py:67` dựa vào CTA cũng xuất hiện ở Tiến độ. Kiểm tra thêm dấu hiệu nhận diện Hôm nay để giảm ca bắt đầu sai màn. [Regression](../e2e_test/test_device_preconditions.py)
- **R05 · Truy vết E2E · Chấp nhận.** `e2e_test/conftest.py:132` có thể fail assertion trước khi lưu bằng chứng lỗi. Ghi kết quả terminal trước khi fail để truy vết được cả lượt thất bại. [Regression](../e2e_test/test_trace_observations.py)

## Công cụ AI

- Codex hỗ trợ code, review, sửa lỗi, kiểm thử và soạn hồ sơ.
- Google ARTEMIS với Gemini chạy E2E trên Android. Kết quả được kiểm tra bằng assertion và đối chiếu trace. [Kết quả](lab3-e2e-results.md)
- ImageGen tạo minh họa trong app. [Nguồn và phạm vi](ui-refresh-2026-11-03.md)
- Google Stitch hỗ trợ thiết kế Lab 2 được kế thừa. [Nhật ký thiết kế](../ai/ai-design-log.md)
