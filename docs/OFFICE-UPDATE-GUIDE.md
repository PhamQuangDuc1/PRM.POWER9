# Cập nhật Lab 2 — Power9 Office Routine

Ngày 26/10/2026. Hướng dẫn dựa trên PDF Lab 2 người dùng gửi, persona mới và nguồn UI Stitch đã lưu. Trạng thái: kế hoạch thực hiện và đầu vào sẵn dùng, không phải báo cáo đã hoàn tất Stitch/Figma. Người dùng cho biết thầy khá ưng UI hiện tại; vì vậy giữ phong cách xanh biển, typography, ảnh và card từ nguồn hiện có, chỉ chỉnh nơi nhu cầu mới đòi hỏi.

## 1. Chốt phạm vi

Tên: Power9 Office Routine. Đối tượng: nhân viên văn phòng 23–45 tuổi. Persona: Huy 28, Mai 24 và Linh 39 đều là persona chính ngang nhau; tất cả giả định. Chín nhóm theo gợi ý của thầy: Move Often, Sit Smart, Eat Well, Sleep Well, Manage Stress, Healthy Space, Social Bonds, Purpose, Work–Life Balance. Đây là hướng phát triển văn phòng có cảm hứng từ Blue Zones, không phải tên nguyên văn chín nguyên tắc gốc.

Giữ một ứng dụng chung; không chọn persona khi vào app. Người dùng tự chọn vài thói quen, không nhiệm vụ bắt buộc 9/9 mỗi ngày. Không thêm HR giám sát, bảng xếp hạng hoặc chat. Không biến logo mới thành lý do đổi toàn bộ phong cách.

## 2. Những yêu cầu đề cần bảo toàn

| Yêu cầu trong PDF | Cách áp dụng khi cập nhật |
| --- | --- |
| Mục 3: ≥8 màn khác nhau; ≥3 flow; ≥1 flow lỗi/phục hồi | Giữ inventory S01–S08, cập nhật ba flow trong ux/user-flow.md; không đếm dialog/state là màn |
| Mục 4: Analyze → Generate → Critique → Refine → Prototype → Handoff | Chốt persona/IA/brief trước lần chạy Stitch mới; dùng wireframe để phản biện và sửa bố cục trước UI |
| Mục 5: prompt nguyên văn, output, ≥3 vòng có vấn đề khác nhau | Tách nhánh Office; lưu before/after và prompt thật từng lần; đổi logo không tự tính thành một vòng UX |
| Mục 5: critique Nielsen + accessibility + persona, ≥5 phát hiện theo màn | Chạy trên ảnh Office thực tế, ghi accept/modify/reject + lý do; không bịa lỗi để đủ số |
| Mục 6: persona chính, thiết bị/accessibility, problem, tiêu chí đo | Cả ba là persona chính; mỗi người có thiết bị/accessibility, problem và tiêu chí riêng; chưa có kết quả đo |
| Mục 7: đúng 6 page Figma, 360×800, kiểm tra 360/412 | Giữ file hiện có; sửa các section theo phiên bản, không tạo page thứ bảy |
| Mục 7: tokens, Auto Layout, 9 nhóm component/state, instances | Logo là asset; ảnh import không thay editable UI, component phải sử dụng token thật |
| Mục 7: chữ ≥14 sp; target ≥48; contrast 4.5:1 và 3:1 theo loại | Kiểm tra lớp cuối, có ảnh/số đo; không suy ra đạt từ prompt |
| Mục 7: 3 starting point, overlay, loading → result | Nối cả Back/Hủy, retry/undo; lưu lịch phải cập nhật Home |
| Mục 8: 6 mục handoff/màn + 2 bảng mapping; mô tả ≥600 dp | Viết lại theo UI đã chốt; nhờ người khác dựng thử một màn và ghi chỗ cần hỏi |
| Mục 8–9: GitHub + Figma xem được; decisions ≤10 | Cập nhật README, log, link cuối; không đổi tên repo tự động |

PDF gốc nêu một persona chính; theo yêu cầu bổ sung của thầy do người dùng xác nhận, bài này dùng **ba persona chính ngang nhau**, mỗi người có nhiệm vụ và tiêu chí đánh giá riêng. Chín nhóm thói quen là nội dung đề tài theo gợi ý của thầy. Không cần code Flutter ở Lab 2.

## 3. Giữ UI hiện tại, sửa nội dung từng màn

Nguồn tham chiếu nằm tại assets/stitch/export-manifest.json và các ảnh trong assets/stitch/. Đó là baseline hình ảnh, chưa phải Office Final. Không lấy bộ HTML low-fi local vừa dựng thay UI thầy đã xem.

