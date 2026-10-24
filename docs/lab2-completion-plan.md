# Kế hoạch hoàn thiện Power9 Lab 2

## Mục tiêu và phạm vi

- Nhóm thực hiện một bài Lab 2 chung, với hệ thống màn hình và tài liệu thống nhất.
- Giữ đủ bốn persona giả định: Minh / Campus, Huy / Desk Reset, Linh / Family Routine, chú Hùng / Active Age. Không gọi đây là khảo sát hay kết quả nghiên cứu.
- **Định hướng thiết kế của nhóm:** một ứng dụng Power9 chung, Linh là persona chính; ba persona còn lại là đối tượng bổ trợ và cơ sở so sánh. Quyết định D01 đã được ghi; chưa có nghĩa output UI đã được tạo hoặc kiểm thử.
- Không làm bốn ứng dụng, bốn design system hoặc bốn bộ 8 màn hình trong phạm vi này. Nếu giảng viên yêu cầu mỗi thành viên một hướng riêng, cần điều chỉnh phạm vi; đây là yêu cầu lớp chưa được xác minh.
- Đã chuẩn bị thêm brief, screen spec, ba sơ đồ flow, prompt và sổ bằng chứng; xem README.md. Đã có ảnh tổng quan V00 của 4 màn Stitch và bản phản biện đầy đủ C00. I01 xanh biển đang chờ chạy; chưa có đủ 8 màn, ba iteration hoàn tất hoặc kiểm chứng trực tiếp Figma.

## Hiểu đề bằng ngôn ngữ đơn giản

Lab 2 yêu cầu thiết kế một ứng dụng mobile có thể bấm thử và đủ đặc tả để lập trình viên làm tiếp. **Không yêu cầu code Flutter hoặc Firebase.**

Quy trình bắt buộc: Analyze → Generate → Critique → Refine → Prototype → Handoff.

1. Nói rõ người dùng là ai và họ cần giải quyết việc gì.
2. Liệt kê ít nhất 8 màn hình thực sự khác nhau và vẽ 3 luồng sử dụng.
3. Viết brief trước, dùng Stitch tạo UI ban đầu, giữ prompt và ảnh đầu ra.
4. Nhờ AI phản biện, tự quyết định sửa gì và thực hiện ít nhất 3 vòng cải tiến khác mục tiêu.
5. Dựng lại UI trong Figma bằng Auto Layout, tokens, component instances và states.
6. Nối 3 luồng bấm thử, có lỗi/phục hồi, Back, overlay và loading → result.
7. Viết tài liệu để người khác hiểu cách triển khai từng màn hình.
8. Nộp repo GitHub và Figma có quyền xem; dùng slide và demo để chỉ ra bằng chứng.

Bốn tab Home / Eat / Mind / Tribe trong ảnh cũ mới là bốn màn hình chính. Đổi màu, dialog, loading hoặc error của cùng một màn không làm tăng số màn hình được tính.

## Nguồn đã đọc và giới hạn xác minh

### Tài liệu đề và hướng dẫn

Đã trích xuất nội dung từ hai PDF và hai DOCX do người dùng cung cấp:

- D:/PRM393/PRM323 - Lab 2 AI-Assisted UI UX Design (Google Stitch → Figma).pdf
- D:/PRM393/PRM323 - Lab 2 Thiết kế UI UX có hỗ trợ AI (bản tiếng Việt).pdf
- D:/PRM393/PRM323_Lab2_HuongDan_Slide_Presentation_Demo.docx
- D:/PRM393/PRM323_Lab2_Presentation_Assessment_Guidelines_EN.docx

Đối chiếu yêu cầu bằng nội dung văn bản; chưa kiểm tra trực quan bố cục từng trang nguồn. Hai bản hướng dẫn slide nhất quán về cấu trúc và nói rõ thời lượng/số slide là đề xuất.

**Phân biệt nguồn quy định:**

