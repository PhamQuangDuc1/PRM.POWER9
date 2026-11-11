# Power9 — kết quả kiểm chứng Auth/F01/F02/F03

## Kiểm chứng bổ sung 03/11/2026

Auth offline/retry/logout/Back đạt trên Xperia; hai tài khoản chưa thử vì người dùng chỉ có một tài khoản. Analytics11/12 event có native SDK evidence, không đồng nhất DebugView server; export_report còn phụ thuộc Storage. Trợ năng17/17 hành vi đạt,21/21 request được chấp nhận nhưng20/21 snapshot thấy focus: còn Hôm nay sau Ở lại, strict check vẫn failed. Người dùng chọn tự động trước, nghe/vuốt thủ công để sau. Đã sửa nhãn chuông, Flutter49/49 đạt, analyzer sạch, APK mới build/cài và dữ liệu/mạng/TalkBack/debug đã khôi phục. Chi tiết: docs/lab3-verification-2026-11-03.md. Hướng dẫn demo đầy đủ: docs/lab3-demo-guide.md. Không gọi thêm ARTEMIS, không bật billing/đồng bộ Figma; video/thầy để sau.


## CRUD lịch đã xác minh trên Xperia

Flutter48/48 đạt, analyzer sạch; APK CRUD mới đã build/cài. Năm tests mới bao phủ ack/chống bấm lặp, failure/retry, đổi tài khoản khi đang xóa, telemetry lỗi và UI cancel/failure/retry giữ completion. Demo native có API server đọc đúng doc kiểm thử theo uid (không xuất uid): create, read, update10:30 giữ createdAt, cancel delete không đổi updatedAt, delete lịch giữ completion và cleanup đúng dữ liệu do lượt thử tạo. Evidence evidence/flows/crud/native-crud-result.json và phase snapshots/ảnh. Ba harness attempts ban đầu giữ riêng; không tính các lỗi nhập liệu/hint thành app pass. Không gọi model, không tăng30/33ARTEMIS. Không đồng bộ Figma theo yêu cầu; video/thầy để sau.

## Cập nhật PR và trình bày

