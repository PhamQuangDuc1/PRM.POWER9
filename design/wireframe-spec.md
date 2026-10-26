# Wireframe Office trên Stitch — OW00 → OW01

Đầu vào: ba persona tại ux/persona.md; chín nhóm trong docs/office-direction.md. Giữ cấu trúc chức năng và nhịp bố cục bộ UI xanh biển đang có, kiểm tra lại trước khi hoàn thiện UI. Bộ HTML Office W02 local trước đây không phải nguồn đã chốt.

Base 360×800, lề 16, body 16, label ≥14, target ≥48. Grayscale, ô ảnh/ô logo đơn giản; nội dung dài cuộn, không ép chín nhóm vào một viewport.

| Màn | Bố cục trên xuống |
| --- | --- |
| S01 | Ô logo + tên → ngày → việc tự chọn theo giờ → hoàn thành/undo → Khám phá/Tiến độ → bốn tab |
| S02 | App bar → Eat Well/bữa trưa → hướng dẫn → ghi nhận → lịch sử → tab |
| S03 | App bar → Manage Stress → thời lượng/timer → điều khiển → hướng dẫn → tab |
| S04 | App bar → Social Bonds → hoạt động đồng nghiệp tự nguyện → ghi nhận → tab |
| S05 | Back → search có nhãn → filter nhóm/thời lượng → đủ 9 nhóm trong danh mục cuộn → xem chi tiết |
| S06 | Back → nhóm/tên/phút → mục tiêu → các bước → thêm hoặc đổi lịch |
| S07 | Back → hành động → ngày → nhắc tùy chọn/giờ → giờ yên lặng → lưu/hủy |
| S08 | Back → tổng tuần trên việc tự chọn → lọc nhóm → bản ghi có ngày → xóa có xác nhận |

OW00 là output wireframe đầu tiên khi chạy prompt; OC00 review artifact thật; OW01 sửa theo findings được chọn. Sau đó mới OU00 dùng wireframe OW01 cùng style reference UI cũ và logo gốc.
Chưa có các output này. Lưu bằng chứng theo hướng dẫn docs/OFFICE-UPDATE-GUIDE.md và ai/prompts/OFFICE-stitch-update.md.
