# Bàn giao triển khai Power9 Family Routine

## Trạng thái và phạm vi

Đặc tả triển khai dựa trên tám màn đã chọn, ba flow và các review. Đây là **đặc tả đích để hoàn thiện**, chưa xác nhận mọi chi tiết đã có trong Figma hoặc app đang chạy. Lab 2 không yêu cầu viết code Flutter.

Nguồn: design/DESIGN.md, design/screen-spec.md, design/ui-selection.md, ux/user-flow.md, design/component-spec.md. Khi Figma được chuẩn hóa, đối chiếu từng mục và ghi khác biệt trước khi bàn giao cuối. Không dùng ảnh Stitch để chứng minh đã có token binding hoặc tương tác hoạt động.

## Quy ước toàn cục

- Tất cả chữ UI bằng tiếng Việt có dấu, phông Be Vietnam Pro hoặc Roboto hỗ trợ đầy đủ dấu; base 360×800, kiểm tra 412.
- Vùng chạm ≥48×48, nút chính cao 52, lề 16; body 16/24, label ≥14/20.
- Frame ngoài cố định viewport, nội dung cuộn bên trong; thanh điều hướng không đè nội dung. Flutter dự kiến dùng Scaffold/SafeArea, vùng cuộn và tránh bàn phím.
- Trạng thái dự kiến: loading → populated/empty/error. Prototype mô phỏng loading có điểm kết thúc, không bẫy người dùng ở spinner.
- Dữ liệu mẫu thống nhất: Thở chậm 5 phút; nhắc ví dụ 20:30; Home tổng 1/3 là kịch bản có 3 occurrence hôm nay, không dùng cùng thời điểm với frame vừa thêm mà tổng không cập nhật.
- Mỗi bản ghi hoàn thành định danh theo habitId + ngày/occurrence; thao tác lặp không ghi trùng. Dữ liệu đã lưu tách draft biểu mẫu.
- Tên/giờ/gợi ý mẫu có thể đổi khi demo, nhưng phải khớp trong toàn flow. Không coi dữ liệu prototype là người dùng thật.
- Trong Figma các đường lỗi/retry/undo có thể dùng frame/variables mô phỏng, phải nêu rõ giới hạn; spec không chứng minh backend đã tồn tại.
- Màn con giữ returnOrigin, query/filter và trạng thái nguồn. O01/O02 đóng trở lại đúng context.
- 600 dp trở lên: căn giữa vùng đọc/form tối đa 600 dp với khoảng bên tối thiểu 24; navigation giữ bốn đích quen thuộc. Không bắt buộc thêm bản vẽ tablet trong Lab 2.

## Ánh xạ token sang Flutter

Tên dưới đây là **dự kiến**, không phải mã đã được triển khai. Các màu chữ khác nhau cần ThemeExtension/constants để tránh ép mất vai trò ngữ nghĩa.

| Token | Giá trị | Ánh xạ dự kiến |
| --- | --- | --- |
| background | #F5F8FD | ThemeData.scaffoldBackgroundColor / P9Colors.background |
| surface | #FFFFFF | ColorScheme.surface |
| text.primary | #152C46 | ColorScheme.onSurface |
| text.secondary | #4C627A | P9Colors.textSecondary |
| action.primary | #1E5AA8 | ColorScheme.primary |
| action.onPrimary | #FFFFFF | ColorScheme.onPrimary |
| surface.selected | #EAF2FC | ColorScheme.primaryContainer |
| border.control | #71839A | ColorScheme.outline |
| feedback.error | #A7332A | ColorScheme.error |
| type.title | 24/32, medium | TextTheme.headlineSmall; height 32/24 |
| type.heading | 20/28, medium | TextTheme.titleLarge; height 28/20 |
| type.body | 16/24, regular | TextTheme.bodyLarge; height 24/16 |
| type.label | 14/20, medium | TextTheme.labelLarge; height 20/14 |
| space.4 | 4 dp | P9Spacing.xs |
| space.8 | 8 dp | P9Spacing.sm |
| space.12 | 12 dp | P9Spacing.md |
| space.16 | 16 dp | P9Spacing.lg |
| space.24 | 24 dp | P9Spacing.xl |
| space.32 | 32 dp | P9Spacing.xxl |
| radius.input | 8 dp | P9Radius.input |
| radius.button | 12 dp | P9Radius.button |
| radius.card | 16 dp | P9Radius.card |
| elevation.0 | Không bóng | P9Shadows.none |
| elevation.1 | offset 0/2, blur 8, rgba(21,44,70,0.08) | P9Shadows.card: BoxShadow tương ứng |
| elevation.2 | offset 0/8, blur 24, rgba(21,44,70,0.16) | P9Shadows.overlay: BoxShadow tương ứng |

