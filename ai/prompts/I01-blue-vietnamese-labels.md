# I01 — Sửa ngôn ngữ và nhận biết tác vụ, kèm hướng xanh biển

Trạng thái: SẴN SÀNG CHẠY, chưa có đầu ra sau chỉnh sửa.
Ảnh trước: assets/stitch/V00/V00-overview-user-provided.png.
Vấn đề: UX01, UX02, UX06 trong ai/critiques/C00-response.md.
Đổi màu đi kèm theo yêu cầu nhóm; không tính riêng đổi màu là một vòng cải tiến UX.

Sao chép khối text vào cùng project Stitch. Giữ V00 trước khi chạy và không sửa bộ wireframe W00/W01.

```text
Chỉnh BỐN MÀN UI hiện có của Power9 Family Routine, không chỉnh bộ wireframe low-fi W00/W01. Đây là vòng I01: thống nhất tiếng Việt và giúp người dùng nhận ra tác vụ hiện tại. Giữ luồng và nội dung cốt lõi, không tạo màn ngoài phạm vi.

VẤN ĐỀ ĐÃ THẤY:
- Tiêu đề Home là “Hom Nay” không dấu.
- Màn khám phá và biểu mẫu lịch cùng dùng “Chi Tiet Thoi Quen”.
- Nút trên thẻ khám phá ghép xem chi tiết với thêm mới nên không rõ một lần chạm sẽ làm gì.

SỬA CHÍNH XÁC:
- Tiêu đề S01: “Hôm nay”.
- Tiêu đề S05: “Khám phá thói quen”.
- Tiêu đề S06: “Chi tiết thói quen”.
- Tiêu đề S07: “Lịch thói quen”.
- Điều hướng dưới: “Hôm nay”, “Ăn uống”, “Thư giãn”, “Kết nối”.
- Nút trên thẻ S05: “Xem chi tiết”, dẫn S06; không làm người dùng hiểu chạm là đã thêm.
- TẤT CẢ chữ giao diện có dấu, gồm nhãn nhỏ, nút, lỗi. Dùng Unicode sửa được, phông Be Vietnam Pro hoặc Roboto hỗ trợ tiếng Việt; không chuyển chữ thành ảnh.

ĐỒNG THỜI ĐỔI HƯỚNG MÀU:
Thay xanh lá bằng xanh biển trên bảng phong cách, nút, mục điều hướng/bộ lọc được chọn, biểu tượng, tiêu điểm nhập và nền bổ trợ.
Nền #F5F8FD; bề mặt thẻ #FFFFFF; chữ chính #152C46; chữ phụ #4C627A; hành động chính #1E5AA8; chữ trên nút chính #FFFFFF; nền được chọn #EAF2FC; viền ô nhập #71839A; lỗi #A7332A.
Không giữ điểm nhấn xanh lá/bạc hà, không neon hoặc gradient. Xanh biển là màu nhấn trang trí duy nhất, đỏ chỉ dùng cho lỗi. Không dùng màu viền làm chữ nội dung.

Giữ nội dung 16/24, nhãn tối thiểu 14/20, vùng chạm ≥48×48, nút chính cao 52, lề 16 và hệ khoảng cách/bo góc hiện có. Khung cơ sở 360×800.

Tên khung: “I01-S01 Hôm nay”, “I01-S05 Khám phá thói quen”, “I01-S06 Chi tiết thói quen”, “I01-S07 Lịch thói quen”. Mã kỹ thuật chỉ ở tên khung, không hiện trong UI. Giữ thứ bậc dễ đọc và nút Quay lại.

Nếu tạo khung mới thay vì sửa đè, đặt đúng tên I01 để nhận diện như phiên bản sau và giữ khung gốc. Hiển thị bốn màn đã chỉnh và bảng màu mới. Không tuyên bố đã đo thời gian hoàn thành hoặc đạt accessibility.
```
