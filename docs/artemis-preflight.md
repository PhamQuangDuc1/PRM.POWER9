# ARTEMIS — chuẩn bị, chưa thực thi AI E2E

## Cập nhật 01/11/2026

- Key local đã xác thực bằng API chỉ liệt kê model; không lưu secret vào tài liệu, evidence hoặc mã nguồn được Git theo dõi.
- Kiểm tra Cloud Billing API trả `billingEnabled: false` cho `power9-office-se180724`.
- `uv sync --frozen` hoàn tất trong môi trường riêng `.build/tools/artemis/.venv`, Python 3.14.5, 190 packages theo lockfile upstream.
- Cấu hình chạy riêng `.build/artemis-run/artemis.jsonc`: Gemini 3.5 Flash-Lite, fallback 3.1 Flash-Lite; detector Robotics ER 2 Preview; Flash tối đa 12 lượt, tắt background summarizer và search grounding của hai node chẩn đoán.
- Launcher riêng nạp key từ file ignored ban đầu, không sao chép key, không sửa config upstream hoặc IDE toàn cục. Phải đặt `ARTEMIS_ARTEMIS_JSONC` để config được ưu tiên hơn bundled source config; chỉ đổi cwd là chưa đủ. Schema model yêu cầu trường fallback.
- Preflight thực tế: model mặc định 3.8 Flash báo 503 quá tải rồi timeout 180 giây; 2.5 Flash trả 404 không hỗ trợ người dùng mới dù vẫn xuất hiện trong API liệt kê model. Sau đó 3.5 Flash-Lite chạy được ca điều hướng.
- Lượt thành công: session `8c8fba65-84a0-45bb-bd9e-ba47ed040f6d`, 4 model calls, 3 recorded steps; Home → Khám phá → Home. Log đã loại key: `evidence/artemis/preflight-navigation-2026-11-01.txt`. ADB kiểm tra độc lập sau chạy xác nhận Home ngày 01/11, 0/0; không sửa dữ liệu ngày 31/10.
- Đây chỉ là preflight, không thay thế bộ pytest >=10 cases ×3 runs. CLI chỉ trả trạng thái/narrative, chưa có structured output assertions của bộ test. Trace compiler báo 0 images/0 steps dù DataEngine ghi 3 steps: phải kiểm tra cách export replay trước khi dùng làm bằng chứng nộp.
- Đã trả `stay_on_while_plugged_in` về 0 và tắt chính sách tự giữ sáng trong launcher cho các lần sau. UIAutomator2 được dùng, không cài Accessibility Helper.

Phần dưới ghi lại khảo sát ban đầu ngày 31/10, trước khi cài runtime và xác thực key.

Đã đọc README và Python SDK từ repo chính thức `https://github.com/google/artemis`. Checkout khảo sát tại `.build/tools/artemis`, commit `351ca8422f7b5b54e80a9c1ce03a222e02415b6b` ngày kiểm tra 31/10/2026. Chưa chạy startup script, chưa cài global MCP/rules và chưa gọi model API.

- Backend yêu cầu Python >=3.12; máy có uv và Python 3.14, nhưng phải kiểm tra environment dependency tương thích trước khi chạy.
- `artemis-client` là SDK HTTP không có runtime dependency; nó không tự điều khiển thiết bị nếu chưa có daemon ARTEMIS chạy trên device host.
- SDK hiện dùng `result.succeeded`, `result.output`, `result.trace_id`; không sao chép ví dụ `status == SUCCESS` của handout mà bỏ qua khác biệt phiên bản. Test cần assert structured values trong output, không chỉ succeeded.
- Startup script của upstream có thể đề nghị cài công cụ và sửa cấu hình IDE toàn cục. Chưa thực hiện các thay đổi đó. Có thể dùng local server/CLI/SDK để chạy test mà không cài global rules.
- Model API phải được cấu hình riêng qua environment/local ignored .env. Không dùng API key định danh app trong google-services.json để suy ra đã có quyền model. Chưa có key/model được người dùng xác nhận cho lượt E2E này; cần chốt hạn mức/chi phí trước khi dùng.
- Mặc định upstream có thể cài Accessibility Helper và giữ màn hình sáng. Cần giải thích cho người dùng khi chọn backend; có tùy chọn uiautomator và không tự cài helper. Không cài helper trên điện thoại chỉ vì đã clone SDK.
- Chỉ bind daemon localhost; test account riêng. Chuẩn bị conftest/test functions sau preflight; `docs/test-plan.md` chứa phạm vi và preconditions. ADB smoke test trong evidence hiện tại không phải ARTEMIS.
