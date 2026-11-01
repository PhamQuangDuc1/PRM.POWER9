# Lab 3 — mốc khởi tạo 31/10/2026

## Trạng thái hiện hành — tiếp tục tối 01/11/2026

Các đoạn mốc cũ bên dưới là lịch sử, không phải danh sách việc còn thiếu hiện tại.

| Hạng mục | Hiện trạng | Cần đóng tiếp |
| --- | --- | --- |
| Flutter/MVVM, 10 màn và ba flow | Đã triển khai, có smoke Xperia | Fidelity 360/412, TalkBack và đồng bộ Figma Login/Profile |
| Auth/Firestore | Có đăng nhập/dữ liệu thật, Rules ownership/schema | Minh chứng hủy đăng nhập, offline/logout và cách ly tài khoản trên máy |
| Analytics/Crashlytics/Remote Config | Có bằng chứng dịch vụ thật | Bổ sung đủ event/params và các lỗi bắt buộc theo đề |
| FCM/PDF | Console ba trạng thái và tap đã kiểm chứng; PDF thật đã lưu | Quyền bị từ chối và ARTEMIS native interaction còn thiếu |
| Storage | Có uploader/Rules/emulator, upload flag=false | Chưa có upload production; giữ Spark theo quyết định người dùng, cần phương án được giảng viên chấp nhận |
| Flutter/Rules | Chạy lại 36/36 Flutter tests và analyze sạch ngày 01/11; Rules 18/18 ở mốc trước | Không dùng thay E2E |
| ARTEMIS | Phase 1 xác minh 7/9: 6 pytest passes hợp lệ +1 delayed-terminal audit; TC04[2]/[3] failed | Hoàn tất hai lượt lỗi, >=10 ca ×3, native/error/analytics và exploratory 15–30 phút |
| Review và bộ nộp | Chưa đóng | Review PR >=5 findings / >=2 nhóm / >=3 accepted fixes; report 8–12 trang, slide 12–15 trang, video 5–10 phút |

Runner đã thêm guard khóa/ngủ trước khi mở Activity, chờ hierarchy có giới hạn, hủy Flutter picker còn mở và chờ terminal trace commit. Tám regression tests cục bộ đạt; không gọi model trong các tests này. Xperia đã trả Home và daemon đã tắt sau bốn lượt. Lỗi HTTP 503/UNAVAILABLE có trong log, chưa quy thành lỗi app. Không tự bật billing, commit hoặc push.

## Bổ sung 01/11/2026

Mốc FCM/PDF: 36 Flutter tests đạt, analyze sạch. Notification Center đã nhận Test message từ Firebase Console ở foreground/background/terminated trên Xperia; native tap mở Home, inbox lưu thông báo. Các lượt API riêng mở Progress. PDF thật đã lưu Download trên Xperia và pull/QA đúng dữ liệu ngày 01/11, 0/2 lịch, giữ giờ 21:30. Storage uploader/Rules có code và 18 emulator tests (16 Firestore +2 Storage) đã đạt, metadata rules đã deploy; chưa có bucket/upload production. Người dùng chọn giữ Spark, không bật billing; upload được khóa bằng report_upload_enabled=false và cần trao đổi với thầy, không tuyên bố Storage đã hoàn thành. Chi tiết ở docs/fcm-pdf-storage.md.

Mốc mới nhất: commit trước 291ff48 đã có trong Git; thay đổi Analytics/Crashlytics/Remote Config hiện chưa commit/push. Tổng Flutter suite 29 tests đạt, analyze không issue, APK mới đã cài Xperia. Remote Config hai tham số đã đổi hành vi thật không rebuild và trả defaults; Analytics đã có sự kiện trên DebugView do người dùng xác nhận bằng ảnh; Crashlytics reporting API xác nhận một fatal test crash và một non-fatal từ lỗi mất mạng thật. Xem docs/firebase-observability.md cho bằng chứng và giới hạn xác minh. Phần lịch sử dưới đây ghi số test của từng mốc trước.

S04 Kết nối có hai hoạt động đi bộ/trò chuyện; S09 checklist thực tế; S10 nội dung nghỉ tối và form lịch quay về nguồn. Flutter analyze không issue, 23 tests đạt. Xperia đã kiểm chứng check-in/undo kết nối và nhánh checklist mất mạng → giữ 3/3 → thử lại → một completion server; xem `docs/workspace-verification.md`. Các kiểm thử mới là ADB smoke, không thay yêu cầu ARTEMIS 10 cases ×3 runs. Chưa commit/push các thay đổi hiện tại.

## Đã kiểm chứng

