# Video Power9 bản Spark — 6 phút 35 giây

Đã dựng ngày 04/11/2026. File chính: [Power9_Lab3_Demo_Final.mp4](../output/lab3/Power9_Lab3_Demo_Final.mp4), kèm [SRT](../output/lab3/Power9_Lab3_Demo_Final.srt). Giọng Hoài My neural do người dùng chọn, không dùng micro. Đây là timeline thực của bản đã xuất, thay kịch bản dự kiến 8–9 phút trước đó.

## Timeline

| Mốc | Nội dung |
| --- | --- |
| 00:00 | Login, lược bỏ bộ chọn Google, Home thật |
| 00:34 | Khám phá, tìm rỗng, validation, tạo lịch |
| 01:14 | Hủy sửa giữ nguyên; lưu giờ 11:00 |
| 01:57 | Check-in và hoàn tác |
| 02:29 | Timer, Ở lại, ghi 19 giây thực |
| 03:16 | Xóa lịch, giữ completion |
| 03:52 | PDF local và Android print preview |
| 04:29 | Firestore activities/move-walk |
| 04:43 | DebugView chưa nhận event |
| 05:01 | Crashlytics, issue lịch sử |
| 05:15 | Remote Config, upload=false |
| 05:29 | Messaging, chiến dịch lịch sử |
| 05:47 | Kết quả và giới hạn |
| 06:35 | Kết thúc |

## Phạm vi bằng chứng

App và Console ghi thật, giữ tốc độ thực; có cắt nối. Bộ chọn Google không ghi hình, người dùng tự chọn lại A và đã đối chiếu cục bộ trước khi quay Home. Không ghi email/UID/token vào video. Tên người xuất bản Remote Config được che; Chrome tab/profile/address và avatar Firebase đã cắt.

DebugView buổi quay có Debug Device=0, chưa nhận event. Crashlytics và FCM hiển thị bằng chứng lịch sử, không coi là crash/gửi mới. Upload production tắt theo Spark; PDF local không thay tiêu chí upload. TC10[3] và Pro còn thiếu; TalkBack sau Ở lại xác nhận riêng, các luồng khác chưa kiểm tra hết.

Đã dọn đúng hai completion do buổi quay tạo, lịch demo đã xóa trong luồng; server xác nhận bốn document thử đều không còn. Khôi phục debug, dừng UIAutomator, về Home A. Không bật billing, publish cấu hình, gửi FCM mới hoặc dùng thêm ARTEMIS.

## Lời đọc đã dùng

Lời đọc dưới đây khớp các file đã tạo trong `output/lab3/video-20261104/narration/`. Trong cảnh Console, các câu được tách theo trang để ghép đúng hình.

### Giới thiệu và tài khoản

Đây là Power Nine Office Routine, ứng dụng hỗ trợ những hoạt động ngắn trong ngày làm việc. Bản demo sử dụng Flutter, kiến trúc M V V M và Firebase. Người dùng đăng nhập bằng Google để lưu lịch và xem tiến độ riêng. Máy hiện đã đăng nhập vào tài khoản kiểm thử. Tôi bắt đầu tại màn Hôm nay với dữ liệu thật của ngày đang chọn. Các thao tác tiếp theo được ghi trực tiếp trên điện thoại Xperia.

### Khám phá, validation và tạo lịch

Từ màn Hôm nay, tôi mở danh mục hoạt động. Tìm kiếm một nội dung không khớp sẽ hiển thị trạng thái rỗng, thay vì tạo dữ liệu giả. Sau khi xóa tìm kiếm, tôi chọn hoạt động Đi bộ giữa giờ rồi mở form lịch. Khi bật nhắc mà chưa chọn giờ, form báo lỗi và giữ lại thông tin để sửa. Tôi tắt nhắc rồi lưu lịch. Sau khi lưu thành công, hoạt động xuất hiện ở đúng ngày trên màn Hôm nay. Một hoạt động có tối đa một lịch trong một ngày. Giờ nhắc hiện chỉ được lưu vào lịch, ứng dụng chưa tự phát thông báo theo giờ này.

### Hủy và lưu sửa lịch

Tôi mở lịch vừa tạo để kiểm tra hai nhánh sửa. Ở nhánh đầu, tôi thay đổi giờ trên form rồi chọn hủy. Khi trở lại, lịch vẫn giữ giờ cũ. Ở nhánh sau, tôi chọn giờ mới và lưu. Màn Hôm nay hiển thị giờ đã cập nhật, trong khi tổng số lịch vẫn không tăng. Đây là sửa lịch hiện có, không phải tạo thêm một lịch. Lượt thao tác trực tiếp trong video được ghi riêng với kiểm thử Artemis; nó không thay cho run kiểm thử còn thiếu.

