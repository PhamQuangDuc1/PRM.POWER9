# I03 — Đánh giá ngữ cảnh thêm mới và đổi lịch

## Nguồn

Ảnh gốc: assets/stitch/I03/I03-overview-user-provided.png; có manifest SHA256.
Prompt dự kiến: ai/prompts/I03-context-actions.md; chưa xác minh toàn văn thực gửi từ ảnh.
Thu phóng 48%. Ảnh thấy hai bản S06 cạnh nhau, cùng một số màn I02 xung quanh.

## Đối chiếu UX05

| Ngữ cảnh | Quan sát sau I03 | Kết luận |
| --- | --- | --- |
| Chưa thêm | S06 bên trái có nút chính “Thêm vào hôm nay”, không thấy nhãn đã có trong lịch | Phân biệt được hành động thêm mới |
| Đã thêm | S06 bên phải có nhãn đã có trong lịch, giờ nhắc 20:30 và nút chính “Đổi lịch” | Phân biệt được ngữ cảnh sửa |
| Hai màn tương ứng | Cùng tên hoạt động, thời lượng và phần hướng dẫn | Hai biến thể S06, không tính thêm chức năng |
| Đường đi | Ảnh chỉ là bố cục | Chưa chứng minh dẫn sang S07 chế độ tạo/sửa, Hủy/Back hoặc không thêm trùng |

Mục tiêu chính I03 được cải thiện trên ảnh, có thể dùng I01 → I03 để đối chiếu. Ghi nhận đã có đầu ra và review vòng thứ ba; không tự đánh toàn bộ rubric đạt.

## Phần cần hoàn thiện trong Figma

- Khung đang chọn hiện **390×1169**. Cần viewport base 360×800 theo đề và vùng nội dung cuộn; không thu nhỏ toàn bộ khung để làm chữ/nút nhỏ đi.
- Hai khung đang được chọn có lớp hiển thị màu tím; chưa dùng ảnh này để kết luận bảng màu thực tế bị đổi. Kiểm tra fills thật sau khi bỏ chọn hoặc nhập Figma.
- S06 chưa thêm vẫn có hành động phụ thử ngay; cần bỏ nếu không thuộc luồng hoặc làm nó thứ cấp rõ để không cạnh tranh CTA thêm.
- Chuẩn hóa tiêu đề “Chi tiết thói quen”, nhãn, khoảng cách, nội dung mẫu và token trên toàn bộ màn.
- Không đưa mã kỹ thuật lên app bar.
- Không khẳng định các nội dung về sức khỏe là kết quả nghiên cứu; dùng hướng dẫn ngắn trong phạm vi ứng dụng và rà soát câu hứa hẹn tác dụng trước bản cuối.
- Kiểm tra font/target/contrast, layout rộng 412, component instances và prototype thực.

## Quyết định

Chọn hai biến thể S06 của I03 thay bản S06 I01. Bản mặc định trong bộ tám màn có thể là S06-new; đặt S06-existing cạnh nó để dùng F03. Dùng design/ui-selection.md làm bản đồ chọn nguồn.

Dừng tạo thêm bộ Stitch. Chuyển sang kiểm tra một màn nhập Figma trước, sau đó hoàn thiện các màn còn lại bằng cùng hệ component/tokens.
