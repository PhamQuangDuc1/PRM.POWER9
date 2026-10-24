# P00b — Đánh giá bốn màn UI bổ sung

## Bằng chứng

Ảnh gốc: assets/stitch/P00b/P00b-overview-user-provided.png, nhóm cung cấp, có manifest SHA256.
Prompt dự kiến: ai/prompts/P00b-stitch-remaining.md. Chưa xác minh nguyên văn thực gửi đầy đủ từ ảnh.
Thu phóng 44%. Nhận diện trái sang phải: S02 Ăn uống, S03 Thư giãn, S08 Lịch sử và tiến độ, S04 Kết nối.

Bốn màn dùng hướng xanh biển tương thích I01. Ghép I01 S01/S05/S06/S07 với P00b S02/S03/S04/S08 cho đủ tám chức năng UI có ảnh. Đây là hoàn thiện độ bao phủ, không tính thêm một vòng cải tiến UX.

## Kết quả

- S02 có hoạt động ăn uống, hướng dẫn ngắn, ghi nhận hoàn thành và lối lịch sử.
- S03 có bộ đếm 05:00, nút bắt đầu, hướng dẫn và lối lịch sử. Chưa chứng minh hoạt động khi bắt đầu/tạm dừng/kết thúc.
- S04 có chọn hoạt động kết nối, số phút, nút ghi nhận và lối lịch sử.
- S08 có tổng tuần và các bản ghi; đồng thời hiển thị thông báo chưa có hoạt động.

## Vấn đề bổ sung

| Mã | Quan sát | Tác động / nguyên tắc | Xử lý |
| --- | --- | --- | --- |
| UX07 | Các thanh tiêu đề có mã như “I01 S02”, “I01 S03”, “I01 S04”, “I01 S08”; tên lịch sử bị cắt | Lộ mã nội bộ, tên chức năng khó đọc; nhất quán và thiết kế tối giản | Giữ mã ở tên khung, UI chỉ hiện tên màn tiếng Việt. S08 sửa trong I02; S02/S03/S04 chỉnh chữ khi ráp Figma, không cần tạo lại ba màn |
| UX08 | S08 hiện ba bản ghi và một khối “Chưa có hoạt động nào được ghi nhận” bên dưới | Trạng thái mâu thuẫn giống UX03 ở S05; hiển thị trạng thái hệ thống và nhất quán | I02 tách S08 có dữ liệu và S08 rỗng; cả tổng tuần cũng phải khớp trạng thái |

Không có ảnh riêng của xác nhận xóa hoặc trạng thái phiên thở đang chạy trong ảnh mới; không khẳng định chúng chắc chắn không tồn tại ngoài ảnh.

## Quyết định và bước tiếp

Dùng bốn bố cục mới làm nguồn S02/S03/S04/S08. Không yêu cầu chạy lại P00b. Tiếp tục I02 tập trung vào UX03/UX04/UX08: trạng thái có dữ liệu/rỗng, hợp lệ/lỗi/đang lưu. Sau đó I03 về ngữ cảnh thêm/sửa của S06.

Vẫn cần đo font/vùng chạm/contrast, khung cơ sở, rộng 412 và dựng tokens/components/prototype trong Figma. Đủ tám bố cục không đồng nghĩa đã hoàn thành bài.
