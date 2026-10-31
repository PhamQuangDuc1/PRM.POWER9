# Power9 Office Routine — Kế hoạch hoàn thiện Lab 3 Cloud-Enabled

Ngày lập: 30/10/2026. Trạng thái: kế hoạch triển khai; chưa phải bằng chứng app đã hoạt động.

## Cập nhật 31/10/2026 — Hướng dẫn chuẩn bị v5 của giảng viên

Đã đọc đủ 25 trang `D:/PRM393/PRM393_Lab3_Preparation_Guide_v5_ToiUu.pdf`. Hướng dẫn này bổ sung cách chuẩn bị và kiểm chứng, phù hợp bản Cloud-Enabled đã chọn; không có nội dung cho phép bỏ màn/flow Lab 2, ARTEMIS hoặc code review. Dùng cùng đề Cloud-Enabled, không coi hướng dẫn tóm tắt là thay thế mọi yêu cầu chi tiết của đề.

- Trang 1–4: hiện thực màn hình và 3 flow Lab 2, gồm lỗi; kiểm tra Firebase trên thiết bị trước khi phát triển tính năng; giữ ranh giới View → ViewModel → Service → Firebase SDK.
- Trang 5–22: mỗi dịch vụ có ba phần khái niệm, tích hợp, kiểm chứng. Tổ chức công việc và minh chứng theo cùng ba phần để người dùng giải thích được mình đang làm gì.
- Trang 23–25: >=10 ca ARTEMIS, mỗi ca >=3 lần, có lỗi và tương tác Android gốc, assert giá trị quan sát được; exploratory 15–30 phút; review PR có >=5 findings thuộc >=2 nhóm và >=3 accepted fixes; bộ nộp giữ nguyên report 8–12 trang, slide 12–15 trang, video 5–10 phút.
- Lời nhắn của giảng viên do người dùng cung cấp: Lab 3 tập trung vào công nghệ. Ưu tiên tích hợp hoạt động thật, xử lý lỗi và minh chứng; cải tiến giao diện vẫn bám Lab 2 và ghi traceability, không mở rộng scope hình thức trong lúc tiêu chí kỹ thuật còn thiếu.

Kiểm chứng lỗi bắt buộc cho từng dịch vụ:

| Dịch vụ | Tình huống phải kiểm tra |
| --- | --- |
| Authentication | Hủy đăng nhập, mất mạng, logout và truy cập khi chưa đăng nhập |
| Storage | Upload mất kết nối và truy cập không có quyền; giữ progress/kết quả rõ ràng |
| FCM | Từ chối cấp quyền; foreground/background/terminated và tap điều hướng; ghi thiết bị và cách lấy token trong hướng dẫn test |
| Analytics | Kiểm tra event thực tế và tham số trong DebugView; không lộ tên/email; xử lý việc gửi event không làm hỏng flow chính |
| Crashlytics | Lỗi không gây dừng từ flow thật vẫn có thông báo; crash thử nghiệm chỉ ở khu demo; cả hai có user ID/custom key trên console |
| Remote Config | Mất mạng/fetch thất bại vẫn có defaults hoặc cấu hình cache; giải thích fetch interval/cache khi demo |

Trạng thái môi trường đã kiểm tra qua `flutter doctor -v`: Flutter stable 3.47.3, Dart 3.13.3, Android toolchain hợp lệ, license đã chấp nhận, JDK đi kèm Android Studio; doctor không báo vấn đề. ADB đã khởi động được nhưng lần kiểm tra gần nhất chưa thấy điện thoại Android. Chưa có app build hoặc Firebase project được kết nối, nên không suy ra môi trường kiểm tra đạt đồng nghĩa tích hợp đã đạt.

Lab 2 đã push lên nhánh cá nhân `OneD`, commit `b02c1f74f37a468356443eac7ea5f14eac2629f8`; người dùng tự merge. Kế hoạch Lab 3 nằm ngoài commit Lab 2.

