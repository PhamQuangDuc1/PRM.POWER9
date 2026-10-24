# Bản mô tả thiết kế Power9 Family Routine

## Trạng thái tài liệu

Đây là đặc tả hiện hành cho hướng xanh biển. Bản mô tả xanh lá ban đầu được giữ nguyên tại design/versions/DESIGN-V00-green.md để đối chiếu nguồn. Nhóm thiết kế một ứng dụng chung, chọn Linh làm persona chính, ba persona còn lại hỗ trợ kiểm tra thiết kế. Công cụ AI hỗ trợ: Codex và kỹ năng StitchDesign.

Ảnh V00 chứng minh bốn màn xanh lá ban đầu. Vòng I01 xanh biển và việc kiểm tra accessibility trên giao diện thực tế chưa hoàn thành.

## Sản phẩm và người dùng

Power9 giúp chọn, lên lịch và ghi nhận các thói quen ngắn hằng ngày. Persona chính P03: Linh, 36 tuổi, nhân viên hành chính có con nhỏ, thường bị gián đoạn khi dùng Android và chỉ có khoảng nghỉ 5 phút. Mục tiêu UX đề xuất: từ Hôm nay, tìm và thêm một thói quen phù hợp trong dưới 60 giây.

Persona hỗ trợ: P01 Minh cần check-in tối đa 3 thao tác; P02 Huy cần đổi lịch dưới 30 giây; P04 chú Hùng cần chữ dễ đọc, nút có nhãn và hoàn thành hoạt động dưới 30 giây không cần hướng dẫn. Tất cả là persona giả định; các tiêu chí là mục tiêu, chưa phải kết quả đo.

Một ứng dụng chung, không có màn chọn persona và không chia thành bốn ứng dụng.

## Phạm vi màn hình

| Mã | Màn hình | Mục đích |
| --- | --- | --- |
| S01 | Hôm nay | Việc hôm nay, thời lượng, giờ nhắc, hoàn thành trực tiếp, mở khám phá/lịch sử |
| S02 | Ăn uống | Ghi nhận một thói quen ăn uống đơn giản |
| S03 | Thư giãn | Phiên nghỉ ngắn, thời lượng và điều khiển bắt đầu/kết thúc rõ |
| S04 | Kết nối | Ghi nhận hoạt động ngoài đời với người thân |
| S05 | Khám phá thói quen | Lọc theo thời gian và tìm hoạt động ngắn |
| S06 | Chi tiết thói quen | Thời lượng, hướng dẫn, thêm mới hoặc đổi lịch |
| S07 | Lịch thói quen | Biểu mẫu ngắn để tạo hoặc sửa lịch |
| S08 | Lịch sử và tiến độ | Hoạt động đã hoàn thành, ngày ghi nhận, tổng kết tuần đơn giản |

Điều hướng cấp cao: Hôm nay / Ăn uống / Thư giãn / Kết nối. S05–S08 là màn con, có Quay lại và giữ ngữ cảnh nguồn. Không ép thanh điều hướng bốn mục vào mọi biểu mẫu con. Mã màn hình phải khớp giữa prompt, ảnh, critique, Figma, slide và handoff.

Danh sách generic Onboarding/Login/... trong ảnh checklist là bản mẫu cũ; thay bằng bộ S01–S08 của sản phẩm. Không thêm đăng nhập chỉ để đủ tám màn.

## Định hướng thị giác

Giao diện chăm sóc thói quen bằng tiếng Việt, bình tĩnh, rõ và thực dụng. Nền trắng ngả xanh nhẹ, hành động chính xanh biển, thẻ trắng và khoảng trống rõ. Tránh gradient, biểu đồ trang trí, nhãn chữ hoa quá nhỏ và dashboard dày đặc. Mỗi màn có một hành động chính nổi bật theo ngữ cảnh. Toàn bộ nội dung giao diện có dấu, thống nhất “thói quen”, “phút”, “Đã hoàn thành”, “Thử lại”.

## Token ngữ nghĩa đề xuất

Token là giá trị thiết kế dùng chung. Tên kỹ thuật bên dưới giữ nguyên để ánh xạ Figma và Flutter. Chưa có nghĩa các giá trị đã được liên kết trong Figma Variables/styles.

| Token màu | Mã màu | Vai trò |
| --- | --- | --- |
| background | #F5F8FD | Nền chính |
| surface | #FFFFFF | Thẻ và biểu mẫu |
| text.primary | #152C46 | Chữ chính |
| text.secondary | #4C627A | Chữ bổ trợ |
| action.primary | #1E5AA8 | Nút chính, chữ/biểu tượng được chọn |
| action.onPrimary | #FFFFFF | Chữ trên nút chính |
| surface.selected | #EAF2FC | Nền mục hoặc bộ lọc được chọn |
| border.control | #71839A | Viền ô nhập, không dùng cho chữ nội dung |
| feedback.error | #A7332A | Nhãn và biểu tượng lỗi trên nền trắng |

Phông chữ: Roboto hoặc Be Vietnam Pro, hỗ trợ tiếng Việt. Tiêu đề lớn 24/32, tiêu đề mục 20/28, nội dung 16/24, nhãn 14/20; cặp số là cỡ chữ/chiều cao dòng. Nội dung tối thiểu 14 sp, ưu tiên 16 sp. Không cố định chiều cao khiến chữ có dấu hoặc nhãn dài bị cắt.

