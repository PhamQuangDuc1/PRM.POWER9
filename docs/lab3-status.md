# Lab 3 — mốc khởi tạo 31/10/2026

## Trạng thái bàn giao trên OneD — 04/11/2026

Nhánh hiện hành là OneD, bảo toàn tám commit từ nhánh review trước và toàn bộ thay đổi UI/bằng chứng/demo. Metadata PR thay thế ở `evidence/code-review/lab3-pr.json`; không merge vào main.

DebugView server đã xác minh `view_activity` có `activity_id=move-walk` qua ảnh Console đã che thông tin riêng, ở `evidence/analytics/2026-11-04/server-receipt.json`. Người dùng đã nghe/vuốt cả ba phần TalkBack và xác nhận đạt; phạm vi cụ thể ở `evidence/accessibility/2026-11-04-manual-flows/result.json`, không bao gồm bộ chọn Google. Trợ năng và Analytics debug đã khôi phục.

ARTEMIS vẫn 32/33 với 63 attempts giữ cả thất bại. TC10[3] mới nhất chưa đạt; Pro chưa đủ thời lượng. Budget 50/50, chưa có xác nhận tăng trần. Giữ Spark và upload=false. Kịch bản mới `docs/demo-android-emulator-2026-11-04.md` thay thiết bị trình bày bằng AVD, chưa diễn tập trên máy ảo. Các bản slide/video giữ đúng thời điểm kiểm chứng và có thể chứa trạng thái trước các xác nhận mới này.

## Mốc video trước các xác nhận bổ sung — 04/11/2026

TalkBack thủ công: người dùng đã xác nhận sau “Ở lại” nghe được Hôm nay, vuốt tới và chạm hai lần mở lại dialog. Nhánh này đạt kiểm tra người thật; toàn bộ màn hình chưa kiểm tra hết. Đã bỏ phiên chưa ghi nhận và khôi phục trợ năng. Bằng chứng: `evidence/accessibility/2026-11-04-manual-focus/result.json`. Các nhận định focus bên dưới là lịch sử trước xác nhận này.

UI/ảnh hoàn thiện, 49 Flutter tests đạt và analyzer sạch. ARTEMIS32/33, TC10[3] còn failed, Pro chưa đạt thời lượng; giữ49/50. Video app/Console/Login đã hoàn tất tại `output/lab3/Power9_Lab3_Demo_Final.mp4`: 6 phút35giây,1080p,Hoài My,SRT64mục. Đã decode toàn bộ hình/tiếng, rà18frame và che thông tin riêng. Slide15trang cập nhật bằng chứng mới tại Final_Video_20261104; các tên chính Designer/Slides đã đồng bộ và mở/xuất PowerPoint thành công.

DebugView buổi quay chưa nhận event, không coi logSDK là bằng chứng server. Crashlytics/FCM hiển thị lịch sử, không gửi/crash mới. Dữ liệu quay đã dọn và server xác minh, debug khôi phục, HomeA giữ nguyên. Billingtắt/Spark. Không ghi100%; còn TC10/Pro/TalkBack các luồng khác/DebugView, báo cáoPDFmốc cũ và việc nộp bài. Audit video: `evidence/video/2026-11-04/final-review.json`.


## Billing — quyết định mới nhất

Người dùng giữSpark sau khi được giải thích rủi ro tính phí/cảnh báo ngân sách. Không bậtbilling, không bật report_upload_enabled. Storageproduction vẫn chưa đạt; PDF local vẫn có thể demo. Không ghi100% hoặc dùng emulator/PDF local thay upload thật.

## Hai tài khoản — đã kiểm chứng sau bản UI

Đã điA→B→A với người dùng tự chọn Google: lịch/checkin thử củaA không sangB; vềA dữ liệu/timestamp giữ nguyên; đã dọn đúng hai document thử. InboxB có6mục, A rỗng trước/sau và không thấy mụcB. Không gửiFCM mới, không đụng dữ liệuB, không tăngARTEMIS. Xem [audit tài khoản](account-isolation-2026-11-03.md). TalkBack thủ công/focus vẫn chưa đóng; ARTEMIS/Pro/Storage/video/slide giữ trạng thái riêng.

## UI và hình ảnh — cập nhật tối 03/11/2026

Đã chạy lại nhánh timer bằng Android accessibility khi TalkBack bound: Ở lại giữ paused02:56; Hôm nay lần nữa kích hoạt/mở dialog được, nhưng snapshot focus vẫnfalse dù request được chấp nhận. 6/7 thao tác thấy focus, không đánh dấu TalkBack/focus hoàn tất. Đã bỏ phiên thử, vềHome và khôi phục trợ năng=null/0. Xem [kiểm tra lại focus](timer-focus-recheck-2026-11-03.md); không có model call hoặc completion mới.

