# Kết quả ARTEMIS Lab 3 ngày 01/11/2026

Đã thực thi 11 ca, 33/33 run ID. Xác minh 30/33: 29 run ID có pytest pass hợp lệ và 1 run ID chỉ có audit trace sau lỗi ghi chậm. Có 59 attempts được giữ; không phải tất cả đều đạt.

| Ca | Run ID đã thử | Lượt xác minh | Attempts | Pytest pass rate theo attempts | Thời gian TB mỗi attempt |
| --- | --- | --- | ---: | ---: | ---: |
| TC02 | 1, 2, 3 | 1, 2, 3 | 4 | 75.0% | 116.26 s |
| TC03 | 1, 2, 3 | 1, 2, 3 | 6 | 50.0% | 45.43 s |
| TC04 | 1, 2, 3 | 1, 2, 3 | 6 | 50.0% | 73.19 s |
| TC06 | 1, 2, 3 | 1, 2, 3 | 5 | 60.0% | 114.59 s |
| TC07 | 1, 2, 3 | 1, 2, 3 | 5 | 60.0% | 106.65 s |
| TC08 | 1, 2, 3 | 1, 2, 3 | 3 | 100.0% | 26.03 s |
| TC09 | 1, 2, 3 | 1, 2, 3 | 5 | 60.0% | 80.32 s |
| TC10 | 1, 2, 3 | 1, 2 | 7 | 28.6% | 121.28 s |
| TC11 | 1, 2, 3 | 1, 2, 3 | 6 | 50.0% | 38.19 s |
| TC13 | 1, 2, 3 | 1, 2, 3 | 6 | 50.0% | 54.45 s |
| TC16 | 1, 2, 3 | 1 | 6 | 16.7% | 85.00 s |

Tỷ lệ trên giữ nguyên pytest result lịch sử, kể cả lượt assertion từng qua nhưng bị audit loại. Chỉ cột lượt xác minh áp dụng kiểm tra loại bỏ đó. Thời gian bao gồm model/provider; không diễn giải là tốc độ xử lý app. Setup/transport errors không có model trace không nằm trong attempts này.

## Ba run ID chưa đạt

- TC10[3]: model báo total_before=0 trong khi native Home là 0/2; metadata không nhất quán nên assertion fail. Trace có đổi giờ thành 11:00; không đổi failed result thành pass.
- TC16[2] và TC16[3]: task model failed, không có output hợp lệ. TC16[1] đã đối chiếu SDK view_activity(activity_id=move-walk) bằng marker bản debug và thời điểm task.
- Các lượt lỗi cũ khác được giữ riêng: sai mẫu tên PDF trong harness, model paraphrase/tóm tắt thay JSON, đọc nhầm mốc thời gian, HTTP503 và setup picker bỏ dở. Không tự quy mọi lỗi này thành app bug.

## Pro và quota

Pro trace48e5a802-0626-4291-979a-c1f320d916bf bị hủy sau926,82giây, có0bướcUI. Thời gian chờ quota không phải15phút exploratory. Gemini trả RESOURCE_EXHAUSTED, GenerateRequestsPerDayPerProjectPerModel-FreeTier=500, retry khoảng16giờ. Đã dùng45/45lượt được người dùng cho phép, đã tắt daemon và khôi phục debugflags; không đổi key/model/billing để né quota.

## Bằng chứng và phạm vi

- Viewer offline: [replay/index.html](../evidence/artemis/replay/index.html),33runs/257ảnh đã lọc bề mặt/email/Profile/debug. Đây là viewer từ DataEngine, không phải upstream compiler.
- Dữ liệu đầy đủ: [lab3-summary.json](../evidence/artemis/lab3-summary.json); rawprompt/trace/hierarchy giữ ignored.
- TC04 chỉ validation và hủy Flutter picker, TC11 chỉ bốn tab, TC13 chỉ PDF/native print preview hủy; không dùng thay toàn bộ các case tương ứng hoặc Storage production.
- Còn kiểm tra Auth error/privacy, quyền FCM, fidelity/TalkBack, Pro, PR review và video app/Console; Storage vẫn bị khóa theo Spark.
