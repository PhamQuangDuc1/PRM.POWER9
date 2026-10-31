# Lab 3 — mốc khởi tạo 31/10/2026

## Đã kiểm chứng

- Dựng Flutter Android trong repo Lab 2, giữ nguyên tài liệu thiết kế. Tên app/title **Power9 Office Routine**; icon adaptive có nền trắng và logo gốc.
- Tạo Firebase project mới `power9-office-se180724`, đăng ký Android app, SHA-1 debug và lấy OAuth config sau khi người dùng bật Google provider. Chưa bật billing.
- Mã theo cấu trúc models/screens/viewmodels/services/theme/widgets. SDK Firebase/Google được gọi ở services; app bootstrap/auth gate đọc state qua Riverpod.
- `flutter analyze lib test`: không có issue ở lượt kiểm tra cuối.
- `flutter test --no-pub`: 11 test đạt, gồm signed-out/private route gate, chống request lặp/retry, dispose, layout Login 360/412 dp text scale 1.5, lọc hoạt động, giữ draft/validation và chuyển ngày. Đây là unit/widget tests, không thay ARTEMIS.
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

F02/timer/completions/tiến độ, các màn phụ theo đủ thiết kế Lab 2, PDF/Storage, FCM, Analytics, Crashlytics, Remote Config, ARTEMIS, PR review và bộ nộp. Các tab Ăn uống/Thư giãn/Kết nối hiện mới là danh sách hoạt động, chưa coi là màn Lab 2 hoàn chỉnh. Profile chưa có khu demo sáu dịch vụ. Figma Login/Profile và fidelity chưa đồng bộ/kiểm tra đầy đủ. Nhắc theo giờ hiện chỉ lưu cấu hình, chưa phát notification. Không có lịch sử hoàn thành giả hoặc nút bỏ qua xác thực.

Mã Lab 3 và tài liệu mới chưa được commit/push trong mốc này. Các thay đổi `.build` của Lab 2 vẫn giữ nguyên ngoài phạm vi.
