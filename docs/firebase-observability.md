# Analytics, Crashlytics, Remote Config — mốc 01/11/2026

## Triển khai

- Firebase SDK chỉ ở services; ViewModel gọi TelemetryService/AppConfigService. `observability_providers.dart` quản lý dependency và state cấu hình. Việc gửi telemetry theo best effort, không làm thất bại thao tác đã lưu.
- SDK pin: firebase_analytics 13.0.1, firebase_crashlytics 6.0.1, firebase_remote_config 7.0.1; Android Crashlytics Gradle plugin 3.0.8.
- Analytics đã liên kết Google Analytics property sau khi người dùng hoàn thành Console. Không bật billing, quảng cáo hoặc Google Signals trong workflow này.
- Firebase UID được đặt làm user identifier khi đăng nhập/khôi phục phiên, xóa khi đăng xuất. Không log tên/email, raw search query hoặc nội dung ghi chú. Params được giới hạn theo whitelist; search debounce 600 ms chỉ gửi độ dài/có từ khóa hay không.

| Event | Trigger thật | Params |
| --- | --- | --- |
| login | Google Sign-In thành công | method=google |
| logout | Firebase sign-out thành công | không có |
| search | nhập tìm kiếm ổn định 600 ms | query_length, has_query, max_minutes |
| view_activity | mở chi tiết hoặc màn chuyên biệt | activity_id, group_id |
| schedule_created | save lịch mới được xác nhận | activity_id, group_id |
| schedule_updated | save từ form sửa được xác nhận | activity_id, group_id |
| activity_completed | check-in/checklist/timer được xác nhận | activity_id, group_id, source; timer có duration_seconds |
| completion_undone | delete completion thành công | activity_id |
| config_refreshed | fetch/activate cấu hình thành công | không có |

Các event save phản ánh hành động được xác nhận, không dùng event count để đếm duy nhất completion trong database.

## Crashlytics

- Hook FlutterError và PlatformDispatcher sau Firebase initialize; báo lỗi framework/async là fatal. Trường hợp lưu lịch, completion, session và fetch config thất bại được report non-fatal sau khi UI xử lý.
- Lỗi gửi đi được chuẩn hóa theo operation + loại/code lỗi, không gửi message exception gốc có thể chứa dữ liệu riêng. Stack trace vẫn được giữ để định vị code.
- Custom keys: app_name, platform; debug crash có test_crash=true. Test crash phải được bấm xác nhận ở Tài khoản → Kiểm thử Firebase; thao tác crash chỉ có trong debug build. Không đặt nút crash trong luồng thông thường.
- Gọi SDK hoặc thấy log local chưa chứng minh dashboard đã nhận báo cáo. Cần mở lại app sau crash và xác nhận fatal/non-fatal trên Console.

## Remote Config

| Key | Default | Hành vi |
| --- | --- | --- |
| discover_max_minutes | 60 | Giới hạn catalog Khám phá, kết hợp với filter người dùng; giá trị ngoài 5–60 fallback 60 |
| connection_checkin_enabled | true | Hiện/ẩn check-in nhanh trên chi tiết social; vẫn có thể chọn lịch và xem/hoàn tác trong Tiến độ |

Hai key này được chọn thay cho report_export_enabled vì export chưa triển khai ở mốc này; cả hai đã có hành vi thực để kiểm chứng. Không dùng Remote Config chứa credential hoặc quyền truy cập.

- Defaults local trước lần fetch đầu, đọc activated cache khi mở app; fetch timeout 10 giây. Nếu fetch lỗi, giữ cache/giá trị đã kích hoạt, báo lỗi tại màn debug.
- Debug fetch interval 0 để demo; release interval 1 giờ. Fetch ban đầu chạy nền; màn debug có nút Tải cấu hình mới để kiểm tra thay đổi không rebuild. Chưa bật real-time subscription.
- Template mặc định trong firebase/remote-config-defaults.json. Publishing dùng ETag của template hiện tại và giữ các parameter khác; không force overwrite.

## Xác minh tại mốc này

