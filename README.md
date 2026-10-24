# PRM.POWER9

Lab 2: Thiết kế UI/UX di động có hỗ trợ AI, từ Google Stitch sang Figma. Nhóm làm một app Power9, Linh là persona chính; Minh, Huy và chú Hùng là persona hỗ trợ. Cả bốn là giả định, chưa khảo sát.

Lab 2 tập trung thiết kế UI/UX, prototype và handoff; không yêu cầu code Flutter.

## Tiến độ và bước tiếp theo

**Mốc mới nhất:** đã dựng nền tảng, 9 nhóm components, 8 màn 360×800 cùng states, 8 wireframe và 3 sơ đồ trong Figma. Chưa nối prototype/kiểm tra 412. MCP Starter vừa hết lượt, lệnh gom section chưa thực thi. Xem [mốc tiếp tục](docs/CONTINUE.md) và [mã node](assets/figma/phase-checkpoint.json).

### Nguồn Stitch đã lưu

Đã lưu I01 xanh biển và [review](ai/critiques/I01-review.md). Chọn bốn màn xanh biển S01/S05/S06/S07, giữ khung xanh lá làm đối chiếu. Wireframe chọn theo [bảng phiên bản](design/wireframe-selection.md).

Xem [đối chiếu yêu cầu Lab 2](docs/lab2-status.md). Không chạy lại wireframe hoặc I01; P00b đã có ảnh bốn màn bổ sung. I02 đã có ảnh và [review](ai/critiques/I02-review.md). I03 đã có [ảnh](assets/stitch/I03/I03-overview-user-provided.png) và [review](ai/critiques/I03-review.md). Bước tiếp theo: [chuyển một màn thử sang Figma](docs/figma-next-steps.md), không tạo thêm bộ Stitch. Xem [bộ UI được chọn](design/ui-selection.md).

## Quy trình giao diện với Stitch

1. Đọc [design brief](design/DESIGN.md).
2. Với project đã có V00, dùng [I01 sửa nhãn và đổi xanh biển](ai/prompts/I01-blue-vietnamese-labels.md). [P00](ai/prompts/P00-stitch-initial.md) được giữ làm nguồn initial xanh lá, không chạy lại để ghi đè bằng chứng.
3. Lưu prompt thực sự gửi, ảnh đầu ra và giờ chạy theo [hướng dẫn từng bước](docs/stitch-to-figma-guide.md).
4. Chạy critique trên output thật trước khi chọn ba vòng cải tiến. Không đánh dấu UI/iteration đã xong chỉ vì prompt đã soạn.

**Trạng thái:** có ảnh tám wireframe và tám bố cục UI xanh biển từ I01 + P00b, đã review C00/I01/I02/I03. Đã có ba vòng cải tiến với ảnh đối chiếu; còn chuẩn hóa khung 360×800, tokens/components, prototype, accessibility và handoff trong Figma/repo.

## Bản đồ deliverable và bằng chứng

| Nội dung | File |
| --- | --- |
| 4 persona, persona chính, mục tiêu UX | [ux/persona.md](ux/persona.md) |
| IA, 3 flow, mapping | [ux/user-flow.md](ux/user-flow.md) |
| Brief và tokens đề xuất | [design/DESIGN.md](design/DESIGN.md) |
| Wireframe low-fi mới | [design/wireframe-spec.md](design/wireframe-spec.md) |
| S01–S08 và states | [design/screen-spec.md](design/screen-spec.md) |
| Quyết định và accessibility status | [design/design-decisions.md](design/design-decisions.md) |
| Khai báo AI, run status, evidence | [ai/ai-design-log.md](ai/ai-design-log.md) |
| Initial, continuation, critique, iteration drafts | [ai/prompts/](ai/prompts/) |
| Stitch/Figma evidence indexes | [assets/stitch.md](assets/stitch.md), [assets/figma.md](assets/figma.md) |
| Sổ bằng chứng và giới hạn claim | [docs/evidence-register.md](docs/evidence-register.md) |
| Kế hoạch, slide và demo | [docs/lab2-completion-plan.md](docs/lab2-completion-plan.md) |
| Hướng dẫn Stitch → Figma | [docs/stitch-to-figma-guide.md](docs/stitch-to-figma-guide.md) |

Đã có [handoff đủ 6 mục cho 8 màn và 2 bảng ánh xạ](handoff/flutter-handoff.md), cùng [đặc tả chín nhóm component](design/component-spec.md). Đây là đặc tả đích, cần đối chiếu Figma sau khi dựng để xác nhận hoàn tất.

## Liên kết và công cụ

- [Figma của nhóm](https://www.figma.com/design/xqBod46IwxD7E9thJZLWqr/Untitled): nhóm xác nhận có 6 page; agent chưa kiểm tra trực tiếp cấu trúc do quyền connector.
- [Canva](https://www.canva.com/design/DAHYzh2uCJA/cfg_PRmah3I6yD7oADaQvw/edit): chưa review nội dung trực tiếp.
- [Checklist](https://docs.google.com/spreadsheets/d/1Lm-dNEH5ypcwLOlLD9JEvA4ZREfGWaCCxzrrnNwoz9U/edit?gid=386600675): đã đọc hai screenshot checklist của nhóm, chưa chỉnh sheet live.
- Stitch project: đã có ảnh canvas V00, chưa có link xác nhận.
- AI và công cụ hỗ trợ: Codex để đọc đề, phân tích, soạn Markdown/prompt và hướng dẫn. Google Stitch có bằng chứng V00; Codex đã critique ảnh overview C00; StitchDesign hỗ trợ rà soát brief; không có công cụ điều khiển Stitch được xác minh. Xem AI log.

Inventory chuẩn là S01 Hôm nay, S02 Ăn uống, S03 Thư giãn, S04 Kết nối, S05 Khám phá, S06 Chi tiết, S07 Lịch, S08 Lịch sử. Danh sách generic Onboarding/Login/... trong screenshot checklist cần cập nhật khi nhóm thao tác.

## Ngôn ngữ tài liệu

Tài liệu hiện hành và prompt mới dùng tiếng Việt có dấu. Xem [quy ước thuật ngữ và ngoại lệ nguồn gốc](docs/language-conventions.md). Các prompt/brief/báo cáo nguồn tiếng Anh được giữ nguyên để đối chiếu bằng chứng, không coi là lần chạy mới.
