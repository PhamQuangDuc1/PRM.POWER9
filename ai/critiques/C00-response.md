# C00 — Bản đánh giá UX của ảnh tổng quan V00

Bản tiếng Việt của báo cáo; bản nguồn tiếng Anh giữ nguyên tại C00-response-original.md. Đây là cùng một lần đánh giá, không phải hai lần chạy AI.

## Phạm vi và phương pháp

Codex xem ảnh thực tế assets/stitch/V00/V00-overview-user-provided.png theo tiêu chí lưu tại C00-review-criteria.md, bốn persona giả định và bộ màn Lab 2. Đây là báo cáo đánh giá trực tiếp, không phải bản chép cuộc hội thoại từ dịch vụ AI khác.

Nhìn thấy: một bảng phong cách và bốn màn. Sau bảng, từ trái sang phải: S05 khám phá, S01 hôm nay, S07 lịch, S06 chi tiết. Mã được suy ra theo nội dung vì nhãn canvas đang là “Generating Screen...”. Ảnh ở mức thu phóng 37%; chỉ trích chữ đọc được.

Chưa nhìn thấy: S02/S03/S04/S08, prompt đã gửi đầy đủ, điều hướng hoạt động, cấu trúc lớp/biến Figma, cỡ chữ sp và vùng chạm dp. Phản hồi bên trái đề xuất tạo bốn màn tiếp theo. Chưa có bằng chứng đủ tám màn.

## Điểm tích cực quan sát được

- Thẻ có thời lượng, gồm ví dụ 5 phút phù hợp Linh.
- Home có nút hoàn thành có nhãn, một ví dụ đã làm và hoàn tác.
- Khám phá có bộ lọc thời gian, tìm kiếm và nút xóa bộ lọc.
- Biểu mẫu có Lưu/Hủy; ví dụ lỗi nhắc đến giữ dữ liệu nhập.
- Điều hướng Home có biểu tượng và chữ, phù hợp hướng thiết kế cho chú Hùng; kích thước vẫn cần đo.

## Các vấn đề

| Mã | Màn và bằng chứng | Tác động / mức độ | Nguyên tắc Nielsen / persona | Đề xuất | Kiểm chứng |
| --- | --- | --- | --- | --- | --- |
| UX01 | S01 ghi “Hom Nay”; các thanh khác ghi “Chi Tiet Thoi Quen”, trong khi nội dung có dấu | Trung bình: ngôn ngữ không nhất quán, khó đọc hơn với Hùng | Phù hợp ngôn ngữ đời thực; Nhất quán và tiêu chuẩn; P04 | Dùng tiếng Việt có dấu cho toàn bộ tiêu đề, nút, điều hướng, nhãn; chọn phông hỗ trợ tiếng Việt | Ảnh rõ bốn tiêu đề và điều hướng; kiểm tra lớp chữ sửa được |
| UX02 | S05 danh sách khám phá và S07 biểu mẫu lịch dùng cùng tên chi tiết như S06 | Cao: khó nhận ra đang tìm, xem hay đặt lịch | Hiển thị trạng thái hệ thống; Nhận biết thay vì ghi nhớ; P03/P02/P04 | S05 “Khám phá thói quen”, S07 “Lịch thói quen”, chỉ S06 dùng “Chi tiết thói quen” | So ảnh trước/sau cùng màn, tiêu đề phân biệt và Quay lại nhất quán |
| UX03 | S05 có ba thẻ nhưng bên dưới lại có bảng không có kết quả | Cao: phản hồi mâu thuẫn, Linh không biết bộ lọc có tìm được hoạt động hay không | Nhất quán và tiêu chuẩn; Thiết kế tối giản; P03 | Tách có dữ liệu và rỗng; rỗng có giải thích và một nút xóa bộ lọc | Màn có kết quả không có thông báo rỗng; biến thể rỗng không có thẻ kết quả |
| UX04 | S07 hiện giờ đã chọn, cảnh báo thiếu giờ và lỗi kết nối/lưu cùng lúc | Cao: không rõ sai dữ liệu hay mất kết nối, Huy dễ sửa lại không cần thiết | Phòng ngừa lỗi; Giúp nhận biết, chẩn đoán và phục hồi lỗi; P02/P03 | Tách mặc định/sửa, thiếu giờ, đang lưu và lưu lỗi. Chỉ lỗi thiếu giờ khi nhắc đang bật mà thực sự chưa có giờ | Ảnh rõ từng trạng thái; thử lại giữ dữ liệu; chỉ thành công mới cập nhật Home |
| UX05 | S06 có dấu hiệu đã thêm nhưng vẫn có nút thêm hôm nay nổi bật và thao tác sửa bên dưới | Cao: lẫn ngữ cảnh mới/đã thêm, có thể hiểu là được thêm trùng | Phòng ngừa lỗi; Nhất quán và tiêu chuẩn; P02/P03 | S06 mới có CTA thêm và không nhãn đã thêm; S06 đã thêm có lịch hiện tại và CTA “Đổi lịch”, không bật nút thêm | So hai biến thể, mỗi bản có một hành động chính đúng ngữ cảnh; kiểm tra đường đi prototype |
| UX06 | Nút trên thẻ S05 ghép ý xem chi tiết và thêm, giống “Xem chi tiết & Thêm” | Trung bình: không đoán được chạm sẽ mở chi tiết hay thêm ngay | Phù hợp ngôn ngữ đời thực; Quyền kiểm soát và tự do; P03/P04 | Dùng “Xem chi tiết” để đi S06; thao tác thêm là hành động riêng trên S06/S07 | Nhãn khớp màn đích; không thêm ngầm; đối chiếu trước/sau |