| Màn | Giữ | Cập nhật theo persona |
| --- | --- | --- |
| S01 Hôm nay | Header, nhịp card, giờ, hoàn thành/hoàn tác | Tên mới + logo; lịch văn phòng; đi bộ/kiểm tra tư thế/mục tiêu ngày; entry danh mục 9 nhóm |
| S02 Ăn uống | Bố cục hướng dẫn ngắn và ghi nhận | Eat Well: bữa trưa văn phòng, chọn hành động dễ thực hiện cho Mai |
| S03 Thư giãn | Timer và nút điều khiển | Manage Stress: phiên nghỉ sau họp; tránh đổi thành màn tư vấn sức khỏe |
| S04 Kết nối | Card hoạt động ngoài đời | Social Bonds: ăn trưa hoặc đi bộ với đồng nghiệp, tham gia tự nguyện |
| S05 Khám phá | Tìm kiếm, filter, card có thời lượng | Hiển thị đủ 9 nhóm với nhãn Việt, lọc nhóm + thời lượng; không nén vào một viewport |
| S06 Chi tiết | Ảnh, thời lượng, các bước, CTA theo ngữ cảnh | Nội dung đúng nhóm; thêm ví dụ Sit Smart/Healthy Space/Sleep Well/Purpose/Work–Life Balance; new và existing riêng |
| S07 Lịch | Form ngày/giờ, Lưu/Hủy | Ngày làm việc, nhắc tùy chọn, giờ yên lặng; có thể lên lịch chuẩn bị nghỉ ngoài giờ nếu người dùng chủ động chọn |
| S08 Tiến độ | Tổng tuần, danh sách ngày, empty | Lọc/theo dõi theo 9 nhóm; tổng trên việc tự chọn; riêng tư, không điểm tuổi thọ |

Khuyến nghị giữ bốn tab cũ Hôm nay / Ăn uống / Thư giãn / Kết nối để ít xáo trộn UI. S05/S08 vẫn là màn con từ Home. Đây là ba lối tắt phổ biến, không đại diện toàn bộ chín nhóm; mọi nhóm đều đến được qua Khám phá. Nếu kiểm thử cho thấy hiểu nhầm, mới cân nhắc điều hướng khác và ghi quyết định.

## 4. Thực hiện trong Stitch theo từng đợt

### Đợt A — baseline và wireframe

1. Mở project Stitch hiện có, giữ nguyên nguồn; lưu ảnh bộ xanh biển trước sửa. Đặt nhánh/nhóm mới Office nếu giao diện hỗ trợ; không giả định tên menu cố định.
2. Chuẩn bị persona mới, design/DESIGN.md và logo assets/brand/power9-logo-3d.png. Dùng ảnh UI đang được chọn làm tham chiếu thị giác; logo không cần render ở low-fi.
3. Gửi khối OW00 trong ai/prompts/OFFICE-stitch-update.md. Lần đầu chỉ tạo wireframe; kiểm tra đủ tám màn và chín nhóm.
4. Lưu prompt thực gửi, ảnh từng màn và overview; rồi dùng OC00 để phản biện. Ghi quyết định từng finding, sửa wireframe thành OW01. Nếu ảnh thiếu/khó đọc, chưa chốt review hình ảnh.

### Đợt B — UI từ wireframe đã sửa

5. Chỉ sau khi chốt OW01, gửi OU00 kèm wireframe, UI xanh biển baseline và logo. Dặn Stitch chuyển bố cục đã chốt sang phong cách cũ, không thiết kế lại toàn bộ.
7. AI phản biện UI thực tế và chọn ít nhất ba vòng cải tiến có vấn đề khác nhau. Gợi ý chủ đề: truy cập đủ chín nhóm; thao tác đổi lịch khi bận; phản hồi và phục hồi lỗi. Chỉ chọn khi finding thật chứng minh cần sửa, không chạy ba prompt mù. Có thể dùng vòng wireframe nếu đủ bằng chứng và được trình bày đúng giai đoạn; để dễ đối chiếu, nên có ba vòng UI được ghi rõ.
8. Mỗi vòng lưu BEFORE → prompt thật → AFTER → review → quyết định. Giữ bằng chứng cũ trong lịch sử, không đổi tên thành output mới.

Không có công cụ điều khiển Stitch được xác minh trong phiên này. Các khối prompt là bản chuẩn bị; người dùng thực hiện trên Stitch và cung cấp output để review. Không khẳng định đã chạy hoặc đã sửa canvas.

## 5. Chuyển sang Figma sau khi chốt Stitch