Đã tạo/tích hợp bộ 8 ảnh minh họa, thumbnail, thẻ hướng dẫn và theme thống nhất; đưa timer/nút lên trước hướng dẫn và sửa tràn chữ ở 360dp/1.5×. Flutter49/49 đạt, analyzer sạch, APK UI mới build/cài bằng install-r. Bản riêng: output/lab3/Power9-Lab3-UI-20261103-debug-arm64.apk; không dùng build-config.json cũ làm hash của bản này. Người dùng đã có tài khoản B và sẵn sàng TalkBack; hai lượt thủ công chưa được tính đạt. Tiếp theo: kiểm chứng còn thiếu → video → chốt slide; không đồng bộ Figma. Chi tiết: [UI refresh](ui-refresh-2026-11-03.md). Các mốc dưới là lịch sử.

## Kiểm chứng bổ sung 03/11/2026

Auth offline/retry/logout/Back đạt trên Xperia; hai tài khoản chưa thử vì người dùng chỉ có một tài khoản. Analytics11/12 event có native SDK evidence, không đồng nhất DebugView server; export_report còn phụ thuộc Storage. Trợ năng17/17 hành vi đạt,21/21 request được chấp nhận nhưng20/21 snapshot thấy focus: còn Hôm nay sau Ở lại, strict check vẫn failed. Người dùng chọn tự động trước, nghe/vuốt thủ công để sau. Đã sửa nhãn chuông, Flutter49/49 đạt, analyzer sạch, APK mới build/cài và dữ liệu/mạng/TalkBack/debug đã khôi phục. Chi tiết: docs/lab3-verification-2026-11-03.md. Hướng dẫn demo đầy đủ: docs/lab3-demo-guide.md. Không gọi thêm ARTEMIS, không bật billing/đồng bộ Figma; video/thầy để sau.


## CRUD đã demo thật ngày 02/11

Lịch cá nhân đã có thêm/xem/sửa/xóa qua app. Native Xperia + Firestore xác minh sửa10:30 cùng document/createdAt, hủy xóa không thay dữ liệu, xóa lịch giữ completion, cleanup đúng dữ liệu thử. Flutter48/48 đạt; analyzer sạch; APK mới đã cài. Năm tests mới gồm lỗi/retry, chống bấm lặp, account race và giữ history. Xem evidence/flows/crud/native-crud-result.json. Không tính smoke này thành ARTEMIS;30/33 và Pro còn thiếu. Storage production vẫn tắt. Video/trao đổi thầy để sau; theo yêu cầu không đồng bộ Figma.

## Cập nhật PR và trình bày

Theo yêu cầu mới, trợ lý đã tạo ba commit riêng R01/R02/R03 và [draft PR #3](https://github.com/PhamQuangDuc1/PRM.POWER9/pull/3) từ codex/lab3-review-and-slides vào main, không merge. Video được người dùng chủ động để cuối sau khi chốt hướng UI/UX. Slide được làm lại thành deck PowerPoint 15 trang chỉnh sửa được; trạng thái ARTEMIS/Storage và các kết quả test không đổi chỉ vì đổi thiết kế slide.

## Cập nhật kiểm tra ngày 02/11/2026

Xperia/Firebase/GitHub kết nối được, billing tắt. Flutter chạy lại 43/43 đạt; kiểm tra nhãn và vùng chạm Android trên 14 widget màn ở 360/412 dp chữ 1,5× đạt. Smoke thật đã xác minh lỗi quyền thông báo và khôi phục, logout/Back/hủy Google Sign-In/retry; người dùng đã đăng nhập lại và Home được xác nhận. Những lượt này không phải ARTEMIS. Xem [mốc tiếp tục ngày 02/11](lab3-resume-2026-11-02.md) và bằng chứng được liên kết ở đó.

ARTEMIS giữ 30/33 xác minh. Người dùng đồng ý tổng 50 lượt nhưng auto-review chặn resume theo ràng buộc dừng cũ; thực tế vẫn dùng 45/45, không có model task mới. Storage production, Pro/ba run ID, PR/ba commit, video Console và fidelity/TalkBack còn thiếu; chưa thể đánh dấu 100%.

## Mốc chốt 01/11 trước hạn nộp 02/11

43/43 Flutter tests đạt, analyzer sạch và APK debug arm64 cuối đã build/cài. Ba fixes runtime và marker chẩn đoán Analytics có regression tests. Các widget màn chính đã được render ở360/412dp textscale1.5; không thay fidelity hoặc TalkBack trên máy.

Đã thực thi11caARTEMIS×3runID, xác minh30/33 (29pytestpasses hợp lệ +1audit trace), giữ59attempts. ChưađạtTC10[3],TC16[2–3]. Một testAnalytics đã khớp SDKevent/params củaPower9; reportchi tiết ởlab3-e2e-results.md. Probịhủy vìquotaGemini ngày500với0bướcUI;926,82giây chờ khôngđóng yêu cầu15–30phút exploratory.

Đã dùng45/45lượt được đồngý; daemon tắt, debugflagsđãdọn, billingkhôngbật. BộPDF10/15trang, APK, footage6phút02giây, replay33runs/257ảnh và kịchbảndemo ởoutput/lab3. Chưa cóvideoConsole, PRURL hoặc ba fixcommits; người dùngtựcommit/push. Storageproduction vẫnchưađạt do giữSpark; cầnphươngánđượcgiảngviênchấpnhận.

Các mục bên dưới lưu mốc cũ; ưu tiên trạng thái mới này.

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