## 1. Phạm vi và quyết định đã thống nhất

- Chuẩn chấm: `D:/PRM393/PRM393 - Lab 3 Cloud-Enabled Mobile App (Firebase, Patrol, AI Code Review).pdf`. Nội dung đề yêu cầu Google ARTEMIS, dù tên file còn ghi Patrol.
- Hoàn thành Lab 3 trước, phát triển tiếp lên Final trên cùng mã nguồn. Chưa triển khai web admin hoặc Gemini trong đợt Lab 3.
- Giữ đề tài Power9 Office Routine, 9 nhóm hoạt động, 10 màn chức năng và 3 flow của Lab 2. Bổ sung Login và Profile theo đề.
- Còn khoảng 3 ngày theo thông tin người dùng. Kế hoạch chia theo 3 khoảng 24 giờ kể từ lúc bắt đầu triển khai; chưa có giờ nộp/demo chính xác.
- Thiết bị đích: Sony Xperia thật; chưa biết model, phiên bản Android, kết nối ADB và dung lượng trống. Đọc các thông tin này khi kết nối.
- Người dùng đã có tài khoản từ bài trước. Chưa xác nhận có Firebase project dùng lại được, cấu hình Android đúng hay dịch vụ đã bật.
- Báo ngay vấn đề thực tế, phần có nguy cơ trễ và thay đổi ảnh hưởng phạm vi. Ý tưởng thêm được trình bày để người dùng quyết định trước khi làm.

## 2. Hiện trạng đã kiểm tra

- Có `design/screen-spec.md`, `design/component-spec.md`, `ux/user-flow.md` và `handoff/flutter-handoff.md`.
- Handoff có mapping token sang Flutter và component sang widget, các quy tắc lưu lịch/ghi nhận/undo/retry.
- Không tìm thấy `pubspec.yaml`, mã Dart hay Firebase app config của ứng dụng trong repo hiện tại. Prototype và slide Lab 2 chưa phải app Lab 3.
- Lệnh Flutter, Dart, ADB, Git và uv có trong PATH. Chưa xác nhận phiên bản, `flutter doctor`, Android toolchain, license, build hoặc thiết bị.
- Workspace có thay đổi Lab 2 chưa commit. Không đưa các thay đổi đó vào commit Lab 3 ngoài ý muốn; không ghi đè hoặc xóa chúng.

## 3. Đường hoàn thành trong 3 ngày

Đây là lịch mục tiêu có điều kiện, không phải cam kết đủ mọi tiêu chí trong 72 giờ. Các điểm chưa xác minh gồm môi trường Android, quyền Firebase, Storage, model API và ARTEMIS. Nếu vướng, báo ngay tác động và cách xử lý; không tự bỏ tiêu chí hoặc tạo minh chứng thay thế.

| Khoảng thời gian | Công việc ưu tiên | Điều kiện kết thúc |
| --- | --- | --- |
| Ngày 1, đầu ngày | Kiểm tra thiết bị/toolchain, Firebase hiện có, khả năng dùng Storage và ARTEMIS; lập traceability, architecture, analytics plan và test plan ban đầu | Biết các phụ thuộc có dùng được; app Flutter cài và mở trên Xperia; có bảng yêu cầu và nguồn dữ liệu |
| Ngày 1, phần còn lại | Khung MVVM + theme/widget, Google Sign-In, Firestore + Rules, flow F01 thêm hoạt động | Đăng nhập thật; đọc danh mục, tìm/lọc, xem chi tiết và lưu lịch; Home cập nhật từ Firestore; lỗi lưu không đổi dữ liệu đã lưu |
| Ngày 2 | F02, F03 và toàn bộ 10 màn; export/upload; FCM; Analytics, Crashlytics và Remote Config; ghi bằng chứng khi tích hợp | Ba flow và nhánh phục hồi chạy trên máy thật; từng dịch vụ có hành vi và bằng chứng; gửi review PR ngay khi có mã đủ để review |
| Ngày 3, phần đầu | Hoàn thành review/fix, ARTEMIS đầy đủ, phiên exploratory, kiểm tra Rules và độ khớp thiết kế; bổ sung ảnh/trace còn thiếu | >=10 test, >=3 lần/test; báo cáo pass rate; >=5 review findings và >=3 fix commit riêng; không che giấu lỗi |
| Ngày 3, phần sau | Đóng băng tính năng, hoàn thiện report/slide, quay demo, kiểm tra link và tập giải thích | Report 8–12 trang, slide 12–15 trang, video 5–10 phút; bản cài và tất cả link được kiểm tra |

