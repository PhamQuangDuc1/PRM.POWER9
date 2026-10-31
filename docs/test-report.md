# Power9 — kết quả kiểm chứng Auth/F01/F02/F03

Ngày 31/10/2026, Asia/Saigon. Bản này là báo cáo tiến độ, chưa phải kết quả toàn bộ Lab 3.

Cập nhật 01/11: toàn bộ Flutter suite hiện có 23 tests đạt, analyze không issue. Ba màn S04/S09/S10 đã được bổ sung và kiểm tra Xperia, gồm mất mạng/thử lại checklist không trùng bản ghi và lưu giờ nghỉ tối 21:30. Chi tiết cùng bằng chứng tại `docs/workspace-verification.md`; log Flutter mới tại `evidence/flutter/unit-widget-workspace-tests.txt`. Các số liệu bên dưới giữ lại kết quả của mốc 31/10, không phải một lần chạy mới.

## Tự động

| Kiểm tra | Kết quả | Nguồn |
| --- | --- | --- |
| flutter analyze lib test | Không có issue | Terminal lượt cuối |
| flutter test --no-pub | 21/21 đạt | evidence/flutter/unit-widget-f02-tests.txt; log mốc trước giữ riêng |
| Firestore Emulator Rules | 14/14 đạt | evidence/firestore/rules-f02-run.txt; log mốc trước giữ riêng |
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

ARTEMIS >=10 ca, >=3 lượt mỗi ca, error/native interaction, analytics assertion và exploratory 15–30 phút; test offline/save-retry thật trên Xperia; kiểm tra tất cả màn 360/412 và TalkBack; các dịch vụ Firebase còn lại; video/console evidence. Không suy ra 21 test Flutter và 14 Rules tests thay thế yêu cầu ARTEMIS.

## Smoke F02 trên Xperia

| Mã | Thao tác | Kết quả thật |
| --- | --- | --- |
| DEV07 | Home check-in rồi Undo | 0/1 → 1/1 → 0/1; durationSeconds=null, không tự gán 3 phút |
| DEV08 | Start → Pause → rời tab → Ở lại | Timer paused giữ 02:58 qua dialog |
| DEV09 | Resume → app background → quay lại → end early | Clock tiếp tục; record source=timer, durationSeconds=72, UI 1 phút 12 giây |
| DEV10 | Delete dialog → Giữ lại, rồi xác nhận Xóa | Giữ lại vẫn 1 completion; Xóa về 0 completion nhưng vẫn 1 schedule |
| DEV11 | Phiên đủ 3 phút thật | Tự kết thúc 00:00, UI và server durationSeconds=180; không đếm thêm thời gian chờ record |
| DEV12 | Record → Progress → Back, rồi app restart | Về Home 1/2, có lịch đi bộ và completion thư giãn; dữ liệu không mất |
| DEV13 | Ăn uống record → Progress → Back → Undo | Back về Ăn uống; source=checkin, durationSeconds=null; Undo chỉ xóa bữa trưa, giữ timer |
| DEV14 | Progress chọn 30/10/2026 | Empty thật, không có lịch/completion, CTA khám phá vẫn có |

Ảnh: evidence/f02/timer-early-end-xperia.png, progress-early-end-xperia.png, timer-full-xperia.png, progress-empty-xperia.png, home-completed-xperia.png. JSON server checkin/undo/early/full/keep/delete/food lưu riêng ở evidence/flows/completion-*.json. Giá trị integerValue trong JSON REST có thể là chuỗi theo định dạng Firestore; thời lượng đã đối chiếu với UI.

Unit tests mới kiểm tra background gap, pause exclusion, cap 180 giây, failed save giữ 45 giây để retry, chặn subsecond fake record, stale response sau logout, union denominator và leave-dialog. Case 45 giây là fake-clock unit test; case máy thật kết thúc sớm là 72 giây, không trộn hai bằng chứng.

Widget test từng phát hiện semanticsValue của Progress không đúng kiểu số; đã bỏ override sai, dùng label mô tả và giá trị mặc định của Flutter. Bộ cuối đạt 21 tests. Rules cuối đạt 14 tests, bao gồm immutable completion, owner/cross-user, duration bounds và delete giữ schedule.
