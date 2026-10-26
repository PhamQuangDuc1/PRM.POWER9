# OI02 — giảm mật độ, giữ nhiệm vụ

Người dùng xác nhận ngày27/10/2026 đã gửi nguyên văn100% prompt Office do trợ lý cung cấp trên dự án Stitch mới. Khối prompt bên dưới được giữ nguyên.

```text
VÒNG CẢI TIẾN OI02 — GIẢM NỘI DUNG THỪA, GIỮ RÕ NHIỆM VỤ.

Áp dụng cho đúng 10 màn UI vừa sửa font. Giữ bộ hiện tại làm BEFORE, bộ sửa đặt tên OFFICE-OI02-S01 đến S10 ngoài canvas; không đưa mã vào UI. Đây là 1 vòng sửa chung, không tạo thêm màn chức năng.

Giữ font sans-serif đã sửa đúng, palette xanh/trắng, logo gốc và điều hướng. Không trở lại low-fi, không đổi layout tổng thể hoặc tự thêm chức năng. 3 persona chính Huy/Mai/Linh và 9 nhóm văn phòng giữ nguyên.

VẤN ĐỀ
UI có banner, ảnh, badge và lời dẫn ngoài wireframe, làm chậm việc đọc hoạt động và đặt lịch. Các nhãn sống thọ/Blue Zones còn có thể khiến hiểu nhầm 9 nhóm văn phòng là sản phẩm chính thức hoặc hứa hiệu quả. Giảm khối phụ để người dùng nhìn nhanh việc cần làm.

SỬA CHUNG THEO MÀN
S01 Hôm nay:
- Bỏ card Thói quen sống thọ Power 9 và badge Power 9 cạnh lời chào.
- Bỏ dòng Duy trì nhịp điệu tích cực dưới progress, không cần thay bằng slogan khác.
- Giữ 3 hoạt động/giờ, tóm tắt 1/3, Khám phá/Tiến độ và bottom navigation.
- Ngày minh họa là Thứ Hai 26/10/2026, khớp Lịch/Tiến độ; bỏ lời chào Thứ Tư nếu đang có.

S02 Ăn uống:
- Bỏ thẻ Khoảnh khắc hiện diện và đoạn phụ đi kèm.
- Giữ tên hoạt động, 1 câu mục đích, 3 bước ngắn, Đã thực hiện/Xem tiến độ và navigation.

S03 Thư giãn:
- Bỏ action loa chưa có nhiệm vụ.
- Giữ tên, 1 câu hướng dẫn, timer03:00, trạng thái Chưa bắt đầu và nút Bắt đầu.
- Không thêm card/ảnh hoặc slogan thay vào chỗ bỏ.

S04 Kết nối:
- Bỏ ảnh bìa lớn và nhãn Tự nhiên & Thư thái.
- Giữ title, 2 hàng hoạt động có thời lượng, ghi chú tham gia tự nguyện và navigation.

S05 Khám phá:
- Bỏ dòng Power9 Blue Zones cạnh tiêu đề nhóm.
- Giữ đủ 9 nhóm, tìm kiếm, filter và nhóm Kết nối đang mở.
- Chữ nhóm dài được xuống dòng; không giảm cỡ chữ để ép vừa.

S06 Chi tiết:
- Bỏ ảnh bìa, nhãn Nghỉ ngắn chủ động/#Power9, tag Nạp năng lượng/Dễ dàng.
- Giữ nhóm, tên đầy đủ, 5 phút, 1 câu mục đích và 3 bước.
- Rút mỗi bước thành 1 câu ngắn như wireframe; bỏ diễn giải phụ dưới từng bước.
- Giữ 1 câu tham gia tự nguyện và Chọn lịch thực hiện. Bỏ dòng nhắc lặp dưới CTA.

S07 Lịch:
- Bỏ banner ảnh và lời dẫn cân bằng nhịp sinh học/năng lượng.
- Tóm tắt hoạt động thành tên đầy đủ Rủ đồng nghiệp đi bộ và 5 phút, cho xuống dòng, KHÔNG ellipsis tên chính.
- Bỏ mô tả phụ Hoạt động giải tỏa mệt... và câu chuông rung nhẹ nhàng.
- Giữ ngày, nhắc tùy chọn, giờ12:00, giờ yên lặng18:00–08:00 hôm sau, Lưu lịch/Hủy.
- Giữ 1 câu giải thích không phát thông báo trong giờ yên lặng.

S08 Tiến độ:
- Bỏ thẻ Khoảng lặng tích cực và dòng Khởi đầu ngày làm việc tích cực.
- Giữ tóm tắt 1/3, hoạt động đã/chưa hoàn thành, thời gian và ghi chú riêng tư ngắn.
- Tên hoạt động chính phải đọc đầy đủ và khớp S01; metadata phụ có thể xuống dòng.

S09 Góc làm việc:
- Bỏ thẻ ảnh Thói quen Power9 và thẻ Mẹo tư thế chuẩn.
- Giữ tên hoạt động,2 phút,1 câu hướng dẫn,3 checkbox và Đã kiểm tra.

S10 Ngủ & phục hồi:
- Bỏ ảnh phòng ngủ, nhãn Khoảng đêm và nhãn Nhịp nhàng.
- Giữ tên,1 câu mục đích,2 gợi ý ngắn,Chọn giờ nhắc và ghi chú thời điểm cá nhân.

YÊU CẦU BẢO TOÀN
Không bỏ hướng dẫn cần thiết,9 nhóm hoặc chức năng. Không dùng thanh placeholder thay chữ thật ở giai đoạn UI. Không thêm slogan mới vào chỗ trống. Giữ logo người dùng nhưng không tự phóng to.
Giữ đúng4 tab trên S01–S04; màn con Back đúng tiêu đề. Tóm tắt S01/S08 thống nhất: 1/3 hoạt động đã chọn hoàn thành.
Giữ chữ/body/nhãn dễ đọc và cỡ tối thiểu14 cho nhãn; target≥48×48. Frame360×800, kiểm tra412; nội dung dài cuộn; không co nhỏ chữ hoặc card để ép mọi thứ vừa1 viewport.
Giữ cấu hình fontFamily đã sửa, không gộp danh sách font thành1 tên nữa.

ĐẦU RA: đúng10 màn UI sau giảm mật độ, xếp cùng thứ tự để so sánh BEFORE/AFTER. Chưa tạo state/error/dialog hoặc thêm chức năng trong lượt này. Dừng để tôi phản biện trước vòng3.
```