Nguyên tắc điều chỉnh: việc test theo từng flow bắt đầu ngay khi flow chạy được; review chuẩn bị trước ngày 3; tài liệu và ảnh ghi liên tục. Không đợi hoàn thành tất cả màn rồi mới thử Firebase hoặc ARTEMIS. Sau ngày 2 không nhận thêm tính năng tùy chọn nếu còn tiêu chí bắt buộc chưa đạt.

## 4. Mốc 0 — Gỡ các phụ thuộc trước

1. Xác nhận phiên bản Flutter/Dart, Android SDK/JDK, license và khả năng build. Ghi phiên bản dùng thật trong README.
2. Kết nối Xperia bằng cáp dữ liệu, bật Developer options/USB debugging, người dùng chấp nhận RSA trên điện thoại. Đọc model/API level và chạy app đầu tiên.
3. Kiểm tra tài khoản/Firebase project cũ với người dùng: quyền sở hữu, app Android, package ID, Analytics, Google provider, Firestore, Storage và cấu hình liên quan. Tái sử dụng phần đúng; không sửa/xóa dữ liệu cũ chưa hiểu mục đích.
4. Kiểm tra yêu cầu gói/billing hiện hành của Cloud Storage trước khi chọn cấu hình. Không tự bật billing hoặc phát sinh chi phí. Nếu cần, báo rõ lựa chọn để người dùng quyết định. Không tự thay Cloud Storage bằng dịch vụ khác vì bản đề áp dụng yêu cầu dịch vụ này.
5. Xác minh ARTEMIS chạy được: phiên bản Python, uv, ADB, commit ARTEMIS, model/profile hỗ trợ, cách cài và truy cập model API. Người dùng tự nhập key bằng phương thức phù hợp; không đưa key vào repo, ảnh hoặc log công khai.
6. Lấy một tài khoản Google test riêng; không dùng tài khoản cá nhân chính cho suite E2E. Kiểm tra SHA-1 cho Google Sign-In và auth-state routing trên thiết bị thật.
7. Smoke test ARTEMIS trên app sớm để phát hiện vấn đề kết nối, Semantics hoặc chi phí trước khi viết cả suite.

**Báo người dùng ngay khi:** không build được, điện thoại không được ADB nhận, Firebase thiếu quyền, Storage yêu cầu billing, không có model API, hoặc ARTEMIS không chạy được. Nếu phải thay công cụ bắt buộc, cần xin giảng viên chấp thuận; không coi việc thay công cụ là tương đương tự động.

## 5. Mốc 1 — Đặc tả và kiến trúc trước feature

Tạo trước khi làm tính năng:

- `docs/design-traceability.md`: mỗi màn/flow/component → route, widget, ViewModel, service, nguồn dữ liệu, test và trạng thái. Ghi mọi khác biệt với Figma và lý do; đồng bộ Figma khi đổi thiết kế.
- `docs/architecture.md`: cấu trúc thư mục, sơ đồ tầng, sequence diagram một flow, bảng ViewModel/service.
- `docs/analytics-plan.md`: >=7 events có trigger, tham số/kiểu, câu hỏi sản phẩm và bước flow.
- `docs/test-plan.md`: ID, precondition, instruction, expected result, flow và dữ liệu reset cho từng test.
- Sổ minh chứng: mỗi tiêu chí → ảnh/trace/commit → trạng thái chưa chạy/đã chạy/đạt/chưa đạt.