## Ánh xạ component sang widget

| Component Figma | Widget Flutter dự kiến | Biến thể và lưu ý |
| --- | --- | --- |
| P9/Button | FilledButton, OutlinedButton, TextButton | Default/pressed/disabled/loading; loading giữ kích thước, chặn lặp |
| P9/TextField | TextFormField | Default/focused/filled/error/disabled; label và lỗi rõ |
| P9/Card | Card + InkWell nếu có hành động | Default/pressed; semantics và vùng chạm |
| P9/Navigation | NavigationBar | SelectedIndex ứng với S01/S02/S03/S04 |
| P9/AppBar | AppBar | Default/actions; title và Back tách biệt |
| P9/Dialog | AlertDialog | Confirmation/destructive; barrier/cancel không xác nhận xóa |
| P9/Loading | Khung skeleton hoặc chỉ báo tải có nhãn | Pattern cấp màn, loading nút là biến thể riêng |
| P9/Empty | Column chứa icon, Text, một Button | Có hành động phục hồi phù hợp màn |
| P9/Error | Column hoặc vùng lỗi nội tuyến + Button | Nguyên nhân dễ hiểu, Thử lại giữ dữ liệu |

Chips thời gian và công tắc reminder là control phụ, dự kiến FilterChip và SwitchListTile; cũng phải dùng token, labels và state rõ.

## Đặc tả sáu mục cho từng màn

### S01 — Hôm nay

1. **Bố cục:** Scaffold → SafeArea → App bar → nội dung cuộn → thanh NavigationBar cố định. Nội dung gồm lời chào/tóm tắt, hai lối Khám phá và Lịch sử, danh sách thói quen. Lề 16, khoảng mục 16, khoảng thẻ 12. Thông báo hoàn thành xuất hiện trong màn và trạng thái thẻ được cập nhật.
2. **Thành phần:** P9/AppBar mặc định/có hành động; P9/Card mặc định/nhấn được; P9/Button loại chính hoặc chữ; P9/Navigation chọn S01; P9/Loading, Empty, Error theo tình huống.
3. **Trạng thái:** Đang tải; có việc hôm nay; không có việc với CTA Khám phá; lỗi tải có Thử lại; một việc hoàn thành có dấu kiểm + nhãn; trạng thái sau thêm mới hoặc đổi lịch. Không đặt empty trong danh sách có việc.
4. **Tương tác và kiểm tra dữ liệu:** Chạm Hoàn thành tạo bản ghi cho hoạt động/ngày, cập nhật tổng ngày và lịch sử. Hiện Hoàn tác trong 8 giây; hoàn tác xóa bản ghi vừa tạo và cập nhật tổng. Chạm lặp không tạo bản ghi trùng. Chạm Chi tiết mở S06-existing. Khám phá mở S05, Lịch sử mở S08.
5. **Điều hướng:** Điểm bắt đầu F01/F02/F03. Bốn tab đi S01–S04, giữ dữ liệu đã lưu. Sau thêm/sửa S07 về S01, hiển thị đúng kết quả. Back hệ thống ở top-level không tự xóa dữ liệu.
6. **Ràng buộc UI:** Tên hoạt động tối đa 80 ký tự dữ liệu; thẻ hiển thị tối đa 2 dòng, chi tiết đọc đầy đủ. Nút có nhãn không chỉ icon; vùng chạm ≥48. Ở 600 dp trở lên, nội dung căn giữa rộng tối đa 600; không kéo thẻ toàn màn hình.

