# Chấm Lab 3 trên Android thật

Dùng Power9 Office Routine trên điện thoại Android thật với APK debug và tài khoản kiểm thử. Dev dùng Firebase Console của project `power9-office-se180724`. Kịch bản này ghi các bước cần chạy trong buổi chấm. [Bằng chứng đã lưu](../evidence/) ghi kết quả của các lượt trước.

## Chuẩn bị

1. Cắm điện thoại qua USB, bật USB debugging và xác nhận thiết bị xuất hiện trong `adb devices`. Nếu có cả emulator, chọn đúng serial điện thoại khi build hoặc cài APK.
2. Mở bản debug của package `vn.power9.power9_office_routine`. Kiểm tra Google Sign-In trước bằng tài khoản test và đối chiếu SHA-1 của APK với Android app trên Firebase nếu không vào được Home.
3. Chuẩn bị một ngày kiểm thử, kết nối mạng và quyền thông báo. Mở sẵn Firestore, Cloud Messaging, DebugView, Crashlytics và Remote Config. Ghi ngày giờ, phiên bản APK và thiết bị cho mỗi bằng chứng mới.

## Trình tự demo 8–10 phút

1. **Đăng nhập và F01 · 0:00–1:45.** Google Sign-In, tìm hoạt động và thử từ khóa không có kết quả. Reset, chọn Đi bộ giữa giờ, bật tùy chọn nhắc rồi thử lưu thiếu giờ để thấy validation. Chọn giờ và lưu, đối chiếu lịch mới trên Home và Firestore.
2. **F02 và F03 · 1:45–3:30.** Bắt đầu timer, tạm dừng, tiếp tục, kết thúc sớm và ghi nhận số giây thực tế. Đổi giờ của lịch, hủy để xác minh giữ giờ cũ, rồi lưu giờ mới và xác minh tổng số lịch không tăng.
3. **PDF và upload · 3:30–4:30.** Mở Tiến độ ngày kiểm thử, tạo PDF, đối chiếu số hoạt động và thời lượng với màn hình. Nếu môi trường upload thật đã sẵn sàng, ghi tiến độ, link tải, kết quả truy cập đúng chủ và việc từ chối tài khoản khác. PDF lưu trên máy được ghi riêng.
4. **Crashlytics và FCM · 4:30–6:15.** Vào **Tài khoản → Kiểm thử Firebase → Gây crash**, xác nhận, quan sát app đóng rồi mở lại để SDK gửi crash. Trong lúc chờ, gửi một Test message từ Firebase Console đến điện thoại, quan sát notification và chạm để kiểm tra route/inbox. Quay lại Crashlytics, kiểm tra đúng sự kiện mới theo thời điểm, bản build và custom keys. Trình bày riêng sự kiện non-fatal từ luồng lỗi thực tế.
5. **Remote Config và Analytics · 6:15–7:45.** Giảm `discover_max_minutes` và tắt `connection_checkin_enabled`, fetch lại để thấy hành vi đổi mà không rebuild. Khôi phục giá trị sau demo. Mở một chi tiết hoạt động, đối chiếu `view_activity` và `activity_id` trong DebugView.
6. **ARTEMIS và review · 7:45–9:30.** Dùng một ca Flash đã chuẩn bị, cho thấy instruction, giá trị quan sát, assertion và trace. Giải thích R02 bằng hai refresh hoàn tất sai thứ tự và commit xử lý kết quả đến muộn. [Quyết định review](code-review.md)

## Nguyên lý để đưa lên slide

- **FCM.** Firebase Messaging SDK gọi `register()` và nhận định danh cài đặt Firebase (**FID**) qua `onRegistered`. Power9 giữ FID trong RAM dưới tên `_token`. Kho local lưu inbox, trạng thái bật và UID đã bind. Trong demo, Console hoặc một môi trường gửi có quyền gọi FCM HTTP v1 với FID đích. Foreground dùng `onMessage` và local notification. Tap từ background dùng `onMessageOpenedApp`, còn tap lúc cold start dùng `getInitialMessage()`. Notification từ Console với nội dung chung mở Home. Payload đích hợp lệ có thể mở Tiến độ. [Code nhận](../lib/services/firebase_notification_service.dart) · [Bằng chứng gửi và nhận](fcm-pdf-storage.md)
- **Crashlytics.** Nút debug gọi ViewModel → telemetry service → `FirebaseCrashlytics.instance.crash()`. Mở lại app sau crash để báo cáo được gửi. Non-fatal đi từ lỗi ghi dữ liệu qua `recordError` và app giữ đường thử lại. Đối chiếu thời điểm, loại sự kiện, custom key và trạng thái user identifier. [Code telemetry](../lib/services/firebase_telemetry_service.dart) · [Bằng chứng server](../evidence/firebase-observability/crashlytics-server.json)
- **Remote Config.** App đọc defaults/cache, fetch và activate giá trị mới qua service, ViewModel cập nhật hành vi. Hai ví dụ đã kiểm chứng là giới hạn thời lượng danh mục và bật/tắt check-in nhanh ở Kết nối. [Bằng chứng](../evidence/remote-config/)
- **PDF.** ViewModel lấy snapshot ngày đang xem, generator tạo PDF có font Việt, sau đó Android cho lưu/chia sẻ. Uploader hiện có dùng Firebase Storage theo UID và ghi metadata sau khi upload thành công. Nếu đổi sang Cloudinary hoặc S3, cần một nguồn cấp quyền upload đáng tin cậy, quyền tải theo chủ sở hữu và cùng bộ minh chứng tiến độ, link, lỗi và thử lại. [Thiết kế hiện tại](fcm-pdf-storage.md)

## Các mục cần đóng bằng kết quả mới

- Bản chạy thông thường vẫn tắt upload cloud. Có luồng Cloudinary cho bản debug qua ADB reverse. Chạy với môi trường test thực và ghi minh chứng trước khi tính đạt `TC13` hoặc event `export_report`. [Cách chạy Cloudinary](../firebase/report-upload/README.md)
- DebugView đã có bằng chứng server cho `view_activity(activity_id=move-walk)`. Thu thêm DebugView theo từng event trong [kế hoạch Analytics](analytics-plan.md).
- ARTEMIS hiện xác minh 32/33 lượt. `TC10[3]` còn thiếu, Pro 189 giây chưa đạt 15–30 phút, ngân sách lượt chạy đã chạm trần ghi trong hồ sơ. [Tổng hợp](../evidence/artemis/lab3-summary.json)
- Đóng gói slide PDF, báo cáo PDF và link video từ bản đã kiểm chứng. Dùng [PR #4](https://github.com/PhamQuangDuc1/PRM.POWER9/pull/4) cho mốc merge, [PR #3](https://github.com/PhamQuangDuc1/PRM.POWER9/pull/3) cho lịch sử review.