Phương án kỹ thuật dự kiến, có thể điều chỉnh theo kiểm tra môi trường:

- Flutter/Dart, MVVM với Riverpod; view không gọi Firebase hoặc xử lý nghiệp vụ trực tiếp.
- Giữ cấu trúc `lib/`, `android/`, `firebase/`, `e2e_test/`, `docs/`, `evidence/`, `report/`, `slides/` theo Lab 3.
- Theme và widget dùng mapping trong handoff; không tạo lại toàn bộ phong cách. Thêm Login/Profile cùng design system, không thêm tab chính tùy tiện.
- Tách model/service khỏi view, tránh phụ thuộc Android trong model để dễ chuyển vào `packages/core/` khi làm Final. Chưa cần dựng monorepo hoặc web ở Lab 3.
- Pin dependency và phiên bản công cụ sau khi xác minh tương thích; không chọn số phiên bản theo trí nhớ.

## 6. Mốc 2 — Dữ liệu thật và ba flow

### Mô hình dữ liệu khởi điểm

| Nơi lưu dự kiến | Mục đích | Quyền dự kiến |
| --- | --- | --- |
| `activities/{activityId}` | Danh mục hoạt động có nội dung thật của 9 nhóm, đưa vào Firestore bằng seed có kiểm soát | Người đăng nhập đọc; client người dùng không ghi danh mục |
| `users/{uid}` | Hồ sơ và cài đặt cần thiết | Chủ tài khoản đọc/ghi các trường được phép |
| `users/{uid}/schedules/{id}` | Lịch đã lưu | Chỉ chủ tài khoản |
| `users/{uid}/completions/{id}` | Bản ghi thực hiện, ngày và thời lượng thực tế | Chỉ chủ tài khoản |
| `users/{uid}/reports/{id}` | Metadata file PDF, owner, thời điểm, Storage path/URL theo thiết kế bảo mật | Chỉ chủ tài khoản |
| Bộ nhớ riêng theo uid hoặc collection được chốt khi triển khai | Notification Center nhận thông báo | Không trộn lịch sử giữa tài khoản |

Đây là thiết kế dự kiến; Rules cần kiểm tra trường hợp lệ, kiểu dữ liệu, ownership và trường không được sửa. Không cho người dùng tự nâng quyền. Không để open rules/test mode. Chốt query và index theo màn thật.

### Các flow và điều kiện đạt

- **F01 — Tìm và thêm:** Home → Khám phá → Chi tiết → Lịch → Home. Tìm/lọc thật; empty/reset; validate; lưu bất đồng bộ; lỗi giữ draft; retry không tạo bản trùng; chỉ cập nhật Home khi ghi thành công.
- **F02 — Thực hiện và xem lại:** timer thật start/pause/resume, xử lý background; chỉ ghi thời lượng thực tế; check-in và undo; lịch sử đọc dữ liệu thật; xóa completion có xác nhận và giữ schedule.
- **F03 — Đổi lịch:** mở hoạt động đã có → sửa giờ → lưu. Hủy không ghi; lỗi giữ giờ cũ; retry thành công cập nhật đúng bản ghi, không tăng số lịch.
- Hoàn thiện cả 10 màn, bao gồm Ăn uống, Kết nối, Góc làm việc và Ngủ/phục hồi. Không chỉ triển khai các màn có trong happy path chính.
- Google Sign-In: đăng nhập, hủy, lỗi, profile, sign-out và route theo auth state. Sign-out dọn dữ liệu/cache/timer gắn với user theo chính sách rõ ràng.
- Ngày 26/10/2026 và giờ mẫu trong prototype chỉ là dữ liệu thiết kế. App chạy theo ngày và dữ liệu thật; test dùng seed/clock có kiểm soát. Không đóng cứng ngày mẫu trong bản nộp.

