# Power9 — kết quả kiểm chứng mốc Auth/F01/F03

Ngày 31/10/2026, Asia/Saigon. Bản này là báo cáo tiến độ, chưa phải kết quả toàn bộ Lab 3.

## Tự động

| Kiểm tra | Kết quả | Nguồn |
| --- | --- | --- |
| flutter analyze lib test | Không có issue | Terminal lượt cuối |
| flutter test --no-pub | 11/11 đạt | evidence/flutter/unit-widget-tests.txt |
| Firestore Emulator Rules | 8/8 đạt | evidence/firestore/rules-run.txt |
| flutter build apk --debug --no-pub --target-platform android-arm64 | Thành công | APK build/app/outputs/flutter-apk/app-debug.apk, không commit file build |

Flutter tests bao gồm xác thực và private route khi logout, layout Login 360/412 dp text scale 1.5, filtering, validation/giữ draft/chống gửi lặp và chuyển ngày. Rules tests có owner allowed/cross-user denied, unauthenticated, catalog query, schema/time/ID/metadata. Test Rules chạy project `demo-power9` cục bộ, không sinh alice/bob trên production.

## Smoke test Xperia thật

Thiết bị Sony SOV41, Android 11/API 30; dữ liệu trên Firebase project mới `power9-office-se180724`. Một tài khoản thật do người dùng tự chọn và đăng nhập; không lưu token/UID vào báo cáo công khai.

| Mã | Thao tác | Quan sát |
| --- | --- | --- |
| DEV01 | Google Sign-In | Người dùng xác nhận Profile, sau đó Home; ADB xác minh Home. Users console/hủy/logout thật còn thiếu |
| DEV02 | Home → Khám phá → Đi bộ giữa giờ → Lịch | Đọc được catalog thật, đủ hướng dẫn 3 bước, có form chọn ngày/giờ |
| DEV03 | Bật nhắc, chưa chọn giờ, Lưu | Báo chọn giờ, giữ form, không tạo lịch |
| DEV04 | Tắt nhắc, lưu không có giờ | Home từ 0 lên 1 hoạt động, server có đúng 1 schedule |
| DEV05 | Mở lịch đã có, chọn giờ 23:01, lưu | Home hiện 23:01, server minuteOfDay=1381, count=1, createdAt giữ nguyên |
| DEV06 | Mở sửa, đổi reminder rồi Hủy | Về đúng chi tiết/Home; server vẫn reminder=false, updatedAt giữ nguyên |

Minh chứng ảnh: `evidence/flows/schedule-validation-xperia.png`, `evidence/flows/home-schedule-xperia.png`. JSON server metadata: `evidence/flows/firestore-server-verification.json`; thời điểm create `2026-10-31T15:58:53.949Z`, update thành công `2026-10-31T16:02:38.247Z`; truy vấn sau Hủy vẫn giữ nguyên update này.

Một lượt thử nhập giờ bằng tọa độ không thành công vì layout thay đổi khi keyboard xuất hiện. Dừng thao tác, quay lại app, chọn lại bằng control có nhãn quan sát được, xác minh form và server. Đây là lỗi kịch bản thao tác, không được tính là pass hoặc suy diễn app không có lỗi. Cần ARTEMIS với instruction/structured assertions để kiểm chứng lại.

## Còn thiếu

ARTEMIS >=10 ca, >=3 lượt mỗi ca, error/native interaction, analytics assertion và exploratory 15–30 phút; test offline/save-retry thật trên Xperia; kiểm tra tất cả màn 360/412 và TalkBack; các dịch vụ Firebase còn lại; video/console evidence. Không suy ra 11 test Flutter và 8 Rules tests thay thế yêu cầu ARTEMIS.