| Nội dung | Nguồn / tính chất |
| --- | --- |
| ≥8 màn hình, ≥3 flow, ≥1 nhánh lỗi/phục hồi | Đề gốc, mục 3 và 6 |
| Một persona chính, problem statement, một tiêu chí đo được | Đề gốc, mục 6 |
| 6 page Figma, tokens, 9 nhóm component, prototype | Đề gốc, mục 7 |
| Handoff 6 mục/màn hình + 2 bảng mapping | Đề gốc, mục 8 |
| 10–12 slide; 10 phút nói + 5 phút demo + 5 phút hỏi đáp | Đề xuất tổ chức đánh giá trong DOCX, không phải yêu cầu thêm của đề gốc |
| Bài chung của nhóm; giữ 4 persona | Phạm vi sản phẩm của nhóm |
| Chọn Linh chính, bộ 8 màn hình và lịch triển khai bên dưới | Đề xuất để thực hiện kịp hạn, không phải quy định của đề |

Đề mặc định cá nhân trừ khi giảng viên cho làm nhóm. Kế hoạch theo thông tin người dùng rằng nhóm đang làm chung, không tự yêu cầu xin lại phép. Bản Việt trang 2 còn nêu chủ đề trùng cả chủ đề và persona với sinh viên khác không được duyệt; nhóm cần bảo đảm hướng của mình đúng phần đã đăng ký.

### Liên kết bài làm

| Nguồn | Kết quả đọc hiện tại | Việc cần làm |
| --- | --- | --- |
| Canva: https://www.canva.com/design/DAHYzh2uCJA/cfg_PRmah3I6yD7oADaQvw/edit | Công cụ web không đọc được cả edit và view; chưa biết nội dung slide hiện có | Người dùng mở để đối chiếu outline, hoặc cung cấp bản PDF export khi cần review slide |
| Figma: https://www.figma.com/design/xqBod46IwxD7E9thJZLWqr/Untitled?node-id=1-2 | Connector báo không có edit access phù hợp; chưa đọc được node/page | Chia sẻ view cho việc chấm; nếu muốn agent thao tác, tài khoản Figma kết nối cần quyền edit |
| GitHub: https://github.com/PhamQuangDuc1/PRM.POWER9 | Web fetch không thành công; remote origin của repo cục bộ khớp URL | Dùng repo cục bộ làm căn cứ; chưa xác minh HEAD local bằng HEAD remote |
| Google Sheets: https://docs.google.com/spreadsheets/d/1Lm-dNEH5ypcwLOlLD9JEvA4ZREfGWaCCxzrrnNwoz9U/edit?gid=386600675 | Công cụ web không đọc được edit/htmlview; chưa biết sheet ghi nội dung gì | Người dùng kiểm tra mục đăng ký/phân công nếu có; không suy đoán nội dung sheet |
| Stitch | Người dùng chưa tạo link; chưa xác minh project/output có sẵn | Mở project hiện có nếu ảnh cũ là từ Stitch; nếu chưa có, tạo project sau khi chốt brief |

Không kết luận các link Canva/Sheets là private chỉ từ lỗi truy xuất. Không kết luận Figma công khai không xem được chỉ từ lỗi connector. Phải kiểm tra quyền xem bằng cửa sổ chưa đăng nhập trước khi nộp.

## Khoảng trống của repo cục bộ

| Artifact | Hiện trạng quan sát | Cần hoàn thiện |
| --- | --- | --- |
| ux/persona.md | Đã cập nhật 4 persona theo chat | Chốt persona chính, không giả mạo Observed |
| ux/user-flow.md | Đã soạn IA, 3 sơ đồ và mapping sau lần kiểm tra đầu | Đưa vào Figma và kiểm tra các đường đi thật |
| design/DESIGN.md | Brief đã lưu trước lần chạy mới | Dùng làm đầu vào Stitch, đo lại UI output |
| design/screen-spec.md | Đã soạn bộ S01–S08 và state inventory | Đối chiếu với output thật |
| design/design-decisions.md | Đã ghi D01–D03 và checklist chưa kiểm tra UI | Bổ sung quyết định từ critique và số đo thật |
| ai/ai-design-log.md | Đã ghi V00 partial output và bản phản biện đầy đủ C00 | Thực hiện I01–I03, bổ sung 4 màn còn thiếu và lưu output |
| assets/stitch.md và assets/figma.md | Đã có index; ảnh tổng quan V00 lưu trong assets/stitch/V00/ | Bổ sung ảnh rõ từng màn, after iterations và Figma exports |
| handoff/flutter-handoff.md | Đã có đặc tả 8 màn × 6 mục và 2 mapping | Đối chiếu Figma cuối và kiểm tra khả năng đọc/triển khai |
| README.md | Chỉ tên repo | Tổng quan, persona chính, AI tools, Figma, bản đồ artifacts |
| Tên repo PRM.POWER9 | Khác mẫu đề prm323-lab2-<student-id> | Xác nhận quy ước nộp nhóm của lớp; chưa tự đổi tên repo remote |