## 7. Mốc 3 — Firebase và minh chứng

| Dịch vụ | Hành vi bắt buộc và áp dụng Power9 | Minh chứng |
| --- | --- | --- |
| Authentication | Google Sign-In, signed-out chỉ thấy Login, xử lý hủy/lỗi, profile và logout | Máy thật ở cả hai auth state; Users console |
| Cloud Storage | Xuất PDF từ lịch sử/tiến độ đang xem; upload `reports/{uid}/...`; progress, retry, URL; Rules giới hạn theo user | PDF mở được; file console; Rules; đường dẫn metadata |
| FCM | Xin quyền khi Android yêu cầu; nhận foreground/background/terminated; Notification Center; chạm mở đúng màn | Tin nhắn console nhận trong cả 3 trạng thái, điều hướng trên máy thật |
| Analytics | >=7 events có tham số; login/logout/search/view_activity/schedule_created/activity_completed/schedule_updated/export_report là phương án ban đầu; user ID sau sign-in | DebugView cho từng event; ít nhất 1 test kiểm tra event qua Logcat hoặc DebugView |
| Crashlytics | Một non-fatal từ lỗi thật được xử lý và một test crash; user ID, custom key; thao tác demo tách rõ | Dashboard hiển thị cả hai; key đúng; không suy diễn từ lời gọi SDK |
| Remote Config | >=2 giá trị thay đổi hành vi, có defaults và UI xem giá trị. Gợi ý `discover_max_minutes` và `report_export_enabled` | Trước/sau đổi console, app phản ứng không rebuild |

Firestore là nguồn dữ liệu cá nhân của Power9 ngoài sáu dịch vụ ở bảng yêu cầu. Kiểm tra đủ CRUD, query/filter/sort, realtime và trạng thái loading/empty/error/retry. Trạng thái UI phải phản ánh thao tác thật, không chỉ dựng màn tĩnh.

Các giá trị Remote Config phải được chốt để không vô tình khóa flow bắt buộc khi chấm; reset về cấu hình demo sau khi ghi minh chứng.

Lưu ý thực tế về FCM: thông báo được gửi từ Firebase console đủ để kiểm chứng tích hợp theo đề. Không gọi đó là hệ thống nhắc lịch tự động. Nhắc tại giờ đã chọn cần cơ chế riêng được chốt ở mục đề xuất. Phân biệt app bị đóng bình thường với người dùng Force stop; ghi điều kiện thử rõ ràng.

Không đưa email, tên, ghi chú tự do hoặc nội dung riêng tư vào Analytics. Lọc query tự do trước khi log; ưu tiên nhóm/filter hoặc từ khóa danh mục kiểm soát. Crashlytics cũng cần lọc nội dung exception và key.

## 8. Mốc 4 — Test trên máy thật

Suite dự kiến 15 nhóm case; có thể tách thêm để kết quả dễ xác minh:

| ID | Kiểm tra | Kết quả cần chứng minh |
| --- | --- | --- |
| TC01 | Google Sign-In và account picker | Vào Home đúng tài khoản, điều hướng chính hiện |
| TC02 | F01 tìm/lọc → chọn → thêm lịch | Tên/giờ đúng; tổng lịch tăng đúng một |
| TC03 | Không có kết quả → reset | Empty đúng, reset lấy lại danh sách |
| TC04 | Validation/lỗi lưu → retry | Draft giữ nguyên; không sửa Home khi lỗi; retry không nhân đôi |
| TC05 | F02 start/pause/resume/finish | Lưu đúng hoạt động và thời lượng; tiến độ cập nhật |
| TC06 | Kết thúc sớm hoặc bỏ phiên | Thời lượng thật hoặc không tạo completion, đúng lựa chọn |
| TC07 | Check-in → undo → xóa completion | Home/history đồng nhất, lịch vẫn còn |
| TC08 | F03 đổi giờ, hủy và lưu lại | Hủy giữ dữ liệu; lưu sửa đúng giờ; số lịch không tăng |
| TC09 | Điều hướng và màn chi tiết | Đủ top-level, Back giữ nguồn/filter; nội dung các loại hoạt động đúng |
| TC10 | Remote Config | Hai giá trị hiện đúng và thay đổi hành vi |
| TC11 | Export/upload PDF | PDF phản ánh dữ liệu đang xem; upload thành công; mở được URL |
| TC12 | Notification permission/notification shade | Nhận và chạm thông báo mở đúng màn |
| TC13 | Sign-out và dữ liệu giữa tài khoản | Về Login; không còn dữ liệu của user trước |
| TC14 | Các màn phụ S02/S04/S09/S10 | Hành động đúng với từng hoạt động, không dùng nhầm dữ liệu đi bộ |
| TC15 | Mạng lỗi và khôi phục | Feedback đúng; không spinner vô hạn; retry có kết quả và dữ liệu nhất quán |

- Mỗi test là pytest qua ARTEMIS SDK, có precondition/reset rõ ràng, không phụ thuộc thứ tự.
- Assert kết quả nhìn thấy/giá trị agent trả về; không chỉ assert SUCCESS.
- Mỗi test chạy >=3 lần, ghi pass rate, thời gian trung bình, trace ID, ảnh/replay và nguyên nhân flaky/fail/skip.
- Dùng Flash cho regression; một phiên Pro exploratory 15–30 phút có ghi nhận vấn đề theo đề.
- Có Semantics labels trên widget quan trọng và một test kiểm tra Analytics event.
- Bổ sung test Dart có giá trị cho tính duy nhất của schedule/completion, undo, timer hoặc validation; không viết test chỉ lặp lại code.
- Emulator tests cho Rules: ownership, cross-user denial, dữ liệu sai kiểu và path file. Hai account test khi cần chứng minh cách ly dữ liệu; không suy ra Security Rules đúng chỉ từ một lần đăng nhập.
- Chạy `flutter analyze`, `dart format`, build APK; kiểm tra layout 360/412 dp, touch target >=48 dp, text, keyboard và TalkBack trên app thật. Nếu Xperia không có đúng hai chiều rộng, bổ sung emulator/viewport kiểm tra có ghi rõ nguồn; không gắn nhãn ảnh emulator là ảnh máy thật.

## 9. Mốc 5 — AI review, tài liệu, bộ nộp

- Review trên PR chứa mã Lab 3; lưu output nguyên bản của công cụ.
- >=5 findings thật gắn file/line, >=2 nhóm vấn đề; mỗi finding có quyết định accepted/modified/rejected và lý do.
- >=3 findings accepted được sửa, mỗi finding một commit riêng ghi ID. Nếu công cụ chưa tìm đủ, mở rộng review sang các module rủi ro; không bịa finding để đủ số lượng.
- Report PDF 8–12 trang; slide PDF 12–15 trang; video 5–10 phút quay live các hạng mục đề yêu cầu, có Firebase console ở chỗ chứng minh kết quả.
- README: chủ đề, link Figma, cách chạy app/test, setup, phiên bản đã pin, công cụ AI, video và bản đồ deliverable.
- Git history thể hiện các mốc thật. Đề còn placeholder `[N]` cho số commit/ngày; không tự đặt con số thành yêu cầu của thầy.
- Repo cần tên `PRM393_Lab03_<StudentID>` theo đề. Cần người dùng cung cấp mã sinh viên và chốt cách xử lý repo hiện có trước thao tác đổi tên từ xa; không tự đổi remote.
- Kiểm tra quyền truy cập repo/report/slide/video ở cửa sổ riêng tư. Bản nộp không có API secret, service-account key hay keystore.
- Khi các tiêu chí đã đạt, tạo mốc Git Lab 3 để giữ bản đã nộp; sau đó mới mở scope Final.

