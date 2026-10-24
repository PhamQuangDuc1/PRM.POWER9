# Sổ bằng chứng Power9 Lab 2

## Nguyên tắc

Mỗi claim cần source có thể mở lại. Bằng chứng người dùng cung cấp, artifact do Codex soạn và kết quả công cụ UI là ba loại khác nhau. Bản nháp không được ghi là đã chạy. Mục tiêu UX không phải kết quả kiểm thử.

## Bằng chứng hiện có

| ID | Loại / nguồn | Chứng minh | Không chứng minh |
| --- | --- | --- | --- |
| E01 | Ảnh checklist người dùng gửi, bản gốc trong assets/evidence/ | Nội dung inventory/checklist tại thời điểm chụp | Những màn generic đã có trong Figma |
| E02 | Ảnh cột checkbox người dùng gửi, assets/evidence/ | Một số bước đã đánh dấu Đã làm, cột xác nhận còn trống | Tất cả yêu cầu đã được kiểm thử |
| E04 | ux/persona.md, DESIGN.md, screen-spec, user-flow, prompt files | Đã chuẩn bị đầu vào thiết kế và truy vết persona | Actual output Stitch/Figma hoặc UX success |
| E05 | Capture test ngoài repo trong thư mục visualizations | Đã chụp và xem được cửa sổ foreground Codex 1920×1080 | Có thể tự điều khiển Stitch hay đã chụp Stitch |

E01/E02 được sao chép từ ảnh đính kèm, không phải agent tự mở Google Sheets. Manifest SHA256 đi kèm xác định tính toàn vẹn bản sao, không xác nhận nội dung đã thực hiện đúng.

## Bằng chứng V00 mới

- E06: assets/stitch/V00/V00-overview-user-provided.png, ảnh gốc nhóm cung cấp, có SHA256; thấy style board và 4 màn S05/S01/S07/S06.
- E07: ai/critiques/C00-response.md, bản đánh giá đầy đủ overview với 6 findings, có phạm vi/giới hạn rõ.
- I01-blue-vietnamese-labels.md mới là prompt dự thảo; chưa có ảnh AFTER.
- P00 xanh lá giữ nguyên; brief input được snapshot trong design/versions/DESIGN-V00-green.md, brief hiện tại chuyển xanh biển.

## Bằng chứng cần bổ sung

| Claim dự kiến | Cần source |
| --- | --- |
| Dùng Stitch tạo initial UI | Project URL nếu có, prompt gửi thật, screenshot prompt và output |
| Đã làm 3 iteration | Ba vấn đề khác nhau, submitted prompt, before/after theo screen ID |
| AI critique ≥5 findings | Full prompt/response, findings screen-specific, decisions |
| Đủ 8 màn | Tổng quan/từng frame thật S01–S08; dialog/state không tính |
| Design system hoạt động | Token binding và instances/variants/Auto Layout thực tế |
| Prototype chạy 3 flow | Starting points và chạy các đường đi, Back/overlay/loading |
| Accessibility đạt | Đo từ UI thật, không chỉ từ prompt |
| UX targets đạt | Task setup, người thử, thời gian/thao tác, kết quả và giới hạn |
| Link nộp hoạt động | Mở GitHub/Figma bằng trình duyệt chưa đăng nhập |

## Cách trình bày cho giảng viên

“Đây là quyết định → đây là nguồn prompt/ảnh → đây là phản biện → đây là điều tôi chấp nhận/sửa/từ chối → đây là thay đổi trong Figma.”

Với phần chưa xong: nói rõ “đã chuẩn bị, chưa chạy/kiểm tra”. Không dùng ảnh minh họa hoặc mockup do công cụ khác tạo để nhận là output Stitch. Khai báo Codex và các công cụ AI khác theo phạm vi dùng thật.

## Wireframe mới W00

Đã có assets/wireframe/W00/W00-overview-user-provided.png và manifest SHA256, chứng minh tám bố cục low-fi. Review: ai/critiques/W00-review.md. Chưa chứng minh cấu trúc editable, trạng thái phụ hoặc prototype. Đã có ảnh W01 tại assets/wireframe/W01/W01-overview-user-provided.png: bốn màn thay thế và bảng trạng thái. O02 bị cắt; chưa chứng minh overlay/prototype hoạt động. Bảng chọn: design/wireframe-selection.md.

## I01 — UI xanh biển

Ảnh gốc: assets/stitch/I01/I01-overview-user-provided.png, có manifest SHA256. Review: ai/critiques/I01-review.md. Chứng minh bốn màn xanh biển với tiêu đề/nhãn được cải thiện; không chứng minh đủ tám Final UI hoặc prototype chạy. Các màn xanh lá xen trong ảnh là phiên bản nguồn, không cộng thêm màn chức năng.

## P00b — Hoàn thiện độ bao phủ UI

Ảnh gốc assets/stitch/P00b/P00b-overview-user-provided.png, manifest SHA256, review ai/critiques/P00b-review.md. Ghép với I01 thể hiện tám chức năng UI khác nhau. Chưa chứng minh các trạng thái nhất quán, kích thước chính xác hoặc prototype hoạt động.

## I02 — Trạng thái tách riêng

Ảnh gốc assets/stitch/I02/I02-overview-user-provided.png và manifest SHA256; review ai/critiques/I02-review.md. Chứng minh cách biểu diễn trạng thái được tách, không chứng minh retry/loading hoạt động. Có nhãn 390×884 trên khung đang chọn; cần chuẩn hóa kích thước thật trong Figma.

## I03 — Ngữ cảnh thêm và đổi lịch

Ảnh assets/stitch/I03/I03-overview-user-provided.png, manifest SHA256, review ai/critiques/I03-review.md. Chứng minh hai biến thể S06 có CTA phù hợp. Có nhãn khung 390×1169, cần chuẩn hóa Figma; chưa chứng minh tương tác hoặc accessibility đạt.
