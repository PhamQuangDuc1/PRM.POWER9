# UI và hình ảnh Power9 — 03/11/2026

## Bản đang kiểm tra

Người dùng yêu cầu hoàn thiện UI/UX, tạo ảnh phù hợp các màn, rồi cùng kiểm chứng phần còn thiếu trước khi quay video và chốt slide. Người dùng đã xác nhận có thể thử TalkBack thủ công và đã có tài khoản Google kiểm thử B; chưa thực hiện lượt A → B → A chỉ từ xác nhận này.

APK: `output/lab3/Power9-Lab3-UI-20261103-debug-arm64.apk`.

SHA-256: `77955787ecb33e60305b3e49ca62894ba003ab335a39f85f064084c870eea41e`.

Build debug arm64 với marker tổng hợp `p9_20261103_ui_a84d2c0e`. Marker phục vụ đối chiếu SDK Analytics, không phải UID hoặc token. Chưa bật Analytics debug hoặc gửi model task trong đợt UI này.

## Thay đổi

- Bộ 8 ảnh minh họa tông xanh dương, ánh sáng tự nhiên, không chữ, tạo bằng công cụ image_gen tích hợp. Prompt và ảnh chọn ở `assets/illustrations/generation-manifest.json`; ba ảnh được tinh chỉnh lại theo ảnh tham chiếu để đồng nhất phong cách.
- Ảnh ở Login, Hôm nay, Ăn uống, Thư giãn, Kết nối, Khám phá, chi tiết hoạt động, Góc làm việc và Ngủ & phục hồi. Thumbnail theo hoạt động, gồm ảnh văn phòng cho mục đích/cân bằng và đi bộ cho social-walk.
- Ảnh local, có giới hạn kích thước decode, loại khỏi semantics vì nội dung/điều khiển đã có văn bản riêng. Banner canh phía trên để tránh cắt mặt nhân vật trên màn hẹp.
- Hướng dẫn được trình bày thành thẻ theo bước. Card, nền, navigation, ô nhập, nút phụ và thanh tiến độ dùng theme thống nhất. Không thêm tính năng hoặc đổi Rules/backend.
- Timer và nút thao tác đứng trước hướng dẫn; ảnh nằm sau nút bắt đầu và ẩn khi phiên đang hoạt động. Nhãn trong thẻ tiến độ có Expanded để không tràn khi chữ lớn.

## Kiểm chứng

- Flutter suite cuối: **49/49 đạt**. Bổ sung Login vào kiểm tra responsive và chạy riêng đạt2/2: **15 màn** ở 360/412 dp, text scale 1.5, vùng chạm Android và nhãn điều khiển. Log: `evidence/flutter/ui-imagery-final-tests-2026-11-03.txt` và `evidence/flutter/ui-imagery-final-responsive-2026-11-03.txt`.
- Dart analyzer: **No issues found**. `evidence/flutter/ui-imagery-analyze-2026-11-03.txt`.
- APK cuối build thành công: `evidence/flutter/ui-imagery-final-build-2026-11-03.txt`. Đã cài bằng install -r, không clear app data.
- Test thao tác xóa lịch/checklist được cập nhật để cuộn đến phần tử trong ListView thay vì giả định đã được dựng sẵn. Giữ assertion về hủy/lỗi/retry và bảo toàn completion. Lượt lỗi ban đầu giữ trong các log attempt trước.
- `output/ui-refresh/previews` là ảnh render Flutter từ fixture local, không phải bằng chứng Firebase/thiết bị thật. Lượt preview đầu thiếu session/font icon đã được render lại; không dùng ảnh đầu để chứng minh tính năng.
- Lượt native UI đầu chạy sớm trước khi hierarchy Power9 sẵn sàng, dừng trước thao tác đầu. Không quy thành app lỗi hoặc ghi pass. Lượt tiếp tục thêm chờ app khởi động đã đi qua8màn và quay Home, có9ảnh: `evidence/ui-refresh/2026-11-03/native-ui-smoke.json`. Đã xem ảnh thật để kiểm tra crop/bố cục; không tạo/xóa lịch, không chạy timer, không logout hoặc mở tài khoản.

## Phần tiếp theo

1. TalkBack bằng người thật: nghe/vuốt, đặc biệt timer pause → Hôm nay → Ở lại → focus lại Hôm nay. Chưa đóng điểm focus từ widget tests.
2. A → B → A: lịch, lịch sử và inbox; dọn đúng dữ liệu thử.
3. ARTEMIS còn TC10[3], TC16[2], TC16[3] và Pro 15–30 phút có trace hoạt động thật. File budget hiện vẫn 45/45; không reset used hoặc bỏ cơ chế duyệt/quota.
4. Storage production còn phụ thuộc quyết định Blaze và bucket thật; report_upload_enabled chưa tự bật. Runner model kiểm tra billing nên hoàn tất ARTEMIS trước nếu dùng chung project/key.
5. Dùng APK và ảnh hiện hành để quay video có thuyết minh + Console; cuối cùng cập nhật slide theo kết quả đã được chứng minh.

Không tăng số run ARTEMIS, không đánh dấu TalkBack/hai tài khoản/Storage đạt chỉ vì UI mới.