- Dựng Flutter Android trong repo Lab 2, giữ nguyên tài liệu thiết kế. Tên app/title **Power9 Office Routine**; icon adaptive có nền trắng và logo gốc.
- Tạo Firebase project mới `power9-office-se180724`, đăng ký Android app, SHA-1 debug và lấy OAuth config sau khi người dùng bật Google provider. Chưa bật billing.
- Mã theo cấu trúc models/screens/viewmodels/services/theme/widgets. SDK Firebase/Google được gọi ở services; app bootstrap/auth gate đọc state qua Riverpod.
- `flutter analyze lib test`: không có issue ở lượt kiểm tra cuối.
- `flutter test --no-pub`: 21 test đạt, thêm timer/elapsed/cap/retry/logout race, overview và dialog rời phiên vào bộ trước. Log F02 ở evidence/flutter/unit-widget-f02-tests.txt. Đây là unit/widget tests, không thay ARTEMIS.
- `flutter build apk --debug --no-pub --target-platform android-arm64`: thành công sau khi tắt Kotlin incremental để tránh lỗi source C:/project D:.
- APK tích hợp Firebase đã cài và mở trên Sony SOV41, Android 11/API 30. ADB xác nhận MainActivity đang foreground và process đang chạy.
- `evidence/bootstrap/login-xperia.png`: ảnh chụp bản bootstrap đầu tiên trên máy thật, đã xem bố cục; chưa phải bằng chứng Google Sign-In thành công.

## Bổ sung mốc F01/F03

- Người dùng xác nhận đã vào Profile ở bản xác thực, rồi vào Home ở bản Firestore. ADB đã đọc và xem ảnh Home có dữ liệu đúng; chưa có ảnh Authentication Users console/hủy/logout thực tế nên chưa đóng toàn bộ tiêu chí Auth.
- Firestore `(default)` Standard, asia-southeast1, freeTier=true. Seed 9 hoạt động chung. Rules deny-by-default, uid ownership/schema, compiled và deployed; 8 test emulator đạt, log trong evidence/firestore.
- Trên Xperia: Home ban đầu 0 lịch → mở Khám phá → chi tiết đi bộ → bật nhắc nhưng bỏ giờ bị validation → tắt nhắc và lưu → Home có 1 lịch. Sau đó đổi giờ thành 23:01; Home và server vẫn 1 doc, createdAt giữ nguyên. Thử đổi nhắc rồi Hủy: updatedAt/time/reminder trên server không đổi.
- Đã đối chiếu Firestore server qua API IAM (không chỉ dựa UI). Evidence xuất bản không chứa UID/token, chỉ metadata hoạt động/ngày/giờ: `evidence/flows/firestore-server-verification.json`.
- Kiểm tra ADB này là smoke test thiết bị, không phải ARTEMIS và chưa phải 3 lượt/test. Lần thử nhập giờ bằng tọa độ gặp thay đổi bố cục keyboard và phải làm lại; ghi rõ trong test report, không tính lượt đó là pass.

## Chưa hoàn thành

PDF/Storage, FCM, bộ ARTEMIS đầy đủ, PR review và bộ nộp. Analytics đã tích hợp 9 loại event, còn bổ sung bằng chứng params/đủ sự kiện và auth events trên SDK mới. S04/S09/S10 đã triển khai/kiểm thử; Profile có khu debug cho Remote Config/Crashlytics, chưa đủ sáu dịch vụ. Figma Login/Profile và fidelity chưa đồng bộ/kiểm tra đầy đủ. Nhắc theo giờ hiện chỉ lưu cấu hình, chưa phát notification. Không có lịch sử hoàn thành seed giả hoặc nút bỏ qua xác thực.

Người dùng đã commit/push mốc Auth/F01/F03, commit `76bbfa5`. Phần F02 hiện tại chưa commit/push. Chưa đổi main hoặc merge thay người dùng.

## Mốc F02 — đã thử trên Xperia

- Check-in Home: 0/1 → 1/1, source=checkin và durationSeconds=null; Undo trả completionCount=0 nhưng scheduleCount=1.
- Timer pause tại 02:58, chọn tab khác → Ở lại vẫn paused 02:58. Resume, ra background và quay lại vẫn đếm đúng.
- End early ghi 72 giây, Progress hiển thị 1 phút 12 giây. Chạy đủ phiên khác: tự về 00:00, record đúng 180 giây.
- Giữ lại trong delete dialog không thay bản ghi; Xóa chỉ xóa completion, schedule còn. Record xong Back từ Progress về Home, dữ liệu còn sau update/restart app.
- Nhánh Ăn uống record source=checkin, durationSeconds=null; Back quay Ăn uống, Undo giữ completion timer trước đó. Dữ liệu thử cuối: 1 schedule đi bộ và 1 completion timer 180 giây.
- Progress chọn 30/10/2026 không có dữ liệu: empty thật, 0 quota, có CTA khám phá; không tạo dữ liệu để lấp màn.
- Rules completion đã compiled/deployed, tổng 14 emulator tests đạt. Evidence F02 trong evidence/f02, JSON server trong evidence/flows/completion-*.json; không chứa UID/token.
- Test thiết bị là smoke ADB, không phải ARTEMIS. Process-death restore, full TalkBack/fidelity và offline/retry thật trên máy còn cần kiểm tra. Thiết lập giữ màn hình sáng qua USB đã khôi phục về 0 sau lượt thử.
