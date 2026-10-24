# AI design log Power9

## Quy ước

Theo dõi theo Run ID, phiên bản và screen ID. Phân biệt chuẩn bị prompt, đã gửi, đã có output, đã review và đã xác minh. Lưu prompt thực sự đã gửi, không chỉ tóm tắt.

## Công cụ hỗ trợ và phạm vi sử dụng

| Công cụ | Mục đích | Output xác minh được | Không chứng minh |
| --- | --- | --- | --- |
| Codex | Đọc đề, soạn brief/prompt, review ảnh V00 | Markdown và bản phản biện đầy đủ C00 | UI hoàn chỉnh hoặc prototype hoạt động |
| Google Stitch | Initial UI, output do nhóm cung cấp | ảnh tổng quan V00: 4 màn xanh lá và style board | Đủ 8 màn, model cụ thể hoặc prototype hoạt động |
| Trích xuất PDF bằng pypdf, DOCX XML | Đối chiếu văn bản tài liệu người dùng | Yêu cầu được dẫn nguồn trong completion plan | Visual QA bố cục tài liệu |
| Web search/read | Kiểm tra nguồn chính thức về Stitch export và Computer Use | Links nguồn trong guide | Quyền truy cập tài khoản Stitch |
| Figma connector | Thử đọc metadata link được gửi trong phiên trước | Trả về thiếu edit access phù hợp | File công khai không có view access |
| Windows screenshot + xem ảnh | Kiểm tra có thể chụp foreground trong phiên này | Ảnh thử lưu ngoài repo, cửa sổ Codex 1920×1080 đã xem | Output Stitch hoặc thao tác Figma |

Không công bố tên model Codex/Stitch nếu chưa có thông tin công cụ đáng tin cậy. StitchDesign đã có trong môi trường; kỹ năng đã được đọc để rà soát semantic brief. Chưa có công cụ điều khiển Stitch trực tiếp được xác minh.

## W00 / W01 — Wireframe

- W00: **ĐÃ CÓ ẢNH TÁM MÀN, ĐÃ REVIEW TỔNG QUAN**.
- Ảnh: assets/wireframe/W00/W00-overview-user-provided.png, bản gốc nhóm cung cấp và manifest SHA256.
- Prompt dự kiến: ai/prompts/W00-wireframe.md; chưa xác minh đầy đủ bản thực gửi.
- Theo nội dung từ trái sang phải: S05, S06, S07, S01, S03, S02, S04, S08.
- Review đầy đủ: ai/critiques/W00-review.md, WF01–WF03: tiêu đề lặp, chữ hướng dẫn dài, trạng thái phụ chưa có bằng chứng trong ảnh.
- W01: **ĐÃ CÓ ĐẦU RA, ĐÃ REVIEW TỔNG QUAN**. Ảnh assets/wireframe/W01/W01-overview-user-provided.png; thấy 4 màn thay thế S07/S06/S05/S08 và bảng trạng thái phụ.
- Prompt dự kiến W01: ai/prompts/W01-wireframe-refinement.md; nguyên văn thực gửi chưa được xác minh toàn bộ.
- Review: ai/critiques/W01-review.md; bộ được chọn: design/wireframe-selection.md. Dùng S01–S04 W00, S05–S08 W01; O02 trong ảnh bị cắt, chưa kiểm tra đủ.
- Đặc tả: design/wireframe-spec.md; danh mục: assets/wireframe/README.md.
- W00 sau V00; W01 chỉ chỉnh low-fi, không tính I01–I03 của Final UI đã hoàn thành.

## P00 / V00 — Tạo giao diện ban đầu

- Trạng thái: **ĐÃ CÓ BẰNG CHỨNG ĐẦU RA MỘT PHẦN**.
- Bằng chứng: assets/stitch/V00/V00-overview-user-provided.png; bản gốc nhóm cung cấp, có manifest SHA256.
- Input brief: design/versions/DESIGN-V00-green.md. DESIGN.md hiện tại là hướng xanh biển cho lần sửa tiếp.
- Candidate prompt: ai/prompts/P00-stitch-initial.md, giữ nguyên màu xanh lá như bản đã chuẩn bị; nguyên văn bản thực gửi chưa xác minh đầy đủ từ ảnh.
- Project title: Power9 Family Routine UI Design. Chưa có URL.
- UI hiển thị “Balanced”; không suy ra model nền.
- Màn thấy được, trái sang phải sau style board: S05, S01, S07, S06, nhận diện theo nội dung.
- S02/S03/S04/S08 chưa có bằng chứng output; sidebar đề xuất tạo tiếp.
- Ảnh zoom 37%, chưa đủ kiểm tra font sp, target dp, màu thực tế hay tương tác.
- Provenance chi tiết: assets/stitch/V00/README.md.

## P00b — Bổ sung bốn màn UI