### S02 — Ăn uống

1. **Bố cục:** Scaffold → App bar → nội dung cuộn gồm tên, thời lượng, hướng dẫn ngắn, CTA ghi nhận, lối lịch sử → NavigationBar cố định. Lề 16, thẻ bo 16, nội dung 16/24.
2. **Thành phần:** P9/AppBar; P9/Card hướng dẫn; P9/Button chính; P9/Navigation chọn S02; các pattern Loading/Empty/Error khi tải dữ liệu.
3. **Trạng thái:** Mặc định có hoạt động; đang ghi; đã hoàn thành; lỗi ghi giữ nội dung và Thử lại. Nếu không có hoạt động gợi ý, empty có CTA Khám phá. Không trộn có dữ liệu và rỗng.
4. **Tương tác và kiểm tra dữ liệu:** Ghi nhận hoàn thành tạo một bản ghi hoạt động/ngày, phản hồi rõ và mở S08 hiển thị bản ghi đó. Nếu đã ghi thì nút đổi thành trạng thái đã hoàn thành, không tạo trùng. Xem lịch sử mở S08 với nguồn S02. Không dùng dữ liệu mẫu để khẳng định tác dụng y tế.
5. **Điều hướng:** F02 nhánh ăn uống. Vào qua tab hoặc deep link nội bộ prototype nếu có. S08 Back về S02, giữ trạng thái đã ghi; đổi tab không mất bản ghi.
6. **Ràng buộc UI:** Bỏ mã I01 S02 khỏi app bar. Hướng dẫn tối đa 3 ý ngắn, mỗi ý cho xuống dòng; không co chữ. Ở ≥600 dp dùng cột đọc tối đa 600, không thêm sidebar ngoài phạm vi.

### S03 — Thư giãn

1. **Bố cục:** Scaffold → App bar → vùng cuộn chứa tên/thời lượng, bộ đếm, điều khiển, hướng dẫn, lối lịch sử → NavigationBar. Timer nằm trong nội dung, không che CTA khi phóng chữ.
2. **Thành phần:** P9/AppBar; P9/Button chính/phụ; P9/Card; P9/Navigation chọn S03; P9/Dialog xác nhận thoát O01; P9/Error khi ghi kết quả lỗi.
3. **Trạng thái:** Sẵn sàng 05:00; đang chạy; tạm dừng; kết thúc; lỗi ghi kết quả. Timer chuyển trạng thái theo hành động, không hiện tất cả nút xung đột cùng lúc. Prototype có thể dùng frame mô phỏng, phải nói rõ chưa có runtime.
4. **Tương tác và kiểm tra dữ liệu:** Bắt đầu chạy phiên; Tạm dừng giữ số giây còn lại; Tiếp tục chạy tiếp; Kết thúc ghi kết quả một lần rồi mở S08. Khi hết thời lượng, hiện kết thúc rõ. Rời tab hoặc Back khi phiên đang chạy/tạm dừng mở O01: Tiếp tục phiên giữ trạng thái, Xác nhận thoát bỏ phiên chưa hoàn thành và không ghi lịch sử. Nếu lưu kết quả lỗi, giữ kết quả để Thử lại, không bắt người dùng tập lại.
5. **Điều hướng:** F02 happy path S01 → S03 → S08 → S01; S08 Back về S03 đã kết thúc, không khởi động phiên mới. Điều hướng khi phiên active phải đi qua O01 trước khi đổi màn.
6. **Ràng buộc UI:** Bỏ mã title và các hứa hẹn % cải thiện sức khỏe chưa có nguồn. Chữ số timer dễ đọc nhưng không làm nút ngoài viewport; không bắt buộc animation. Reduced motion không ảnh hưởng thao tác. Ở ≥600 dp căn giữa nội dung, không đổi thao tác.

### S04 — Kết nối

