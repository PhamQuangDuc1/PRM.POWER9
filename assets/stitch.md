# Danh mục bằng chứng Stitch

Trạng thái: đã có ảnh tổng quan V00 do nhóm cung cấp, thể hiện 4 màn xanh lá; chưa có URL project được xác nhận. Đã có ảnh I01 với bốn màn xanh biển; xem ai/critiques/I01-review.md.

- Brief: ../design/DESIGN.md
- P00: ../ai/prompts/P00-stitch-initial.md
- AI log: ../ai/ai-design-log.md
- Hướng dẫn: ../docs/stitch-to-figma-guide.md

## Lưu file sau khi chạy

assets/stitch/V00/ chứa ảnh prompt, canvas tổng quan và output S01–S08 ban đầu.
assets/stitch/I01/, I02/, I03/ chứa before/after và ảnh prompt thật của từng vòng.
Dùng tên có ID, ví dụ V00-S05-discover.png và I01-after-S05.png.

Không tạo ảnh rỗng để lấp slot. Không ghi ngày giờ chạy theo tên file legacy khi chưa xác minh. Nếu crop để đưa slide, giữ bản gốc và đường dẫn nguồn.

| Phiên bản | Liên kết project | Prompt thực gửi | Đầu ra | Kiểm chứng |
| --- | --- | --- | --- | --- |
| V00 | Chưa có URL | Candidate P00; exact submitted text chưa xác minh đủ | V00/V00-overview-user-provided.png | C00 overview review; chưa đo tương tác/accessibility |
| I01 | Chưa có URL | Prompt dự kiến I01-blue-vietnamese-labels.md | I01/I01-overview-user-provided.png | Đã review tiêu đề/nhãn/màu tổng quan; tương tác và số đo chưa kiểm tra |
| I02 | Chưa có URL | Prompt dự kiến I02-states-recovery.md | I02/I02-overview-user-provided.png | Đã review; states tách riêng; khung 390×884 cần sửa |
| I03 | Chưa có URL | Prompt dự kiến I03-context-actions.md | I03/I03-overview-user-provided.png | Đã review hai ngữ cảnh S06; đường đi/kích thước cần hoàn thiện |

## Review và truy vết

- V00 provenance: assets/stitch/V00/README.md.
- C00 bản đánh giá đầy đủ: ai/critiques/C00-response.md.
- I01 draft: ai/prompts/I01-blue-vietnamese-labels.md.
- Đổi màu đơn thuần không được tính là một vòng cải tiến UX.

## P00b — Bốn màn UI bổ sung

Ảnh: assets/stitch/P00b/P00b-overview-user-provided.png, kèm manifest SHA256. Thấy S02/S03/S08/S04 xanh biển. Review: ai/critiques/P00b-review.md. Đã có ảnh đủ tám chức năng khi ghép I01; chưa hoàn tất states/prototype. Bước tiếp theo I02-states-recovery.md, chưa chạy.

## I02 — Trạng thái và phục hồi

Đã lưu ảnh assets/stitch/I02/I02-overview-user-provided.png, manifest SHA256, review ai/critiques/I02-review.md. Chọn S05 có kết quả, S07 hợp lệ, S08 có dữ liệu làm bản mặc định; giữ biến thể riêng. I03 đang chờ chạy.

## I03 — Hai ngữ cảnh S06

Ảnh assets/stitch/I03/I03-overview-user-provided.png và manifest SHA256; review ai/critiques/I03-review.md. Đã có CTA thêm/đổi lịch riêng. Bộ chọn theo design/ui-selection.md. Bước tiếp theo chuyển Figma, không chạy lại I03.
