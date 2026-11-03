# PR hiện hành — OneD, 04/11/2026

[PR #4: OneD → main](https://github.com/PhamQuangDuc1/PRM.POWER9/pull/4) thay PR #3. Tám commit cũ và thay đổi UI/bằng chứng/demo được giữ trên OneD; PR cũ đã đóng, nhánh review cũ đã xóa local/remote sau kiểm tra ancestry và bundle. Không merge main. Metadata: `evidence/code-review/lab3-pr.json`; audit: `evidence/git/2026-11-04/oned-pr-replacement.json`.

Các chỉ dẫn bên dưới là lịch sử của PR #3.

# Ba commit sửa lỗi và PR Lab 3

Các sửa runtime đã hoàn tất và bộ Flutter cuối đạt 43/43, analyze sạch. Người dùng đã đổi lựa chọn ngày 02/11: yêu cầu trợ lý tự commit và tạo PR. Đã tạo nhánh codex/lab3-review-and-slides và [draft PR #3](https://github.com/PhamQuangDuc1/PRM.POWER9/pull/3) vào main; không merge. Video được chủ động để cuối sau khi chốt hướng UI/UX.

Ba commit thực tế: R01 `ac4b35b`, R02 `38b52bc`, R03 `e595956`. Mỗi commit chỉ chứa source và regression test tương ứng. Năm findings/dispositions có trong PR body, không khẳng định đã có human approval. Các lệnh bên dưới lưu quy trình đã thực hiện; không chạy lại để tạo commits trùng.

Trước mỗi commit, xem `git diff --cached --name-only` để tránh đưa file đã stage khác vào commit. Ba cặp source/test dưới đây độc lập; các tài liệu/evidence/test runner còn lại có thể commit riêng sau.

## R01 FCM date payload sai kiểu

```powershell
git add -- lib/services/firebase_notification_service.dart test/notification_payload_regression_test.dart
git commit -m "fix(R01): tolerate malformed notification date payloads"
```

Nếu date_key là số/bool/list/map, parser trước đây có thể ném TypeError và làm callback bỏ thông báo. Hiện fallback về ngày hợp lệ mà không mất route progress.

## R02 Inbox refresh trả về lệch thứ tự

```powershell
git add -- lib/viewmodels/notification_viewmodel.dart test/notification_refresh_regression_test.dart
git commit -m "fix(R02): ignore stale inbox refresh results"
```

Refresh cũ hoàn tất sau refresh mới không được ghi đè trạng thái đọc hiện hành. Regression dùng hai futures hoàn tất đảo thứ tự.

## R03 Logout lỗi làm mất binding thông báo

```powershell
git add -- lib/viewmodels/profile_viewmodel.dart test/profile_signout_regression_test.dart
git commit -m "fix(R03): restore messaging when sign-out fails"
```

Nếu Auth signOut lỗi và uid còn nguyên, messaging được restore; state vẫn hiển thị lỗi sign-out gốc.

## Hồ sơ review

Output review và quyết định: `ai/code-review/lab3-review.md`. Baseline: 616f83e. Có năm findings thuộc payload robustness, async correctness, session recovery và test reliability. R01–R03 là ba fixes runtime; R04/R05 là fixes runner. Sau commit, bổ sung SHA thực tế bằng `git log -3 --oneline`; không điền SHA giả.

PR cần chứa mã Lab 3 so với nhánh được giảng viên/nhóm chọn. Nếu mã đã merge main, tạo PR theo đúng diff còn lại và giữ liên kết PR chứa triển khai ban đầu; không tạo PR rỗng hoặc coi Markdown review cục bộ là review trên PR.

## Nội dung PR đề xuất

**Title:** Power9 Lab 3 Firebase flows and notification recovery fixes

**Body:**

Power9 implements the three Lab 2 flows using Flutter MVVM and Firebase, with real scheduling/completion data, FCM delivery, PDF export, Analytics, Crashlytics and Remote Config evidence. Production Storage remains disabled under the chosen Spark configuration and is explicitly reported as incomplete.

This review adds three notification fixes: malformed date payloads fall back safely; stale inbox requests cannot overwrite newer read state; failed sign-out restores messaging for the still-active account. Each runtime fix has a dedicated regression test and should be represented by its own commit.

Validation: 43 Flutter tests passed, analyzer reported no issues, and the arm64 debug APK built successfully. ARTEMIS results, retained failures and coverage limits are recorded in `evidence/artemis/lab3-summary.json`; these counts must be refreshed after the final run. Local review with five findings is in `ai/code-review/lab3-review.md` and must be attached/reviewed on this PR before claiming the PR-review requirement complete.

Bổ sung sau ba fixes: kiểm tra responsive 14 màn ở360/412dp và marker debug của Analytics SDK. Tổng cuối43/43tests; phần telemetry/test/evidence này có thể commit riêng sau ba fixes. Marker là giá trị tổng hợp của bản debug và bị xóa ở bản thường/release; không phải log giả để thay SDK.