1. **Bố cục:** Scaffold → App bar → nội dung cuộn gồm giới thiệu ngắn, danh sách lựa chọn có thời lượng, CTA ghi nhận và lối lịch sử → NavigationBar. Lựa chọn là hàng có icon/trạng thái + nhãn.
2. **Thành phần:** P9/AppBar; P9/Card nhấn được với chỉ báo chọn; P9/Button; P9/Navigation chọn S04; Loading/Empty/Error theo dữ liệu.
3. **Trạng thái:** Chưa chọn, đã chọn một hoạt động, đang ghi, đã ghi, ghi lỗi. Chưa chọn thì CTA disabled có giải thích ngắn. Empty có một hành động Khám phá, không danh sách giả đang trực tuyến.
4. **Tương tác và kiểm tra dữ liệu:** Chạm lựa chọn đổi selectedActivityId; chỉ chọn một hoạt động cho một lần ghi nhận. Ghi nhận tạo bản ghi đúng hoạt động/ngày, mở S08. Lỗi ghi giữ lựa chọn và cho Thử lại. Không gửi tin nhắn hoặc tương tác với người khác thật trong prototype.
5. **Điều hướng:** F02 nhánh kết nối. Tab chọn S04; Xem lịch sử mở S08 với nguồn S04. S08 Back về S04 giữ lựa chọn và trạng thái ghi nhận.
6. **Ràng buộc UI:** Bỏ mã I01 S04 khỏi tiêu đề. Chỉ báo chọn có icon/viền, không chỉ màu. Mô tả lựa chọn tối đa 2 dòng, tên tối đa 2 dòng. Ở ≥600 dp giữ cột nội dung tối đa 600.

### S05 — Khám phá thói quen

1. **Bố cục:** Scaffold → App bar có Quay lại → search có nhãn → bộ lọc thời gian → danh sách cuộn hoặc empty/error riêng. Không có bottom nav bắt buộc trên màn con. Lề 16; trường và chips không chồng nhau ở 360.
2. **Thành phần:** P9/AppBar có hành động Back; P9/TextField trạng thái mặc định/focus/filled; P9/Card; P9/Button chữ; P9/Loading, Empty và Error. Bộ lọc dùng chỉ báo chữ + dấu kiểm.
3. **Trạng thái:** Đang tải; danh sách có kết quả; rỗng do bộ lọc; lỗi tải có Thử lại. S05-populated và S05-empty riêng. Từ khóa và bộ lọc được giữ khi vào chi tiết rồi Back.
4. **Tương tác và kiểm tra dữ liệu:** Search lọc theo tên không phân biệt hoa/thường và có thể bỏ dấu khi so khớp; nhãn UI vẫn có dấu. Từ khóa tối đa 80 ký tự, khoảng trắng đầu/cuối bị bỏ khi tìm. Quy ước bộ lọc là thời lượng TỐI ĐA: ghi rõ '≤5 phút', '≤10 phút', 'Tất cả' trong bản cuối; hoạt động 3 phút thuộc ≤5 phút. Xóa bộ lọc đặt query rỗng và thời lượng Tất cả. Xem chi tiết mở S06-new hoặc existing theo việc đã lên lịch, không tự thêm.
5. **Điều hướng:** F01 S01 → S05 → S06. Back về S01. Back từ S06 khôi phục query/filter/vị trí cuộn của S05. Empty CTA reset tại chỗ, không đưa sang màn không liên quan.
6. **Ràng buộc UI:** Bàn phím search, action tìm; bàn phím đóng khi chọn kết quả, vùng cuộn tránh che nội dung. Tiêu đề được xuống dòng nếu cần, không thêm mã. Ở ≥600 dp giữ cột tối đa 600; màn cần chứa thẻ ≥48 target.

### S06 — Chi tiết thói quen

