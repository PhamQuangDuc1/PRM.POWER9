# Đối chiếu tiến độ Power9 với đề Lab 2

## Kết luận

Quy trình hiện tại phù hợp hướng Analyze → Generate → Critique → Refine → Prototype → Handoff. Đã có đầu vào UX, output Stitch, phản biện và ba vòng UI có ảnh đối chiếu. Chưa hoàn thành bài và không được dùng số khung trùng trên canvas để chứng minh số màn cuối.

Stitch đang giữ nhiều bản trên canvas; bản cũ và bản mới cùng chức năng là phiên bản của cùng màn. Không bắt buộc công cụ sửa đè để chứng minh cải tiến. Khi nộp Figma phải chọn một bộ cuối rõ ràng, giữ nguồn/bản trước để đối chiếu.

## Bảng yêu cầu và bằng chứng

| Hạng mục đề | Bằng chứng hiện tại | Trạng thái |
| --- | --- | --- |
| Một persona chính, phát biểu vấn đề, tiêu chí đo được | ux/persona.md: Linh chính, ba persona hỗ trợ, tất cả giả định | Đã có tài liệu; tiêu chí UX chưa đo |
| IA, 3 sơ đồ, nhánh thay thế/lỗi, mapping | ux/user-flow.md | Đã có Markdown; Figma/prototype chưa xác minh |
| Brief trước initial UI, prompt và output Stitch | P00, brief xanh lá nguồn, V00 screenshot | Có nguồn và ảnh; cần xác nhận toàn văn prompt thực gửi |
| AI critique ≥5 vấn đề gắn màn | C00 có UX01–UX06, full review và decisions | Đã có bản đánh giá |
| ≥3 vòng cải tiến khác vấn đề, before/after | I01, I02, I03 có ảnh đối chiếu và review | Đã review tổng quan 3 vòng khác mục tiêu; còn xác minh prompt thực gửi và triển khai Figma |
| Wireframe mọi màn | W00/W01 và bảng chọn S01–S08 | Có ảnh bố cục tám màn; Figma editable chưa xác minh |
| ≥8 màn Final UI khác nhau | I01 S01/S05/S06/S07 + P00b S02/S03/S04/S08 | Đã có ảnh tám bố cục UI; còn sửa trạng thái/nội dung và kiểm tra Figma |
| Đúng 6 page Figma | Nhóm báo đã có, ảnh checklist | Chưa kiểm tra trực tiếp nội dung trong file |
| Tokens, Auto Layout, 9 nhóm component và states/instances | Brief và đặc tả | Chưa có bằng chứng Figma thực hiện |
| Accessibility, 360/412 | Palette đề xuất có phép tính; I02 có khung hiện 390×884 | Chưa đạt căn cứ viewport; cần chuẩn hóa 360×800 và kiểm tra 412 trong Figma |
| 3 prototype flow, Back, overlay, loading → result | Sơ đồ và kế hoạch | Chưa có bằng chứng bấm chạy |
| Handoff 6 mục/màn và 2 mapping | handoff/flutter-handoff.md đã có đủ 8 × 6 mục + 2 bảng | Đã soạn đặc tả đích; cần đối chiếu Figma và thử người khác đọc |
| Repo và Figma truy cập được | Repo cục bộ, link nhóm cung cấp | Chưa kiểm tra quyền xem cuối |
| Slide và demo | Dàn ý trong completion plan | Chưa xác minh slide hiện có |

## Bản nào được dùng

- Wireframe: S01–S04 W00, S05–S08 W01; xem design/wireframe-selection.md.
- UI hiện tại: chọn I01 S01/S05/S06/S07 và P00b S02/S03/S04/S08; khung xanh lá chỉ giữ làm nguồn đối chiếu.
- Không tính 8 wireframe + 4 UI thành 12 màn Final UI.
- Bảng phong cách, bảng trạng thái và dialog không được cộng vào tám màn.

## Đường đi tiếp, không tạo lại phần đã có

1. Không chạy lại W00/W01 hoặc I01.
2. P00b và I02 đã có ảnh, không chạy lại. I03 đã có ảnh và review; chuyển sang docs/figma-next-steps.md.
3. I02 đã tách các trạng thái; sửa mã title còn sót và kích thước khi dựng Figma, theo design/ui-selection.md.
4. Chọn hai bản S06 I03; không tạo thêm bộ Stitch.
5. Đưa bộ được chọn vào Figma; hoàn thiện tokens/components, responsive, prototype, kiểm tra và handoff.
6. Slide dùng ảnh và quyết định thật, không đưa toàn bộ canvas lộn xộn lên trình bày.

## Nguồn đối chiếu

Đề Lab 2 song ngữ do nhóm cung cấp: mục 3, 5, 6, 7, 8, rubric mục 9. Hướng dẫn slide là hình thức trình bày bằng chứng; không thay các deliverable bắt buộc. Xem docs/lab2-completion-plan.md để tìm tên tài liệu nguồn và dàn ý slide.

## Cập nhật triển khai Figma qua MCP

Đã dựng 8 màn 360×800 cùng states, 9 component sets/30 variants, 29 variables, 4 text styles/2 effect styles và 144 instances. Đã có 8 wireframe và 3 sơ đồ native trên page 01/02. Chưa có prototype hoặc kiểm tra 412 toàn bộ. Mã node và điểm dừng nằm trong assets/figma/phase-checkpoint.json. Lệnh gom section bị hạn mức MCP Starter chặn, chưa thực thi; không đánh dấu bài hoàn tất.