Khoảng cách: 4, 8, 12, 16, 24, 32 dp. Lề màn 16 dp, khoảng cách thẻ/nội dung 12–16 dp. Bo góc: ô nhập 8 dp, nút 12 dp, thẻ 16 dp.

Độ nổi: mức 0 phẳng; mức 1 bóng nhẹ 0/2/8 với rgba(21,44,70,0.08); mức 2 cho lớp phủ 0/8/24 với rgba(21,44,70,0.16). Thứ bậc vẫn phải rõ khi không nhìn thấy bóng.

Vùng chạm tối thiểu 48×48 dp, nút chính cao 52 dp. Màn cơ sở 360×800 dp, kiểm tra thêm rộng 412 dp. Nội dung dài cuộn bên trong, không bị thanh điều hướng hoặc bàn phím che.

## Tính trước độ tương phản của bảng màu

Các tỉ lệ dưới đây tính từ mã màu đề xuất bằng công thức độ chói tương đối WCAG, làm tròn hai chữ số. Đây chưa phải kết quả đo giao diện Stitch/Figma thực tế.

| Màu chữ / nền | Tỉ lệ |
| --- | --- |
| #152C46 / #FFFFFF | 14.18:1 |
| #4C627A / #FFFFFF | 6.30:1 |
| #FFFFFF / #1E5AA8 | 6.81:1 |
| #1E5AA8 / #EAF2FC | 6.03:1 |
| #A7332A / #FFFFFF | 6.67:1 |
| #4C627A / #F5F8FD | 5.91:1 |

Viền #71839A trên trắng: 3.88:1; không dùng màu này cho chữ nội dung cỡ thường. Đo lại màu, độ trong suốt và trạng thái thật trước khi đánh dấu đạt.

## Quy tắc nội dung và tương tác

- Thẻ hiển thị thời lượng bằng chữ: “Thở chậm · 5 phút”; có giờ nhắc nếu đã lên lịch.
- S01 có nút “Hoàn thành”; phản hồi dùng dấu kiểm + “Đã hoàn thành” và “Hoàn tác”.
- S05 có “Tất cả”, “5 phút”, “10 phút”; mục được chọn có dấu kiểm hoặc chỉ báo ngoài màu.
- S06 mới có “Thêm vào hôm nay”; S06 đã thêm có “Đổi lịch”. Không hiển thị hai ngữ cảnh mâu thuẫn.
- S07 chọn ngày, tùy chọn nhắc giờ và trường giờ. Chỉ bắt buộc giờ khi bật nhắc; lỗi nằm cạnh trường, lưu lỗi giữ dữ liệu.
- Thành công phải hiện trong nội dung màn đích, không chỉ một thông báo biến mất nhanh.
- S03 dùng “Bắt đầu”, “Tạm dừng”, “Tiếp tục”, “Kết thúc”. Bộ đếm trong prototype chỉ là minh họa hành vi.
- S04 ghi nhận kết nối ngoài đời, không mở rộng thành trò chuyện thời gian thực hay giả dữ liệu người dùng thật.
- S08 có ngày và tiến độ tuần đơn giản; xóa cần xác nhận, hủy giữ dữ liệu.
- Quay lại biểu mẫu trả đúng ngữ cảnh; không âm thầm lưu thay đổi.

## Hướng dẫn tương tác theo StitchDesign

Điều chỉnh kỹ năng cho ứng dụng này: mật độ 4/10, độ biến đổi bố cục 2/10, chuyển động 2/10. Ưu tiên thói quen sử dụng bị gián đoạn và khả năng đọc; không cần phần giới thiệu kiểu trang quảng cáo.

- Xanh biển #1E5AA8 là màu nhấn trang trí duy nhất; đỏ dành cho lỗi, luôn kèm chữ/biểu tượng.
- Nhãn ở trên ô nhập, trợ giúp/lỗi bên dưới; tiêu điểm nhập có viền rõ.
- Nút đang nhấn đổi sắc độ nhẹ; đang tải chặn gửi lặp và giữ ngữ cảnh hành động.
- Chuyển cảnh 120–200 ms khi phù hợp; không nhấp nháy lặp, chữ chạy hay trì hoãn danh sách. Chế độ giảm chuyển động dùng phản hồi ngay hoặc mờ nhẹ.
- Khung chờ tải bám hình dạng nội dung; rỗng/lỗi nêu rõ hành động tiếp theo.
- Không chồng lấp, phát sáng neon, ba cột thẻ chật, phần trăm trang trí hay câu quảng cáo chung chung.

Đây là đặc tả, chưa phải bằng chứng đã triển khai chuyển động hay chế độ giảm chuyển động.

## Trạng thái và phần Figma còn phải làm

Cần tách trạng thái mặc định/có dữ liệu, đang tải, rỗng, lỗi, thành công cạnh màn cha. Hộp thoại và biến thể không tính thêm màn.

Dựng component bằng Auto Layout và biến thể theo chín nhóm: nút, ô nhập, thẻ, điều hướng, thanh tiêu đề, hộp thoại, đang tải, rỗng, lỗi. Liên kết token và dùng instance. Chỉ nhập lớp từ Stitch chưa chứng minh có hệ thống thiết kế.

Ngoài phạm vi: code Flutter, backend, đăng nhập, kho công thức, mạng xã hội, tư vấn y tế, giao diện tối hoặc thiết kế riêng cho máy tính bảng.
