# OI01 — typography toàn bộ UI

Người dùng xác nhận ngày27/10/2026 đã gửi nguyên văn100% prompt Office do trợ lý cung cấp trên dự án Stitch mới. Khối prompt bên dưới được giữ nguyên.

```text
Thực hiện vòng cải tiến OI01 cho toàn bộ 10 màn UI Power9 Office Routine vừa tạo. Chỉ xử lý TYPOGRAPHY VÀ TÍNH NHẤT QUÁN CỦA CHỮ. Giữ UI01 làm BEFORE để đối chiếu, không xóa wireframe. Đặt bộ sửa tên OFFICE-OI01-S01 đến S10 ngoài canvas, không chèn mã vào giao diện.

VẤN ĐỀ CÓ BẰNG CHỨNG
Chữ đang hiển thị giống font serif trên các màn, trong khi bảng phong cách ghi Be Vietnam Pro. Chỉ đổi tên font trên style board không thay được text thực tế. Chúng tôi cần UI sans-serif dễ đọc, hỗ trợ tiếng Việt cho cả 3 persona chính Huy/Mai/Linh.

YÊU CẦU SỬA
1. Áp dụng Be Vietnam Pro THỰC TẾ cho toàn bộ text của 10 màn: tên app, app bar, heading, body, button, label, input, chip, navigation, chữ phụ. Nếu không tải được dùng Roboto, sau đó sans-serif. Không Times New Roman, Georgia hoặc font serif. Không chỉ cập nhật style board.
2. Nếu xuất HTML/CSS: bảo đảm font được import và font-family được áp cho body, headings, button, input, select, textarea, các component con. Bỏ khai báo serif ghi đè. Icon giữ font icon riêng, không đổi thành chữ hoặc ô vuông.
3. Chuẩn hóa thang chữ: app bar/heading mục20/28, tên hoạt động nổi bật24/32 khi hợp lý, body16/24, button16, label/trợ giúp/navigation tối thiểu14/20. Timer32, dùng chữ số rõ. Không thu nhỏ riêng từng màn để ép vừa.
4. Nhãn dài xuống dòng và container tăng chiều cao; nội dung được cuộn. Không tạo overlap/cắt dấu tiếng Việt khi đổi font.
5. Tên app đúng Power9 Office Routine. Tiêu đề chức năng viết đầu câu: Hôm nay, Ăn uống, Thư giãn, Kết nối, Khám phá, Chi tiết thói quen, Lịch thói quen, Tiến độ, Góc làm việc, Ngủ & phục hồi. Không viết hoa mọi từ trong title.

GIỮ NGUYÊN Ở VÒNG NÀY
Giữ palette xanh/trắng, logo gốc, thứ tự nội dung, các task, ảnh và trạng thái hiện tại. Chưa thêm/bỏ banner hoặc viết lại nội dung; vấn đề mật độ sẽ sửa ở vòng sau. Không đổi cấu trúc điều hướng hoặc thêm chức năng. Chỉ cho phép reflow/khoảng cách cần để chữ không bị cắt sau đổi font.

KIỂM TRA
Kiểm tra font thực dùng trên các text layer hoặc computed CSS nếu có, không chỉ nhìn style board. Bảo đảm tất cả text sans-serif và tiếng Việt đúng dấu; icon vẫn đúng. Kiểm tra lại ở rộng360 và412, target không bị co nhỏ, không overlap. Không tự tuyên bố đã đo nếu không kiểm tra được.

Đầu ra đúng 10 màn UI đã sửa chữ, giữ BEFORE và dừng để tôi chụp đối chiếu cả bộ. Không tạo state hoặc màn mới.
```
