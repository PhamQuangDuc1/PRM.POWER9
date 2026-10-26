# Sửa chung bộ 10 màn — skeleton low-fi

Người dùng xác nhận ngày27/10/2026 đã gửi nguyên văn100% prompt Office do trợ lý cung cấp trên dự án Stitch mới. Khối prompt bên dưới được giữ nguyên.

```text
Sửa toàn bộ bộ 10 màn OFFICE-BASE vừa tạo trong 1 lượt. Giữ BASE làm before; tạo bộ after tên OFFICE-STRUCTURE-S01 đến S10. Không tạo thêm chức năng hoặc phiên bản ngoài 10 frame này.

Mục tiêu là WIREFRAME SƠ ĐỒ CẤU TRÚC: hộp, đường nét, nhãn ngắn. Bộ vừa tạo còn ảnh và chi tiết UI quá nhiều. Đổi sang grayscale đơn thuần chưa đủ; cần giảm độ chi tiết.

ÁP DỤNG CHUNG
- Frame mobile gốc 360×800, không wrapper desktop có vùng trắng 2 bên. Xếp 2 hàng, mỗi hàng 5 màn.
- Nền trắng, nét xám/đen, font sans-serif thông thường, không màu, bóng hoặc bo góc trang trí.
- Bỏ ảnh món ăn, hình minh họa góc làm việc, avatar, chuông, menu và icon trang trí. Không tạo bảng style.
- Không thêm khối mới để lấp khoảng trắng.
- Chữ thật chỉ giữ: tiêu đề chức năng, tên hoạt động ngắn, nhãn trường, giờ/số liệu cần cho task, CTA và navigation. Nội dung hướng dẫn dài thay bằng 2–3 thanh xám hoặc hộp ghi Hướng dẫn. Không thay nhãn điều hướng/nút bằng placeholder.
- Lề 16, body khoảng 16, label ≥14; vùng chạm ≥48×48. Nội dung cuộn khi cần, không thu nhỏ chữ để ép vừa.
- Số lượng/thứ tự/thời lượng dùng chữ số.

KHUNG CẦN GIỮ TỪNG MÀN
S01 Hôm nay: ô logo nhỏ + tên app; tiến độ 1/3; 3 hàng checkbox/tên/giờ; Khám phá/Tiến độ; 4 tab.
S02 Ăn uống: tên Ăn trưa có chú ý; 1 khối Hướng dẫn 3 bước bằng placeholder; nút Đã thực hiện; Xem tiến độ; 4 tab. Bỏ ảnh và phần Nghỉ trưa 20 phút thêm ngoài brief.
S03 Thư giãn: tên Nghỉ sau cuộc họp; 1 dòng hướng dẫn placeholder; timer chữ 03:00; nút Bắt đầu; 4 tab. Không khung minh họa hoặc khung lưu ý phụ.
S04 Kết nối: 2 hàng Rủ đồng nghiệp đi bộ và Trò chuyện trong giờ nghỉ, mỗi hàng 5 phút + dấu đi tới; ghi chú ngắn Tham gia tự nguyện; 4 tab.
S05 Khám phá: Back; ô tìm; filter Tất cả/≤5 phút/≤10 phút; đủ 9 nhóm như brief; Kết nối đồng nghiệp mở với 2 hoạt động. Danh sách cuộn, không nén vào 1 viewport.
S06 Chi tiết thói quen: Back; nhóm; Rủ đồng nghiệp đi bộ; 5 phút; 1 khối Hướng dẫn bằng 3 thanh placeholder; ghi chú Tham gia tự nguyện; nút Chọn lịch thực hiện.
S07 Lịch thói quen: Back; tên hoạt động; ngày 26/10/2026; Nhắc tôi bật; giờ 12:00; giờ yên lặng 18:00–08:00 hôm sau; Lưu lịch/Hủy. Trợ giúp tối đa 1 câu ngắn.
S08 Tiến độ: Back; tóm tắt 1/3; 1 hàng đã hoàn thành và 2 hàng chưa hoàn thành khớp Home; không progress card/biểu đồ trang trí.
S09 Góc làm việc: Back; tên Kiểm tra góc làm việc; 3 hàng checkbox Màn hình/Ghế và tư thế/Mặt bàn và lối đi; nút Đã kiểm tra. Không ảnh hoặc mô tả phụ dài.
S10 Ngủ & phục hồi: Back; tên Chuẩn bị nghỉ tối; 1 khối Hướng dẫn bằng 2 thanh placeholder; nút Chọn giờ nhắc.

HEADER VÀ ĐIỀU HƯỚNG
Không dùng cùng tiêu đề Chi Tiết Thói Quen cho mọi màn. Mỗi header phải đúng tên chức năng nêu trên.
Chỉ S01–S04 có bottom navigation Hôm nay/Ăn uống/Thư giãn/Kết nối, chọn đúng tab.
S05–S10 chỉ có Back, không bottom navigation.
Giữ đường đi và phạm vi 3 persona chính ngang nhau, đủ 9 nhóm theo brief. Không thêm màn chọn persona hoặc ép hoàn thành 9/9.

Đầu ra đúng 10 wireframe skeleton nhất quán, giữ BASE trước sửa, dừng để tôi phản biện tổng thể. Chưa UI màu, chưa thêm state/dialog hoặc tuyên bố prototype hoạt động.
```
