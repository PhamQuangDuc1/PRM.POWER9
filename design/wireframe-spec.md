# Đặc tả wireframe Power9

## Mục đích và trạng thái

Bộ low-fi mới dùng screen contract S01–S08 trong screen-spec.md và ba flow trong ux/user-flow.md. Đã có ảnh tổng quan W00 thể hiện tám màn, review tại ai/critiques/W00-review.md. W01 đã có ảnh bốn màn thay thế và bảng trạng thái, review tại ai/critiques/W01-review.md. Bộ chọn theo design/wireframe-selection.md; Figma chưa dựng/kiểm tra. Tài liệu này là bản thiết kế đầu vào, không phải bằng chứng wireframe đã được tạo.

V00 là UI ban đầu đã có ảnh. W00 được tạo sau V00 để kiểm tra lại bố cục trước khi refine UI xanh biển. Không trình bày W00 là artifact đã có trước V00.

## Quy tắc chung

- Frame cơ sở 360×800; nội dung dài cuộn bên trong, không đè lên navigation.
- Đen–trắng/xám, không ảnh đẹp, không màu thương hiệu hoặc hiệu ứng trang trí.
- Dùng text tiếng Việt có dấu để kiểm tra độ dài thật.
- Padding 16, body 16, label tối thiểu 14, vùng chạm mục tiêu ≥48×48.
- Một hành động chính theo task/ngữ cảnh; trạng thái lỗi/empty không trộn với default/populated.
- Mã W00-Sxx đặt ở tên frame. App bar chỉ chứa tên chức năng.

## Bố cục từ trên xuống

| Frame | Cấu trúc low-fi | Điểm cần phản biện |
| --- | --- | --- |
| W00-S01 | App bar → tóm tắt hôm nay → entry Khám phá/Lịch sử → danh sách việc → bottom nav | Check-in có trực tiếp không; thời lượng và phản hồi rõ không |
| W00-S02 | App bar → tên thói quen ăn uống → thời lượng/hướng dẫn → ghi nhận → lịch sử → nav | Có một CTA rõ, tránh mở rộng thành app dinh dưỡng phức tạp |
| W00-S03 | App bar → tên/thời lượng → timer → bắt đầu → hướng dẫn → lịch sử → nav | Bắt đầu/đang chạy/tạm dừng có ngữ cảnh riêng |
| W00-S04 | App bar → hoạt động kết nối có thời lượng → lựa chọn → ghi nhận → lịch sử → nav | Hành động ngoài đời rõ, không thêm chat ngoài phạm vi |
| W00-S05 | Back/title → search có nhãn → filter thời gian → kết quả/card → Xem chi tiết | Tìm hoạt động 5 phút nhanh; empty là state riêng |
| W00-S06 | Back/title → tên + thời lượng → mục đích → các bước → CTA thêm hoặc sửa | Phân biệt new/existing, không hiện hai CTA mâu thuẫn |
| W00-S07 | Back/title → thói quen → ngày → reminder → giờ → Lưu/Hủy | Form ngắn; nhắc giờ tùy chọn; validation và retry đúng ngữ cảnh |
| W00-S08 | Back/title → tổng tuần → danh sách có ngày → action phụ nếu có | Tiến độ dễ hiểu, xóa cần xác nhận; empty không trộn dữ liệu |

## State variants

Tách riêng S05-empty; S07-validation/saving/error; S08-empty; O01 xác nhận thoát phiên và O02 xác nhận xóa. Các biến thể không tăng số màn hình được tính.

## Truy vết persona và lý do bố cục

- Linh: đưa số phút ra card và filter ở trước danh sách; rút form để thao tác khi bị gián đoạn.
- Minh: nút hoàn thành có ngay trên Home, phản hồi có nhãn và hoàn tác.
- Huy: giờ nhắc dễ tìm, có đường đổi lịch và hủy giữ giờ cũ.
- Chú Hùng: nhãn rõ, không dựa cử chỉ ẩn; thứ bậc đơn giản và xác nhận trước xóa.

## Quy trình tiếp theo

1. Chạy ai/prompts/W00-wireframe.md trong cùng project Stitch, tạo section/frame mới và giữ V00.
2. Lưu ảnh tổng quan W00 và ảnh rõ từng S01–S08 vào assets/wireframe/W00/.
3. Review theo flow và bảng bố cục trên; ghi vấn đề thực tế trước khi sửa.
4. Đưa bộ low-fi editable vào Figma page 02 Wireframe; ảnh reference không thay thế việc kiểm tra lớp/constraints.
5. Khi bố cục hợp lý, quay lại I01 trên V00 để sửa nhãn và chuyển UI xanh biển. I01 vẫn chưa được tính hoàn thành chỉ vì W00 đã tạo.

## Checklist bằng chứng

- [ ] Prompt thực gửi được lưu; nếu sửa W00 draft, lưu bản đúng nguyên văn.
- [x] Có ảnh tổng quan tám màn khác nhau.
- [x] Ảnh W01 có tiêu đề S05–S08 đúng chức năng; kết hợp S01–S04 W00 để chọn đủ bộ.
- [ ] Có before/after nếu sửa bố cục; không ghi kết quả khi chưa có output.
- [ ] Có đường đi cho ba flow và mọi màn đều được dùng.
- [ ] Default/populated, empty, validation và network error phân biệt rõ.
- [ ] Page 02 Figma có bộ low-fi tương ứng bộ Final UI.
- [ ] Đối chiếu ít nhất một cặp Wireframe → Final UI khi thuyết trình, giải thích bằng persona.
