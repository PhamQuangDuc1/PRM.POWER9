# AI design log Power9 Office Routine

Figma: https://www.figma.com/design/MTv5qJbn065VYJQIXausoq

Stitch: https://stitch.withgoogle.com/projects/2176700449127941467

GitHub: https://github.com/PhamQuangDuc1/PRM.POWER9

## Xác nhận prompt

Ngày 27/10/2026, người dùng xác nhận 100% các prompt Office đã được gửi nguyên văn theo nội dung trợ lý cung cấp trên dự án Stitch mới. Đây là xác nhận của người thực hiện. Khối prompt trong ai/prompts/OFFICE-*.md được giữ nguyên; không sửa lại lời prompt theo kết quả.

## Công cụ và đầu ra

Google Stitch tạo wireframe/UI nguồn; người dùng cung cấp ZIP và ảnh. Codex hỗ trợ phân tích, phản biện, kiểm chứng HTML/font, dựng lớp native Figma, nối prototype và tài liệu. Không gán tên model nền của Stitch khi chưa có thông tin công cụ xác nhận.

## Tạo UI từ wireframe

Nguồn: assets/stitch/office-final/; ai/prompts/OFFICE-UI01-from-final-wireframe.md; assets/stitch/office-ui/UI01/. Brief xác định Android tiếng Việt, 3 persona chính ngang nhau, 10 màn, 9 nhóm, 360/412, logo gốc và phong cách xanh biển.

## OI01 Typography

- Vấn đề C01: font render serif khác brief; lỗi array gộp toàn danh sách fallback thành một font-name.
- Prompt sửa: ai/prompts/OFFICE-OI01-font-root-fix.md.
- BEFORE/AFTER kiểm chứng Chrome: output/office-ui-font-check/S07-before.png và S07-after-local-fix.png; font-verification.json ghi font render thật.
- Ảnh Stitch sau sửa: assets/stitch/office-ui/OI01-after/.
- Quyết định: sửa cấu hình, giữ nhiệm vụ/bố cục; không dùng ảnh style board để chứng minh font render. Không gọi ảnh Chrome cục bộ là output Stitch.

## OI02 Mật độ nội dung

- Vấn đề C02: ảnh/banner/thẻ phụ ngoài nhiệm vụ, tên hoạt động S07 bị cắt.
- Prompt sửa: ai/prompts/OFFICE-OI02-content-density.md.
- BEFORE: assets/stitch/office-ui/OI01-after/; AFTER: assets/stitch/office-ui/OI02-after/.
- Quyết định: bỏ nội dung phụ, giữ tên và CTA. Review thấy Home thiếu hàng hoàn thành so với Tiến độ, chuyển xử lý dữ liệu ở OI03; không bịa số đo thời gian giảm.

## OI03 Hoàn thành nhiệm vụ và phục hồi

- Vấn đề C03: thiếu đường kết thúc, error đổi tên/ngày/giờ, phiên nghỉ lệch thời lượng, metric không có nguồn.
- Prompt sửa: ai/prompts/OFFICE-OI03-task-recovery.md.
- BEFORE: OI02-after; output mở rộng và review: assets/stitch/office-ui/OI03-expanded/, ai/critiques/OFFICE-OI03-expanded-review.md.
- AFTER hoàn thiện: Figma 03/06. Cùng hoạt động giữ dữ liệu xuyên form/saving/error/retry; Home và Tiến độ đồng bộ. Bỏ metric không có dữ liệu đo.
- Kiểm tra: 15 điều kiện điều hướng/dữ liệu và nhánh xóa0/3; office-behavior-audit.json, office-deletion-audit.json.

## Hoàn thiện accordion

Người dùng phát hiện chỉ nhóm07 mở sẵn. Đã dựng DiscoverGroup18variants, áp dụng 9 nhóm trên All/≤5/≤10 và UI360/412. Đã kiểm tra 27 nhóm prototype chuyển trạng thái và giữ đích của thẻ/mũi tên; đúng 3 starting point; 323 reactions, 0 đích hỏng. Nguồn: office-accordion-audit.json và office-checkpoint.json.

## Giới hạn

Kiểm tra trên lớp Figma và dữ liệu mẫu, chưa phải usability test. Timer, tìm kiếm và nhập giờ là mô phỏng. Chưa có app Flutter/backend, TalkBack hoặc peer handoff test. Mục tiêu thời gian chưa được đo với người dùng.