Theo yêu cầu mới, trợ lý đã tạo ba commit riêng R01/R02/R03 và [draft PR #3](https://github.com/PhamQuangDuc1/PRM.POWER9/pull/3) từ codex/lab3-review-and-slides vào main, không merge. Video được người dùng chủ động để cuối sau khi chốt hướng UI/UX. Slide được làm lại thành deck PowerPoint 15 trang chỉnh sửa được; trạng thái ARTEMIS/Storage và các kết quả test không đổi chỉ vì đổi thiết kế slide.

## Cập nhật kiểm tra ngày 02/11/2026

Xperia/Firebase/GitHub kết nối được, billing tắt. Flutter chạy lại 43/43 đạt; kiểm tra nhãn và vùng chạm Android trên 14 widget màn ở 360/412 dp chữ 1,5× đạt. Smoke thật đã xác minh lỗi quyền thông báo và khôi phục, logout/Back/hủy Google Sign-In/retry; người dùng đã đăng nhập lại và Home được xác nhận. Những lượt này không phải ARTEMIS. Xem [mốc tiếp tục ngày 02/11](lab3-resume-2026-11-02.md) và bằng chứng được liên kết ở đó.

ARTEMIS giữ 30/33 xác minh. Người dùng đồng ý tổng 50 lượt nhưng auto-review chặn resume theo ràng buộc dừng cũ; thực tế vẫn dùng 45/45, không có model task mới. Storage production, Pro/ba run ID, PR/ba commit, video Console và fidelity/TalkBack còn thiếu; chưa thể đánh dấu 100%.

## Kết quả chốt tối 01/11/2026

- Flutter43/43đạt; analyzer0issue; APKdebugarm64build/cài thànhcông.13offline runner testsđạt.18Rules tests là mốc trước, không chạy lại khi Rules không đổi.
- ARTEMIS11ca×3runIDđãthử;30/33xácminh =29pytestpasses hợp lệ +1auditTC03.59attemptsđượcgiữ,9cacó3/3xácminh. Ba runIDchưađạt:TC10[3],TC16[2]/[3]. [Bảng tỷ lệ và thời gian](lab3-e2e-results.md) không đếm các lỗi thành pass.
- TC16[1] cóevent/paramSDKthật lọc theo markerbuildngẫu nhiên và tasktime. Khôngxuất rawlogFA-SVC củaappkhác hoặc dùng logDart thaySDK.
- Prolượt45bịquotaRESOURCE_EXHAUSTED500/ngày,0bướcUI;926,82giây chờ không phải15phút khámphá. Đãdừngtask/daemon, dùngđủ45/45lượtđượcđồngý, khôngđổi key/model/billingđểnéquota.
- Replayoffline33runs/257ảnhgốc đãlọc ởevidence/artemis/replay/index.html. Footage361,89giây làbổsung, chưa thay videoapp/Console. Bộreport10trang/slide15trang ởoutput/lab3. PRreview,Storageproduction,video vàcác phầncoverageđãghichú vẫnchưađóng.

Các đoạn sau là lịch sử các mốc kiểm chứng.

## Kiểm tra tiếp tục tối 01/11/2026

- Flutter chạy lại: 36/36 tests đạt; flutter analyze lib test không issue. 18 Rules tests là kết quả đã có ở mốc FCM/PDF, không chạy lại trong phiên này.
- Runner ARTEMIS: 8 tests cục bộ đạt cho khóa/ngủ, hierarchy lọc package/retry, hủy picker bỏ dở và race terminal trace commit. Không dùng các tests này thay E2E.
- Bốn run ID tiếp tục: TC03[3] pytest đạt; TC03[2] pytest fail do terminal trace chưa commit lúc đọc, audit cùng trace sau đó xác minh JSON và final post-action UI (giữ nguyên failure lịch sử). TC04[2]/[3] task failed, output=null, không tính đạt; log ignored có HTTP 503/UNAVAILABLE. Có validation/picker trong trace chưa chứng minh đã hủy thành công.
- Tổng phase 1: **7/9 run ID xác minh** (6 pytest passes hợp lệ +1 delayed-terminal audit), 15 attempts có trace, 8 attempts không tính đạt. Setup errors trước khi gửi model không nằm trong 15 attempts. Không phải toàn bộ >=10 ca ×3, không phải pass rate toàn Lab 3. TC04/TC11 ở phase 1 chỉ bao phủ một phần case đầy đủ trong test-plan.
- Summary và từng trace ID: evidence/artemis/phase1/summary.json. Checkpoint cũ nhầm TC03[1] với lượt bị audit loại đã được sửa sang trace dc7bc0e4; không sửa/xóa kết quả lịch sử. Power9 đã về Home; daemon được tắt sau thử nghiệm.

Phần dưới lưu lịch sử các mốc cũ.

Ngày 31/10/2026, Asia/Saigon. Bản này là báo cáo tiến độ, chưa phải kết quả toàn bộ Lab 3.

Cập nhật 01/11: toàn bộ Flutter suite hiện có 23 tests đạt, analyze không issue. Ba màn S04/S09/S10 đã được bổ sung và kiểm tra Xperia, gồm mất mạng/thử lại checklist không trùng bản ghi và lưu giờ nghỉ tối 21:30. Chi tiết cùng bằng chứng tại `docs/workspace-verification.md`; log Flutter mới tại `evidence/flutter/unit-widget-workspace-tests.txt`. Các số liệu bên dưới giữ lại kết quả của mốc 31/10, không phải một lần chạy mới.

Mốc tiếp theo cùng ngày: 29 tests đạt sau tích hợp Analytics/Crashlytics/Remote Config; analyze không issue, APK mới đã cài Xperia. Đổi hai giá trị Remote Config làm thay đổi hành vi thật không rebuild; Crashlytics server xác nhận fatal test crash và non-fatal completion_write/unavailable; DebugView người dùng cung cấp cho thấy sự kiện thật. Xem docs/firebase-observability.md và evidence/firebase-observability. Không tính các thao tác ADB này thành ARTEMIS runs.

Mốc FCM/PDF ngày 01/11: 36 Flutter tests đạt, analyze sạch; 18 Rules tests đạt (16 Firestore + 2 Storage). Console Test message đã nhận và chạm mở Home ở cả foreground/background/terminated trên Xperia; PDF thật đã lưu trên máy. Log mới tại evidence/flutter/unit-widget-fcm-report-tests.txt và evidence/firestore/report-storage-rules-tests.txt; chi tiết docs/fcm-pdf-storage.md. Storage production chưa kiểm thử vì giữ Spark. Không tính các lượt này thành ARTEMIS.

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

## Kiểm thử Admin Web — Firebase Emulator

Môi trường: Edge với phiên trình duyệt riêng, Firebase Auth và Firestore Emulator project `demo-power9`, Android Emulator API 35. Tài khoản, hoạt động và thông báo dùng trong bài test là dữ liệu thử.

- Google Sign-In qua Auth Emulator. Admin vào được dashboard và tài khoản thử không có role Admin bị chặn. [Đăng nhập](../evidence/assignment/web-emulator/01-sign-in.png) · [Chặn sai role](../evidence/assignment/web-emulator/10-role-denied.png)
- Dashboard đọc các truy vấn tổng hợp Firestore và hiển thị biểu đồ theo trạng thái. Mô phỏng lỗi truy vấn và xác nhận nút Thử lại tải được số liệu. [Dashboard](../evidence/assignment/web-emulator/02-dashboard.png) · [Lỗi truy vấn](../evidence/assignment/web-emulator/07-dashboard-error.png)
- Danh mục kiểm tra form trống, tạo, tìm, sửa, lưu trữ và khôi phục. [Danh mục](../evidence/assignment/web-emulator/03-catalog.png) · [Tìm không có kết quả](../evidence/assignment/web-emulator/04-empty-search.png)
- Hai đề xuất gửi từ Android. Admin duyệt một đề xuất, xuất bản và từ chối đề xuất còn lại. Android hiển thị trạng thái và lý do. Hoạt động đã xuất bản xuất hiện trong Khám phá. [Hàng đợi sau xử lý](../evidence/assignment/web-emulator/05-review.png) · [Kết quả trên Android](../evidence/assignment/web-emulator/08-android-review.png) · [Danh mục Android](../evidence/assignment/web-emulator/13-android-published.png)
- Form thông báo kiểm tra dữ liệu trống và gửi tin vào Firestore. Android đọc được tin trong inbox. [Web gửi](../evidence/assignment/web-emulator/06-announcement.png) · [Android nhận](../evidence/assignment/web-emulator/09-android-inbox.png)
- 22 Firestore Rules tests và 53 Flutter tests đạt. Phân tích tĩnh mobile và web đạt.

Web đã được deploy lên Firebase Hosting và màn đăng nhập mở được trong phiên trình duyệt riêng. Kiểm thử thao tác Admin dùng tài khoản Emulator theo lựa chọn của nhóm. App Check enforcement và các lượt xuyên vai trò trên bản deploy vẫn cần kiểm tra với tài khoản thật. [Màn đăng nhập Hosting](../evidence/assignment/web-emulator/15-hosted-login.png)

### Review bằng AI cho phần web

- Dashboard từng tải toàn bộ đề xuất để đếm. Chuyển sang truy vấn `count()` của Firestore theo từng trạng thái và kiểm tra trên web.
- Lưu trữ hoạt động được mở trực tiếp từ tab Ăn uống hoặc Thư giãn có thể làm tab mất nội dung. Giữ hai mục đó hiển thị bằng Rules và vô hiệu hóa nút lưu trữ tương ứng. Rules test kiểm tra Admin bị từ chối khi lưu trữ mục cố định.
- Sự kiện gửi thông báo lặp có thể tạo nhiều document trước lần render kế tiếp. Thêm điều kiện kiểm tra `_sending` ngay ở đầu hàm gửi, bên cạnh việc vô hiệu hóa nút trong lúc chờ.

### Nghiệm thu bổ sung ASM

- Firebase Hosting đã cập nhật bản responsive. Edge trong phiên mới mở được trang và popup Google OAuth.
- APK Assignment trên Android Emulator tạo PDF, mở được các thao tác xem/lưu và chia sẻ. Firestore Emulator có metadata khớp tên file với `storagePath: null`. Phiên Auth Emulator cũ hết hiệu lực sau khi Emulator khởi động lại. Đăng xuất và vào lại bằng User thử nghiệm rồi chạy lại thành công. [Màn PDF](../evidence/assignment/web-emulator/16-android-pdf.png)
- 56 bài test Flutter và 23 bài test Firestore Rules đạt. Bộ test AI kiểm tra lọc ID theo ứng viên, bỏ ID trùng và xử lý JSON sai.
- Ba lượt gọi Gemini Developer API qua Firebase AI Logic thành công trên Android Emulator với App Check debug. App xử lý lỗi khi token chưa đăng ký. Khi Remote Config tắt cờ, panel Gemini ẩn và danh mục vẫn hoạt động. [Đầu vào, đầu ra và ảnh](ai-feature.md)
