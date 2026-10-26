# Project Stitch mới — lượt 01

Người dùng xác nhận ngày27/10/2026 đã gửi nguyên văn100% prompt Office do trợ lý cung cấp trên dự án Stitch mới. Khối prompt bên dưới được giữ nguyên.

```text
Tạo project thiết kế ứng dụng Android Power9 Office Routine. Ghi nhớ brief toàn dự án, nhưng lượt này CHỈ TẠO MỘT WIREFRAME LOW-FI S01 — Hôm nay, rồi dừng để tôi phản biện.

NGƯỜI DÙNG: nhân viên văn phòng 23–45 tuổi. Ba persona CHÍNH NGANG NHAU, đều là giả định:
- Huy, 28, lập trình viên: ngồi lâu, quên nghỉ; cần vận động, tư thế, góc làm việc và đổi giờ nhắc khi bận họp.
- Mai, 24, marketing mới: ăn vội, căng thẳng, ít quen đồng nghiệp; cần ăn uống, nghỉ ngắn và kết nối tự nguyện.
- Linh, 39, trưởng nhóm hành chính: họp nhiều, việc kéo dài ngoài giờ; cần phục hồi, mục tiêu có ý nghĩa và cân bằng công việc–cuộc sống.
Một ứng dụng chung đáp ứng cả ba. Không có màn chọn persona, không ưu tiên một người rồi coi hai người còn lại là phụ.

CHÍN NHÓM NỘI DUNG theo gợi ý của giảng viên:
1. Move Often — Vận động thường xuyên.
2. Sit Smart — Ngồi đúng tư thế.
3. Eat Well — Ăn uống lành mạnh.
4. Sleep Well — Ngủ đủ, phục hồi tốt.
5. Manage Stress — Quản lý căng thẳng.
6. Healthy Space — Không gian tốt.
7. Social Bonds — Kết nối đồng nghiệp.
8. Purpose — Có mục tiêu, ý nghĩa.
9. Work–Life Balance — Cân bằng công việc và cuộc sống.
Không thay bằng chín tên Blue Zones gốc. Không ép hoàn thành 9/9 mỗi ngày.

PHẠM VI SAU NÀY — CHƯA DỰNG: S01 Hôm nay, S02 Ăn uống, S03 Thư giãn, S04 Kết nối, S05 Khám phá, S06 Chi tiết, S07 Lịch, S08 Tiến độ. Bốn tab: Hôm nay / Ăn uống / Thư giãn / Kết nối. Khám phá và Tiến độ mở từ Home. Đủ chín nhóm sẽ nằm trong Khám phá, không nhét tất cả lên Home.

LƯỢT NÀY: đúng một frame 360×800, tên OW00-S01-HomNay; mã chỉ ở tên frame, không trên UI.
Bố cục từ trên xuống:
1. App bar: ô logo 40×40 và tên Power9 Office Routine, cho xuống hai dòng. Không thêm avatar, chuông hoặc menu chưa có nhiệm vụ.
2. Tiêu đề Hôm nay; ngày Thứ Hai, 26/10. Không chào riêng tên một persona.
3. Tóm tắt: Đã hoàn thành 1/3 hoạt động đã chọn. Tính theo việc tự chọn, không điểm sức khỏe hay tiến độ 1/9.
4. Hai lối tắt phụ: Khám phá thói quen và Xem tiến độ.
5. Lịch hôm nay gồm đúng ba card theo giờ:
   - 09:00; nhóm Mục đích; Viết một việc có ý nghĩa; 2 phút. Có dấu kiểm + Đã hoàn thành và nút phụ Hoàn tác.
   - 10:00; nhóm Vận động; Đi bộ giữa giờ; 3 phút. Nút Hoàn thành và lối phụ Chi tiết, sau này mở chi tiết để đổi lịch.
   - 17:30; nhóm Cân bằng; Tổng kết và khép lại công việc; 2 phút. Nút Hoàn thành và lối phụ Chi tiết.
Đây là dữ liệu mẫu của một tài khoản, không phải ba hồ sơ. Nút cùng loại có hình thức nhất quán.
6. Bottom navigation cố định: Hôm nay / Ăn uống / Thư giãn / Kết nối. Hôm nay selected bằng nhãn, icon và chỉ báo, không chỉ màu. Icon nét đơn giản, không emoji.

RÀNG BUỘC: grayscale, không ảnh trang trí, chưa UI màu/gradient/bóng 3D. Tôi có logo riêng, ở wireframe chỉ dùng ô giữ chỗ, không tự vẽ logo. Lề 16; spacing 4/8/12/16/24; body 16, label ≥14; vùng chạm ≥48×48, nút chính cao 52. Nội dung giữa app bar và navigation cuộn dọc; không che card, không cắt dấu tiếng Việt, không tràn ngang hoặc thu chữ để ép vừa.
Chỉ dựng trạng thái có dữ liệu mô tả trên. Chưa tạo empty/loading/error/dialog hoặc màn khác. Không thêm login/onboarding/chat/ranking/HR. Chưa tự chọn phong cách UI mới; tôi sẽ cung cấp tham chiếu UI xanh biển khi chốt wireframe.

ĐẦU RA: đúng một wireframe S01. Dừng để tôi chụp, phản biện và yêu cầu sửa trước khi làm màn tiếp theo.
```

Sau chạy: chụp frame đọc rõ; nếu có cuộn chụp thêm phần dưới. Lưu prompt thật và ảnh theo OW00-S01. Viết lệnh sửa sau khi xem output, không bịa findings hoặc nhận là đã kiểm tra hành vi chỉ từ ảnh.