1. **Bố cục:** Scaffold → App bar có Back → nội dung cuộn: tên, thời lượng, trạng thái lịch nếu có, mục đích, ba bước → vùng CTA cuối. Giữ nội dung đủ gọn cho CTA dễ tiếp cận; có cuộn khi cần. Hai biến thể cùng bố cục.
2. **Thành phần:** P9/AppBar; P9/Card hướng dẫn; P9/Button chính; nhãn lịch có icon + chữ. Không cần tạo component/screen mới cho từng hoạt động.
3. **Trạng thái:** S06-new chưa lên lịch: không nhãn đã thêm, CTA Thêm vào hôm nay. S06-existing: nhãn Đã có trong lịch, giờ hiện tại, CTA Đổi lịch; không bật nút thêm trùng. Tải/lỗi tải chi tiết có pattern tương ứng.
4. **Tương tác và kiểm tra dữ liệu:** Thêm vào hôm nay mở S07(create, habitId), chưa ghi dữ liệu ở bước này. Đổi lịch mở S07(edit, scheduleId) có dữ liệu hiện tại. Nếu thói quen đã có lịch, nhận diện theo habitId/scheduleId chứ không chỉ tên. Không để Thử ngay cạnh tranh hành động thêm; bỏ khỏi prototype cốt lõi hoặc làm hành động phụ có đường đi rõ được đặc tả riêng.
5. **Điều hướng:** Từ S05 trở về S05 giữ filter; từ S01 trở về S01. S07 Hủy quay đúng S06-new/existing; S07 lưu thành công về S01. Chọn đúng variant cho F01 và F03, không đếm thành hai màn.
6. **Ràng buộc UI:** Tên tối đa 80 ký tự, mục đích tối đa 240, mỗi bước tối đa 160; trong UI phải wrap, không cắt mất hướng dẫn. Tránh ảnh hero quá cao. Nguồn I03 hiện 390×1169; rebuild viewport 360×800, không scale toàn bộ. ≥600 dp cột giữa tối đa 600.

### S07 — Lịch thói quen

1. **Bố cục:** Scaffold → App bar Back → nội dung cuộn biểu mẫu: tóm tắt hoạt động, ngày, lặp lại nếu có, công tắc nhắc, trường giờ → Lưu/Hủy. Lề 16, khoảng trường 16, lỗi cạnh trường tương ứng. Khi bàn phím/picker mở, CTA và trường còn truy cập được.
2. **Thành phần:** P9/AppBar; P9/TextField hoặc trigger time picker; P9/Button default/disabled/loading; P9/Card; P9/Loading/Error nội tuyến. Công tắc có nhãn và state rõ.
3. **Trạng thái:** Create/edit hợp lệ; validation thiếu giờ; saving; save-error. Không trộn valid với lỗi thiếu giờ/network. Dữ liệu draft tách dữ liệu đã lưu. Loading chỉ tạm thời, không ghi Home thành công trước kết quả.
4. **Tương tác và kiểm tra dữ liệu:** Create mặc định hôm nay, nhắc tắt; Edit điền lịch hiện tại. Bật nhắc yêu cầu giờ HH:mm hợp lệ 00:00–23:59 qua picker; tắt nhắc cho phép lưu không có giờ và xóa reminder ở dữ liệu lưu. Chọn ngày hôm nay hoặc tương lai, không tạo occurrence quá khứ. Nếu dùng lặp mỗi ngày, lưu quy tắc riêng, không giả dữ liệu đã hoàn thành. Lưu kiểm tra, chuyển saving, chặn gửi lặp; thành công cập nhật S01, lỗi giữ draft và cho Thử lại. Hủy không ghi draft; sửa lịch không tạo schedule trùng.
5. **Điều hướng:** F01 tạo và F03 sửa dùng cùng màn. Back/Hủy về S06 tương ứng, giữ dữ liệu lịch đã lưu; không đóng sang Home như đã thành công. Save-error hủy giữ lịch cũ. Lưu thành công → S01 có thông báo và dữ liệu mới.
6. **Ràng buộc UI:** Ngày/giờ dùng bộ chọn có nút Hủy/Xác nhận; không chỉ icon không nhãn. Lỗi thiếu giờ chỉ khi bật reminder; lỗi mạng không đồng thời gọi dữ liệu hợp lệ là sai. ≥600 dp form giữa tối đa 600, không kéo trường quá rộng.

### S08 — Lịch sử và tiến độ

