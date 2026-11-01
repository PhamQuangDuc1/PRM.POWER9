# Rà soát nguồn dữ liệu trước khi nâng cấp UI/UX

Ngày 01/11/2026. Phạm vi: đọc đường chạy trong lib/, catalog, script seed và test; đối chiếu bằng chứng thiết bị đã thu. Không thực hiện truy vấn lại toàn bộ production, không xóa dữ liệu hoặc thay đổi hành vi app trong lần rà soát này.

## Kết luận

Không tìm thấy mock service, fixture hay fallback danh sách mẫu được nối vào entry point ứng dụng. main.dart dùng ProviderScope thực; providers nối Firebase Auth, Firestore, FCM, Remote Config, Analytics/Crashlytics và bộ tạo PDF thật. Fake/stub và provider overrides dữ liệu nằm trong test/. Override ở ScheduleScreen chỉ khởi tạo draft từ lịch đang sửa, không thay backend bằng fake.

| Phần | Nguồn và giới hạn |
| --- | --- |
| Tài khoản | Firebase Auth/Google. Nhãn Tài khoản Google khi thiếu displayName là fallback chữ, không phải tài khoản giả. |
| Danh mục hoạt động | Đọc activities published=true từ Firestore. firebase/catalog.json chứa 10 nội dung biên soạn sẵn; seed-catalog.cjs đưa lên cloud, không được app dùng làm fallback offline. Đây là nội dung sản phẩm, không phải hành vi người dùng hay kết quả AI cá nhân hóa. |
| Lịch | users/{uid}/schedules, transaction Firestore, giờ/ngày do người dùng chọn. |
| Tiến độ | Ghép schedules và completions theo ngày, đếm thực tế; không có chuỗi ngày/điểm sức khỏe/biểu đồ giả. Ghi nhận tự khai không chứng minh vận động bằng cảm biến. |
| Timer | Đếm bằng đồng hồ monotonic và lưu durationSeconds đo được. Số phút trong catalog là mục tiêu, không phải thời gian đã thực hiện. Phiên chưa ghi nhận chỉ ở RAM. |
| Checklist | Các dấu tick đang làm ở RAM; khi ghi nhận lưu một completion, không lưu lịch sử từng bước. Không phục hồi draft sau khi process tắt. |
| Thông báo | FCM thật; hộp thư lưu trên máy bằng SharedPreferences, tối đa 100 tin theo tài khoản. Không đồng bộ inbox/đã đọc giữa điện thoại. Các tin Console/Test đang có là thông báo kiểm thử được gửi thật. |
| PDF | Sinh từ snapshot lịch/ghi nhận ngày đang xem, font/logo nội bộ. Các file fixture bố cục trong evidence/test không được nạp làm báo cáo người dùng. |
| Storage | Uploader có code nhưng chưa kiểm thử production; report_upload_enabled=false do giữ Spark. UI khóa upload, không trả link thành công giả. |
| Cấu hình | Remote Config thật, có default an toàn khi chưa fetch/lỗi; default không phải dữ liệu hoạt động giả. |

## Vấn đề cần xử lý khi nâng cấp

1. Ưu tiên cao: ScheduleScreen vẫn cho bật Nhắc hoạt động và ghi Giờ yên lặng 18:00–08:00; ScheduleViewModel/FirestoreScheduleService chỉ lưu reminderEnabled. Không tìm thấy scheduler hoặc logic thực thi giờ yên lặng. FCM gửi thử không tự biến thành nhắc theo lịch. NotificationScreen có nói rõ giới hạn nhưng màn đặt lịch chưa rõ. Cần triển khai nhắc giờ thực hoặc khóa/đổi mô tả ngay tại màn đặt lịch trước khi quảng bá tính năng.
2. Route/chọn nội dung phụ thuộc ID: FoodScreen cố định eat-lunch, RelaxScreen cố định stress-break; ActivityDetailScreen rẽ nhánh space-desk/posture-check/sleep-prepare. Không phải mock, nhưng thêm hoạt động mới trên cloud chưa đủ để tự có kiểu màn tương ứng. Nên bổ sung loại tương tác vào model/catalog khi mở rộng, kèm migration và Rules.
3. Nội dung số phút và hướng dẫn hiện là nội dung biên soạn sẵn, chưa có hệ thống cá nhân hóa. Khi thiết kế UI, không gắn nhãn đề xuất AI, số bước, calo hoặc giấc ngủ đo được nếu chưa có nguồn dữ liệu đó.
4. Draft checklist/timer/PDF chưa lưu bền qua process death. Inbox chỉ local. Cần quyết định rõ khôi phục phiên và đồng bộ nhiều máy trước khi thiết kế trải nghiệm tương ứng.
5. Phiên phát triển có lịch/ghi nhận do kiểm thử thao tác thật và thông báo Test/Console. Chúng không phải mock runtime nhưng không nên dùng làm minh chứng hiệu quả sức khỏe hoặc lịch sử sử dụng tự nhiên. Không tự động xóa vì có thể là bằng chứng Lab 3.
6. FirebaseDemoScreen/crash action là công cụ debug, chỉ mở trong kDebugMode; tách khỏi trải nghiệm người dùng khi thiết kế release.

## Cơ sở nâng cấp giao diện

Có thể thay bố cục, typography, thành phần và điều hướng mà giữ các contract service/viewmodel. Theme/tokens ở lib/theme/p9_theme.dart và widget dùng chung ở lib/widgets/. Giữ loading/error/empty, kiểm soát phiên timer, phân quyền theo tài khoản và trạng thái thành công sau khi backend xác nhận. Nếu thêm biểu đồ, tính từ completions thật và hiển thị ngày thiếu dữ liệu đúng nghĩa; không chèn số đẹp để lấp khoảng trống. Cập nhật Figma và design traceability cùng thay đổi UI cho bài nộp.

Không chạy lại test suite vì lần này chỉ rà soát và thêm tài liệu, không sửa code runtime.