## Bước đang thực hiện

Tạo bộ wireframe W00 mới theo ai/prompts/W00-wireframe.md và design/wireframe-spec.md; lưu ảnh để review trước khi tiếp tục I01 xanh biển. V00 và C00 đã được giữ làm bằng chứng initial UI và critique.

## Bộ 8 màn hình đề xuất cho một ứng dụng chung

Giữ bốn tab đang có trong wireframe để giảm làm lại. Mở rộng các màn con phục vụ thao tác thói quen, không thêm màn chỉ để đủ số.

| ID | Màn hình | Cấp điều hướng | Mục đích | Flow |
| --- | --- | --- | --- | --- |
| S01 | Home / Hôm nay | Top-level | Việc hôm nay, thời lượng, giờ nhắc, nút hoàn thành có nhãn | F1, F2, F3 |
| S02 | Eat / Ăn uống | Top-level | Ghi nhận thói quen ăn uống bằng thao tác ngắn; không mở rộng app công thức món ăn | F2 nhánh thay thế |
| S03 | Mind / Thư giãn | Top-level | Chọn phiên nghỉ ngắn, bắt đầu/kết thúc, ghi nhận | F2 happy path |
| S04 | Tribe / Kết nối | Top-level | Chọn hoạt động cùng người thân/bạn bè, ghi nhận đã thực hiện | F2 nhánh thay thế |
| S05 | Khám phá thói quen | Màn con từ Home | Lọc theo thời lượng, tìm hoạt động phù hợp | F1 |
| S06 | Chi tiết thói quen | Màn con từ Home/Khám phá | Mục tiêu, thời lượng, cách làm, thêm hoặc sửa lịch | F1, F3 |
| S07 | Thiết lập lịch thói quen | Màn con từ Chi tiết | Chọn ngày/giờ; thêm mới hoặc chỉnh lịch | F1, F3 |
| S08 | Lịch sử và tiến độ | Màn con từ Home/các tab hoạt động | Xem việc vừa hoàn thành và tiến độ đơn giản | F2 |

S07 thêm mới và sửa lịch dùng chung cấu trúc nhưng không tính thành hai màn hình. Dialog, loading, empty, error đặt cạnh màn tương ứng. Không thêm chat realtime, đăng nhập, backend, công thức món ăn hoặc dark theme vào phạm vi tối nay. Nội dung Tribe có thể là tương tác prototype về hoạt động kết nối; không gọi dữ liệu mẫu là người dùng thật.

### Ba flow cần vẽ và nối trong Figma

| Flow | Start → goal → end / happy path | Nhánh thay thế | Lỗi hoặc phục hồi |
| --- | --- | --- | --- |
| F1 — Tìm và thêm hoạt động ngắn | S01 → S05 lọc ≤5 phút → S06 → S07 lưu → S01 có hoạt động mới | Không phù hợp: quay về S05 đổi bộ lọc; hủy thêm quay lại chi tiết | Không có kết quả: reset bộ lọc; lưu lỗi: giữ lựa chọn và thử lại; có loading → kết quả |
| F2 — Hoàn thành và xem lại | S01 → S03 chọn hoạt động nghỉ ngắn → hoàn thành → S08 → S01 | Chọn hoạt động ăn uống ở S02 hoặc kết nối ở S04, ghi nhận rồi tới S08; hoặc check-in trực tiếp từ Home | Bấm nhầm: hoàn tác; dialog xác nhận hủy phiên khi đã bắt đầu |
| F3 — Đổi lịch khi bận | S01 → S06 của thói quen đã thêm → S07 sửa giờ → S01 thấy giờ mới | Hủy sửa: Back về S06 và giữ giờ cũ | Thiếu giờ: validation có nhãn; lưu lỗi: retry không mất lựa chọn |

Trong file user-flow.md phải vẽ ba sơ đồ thực sự; bảng này chỉ là kế hoạch, chưa thay thế deliverable sơ đồ. Mỗi flow có starting point riêng và mọi màn phải xuất hiện trong ít nhất một đường đi có thể bấm. Kiểm thử các nhánh phụ để S02 và S04 không thành màn trưng bày.