UX01–UX06 có căn cứ từ ảnh tổng quan. Chữ nhỏ và tương tác cần ảnh rõ hoặc thử prototype. Mức độ là nhận định thiết kế, chưa phải tác động được đo qua thử người dùng.

## Phần màn hình còn thiếu

Ảnh chứng minh bốn màn khác nhau; bảng phong cách và biến thể không tăng số màn. Cần bổ sung S02/S03/S04/S08 theo hệ thống đã chốt. Đây là hoàn thiện độ bao phủ, không tự tính là ba vòng cải tiến.

## Ba mục tiêu cải tiến khác nhau

1. **I01 — Ngôn ngữ và nhận biết tác vụ:** sửa UX01/UX02/UX06. Kèm yêu cầu xanh biển của nhóm, nhưng đổi màu riêng không đủ là vòng UX.
2. **I02 — Trạng thái nhất quán và phục hồi:** sửa UX03/UX04, tách có dữ liệu/rỗng/thiếu dữ liệu/đang tải/lỗi và nút thử lại.
3. **I03 — Hành động chính đúng ngữ cảnh:** sửa UX05, phân biệt thêm mới/đã thêm và đường thêm/sửa an toàn.

Đánh giá lại ảnh sau từng vòng; chưa đánh dấu I01–I03 hoàn tất.

## Accessibility và cấu trúc cần kiểm tra

- Không đo được sp/dp từ ảnh canvas 37%.
- Chưa kết luận tương phản từ token dự kiến; cần đo màu và độ trong suốt thực.
- Chưa chứng minh Auto Layout, liên kết token, instance hoặc responsive.
- Chưa chứng minh Quay lại, Lưu, Hoàn tác, Thử lại, overlay và loading hoạt động.
- Chưa kết luận đạt mục tiêu dưới 60 giây, dưới 30 giây hoặc tối đa 3 thao tác.

## Trạng thái quyết định

Nhóm yêu cầu hướng xanh biển. Sửa dấu tiếng Việt và tên màn khớp đặc tả hiện có. Quyết định và phần chờ kiểm tra nằm trong design/design-decisions.md. Báo cáo không suy ra đã hoàn thành iteration hoặc thử nghiệm người dùng.
