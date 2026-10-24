# Bộ ảnh nguồn cho page 06 Prototype

## Đã xuất

Tám màn chính và sáu biến thể, render từ HTML Stitch ở chiều rộng 360 px. Font/CSS/ảnh đã tải, ảnh mẫu được kiểm tra. Không phải bộ UI giản lược agent đã dựng trong Figma.

- main/: tám màn chính, mỗi màn có ảnh full và viewport 360×800.
- states/: sáu trạng thái/biến thể, mỗi bản có full và viewport.
- render-manifest.json: nguồn HTML, kích thước và vị trí các control.
- xem-truoc.html: xem ảnh offline, không phải prototype đã nối tương tác.
- so-do-noi.md: đường đi và tọa độ tham khảo để đặt vùng bấm.
- SHA256SUMS.txt: kiểm tra tính toàn vẹn ảnh.

Đây là ẢNH TĨNH, không tự có interaction khi dán vào Figma. Chúng không đáp ứng thay cho lớp editable/component của Final UI. Chưa hoàn thành prototype theo đề chỉ nhờ xuất ảnh.

## Dán ảnh vào page 06

1. Dùng file main/*-full.png để không mất CTA nằm dưới vùng nhìn đầu tiên. File *-360x800.png chỉ thể hiện viewport đầu, có thể chưa thấy nút ở cuối nội dung.
2. Kéo tám ảnh full vào 06 Prototype, sắp S01–S08; dùng S06-new làm màn cơ sở, S06-existing là biến thể bên cạnh.
3. Mỗi ảnh đặt trong một frame 360×800; ảnh rộng 360 giữ chiều cao gốc, căn x=0/y=0, không kéo ép về cao800.
4. Bật Clip content cho frame; đặt overflow Vertical scrolling nếu ảnh cao hơn800. Cách này cho cuộn ảnh; để cố định app bar/nav như app thật phải tách lớp, không mặc định ảnh full có thể giữ chúng cố định.
5. Thêm hình chữ nhật làm hotspot có vùng chạm tối thiểu48×48 tại nút, đặt fill opacity0; giữ layer vẫn visible. Nối On click → Navigate to đúng frame.
6. Đối chiếu so-do-noi.md và tọa độ trong manifest. Tọa độ tính từ góc trên ảnh full trước khi cuộn.
7. Dialog dùng frame/hộp thoại riêng và Open overlay; loading phải có After delay đi tới kết quả.
8. Tạo ba starting point độc lập (có thể nhân bản Home cho từng flow), thử Back/Hủy/retry/undo.

Nguồn HTML vẫn có một số lỗi nhỏ đã ghi nhận như title cắt, mã kỹ thuật hoặc lời hứa sức khỏe. Bộ ảnh giữ nguồn, không được dùng để tuyên bố đã khắc phục những lỗi đó. Khi sửa Final UI, chỉnh trên lớp thật và export lại.
