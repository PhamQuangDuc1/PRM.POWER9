# Sửa sai lệch giữa Stitch và Figma

## Phát hiện và quyết định

Bộ UI native đã dựng bằng scripts/figma/03-screens.js đã giản lược bố cục và bỏ nhiều ảnh/nội dung so với các bản Stitch được nhóm chọn. Người dùng yêu cầu khôi phục đúng thiết kế Stitch. Không coi bộ dựng lại đó là bản Final UI đã được duyệt.

Không xóa công sức trong file khi chưa thay thế xong. Cần giữ bộ dựng lại ở khu riêng hoặc ẩn, dùng đúng nguồn HTML/PNG Stitch để dựng lại phần Final UI. Hệ token/component có thể tận dụng nhưng phải điều chỉnh phù hợp bố cục nguồn, không ép ảnh nguồn theo mẫu dựng lại.

## Nguồn chính xác

output/stitch-source/01-final-ui-8-man-goc.zip chứa đúng tám màn chính: S01 I01; S02/S03/S04 P00b; S05/S07/S08 I02 có dữ liệu/hợp lệ; S06 mới I03.

output/stitch-source/02-trang-thai-phu-goc.zip chứa S06 đã thêm và các trạng thái I02.

output/stitch-source/03-wireframe-8-man-goc.zip chứa S01–S04 W00, S05–S08 W01.

Mỗi ZIP có HTML/PNG nguồn không chỉnh sửa và manifest SHA256 để đối chiếu. Không dùng PNG làm toàn bộ UI giao nộp rồi gọi là editable.

## Phạm vi sửa

- Giữ ảnh nội dung, thứ bậc, thành phần, kiểu chữ và nhận diện từ nguồn Stitch.
- Chỉ sửa chi tiết có lý do theo đề/critique: viewport 360×800, vùng cuộn, chữ bị cắt, mã kỹ thuật lộ trên title, states mâu thuẫn và thông số accessibility thực đo.
- Không scale toàn bộ ảnh 390px xuống360 rồi tuyên bố target/font đạt.
- Đối chiếu từng màn với screen.png trước khi gọi bản Figma là đúng nguồn.
- Chưa có thay đổi khôi phục nào trên canvas trong bước đóng gói này vì MCP đang hết lượt Starter.

## Trạng thái

Nguồn đã chọn và đóng gói. Việc thay UI trong Figma vẫn còn phải thực hiện khi có kênh chỉnh sửa hoạt động. Không khẳng định phase 1 đã hoàn tất về độ trung thành với Stitch.