1. **Bố cục:** Scaffold → App bar Back → vùng cuộn tổng tuần và danh sách bản ghi gần đây HOẶC empty/error. Nút xóa phụ từng bản ghi; empty có CTA Khám phá. Hiển thị 3 mục gần nhất trên bản mẫu, không ngụ ý chỉ có 3 bản ghi toàn bộ.
2. **Thành phần:** P9/AppBar; P9/Card; P9/Button chính/phụ; P9/Dialog destructive O02; P9/Loading, Empty, Error. Completion có icon + chữ.
3. **Trạng thái:** Có dữ liệu; rỗng với tổng 0 hoặc ẩn summary; đang tải; lỗi; dialog xác nhận xóa; danh sách sau xóa. Tuyệt đối không đặt thông báo chưa có hoạt động dưới danh sách có bản ghi.
4. **Tương tác và kiểm tra dữ liệu:** Tổng tuần tính trên dữ liệu thật, không giữ số 85% ngẫu nhiên. Nếu có % kế hoạch: completedOccurrences/plannedOccurrences ×100, làm tròn số nguyên; không có planned thì ẩn %. Xóa mở O02: Giữ lại không đổi dữ liệu; Xóa bản ghi xóa đúng occurrence, cập nhật tổng tuần và Home. Xóa hết → empty. Empty CTA mở S05. Lỗi xóa giữ bản ghi và có Thử lại; không âm thầm mất dữ liệu.
5. **Điều hướng:** F02 đích ghi nhận, cũng mở từ Home. Back về nguồn S01/S02/S03/S04; nếu từ phiên S03 thì về đã kết thúc. Khi từ empty đi S05, Back ở S05 cần biết nguồn S08 (ngoài F01 nguồn Home) để trả đúng ngữ cảnh.
6. **Ràng buộc UI:** Tiêu đề chỉ Lịch sử và tiến độ, không I01 S08. Tên bản ghi tối đa 2 dòng, ngày/giờ đọc được; xóa có vùng chạm ≥48. Từ nguồn I02 có khung 390×884 cần chuẩn viewport. ≥600 dp cột giữa tối đa 600, không tự thêm chart.

## Hộp thoại và chuyển trạng thái

| Mã | Nơi mở | Hành động | Kết quả |
| --- | --- | --- | --- |
| O01 | S03 khi rời phiên active/paused | Tiếp tục phiên / Xác nhận thoát | Giữ phiên / bỏ phiên chưa hoàn thành, không ghi lịch sử |
| O02 | S08 nút xóa bản ghi | Giữ lại / Xóa bản ghi | Giữ nguyên / xóa đúng bản ghi, cập nhật tổng và empty nếu hết |
| T01 | S07 Lưu hợp lệ | Saving → success | S01 hiển thị kết quả và xác nhận |
| T02 | S07 lưu lỗi | Error → Retry → Saving | Giữ draft, không tạo trùng, chỉ commit khi thành công |

Trong prototype có thể dùng chuyển sau 600–1000 ms để minh họa T01; đây là thời gian demo, không phải latency đo được. Có đường lỗi riêng để demo T02; không phải lỗi xuất hiện cùng successful state.

## Tiêu chí kiểm tra bàn giao

- [ ] Người khác đọc một màn và hiểu cấu trúc, controls, state, validation, navigation và constraints mà không hỏi thêm.
- [ ] Bộ token và component trong Figma khớp bảng; tên/ID thật được bổ sung khi truy cập được.
- [ ] Các bản 360×800 và kiểm tra 412 có bằng chứng; nội dung ≥600 dp được mô tả.
- [ ] Prototype ba flow có Back/Hủy, overlay, loading → result, retry/undo; không ngõ cụt.
- [ ] Màu thật/opacity, target, font được đo; chưa đo thì không ghi pass.
- [ ] Copy không lộ mã kỹ thuật hoặc khẳng định sức khỏe không có căn cứ.
- [ ] Đặc tả filter ≤5/≤10 và returnOrigin từ S08 được phản ánh trong UI/flow cuối.