### Check-in và hoàn tác

Lịch là hoạt động đã chọn, còn bản ghi hoàn thành là việc đã thực hiện. Tôi chọn Đã thực hiện trên lịch của lượt demo. Tiến độ tăng sau khi thao tác thành công. Sau đó, tôi hoàn tác đúng bản ghi vừa tạo và kiểm tra lịch vẫn còn. Với check in, ứng dụng không đo thời gian nên thời lượng được để trống, không lấy số phút gợi ý trong danh mục làm thời gian thực tế.

### Timer và dialog ở lại

Tại màn Thư giãn, tôi bắt đầu một phiên mới. Timer đếm theo thời gian thực. Khi tạm dừng, thời gian chờ không được cộng vào phiên. Nếu chọn tab Hôm nay, dialog hỏi trước khi rời phiên. Tôi chọn Ở lại để giữ trạng thái tạm dừng, rồi tiếp tục và kết thúc sớm. Sau khi ghi nhận, màn tiến độ hiển thị thời lượng thực đã thực hiện. Nhánh TalkBack sau Ở lại đã được người dùng nghe tên tab, vuốt tới và kích hoạt thành công. Điều này chỉ xác nhận nhánh đã kiểm tra, chưa đại diện cho toàn bộ trải nghiệm TalkBack của ứng dụng.

### Xóa lịch, giữ lịch sử

Tôi ghi nhận lại hoạt động đi bộ của lượt demo, rồi mở thao tác xóa lịch. Dialog có lựa chọn Giữ lịch để tránh xóa nhầm. Khi chọn giữ, lịch không thay đổi. Sau khi xác nhận xóa, lịch được bỏ khỏi Hôm nay nhưng bản ghi đã thực hiện vẫn còn trong tiến độ. Hai loại dữ liệu được lưu riêng vì có mục đích khác nhau. Sau video, chỉ các bản ghi do lượt quay này tạo mới được dọn; dữ liệu có trước được giữ nguyên.

### Báo cáo PDF và giới hạn Storage

Từ tiến độ của đúng ngày, tôi mở báo cáo và tạo P D F. Báo cáo là ảnh chụp dữ liệu tại thời điểm tạo, gồm hoạt động và thời lượng đã ghi nhận. Khi dữ liệu thay đổi, cần tạo lại báo cáo. Tôi mở bản xem trước thật của Android để kiểm tra nội dung. Dự án chủ động giữ gói Spark để tránh phát sinh phí, nên Cloud Storage production chưa được kích hoạt và nút tải lên đang tắt. Tệp P D F trên điện thoại không được dùng để khẳng định đã tải lên Firebase thành công.

### Firebase Console

Phần này chuyển sang Firebase Console của dự án thật. Firestore lưu danh mục hoạt động, lịch và lịch sử theo tài khoản. Với Analytics, thao tác trong app tạo sự kiện và các tham số đã cho phép; việc đối chiếu cần đúng sự kiện và đúng thời điểm. Log trên thiết bị và dữ liệu server được phân biệt rõ. Crashlytics lưu các lỗi đã kiểm thử ở những lượt trước; các bằng chứng lịch sử cần giữ đúng ngày của chúng. Remote Config có các tham số để thay đổi hành vi mà không cần xây dựng lại ứng dụng. Tải báo cáo lên đám mây vẫn được tắt. F C M là luồng thông báo riêng và có bằng chứng nhận ở các trạng thái ứng dụng khác nhau. Chỉ trình bày một lượt gửi là hiện tại nếu thực sự gửi và nhận trong lúc quay. Không đưa mã thiết bị hoặc mã truy cập vào video.

### Kết quả và giới hạn

Bản giao diện mới có tám ảnh minh họa, bốn mươi chín kiểm thử Flutter đạt và không có lỗi phân tích mã. Mười lăm màn hình đã được kiểm tra ở hai chiều rộng với cỡ chữ lớn. Lượt đổi hai tài khoản A sang B rồi về A đã đối chiếu lịch, lịch sử và hộp thư. Artemis hiện xác minh ba mươi hai trên ba mươi ba run I D. T C mười lượt ba chưa đạt; phiên Pro trước kết thúc sớm nên chưa đủ thời lượng. TalkBack sau Ở lại đã có xác nhận trực tiếp, các luồng khác còn cần kiểm tra. Dự án giữ gói miễn phí, chưa kích hoạt Storage production. Những giới hạn này được ghi trong hồ sơ nộp bài, không trình bày là hoàn thành toàn bộ tiêu chí.