### Thể hiện đủ bốn persona trong cùng ứng dụng

| Persona | Thiết kế cần nhìn thấy | Nơi kiểm tra |
| --- | --- | --- |
| Minh | Check-in ngay Home, icon + nhãn hoàn thành, tuần đơn giản | S01, S08; đếm ≤3 thao tác |
| Huy | Giờ nhắc rõ, sửa nhanh, hủy sửa giữ lịch cũ | S01, S06, S07; đo <30 giây |
| Linh (đề xuất chính) | Thời lượng trên card, lọc 5/10 phút, form ngắn, xác nhận lưu rõ | S05–S07; đo tìm + thêm <60 giây |
| Chú Hùng | Chữ dễ đọc, nút có nhãn, không phụ thuộc cử chỉ ẩn, xác nhận trước xóa | S01, S08, dialog; đo tìm + hoàn thành <30 giây không hướng dẫn |

Bộ chữ lớn hơn cho chú Hùng có thể là lựa chọn thiết kế chung, không cần thêm một màn cài đặt chỉ để minh họa. Nếu prototype không có thao tác xóa, vẫn tạo destructive dialog variant trong component library theo đề và chỉ rõ phạm vi sử dụng; không bịa một luồng đã demo.

## Thứ tự triển khai

| Giai đoạn | Việc chính | Điều kiện kết thúc |
| --- | --- | --- |
| 1. Phân tích | Persona, IA, 8 màn, 3 flow, brief và screen spec | Đầu vào nhất quán trước khi chạy Stitch |
| 2. Initial UI | Tạo UI trong Stitch, lưu prompt và ảnh V00 | Bao phủ flow chính và có bằng chứng output |
| 3. Critique và refine | Ít nhất 5 findings; 3 vòng cải tiến khác vấn đề | Có before/after và quyết định gắn màn hình |
| 4. Design system | Tokens, 9 nhóm component, variants và Auto Layout | Component dùng token và màn dùng instances |
| 5. Final UI | Hoàn thiện wireframe và 8 màn Final UI | Đủ màn khác nhau, nội dung/states nhất quán |
| 6. Prototype | Nối 3 flow, Back, overlay, loading và recovery | Đi được từ start tới end, không ngõ cụt |
| 7. Kiểm chứng và handoff | Đo accessibility, 360/412, 6 mục mỗi màn và 2 mapping | Bằng chứng và đặc tả khớp UI |
| 8. Slide và demo | Chọn ảnh thật, liên kết nguồn, tập trình bày | Slide ngắn gọn, demo ổn định |
| 9. Bàn giao | Kiểm tra repo, Figma và quyền xem | Hai link nộp hoạt động, tồn tại được ghi rõ |

Ưu tiên hoàn thiện luồng và bằng chứng trước trang trí. Lưu phiên bản theo từng mốc công việc; không thay đổi lịch sử Git/Figma. Không đánh dấu đạt khi chưa kiểm tra.

## Stitch và ba vòng cải tiến

Chưa có link Stitch không đồng nghĩa chưa có project. Trước tiên tìm lại project tạo ảnh cũ và lưu lịch sử thật nếu còn; không tự ghi ngày hay nguồn công cụ cho ảnh chỉ dựa vào hình.

1. Chốt persona chính và lưu DESIGN.md.
2. Dùng prompt có người dùng, task, Android/mobile, 360×800, style, constraints, screen IDs và flow chính.
3. Lưu nguyên văn prompt, output screenshots và Run ID trong ai/ai-design-log.md.
4. Xin AI critique dựa trên Nielsen, accessibility và bốn persona; giữ nguyên toàn bộ câu trả lời.
5. Với mỗi ý quan trọng ghi accept / modify / reject + lý do + screen ID + ảnh.
6. Thực hiện ít nhất ba vòng cải tiến, mỗi vòng một vấn đề khác nhau. Các mục dưới đây là mục tiêu dự kiến, chỉ dùng nếu output thật có vấn đề tương ứng:

| Vòng | Vấn đề dự kiến | Thay đổi cần kiểm tra | Bằng chứng |
| --- | --- | --- | --- |
| I1 | Khó tìm hoạt động phù hợp thời gian của Linh | Thời lượng ngay card; filter rõ; CTA thêm nổi bật | S05/S06 trước–sau; thao tác tìm + thêm |
| I2 | Đổi lịch nhiều bước, khó biết đã lưu cho Huy | Đường sửa lịch ngắn, giờ cũ/mới và phản hồi rõ | S01/S07 trước–sau; đường đi và thời gian |
| I3 | Trạng thái khó đọc và phục hồi khó với Minh/chú Hùng | Nhãn + icon, contrast, target, retry/undo rõ | S01 và các state trước–sau; số đo và flow phục hồi |

Không tạo trước nội dung “đã phát hiện” hoặc ảnh after khi chưa làm thật. Nếu các vấn đề dự kiến không xuất hiện, chọn vấn đề khác có bằng chứng. Log tất cả công cụ AI đã dùng, gồm Codex hỗ trợ cập nhật persona/lập kế hoạch; không ghi Codex đã dựng UI khi chưa thực hiện.

Đề gốc yêu cầu bằng chứng Stitch và hai link nộp là GitHub/Figma; không có một yêu cầu riêng rằng thiếu link Stitch là tự động không đạt. Nên lưu URL project trong assets/stitch.md nếu có, nhưng prompt và ảnh mọi phiên bản mới là phần cần bảo toàn.

## Checklist Figma và handoff

### Chính xác sáu page theo thứ tự

1. 01 User Flow
2. 02 Wireframe
3. 03 Final UI
4. 04 Design System
5. 05 Components
6. 06 Prototype

Giữ nội dung các persona trong section/frame bên trong các page, không tạo thêm bốn page persona làm sai cấu trúc sáu page. Final UI có base frame 360×800 dp; kiểm tra thêm rộng 412 dp. Mô tả ≥600 dp trong handoff, không bắt buộc thiết kế thêm tablet.

### Tokens và components

Tokens gồm color, typography, spacing, radius, elevation; có light theme; component phải dùng Variables/styles phù hợp và màn dùng instances.

| Component | States tối thiểu theo đề |
| --- | --- |
| Button | Default, pressed, disabled, loading |
| Text field | Default, focused, filled, error, disabled |
| Card | Default, pressed nếu tappable |
| Navigation | Mỗi destination selected |
| App bar | Default, with actions |
| Dialog | Confirmation, destructive hoặc error variant |
| Loading | Ít nhất một pattern cấp màn hình |
| Empty | Icon/illustration, message, một action |
| Error | Message, nguyên nhân dễ hiểu, retry |

### Accessibility cần ghi kết quả thực tế

- Text contrast ≥4.5:1 cho chữ thường; ≥3:1 cho chữ lớn và UI controls theo yêu cầu đề.
- Touch target ≥48×48 dp; body text ≥14 sp.
- Không chỉ dùng màu truyền đạt thông tin.
- Auto Layout/constraints không làm vỡ layout ở 360 và 412 dp.
- Ghi screen/component ID, cặp màu hoặc kích thước đo và bằng chứng; chưa đo thì ghi chưa kiểm tra, không đánh pass.

### Handoff cho mỗi màn

Đủ layout, components/variants, states áp dụng, interactions/validation, navigation/Back, UI constraints (bàn phím, tràn chữ, độ dài, target, rộng ≥600 dp). Hai bảng toàn cục: tokens → ColorScheme/TextTheme/constants; components → Flutter widgets. Nhờ người khác đọc thử một màn nếu có thể, ghi câu hỏi còn thiếu và sửa.

## Dàn ý slide và kịch bản demo

10–12 slide là đề xuất của hướng dẫn, không phải yêu cầu thêm của đề. Nên dùng 12 slide dưới đây, nói khoảng 10 phút. Không cần mỗi persona có một bộ slide riêng.