## 10. Tăng tính thực tế, trình người dùng quyết định

Các mục sau là đề xuất, chưa được phê duyệt thành scope bổ sung. Ưu tiên đề xuất khi biết chi phí triển khai và deadline; không làm thêm chỉ để nhiều tính năng.

| Đề xuất | Giá trị | Cách xử lý trong lịch 3 ngày |
| --- | --- | --- |
| Nhắc giờ bằng local notification, có quiet hours | Lịch nhắc có ích ngay cả khi không có backend tự gửi FCM | Ưu tiên xin quyết định sớm nếu triển khai nhắc thật; phải tách khỏi minh chứng FCM và kiểm tra quyền/giới hạn nền trên Xperia |
| PDF tổng kết một ngày/tuần, chỉ số có nghĩa | Biến yêu cầu export bắt buộc thành báo cáo thật: hoạt động đã chọn/đã làm, thời lượng thực tế, không suy diễn sức khỏe | Chọn phạm vi tối thiểu trước; tuần là tùy chọn nếu báo cáo ngày đã ổn |
| Đọc dữ liệu gần nhất khi mất mạng, nhãn trạng thái rõ | Giữ app hữu ích khi mạng yếu và tránh hiểu nhầm đã lưu | Xử lý lỗi/giữ draft là bắt buộc; cơ chế offline write/sync đầy đủ chỉ thêm nếu kiểm chứng được |
| Thử với 1–2 người trong 10 phút | Phát hiện copy khó hiểu hoặc thao tác sai trên máy thật | Làm khi app đủ flow; ghi đúng số người và quan sát, không gọi là nghiên cứu quy mô lớn |

Không thêm streak ép hoàn thành, bảng xếp hạng sức khỏe, chat/social thực, tích hợp lịch công ty, web admin hoặc Gemini trong đợt Lab 3.

## 11. Cách phối hợp với người dùng

- Khi có blocker, báo ngắn: vấn đề gì → ảnh hưởng tiêu chí/mốc nào → phương án và việc người dùng cần làm → phần vẫn có thể tiếp tục.
- Hỏi trước khi phát sinh billing/model API cost chưa được chấp thuận, dùng dịch vụ/tài khoản khác, đổi scope lớn, hoặc thay công cụ bắt buộc cần ý kiến thầy.
- Không hỏi lại để quyết định routine như tên file, tách widget/service hoặc sửa bug trong scope đã chốt.
- Thiết bị cần ở đầu ngày 1 để cài app/Auth; ngày 2 để FCM/PDF/Crashlytics/Analytics; ngày 3 để ARTEMIS và quay demo. ARTEMIS cần máy rảnh vì agent sẽ thao tác màn hình.
- Người dùng trực tiếp đăng nhập/chấp nhận quyền trên điện thoại, mở console hoặc cấp quyền dịch vụ khi cần. Không yêu cầu gửi mật khẩu hoặc key qua chat.
- Cập nhật theo mốc có bằng chứng: đã chạy gì, còn lỗi gì, việc tiếp theo. Không đánh dấu hoàn thành dựa vào code hoặc ảnh prototype.

## 12. Điều kiện chuyển sang Final

Lab 3 có bản cài chạy thật, flow và dịch vụ có bằng chứng, test/review có kết quả thật, bộ nộp truy cập được và các lỗi còn lại được ghi rõ. Sau đó mở kế hoạch Final riêng: role/admin, web, shared package, cross-role realtime, inbox và Gemini.

Final có quy định khác về file: lưu/chia sẻ PDF tại thiết bị và metadata trên Firestore, loại Cloud Storage khỏi scope. Tách `ReportGenerator` khỏi `ReportUploadService` ở Lab 3 để điều chỉnh được; không mặc định nộp nguyên bản Lab 3 là đạt Final.
