# Dựng bốn màn còn lại — một lượt

Người dùng xác nhận ngày27/10/2026 đã gửi nguyên văn100% prompt Office do trợ lý cung cấp trên dự án Stitch mới. Khối prompt bên dưới được giữ nguyên.

```text
Tiếp tục project Power9 Office Routine hiện tại. Giữ nguyên bốn màn đã tạo: Hôm nay, Khám phá, Chi tiết và Lịch; giữ các bản cũ làm lịch sử.

Lượt này tạo đúng BỐN màn wireframe low-fi còn lại: Ăn uống, Thư giãn, Kết nối và Tiến độ. Làm trong một lượt rồi dừng để tôi phản biện toàn bộ tám màn. Không tạo UI màu hoặc tự sinh thêm màn.

NGỮ CẢNH CHUNG
Một ứng dụng cho nhân viên văn phòng, có ba persona chính ngang nhau:
- Huy 28: vận động, tư thế, góc làm việc, lịch linh hoạt.
- Mai 24: ăn uống, giảm căng thẳng, kết nối đồng nghiệp tự nguyện.
- Linh 39: nghỉ/ngủ, mục tiêu có ý nghĩa, cân bằng công việc và cuộc sống.
Không có màn chọn persona. Chín nhóm văn phòng trong brief vẫn giữ đủ qua Khám phá; không cần mỗi nhóm có màn riêng. Không ép hoàn thành 9/9.

PHONG CÁCH CHUNG
Mỗi màn mobile 360×800. Dùng đúng low-fi đơn giản như Home mới: trắng/xám/đen, chữ và đường phân cách, ô chữ nhật, nhiều khoảng trống hợp lý. Không ảnh, avatar, bóng, gradient, khung trích dẫn, chip trang trí hoặc style board. Không thêm nội dung để lấp đầy màn. Chỉ giữ nhãn cần cho nhiệm vụ.
Lề 16, body khoảng 16, nhãn ≥14, vùng chạm ≥48×48, nút chính cao 52. Nội dung dài được cuộn, không thu nhỏ chữ để ép vừa. App bar và navigation không che nội dung. Không hiển thị mã frame trên UI.

MÀN 1 — OFFICE-W01-S02-AnUong
Đây là tab Ăn uống.
- App bar: Ăn uống, không Back/avatar/chuông.
- Nhãn nhóm: Ăn uống lành mạnh.
- Tiêu đề hoạt động: Ăn trưa có chú ý.
- Một câu: Dành thời gian cho bữa trưa, tạm rời công việc.
- Ba bước ngắn: Chọn món có rau hoặc đậu phù hợp; đặt điện thoại sang một bên; ăn chậm và chú ý cảm giác vừa đủ.
- Một nút chính: Đã thực hiện.
- Liên kết phụ: Xem tiến độ.
- Bottom navigation Hôm nay / Ăn uống / Thư giãn / Kết nối, Ăn uống được chọn.
Ghi nhận dự kiến cập nhật lịch sử và có Hoàn tác ở giai đoạn prototype. Không tính calo, không thêm thực đơn hoặc chỉ số sức khỏe.

MÀN 2 — OFFICE-W01-S03-ThuGian
Đây là tab Thư giãn.
- App bar: Thư giãn, không Back/avatar/chuông.
- Nhãn nhóm: Quản lý căng thẳng.
- Tên: Nghỉ sau cuộc họp.
- Một câu: Thả lỏng vai và thở theo nhịp tự nhiên, dễ chịu.
- Bộ đếm dạng chữ 03:00, không vòng tròn trang trí.
- Một nút chính: Bắt đầu.
- Bottom navigation như trên, Thư giãn được chọn.
Chỉ vẽ trạng thái chưa bắt đầu. Sau này mới bổ sung đang chạy/tạm dừng/kết thúc/xác nhận rời. Bắt đầu không đồng nghĩa đã hoàn thành, chưa tự ghi nhận lúc mở màn.

MÀN 3 — OFFICE-W01-S04-KetNoi
Đây là tab Kết nối.
- App bar: Kết nối, không Back/avatar/chuông.
- Nhãn nhóm: Kết nối đồng nghiệp.
- Một câu: Chọn một hoạt động tự nguyện cùng đồng nghiệp.
- Hai hàng chọn đơn giản:
  Rủ đồng nghiệp đi bộ — 5 phút — dấu đi tới.
  Trò chuyện trong giờ nghỉ — 5 phút — dấu đi tới.
- Ghi chú ngắn: Ứng dụng không tự gửi lời mời.
- Bottom navigation như trên, Kết nối được chọn.
Chạm hàng dự kiến mở template Chi tiết S06 với đúng dữ liệu; chưa thêm nút hoàn thành trên từng hàng. Không chat, danh sách thành viên, avatar hoặc nút mời tự động. Không tạo trùng màn Chi tiết.

MÀN 4 — OFFICE-W01-S08-TienDo
Đây là màn con mở từ Home hoặc sau ghi nhận, không bottom navigation.
- App bar: Back và Tiến độ.
- Dòng thời gian: Hôm nay · 26/10/2026.
- Tóm tắt: 1/3 hoạt động đã chọn hoàn thành.
- Mục Đã hoàn thành, một hàng mẫu:
  Dấu kiểm; Viết một việc có ý nghĩa; 09:00; nhóm Mục đích.
- Mục Chưa hoàn thành, hai hàng mẫu:
  Đi bộ giữa giờ; 10:00; nhóm Vận động.
  Tổng kết và khép lại công việc; 17:30; nhóm Cân bằng.
- Ghi chú: Tiến độ cá nhân trên các hoạt động bạn tự chọn.
Giữ dữ liệu khớp Home hiện có. Không biểu đồ trang trí, streak gây áp lực, ranking hoặc điểm tuổi thọ. Back dự kiến về đúng nguồn đã mở Tiến độ, không mặc định mọi trường hợp đều về Home.

GIỚI HẠN LƯỢT NÀY
Chỉ bốn màn mặc định nêu trên. Không tạo loading/empty/error/dialog hoặc các biến thể khác trong lượt này. Các tương tác mô tả là ý đồ để dựng prototype sau, không tự tuyên bố đã chạy được. Không sửa bốn màn đang có. Đặt bốn màn mới cạnh nhau để chụp overview, rồi dừng.
```