- Trạng thái: **ĐÃ CÓ ẢNH VÀ REVIEW TỔNG QUAN**.
- Prompt dự kiến: ai/prompts/P00b-stitch-remaining.md; nguyên văn thực gửi chưa xác minh toàn bộ.
- Ảnh: assets/stitch/P00b/P00b-overview-user-provided.png và manifest SHA256.
- Nhận diện trái sang phải S02/S03/S08/S04, xanh biển.
- Review: ai/critiques/P00b-review.md; UX07 mã kỹ thuật lộ trong tiêu đề, UX08 S08 trộn có dữ liệu/rỗng.
- Ghép với I01 đã có bằng chứng đủ tám chức năng UI; không tính P00b là vòng cải tiến bổ sung.

## C00 — Phản biện UX

- Trạng thái: **ĐÃ VIẾT ĐÁNH GIÁ ẢNH TỔNG QUAN V00**.
- Tiêu chí/prompt áp dụng: ai/critiques/C00-review-criteria.md.
- Báo cáo đầy đủ: ai/critiques/C00-response.md, do Codex review trực tiếp ảnh thật.
- 6 findings UX01–UX06 gắn màn: dấu tiếng Việt, tên màn sai ngữ cảnh, kết quả/empty trộn, validation/network error trộn, CTA thêm/sửa mâu thuẫn, nhãn xem/thêm không rõ.
- Không có cuộc hội thoại critique bên ngoài được giả lập; chưa có kiểm thử tương tác hoặc số đo accessibility.

## Các vòng cải tiến

| Mã | Trạng thái | Vấn đề | Prompt thực gửi | Trước | Sau | Quyết định |
| --- | --- | --- | --- | --- | --- | --- |
| I01 | ĐÃ CÓ ẢNH, ĐÃ REVIEW TỔNG QUAN | UX01/UX02/UX06: tiêu đề và nhãn rõ hơn; kèm xanh biển | Prompt dự kiến: ai/prompts/I01-blue-vietnamese-labels.md; toàn văn thực gửi chưa xác minh | V00 overview | assets/stitch/I01/I01-overview-user-provided.png; review ai/critiques/I01-review.md | D04/D05/D06; chưa kiểm tra tương tác |
| I02 | ĐÃ CÓ ẢNH, ĐÃ REVIEW TỔNG QUAN | UX03/UX04/UX08: trạng thái và phục hồi | Prompt dự kiến ai/prompts/I02-states-recovery.md, toàn văn thực gửi chưa xác minh | I01 S05/S07, P00b S08 | assets/stitch/I02/I02-overview-user-provided.png; ai/critiques/I02-review.md | D08; tương tác chưa kiểm tra |
| I03 | ĐÃ CÓ ẢNH, ĐÃ REVIEW TỔNG QUAN | UX05: ngữ cảnh thêm mới/đã thêm | Prompt dự kiến ai/prompts/I03-context-actions.md; toàn văn thực gửi chưa xác minh | I01 S06 | assets/stitch/I03/I03-overview-user-provided.png; ai/critiques/I03-review.md | D09; đường đi và số đo chưa kiểm tra |

Drafts tại ai/prompts/I01-I03-drafts.md không phải bằng chứng iteration đã thực hiện.

## Mẫu ghi cho từng lần chạy thật

- Mã lần chạy / phiên bản:
- Công cụ / chế độ hoặc model hiển thị:
- Phiên bản đầu vào / mã màn hình:
- File prompt nguyên văn thực sự gửi:
- Ảnh đầu ra và liên kết project:
- Prompt đánh giá và phản hồi đầy đủ:
- Vấn đề gắn với từng màn:
- Đề xuất → chấp nhận/điều chỉnh/từ chối → lý do:
- Đường dẫn ảnh trước và sau:
- Kiểm tra lại: kết quả thực tế, chưa đo hoặc còn lỗi:
- Nút/khung Figma liên quan (chỉ thêm khi tồn tại):
- Slide tham chiếu và kết quả kiểm tra:

Nếu một prompt thất bại hoặc output thiếu màn, giữ nguyên lần thử và ghi rõ, không xóa để tạo lịch sử trông hoàn hảo.

## Lưu ý kích thước sau I02

Ảnh I02 cho thấy khung đang chọn 390×884, cần chuẩn hóa về 360×800 trong Figma và kiểm tra rộng 412. Không coi lời mô tả của Stitch là kết quả đo. Xem design/ui-selection.md.

## Kết thúc giai đoạn tạo sinh Stitch

Đã review ba vòng I01/I02/I03 khác mục tiêu với ảnh trước/sau. Chuyển Figma theo docs/figma-next-steps.md. I03 hiện khung chọn 390×1169; còn phải chuẩn hóa 360×800, layout 412 và kiểm tra UI thực.