| Page đúng theo đề | Việc cập nhật |
| --- | --- |
| 01 User Flow | Ba sơ đồ Office và mapping: F01 Mai, F02 Huy, F03 Linh; cả ba là persona chính |
| 02 Wireframe | OW01 tất cả tám màn; không chỉ ảnh chụp, kiểm tra lớp editable |
| 03 Final UI | Bộ Office UI cuối 360×800; states cạnh màn cha; logo nguyên bản |
| 04 Design System | Giữ palette xanh phù hợp; chuẩn hóa color/type/spacing/radius/elevation bằng Variables/styles |
| 05 Components | 9 nhóm component và states bắt buộc; Auto Layout, token bindings; màn dùng instances |
| 06 Prototype | Ba starting point; Back đúng nguồn; overlay xác nhận; loading → thành công hoặc lỗi/retry |


Chín nhóm component tối thiểu của đề (khác với chín nhóm thói quen):

| Component | State/variant cần có |
| --- | --- |
| Button | default, pressed, disabled, loading |
| Text field | default, focused, filled, error, disabled |
| Card | default, pressed nếu bấm được |
| Navigation | Mỗi điểm đến ở trạng thái selected |
| App bar | default, có action |
| Dialog | xác nhận và một biến thể hủy hoặc báo lỗi |
| Loading | ít nhất một pattern cấp màn |
| Empty | icon/minh họa, thông báo, một hành động |
| Error | nguyên nhân dễ hiểu, hành động thử lại |

## 6. Bản đồ cập nhật toàn bộ hồ sơ

| Tệp/nhóm | Việc làm | Trạng thái ở lần hướng dẫn này |
| --- | --- | --- |
| ux/persona.md | Ba persona, bổ sung thiết bị/accessibility | Đã sửa |
| ux/user-flow.md | IA, ba sơ đồ và mapping cho chín nhóm | Đã sửa đặc tả đích, chưa kiểm thử |
| design/DESIGN.md | Brief giữ visual cũ + quy tắc logo | Đã sửa đầu vào Stitch |
| design/screen-spec.md | Tám màn và state theo bộ chín nhóm | Đã sửa đặc tả đích |
| design/wireframe-spec.md | Bố cục Office mới | Đã sửa đặc tả, chưa có output Stitch mới |
| design/ui-selection.md, wireframe-selection.md | Chọn ID/file output Office thật | Chờ chạy và review |
| design/design-decisions.md | ≤10 quyết định + kết quả kiểm tra accessibility | Chờ output, không tự đánh đạt |
| ai/ai-design-log.md + prompts/critiques | Ghi prompt, output, critique đầy đủ, before/after | Đã có bộ prompt nháp; log mới chờ chạy |
| assets/brand/ | Logo nguyên bản và quy tắc sử dụng | Đã lưu |
| assets/stitch/, assets/figma/ | Output Office thật, không sửa ảnh giả | Chờ tạo/export |
| handoff/flutter-handoff.md | 8 màn × 6 mục, 2 mapping, ≥600 dp | Chờ UI chốt; bản cũ chưa dùng nộp |
| design/component-spec.md | Đối chiếu variant/token mới với canvas | Cần cập nhật sau khi dựng |
| docs/lab2-status.md, evidence-register.md | Trạng thái theo bằng chứng mới | Cần cập nhật sau mỗi mốc; không lấy số lượng bản cũ chứng minh hướng mới |
| README.md, docs/CONTINUE.md | Link và mốc bắt đầu Stitch | Đã thêm hướng dẫn hiện hành |
| Slide/demo/output ZIP và scripts/figma | Thay persona, ảnh, logo, flow, nội dung demo | Chờ bộ UI cuối; file xuất cũ chưa đồng bộ |

Không cần viết lại lịch sử log/prompt cũ. Đặt liên kết hướng hiện hành, giữ lịch sử có ngày; chỉ gỡ nhãn lịch sử ở tài liệu đã thực sự đồng bộ.

## 7. Điều kiện để chốt và nộp

- Tám màn khác chức năng, chín nhóm được truy cập; 3 persona chính ngang nhau, mỗi người có nhiệm vụ và tiêu chí riêng; logo đúng nguyên bản.
- Có prompt và output Stitch mới; review ≥5 findings theo màn; ≥3 vòng vấn đề khác nhau, before/after và lý do quyết định.
- Ba flow bấm hết, có alternate/error; overlay và loading → result; Home/lịch/history nhất quán.
- Tokens/component/instances và các state bắt buộc hiện hữu trong sáu page Figma.
- Có số đo/ảnh 360 và 412, contrast, target ≥48, chữ ≥14; handoff mô tả ≥600.
- Handoff 6 mục/màn + 2 mapping, người khác dựng thử; GitHub/Figma mở được; slide chỉ nói những gì đã chứng minh.

Việc tiếp theo ngay bây giờ: mở Stitch, lưu baseline xanh biển và chạy **OW00**. Chưa chạy OU00 hoặc chuyển Figma trước khi phản biện và sửa wireframe.
