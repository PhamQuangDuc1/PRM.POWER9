# C00 — Prompt đánh giá UX

Bản tiếng Việt để dùng cho các lần đánh giá tiếp theo. Tiêu chí tiếng Anh đã dùng để review V00 giữ nguyên tại ai/critiques/C00-review-criteria.md. Không ghi bản dịch này là prompt đã gửi trước đó.

Chỉ chạy trên ảnh đầu ra thực tế; giữ prompt và toàn bộ phản hồi AI, không chỉ bảng tóm tắt.

```text
Đánh giá các ảnh Power9 Stitch được đính kèm. Trước tiên liệt kê mã màn và phiên bản bạn thực sự thấy. Không bịa màn còn thiếu, tương tác, số đo hoặc kết quả thử nghiệm.

Bối cảnh: một ứng dụng Android, khung cơ sở 360×800, UI tiếng Việt. Persona chính giả định Linh có 5 phút, cần tìm và thêm thói quen phù hợp trong dưới 60 giây. Persona hỗ trợ giả định: Minh check-in tối đa 3 thao tác; Huy đổi lịch dưới 30 giây; chú Hùng cần nút có nhãn, chữ dễ đọc và phục hồi bấm nhầm. Đây là mục tiêu chưa kiểm chứng.

Đánh giá theo 10 nguyên tắc usability của Nielsen, accessibility và persona. Nêu tên nguyên tắc liên quan. Kiểm tra F01 thêm thói quen, F02 hoàn thành/xem lịch sử và các nhánh theo nhóm hoạt động, F03 đổi lịch. Chú ý phản hồi, giữ dữ liệu, Quay lại/Hủy, đang tải, rỗng, lỗi/thử lại, hoàn tác và xác nhận xóa.

Nêu ít nhất 5 vấn đề cụ thể NẾU ảnh thực sự chứng minh được. Mỗi vấn đề có:
- Mã UX01…; mã màn và phiên bản.
- Chữ hoặc chi tiết nhìn thấy; tách quan sát khỏi suy luận.
- Tác động và mức độ nghiêm trọng.
- Nguyên tắc Nielsen hoặc tiêu chí accessibility và persona bị ảnh hưởng.
- Đề xuất sửa cụ thể.
- Cách kiểm chứng và ảnh cần lưu.

Nếu không có đủ 5 vấn đề có căn cứ, nói rõ thay vì bịa cho đủ.
Chỉ khẳng định tỉ lệ tương phản sau khi đo màu thật. Từ ảnh tổng quan, vùng chạm dp, cỡ chữ sp, token binding, Auto Layout và điều hướng hoạt động phải ghi “cần kiểm tra” nếu chưa có dữ liệu cấu trúc/kích thước. Không kết luận đạt thời gian UX từ ảnh tĩnh.

Đề xuất ba mục tiêu cải tiến KHÁC NHAU nếu findings đủ căn cứ. Không thêm lỗi có chủ ý để buộc có iteration. Không tự quyết accept/modify/reject thay nhóm; liệt kê đề xuất để nhóm quyết định.
```