- flutter analyze đã phát hiện hai style issues, đã sửa.
- Toàn bộ 29 Flutter tests đạt; sáu test mới về config/filter/cache, tham số không hợp lệ, save lỗi không log success, search debounce/privacy, parameter whitelist. Một lượt đầu test mới timeout do thiếu subscription Riverpod; đã sửa fixture và chạy lại suite đạt.
- Analyze cuối không issue, APK debug build thành công và đã cài lên Xperia (29 tests đạt). Logs trong evidence/flutter/unit-widget-observability-tests.txt và observability-analyze.txt.
- Remote Config: server version 1 defaults 60/true → version 2 demo 5/false → version 3 trở về 60/true. Không rebuild giữa các lần. App thực tế ẩn check-in social nhưng giữ nút chọn lịch; Discover loại balance-review 10 phút, còn các hoạt động <=5 phút. Đã fetch lại defaults trong app. Evidence JSON/screenshot trong evidence/remote-config.
- Crashlytics: ca offline trên checklist space-desk tạo non-fatal completion_write/unavailable; UI giữ 3/3 và online retry thành công, sau đó hoàn tác bản ghi thử. Test crash native đã đóng process, mở lại app giữ auth và lịch 21:30. Reporting API đã xác nhận 2 issues: FATAL (test crash) và NON_FATAL (completion_write failed unavailable), mỗi loại 1 event. Bằng chứng server: evidence/firebase-observability/crashlytics-server.json; fatal.txt/nonfatal.txt/restarted.txt là log local đã lọc định danh.
- Event details API cho hai issue xác nhận có user identifier ở cả hai (chỉ xuất boolean), custom keys app_name/platform, và test_crash=true ở fatal. Breadcrumbs giữ activity_id/group_id/source đúng. Evidence: evidence/firebase-observability/crashlytics-event-metadata.json. API listEvents mobile cần issueId filter; request đầu không filter bị 400, request theo issue thành công.
- Analytics: người dùng cung cấp ảnh DebugView đúng project/app với config_refreshed, view_activity và activity_completed. Đây là xác nhận server đã nhận các sự kiện đó, khác với chỉ kiểm tra lời gọi SDK.
- Native FA-SVC Logcat trong hai lượt kiểm tra thấy config_refreshed/search và view_activity/schedule_created/schedule_updated/activity_completed/completion_undone. FA-SVC là service dùng chung nhiều app và tên package không nằm cùng dòng event; không dùng dữ liệu này để suy ra tất cả 7 loại đã được xác nhận riêng trên DebugView. File analytics-native-check.json là snapshot mới nhất, không cộng số dòng thành số event duy nhất (mỗi event có thể xuất hiện ở dòng xử lý và dòng lưu).
- Đã thực hiện luồng F01 tạo lịch đi bộ ngày 01/11 (chưa chọn giờ, nhắc tắt), F03 save từ form sửa giữ ID, Ăn uống check-in/undo và tìm kiếm empty/reset để sinh sự kiện thật. Các completion thử đã hoàn tác; giữ lịch đi bộ hôm nay để tiếp tục demo. Lịch/timer ngày 31/10 và lịch nghỉ tối 21:30 không đổi. Server evidence: evidence/flows/completion-observability-after.json và observability-schedules.json.
- Wi-Fi=1, mobile_data=1, stay_on_while_plugged_in=0 như trước test. Analytics debug được giữ bật tạm thời để người dùng xem DebugView; cần tắt bằng `adb shell setprop debug.firebase.analytics.app .none.` sau khi lấy đủ bằng chứng.
- Chưa kiểm tra login/logout trên thiết bị với SDK Analytics mới; cần bổ sung params screenshots/đủ event cho bộ nộp và test Analytics trong ARTEMIS. Chưa gọi đây là hoàn thành toàn bộ tiêu chí Firebase/Lab 3.

Nguồn triển khai: [Flutter Crashlytics](https://firebase.google.com/docs/crashlytics/flutter/get-started), [Android Gradle plugin](https://firebase.google.com/docs/crashlytics/android/get-started), [Flutter Remote Config](https://firebase.google.com/docs/remote-config/flutter/get-started), [Flutter Analytics](https://firebase.google.com/docs/analytics/flutter/get-started).