| Slide | Thời gian | Nội dung cần nói | Minh chứng |
| --- | --- | --- | --- |
| 01 Overview | 30 giây | Một app Power9 chung, vấn đề, nhóm, vai trò | Repo + Figma |
| 02 Personas & Problem | 60 giây | Bốn persona giả định; persona chính; một tình huống và tiêu chí cho mỗi người | persona.md, bảng so sánh ngắn |
| 03 IA | 40 giây | 8 màn, top-level/nested | user-flow.md, page 01 |
| 04 Three Flows | 60 giây | Ba mục tiêu, nhánh thay thế, error/recovery | Sơ đồ và flow–screen table |
| 05 AI Generation | 40 giây | Brief trước Stitch, prompt đủ ngữ cảnh, initial output | DESIGN.md, prompt và ảnh thật |
| 06 Iterations & Critique | 70 giây | Ba vấn đề khác nhau; ≥5 findings theo màn | Before/after, full log |
| 07 Decisions | 45 giây | 3–5 ví dụ accept/modify/reject có lý do | design-decisions.md và Figma |
| 08 Wireframe → Final | 45 giây | Bố cục thay đổi để phục vụ persona; states | Page 02/03, 8 màn |
| 09 Design System | 45 giây | Token thật được component dùng; variants/instances | Page 04/05 |
| 10 Accessibility | 35 giây | Số đo contrast, target, type và 360/412 | Checklist và ảnh đo |
| 11 Prototype | 30 giây | Giới thiệu ba starting point và phần demo tiếp theo | Page 06 |
| 12 Handoff & Closing | 40 giây | Sáu mục/màn, hai mapping, kết quả và tồn tại thật | Handoff, repo và link nộp |

Tổng 600 giây. Rút bớt chữ trên slide; để full prompt, bản phản biện đầy đủ và bảng handoff trong repo. Trên slide 02 nói rõ “persona giả định, chưa khảo sát”; không báo số đo UX như kết quả nếu mới là mục tiêu.

### Demo 5 phút

- 00:00–00:30: chỉ đúng sáu page, bộ 8 màn và ba starting point.
- 00:30–01:40: F1 tìm hoạt động 5 phút, thêm, loading → kết quả; cho thấy lỗi lưu và retry.
- 01:40–02:30: F2 hoàn thành, lịch sử, undo; mở dialog overlay và đóng đúng.
- 02:30–03:10: F3 đổi lịch, hủy sửa/Back, lưu thành công.
- 03:10–04:00: mở component có Auto Layout/variants, chỉ token binding và instance trên màn.
- 04:00–04:30: mở một iteration: prompt → output → critique → decision → thay đổi thật.
- 04:30–05:00: mở repo và handoff, chỉ hai mapping cùng một màn đủ sáu mục.

Chuẩn bị trả lời: vì sao persona chính; bốn persona khác nhau ở UI chỗ nào; đề xuất AI nào bị từ chối; ba vòng sửa khác gì nhau; nếu đổi token thì phần nào cập nhật; lỗi nào phục hồi được; lập trình viên còn phải hỏi gì.

## Điều kiện bàn giao cuối

- [ ] Persona chính đã được xác định; đủ 4 persona giả định và tình huống cụ thể.
- [ ] ≥8 màn khác nhau; mỗi màn thuộc ít nhất một flow.
- [ ] ≥3 sơ đồ có start/goal/end, happy/alternate; ≥1 error/recovery.
- [ ] DESIGN.md có trước initial prompt mới; prompt và ảnh Stitch được lưu.
- [ ] ≥3 iteration thật có before/after; critique đầy đủ ≥5 findings theo màn.
- [ ] Decisions có lý do gắn persona/heuristics/constraints, không quá 10 quyết định chính.
- [ ] Figma đúng 6 page, light theme, tokens, 9 component groups và states/instances.
- [ ] 3 prototype flow có starting point; Back, overlay và loading → result hoạt động.
- [ ] Accessibility và responsive có bằng chứng thực tế.
- [ ] Handoff đủ 6 mục cho cả 8 màn; có hai bảng mapping và hành vi ≥600 dp.
- [ ] Thư mục handoff/ đúng tên; assets/stitch/ và assets/figma/ có ảnh thật.
- [ ] README có persona chính, AI tools, Figma và bản đồ artifacts.
- [ ] Đã kiểm tra cách đặt tên repo theo quy ước lớp; không tự coi tên hiện tại là đúng mẫu đề.
- [ ] Figma mở được chưa đăng nhập; GitHub và ảnh không bị chặn; kiểm tra thêm Canva nếu dùng trình bày.
- [ ] Git/Figma history phản ánh việc làm thật; không tạo log hoặc timestamp giả.
- [ ] Rehearsal slide + demo, biết nêu tồn tại nếu còn.
- [ ] Bàn giao đầy đủ; phần chưa đạt được ghi rõ, không đánh dấu hoàn tất toàn bộ.
