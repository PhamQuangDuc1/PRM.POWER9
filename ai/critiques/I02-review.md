# I02 — Đánh giá trạng thái và phục hồi lỗi

## Nguồn

Ảnh gốc: assets/stitch/I02/I02-overview-user-provided.png, có manifest SHA256.
Prompt dự kiến: ai/prompts/I02-states-recovery.md; toàn văn thực gửi chưa xác minh từ ảnh.
Thu phóng 32%. Nhận diện từ trái sang phải theo nội dung: S08 có dữ liệu, S07 hợp lệ, S05 có kết quả, S05 rỗng, S07 đang lưu, S07 thiếu giờ, S07 lỗi kết nối, S08 rỗng.

## Đối chiếu mục tiêu

| Vấn đề trước | Quan sát sau | Kết luận tổng quan |
| --- | --- | --- |
| UX03: S05 vừa có kết quả vừa báo rỗng | Hai bố cục riêng, danh sách kết quả không kèm khối rỗng; bản rỗng có xóa bộ lọc | Đã cải thiện cách biểu diễn trạng thái |
| UX04: S07 hợp lệ nhưng trộn lỗi thiếu giờ/mạng | Có các bản riêng: giờ hợp lệ, đang lưu, thiếu giờ và mất kết nối | Đã tách trạng thái đúng hướng |
| UX08: S08 có bản ghi nhưng báo chưa có hoạt động | Bản có dữ liệu riêng; bản rỗng hiển thị 0 hoạt động và không có danh sách bản ghi đã hoàn thành | Đã loại mâu thuẫn chính trong ảnh |
| Phục hồi lỗi | Bản mất mạng nói giữ dữ liệu, có nút thử lại; bản rỗng có hành động tiếp | Có thiết kế phản hồi, chưa chứng minh tương tác chạy |

I02 được ghi nhận đã có đầu ra và review có đối chiếu I01/P00b → I02. Đây là vòng cải tiến khác mục tiêu I01; chưa đồng nghĩa prototype đã hoạt động.

## Điểm còn phải chỉnh khi hoàn thiện Figma

- **UX09:** khung S08 đang chọn hiển thị nhãn kích thước **390×884** trên canvas, không khớp base 360×800 yêu cầu của đề. Không suy ra tất cả khung có cùng kích thước; kiểm tra từng khung, dựng viewport 360×800 và cho cuộn nội dung thay vì thu nhỏ toàn bộ chữ/nút.
- S08 rỗng vẫn lộ mã “I01 S08” và tiêu đề bị cắt; đây là UX07 còn sót. Sửa lớp chữ khi dựng Figma, mã chỉ ở tên frame.
- Một số bản lỗi/đang lưu có nội dung phụ khác nhau; dùng chung cấu trúc biểu mẫu và cùng dữ liệu mẫu trong Figma để người dùng không thấy đổi ngữ cảnh ngoài lỗi cần xử lý.
- S05 lọc thời gian ở bản rỗng có thêm ví dụ khác; đồng bộ nhãn bộ lọc và hiểu rõ “5 phút” là chính xác hay tối đa. Ghi quy tắc trong đặc tả.
- Chưa đo font, target, màu/contrast; chưa kiểm tra thao tác Retry/Reset/Back/Save thực sự.
- Không cộng các biến thể vào số màn chức năng.

## Lựa chọn

Dùng S05 có kết quả, S07 hợp lệ, S08 có dữ liệu của I02 làm bản mặc định; giữ các trạng thái phụ cùng màn cha. Không chạy lại I02 chỉ để dọn tên khung.

Tiếp tục I03 chỉ xử lý UX05 ở S06: mới có hành động thêm, đã thêm có hành động đổi lịch. Sau I03 review kết quả và chuyển sang Figma.
