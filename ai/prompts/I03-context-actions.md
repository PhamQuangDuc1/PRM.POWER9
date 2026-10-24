# I03 — Hành động đúng ngữ cảnh thêm mới và đã thêm

Trạng thái: SẴN SÀNG CHẠY, chưa có ảnh sau.
Vấn đề UX05: S06 xanh biển I01 vừa báo đã thêm vừa bật nút thêm mới.
Ảnh trước: assets/stitch/I01/I01-overview-user-provided.png.
Vòng này chỉ chỉnh S06 thành hai biến thể, không tạo lại bộ tám màn hoặc bộ wireframe.

```text
Thực hiện vòng I03 của Power9 Family Routine: sửa NGỮ CẢNH HÀNH ĐỘNG trên màn Chi tiết thói quen S06 xanh biển. Màn cũ vừa ghi đã có trong lịch vừa hiện nút “Thêm vào hôm nay”; điều này làm Linh/Huy không biết mình đang thêm mới hay sửa lịch.

CHỈ TẠO HAI BIẾN THỂ CỦA S06:
Không sửa S01/S02/S03/S04/S05/S07/S08, các state I02 hoặc wireframe W00/W01.

1. Khung “I03-S06-new — Chưa thêm”:
Tiêu đề ứng dụng chỉ “Chi tiết thói quen”, có Quay lại.
Hoạt động “Thở chậm”, thời lượng “5 phút”, mục đích ngắn và ba bước rõ.
Không có nhãn đã có trong lịch, không có giờ nhắc cũ và không có nút đổi lịch.
Một nút chính “Thêm vào hôm nay”, dẫn sang S07 chế độ thiết lập lịch mới.
Có thể có hành động phụ “Quay lại”; không thêm một nút bắt đầu phiên để cạnh tranh với CTA thêm.

2. Khung “I03-S06-existing — Đã thêm”:
Cùng cấu trúc, tên hoạt động, thời lượng và hướng dẫn.
Có nhãn biểu tượng + “Đã có trong lịch”.
Hiển thị tóm tắt “Hôm nay · Nhắc lúc 20:30”.
Một nút chính “Đổi lịch”, dẫn S07 chế độ sửa giữ dữ liệu hiện tại.
Không hiển thị nút thêm mới đang bật; không cho người dùng hiểu sẽ thêm lại một thói quen đã có.

QUY TẮC CHUYỂN MÀN ĐỂ GHI CHÚ TRÊN CANVAS, KHÔNG NHÉT VÀO UI:
S05 Xem chi tiết → S06-new → S07 tạo lịch.
S01 Chi tiết → S06-existing → S07 sửa lịch.
S07 Hủy → S06 tương ứng, không đổi lịch cũ.
Lưu thành công → S01 hiển thị thói quen/giờ mới; lỗi lưu dùng các state I02 đã có.
Hai biến thể S06 không được tính thành hai màn chức năng khác nhau.

Giữ phông Be Vietnam Pro hoặc Roboto, chữ tiếng Việt có dấu. Giữ chủ đề xanh biển: nền #F5F8FD, thẻ #FFFFFF, chữ chính #152C46, chữ phụ #4C627A, nút chính #1E5AA8, nền chọn #EAF2FC.
Mã I03-S06-new/existing chỉ ở tên khung, tuyệt đối không xuất hiện trong thanh tiêu đề.
Tạo mỗi viewport ĐÚNG 360×800, không phải 390×884; nội dung dài cuộn trong viewport. Không thu nhỏ chữ để ép vừa: nội dung 16, nhãn ≥14, vùng chạm ≥48×48, nút chính cao 52, lề 16.
Nếu công cụ tạo khung mới thay vì sửa đè, giữ bản cũ để đối chiếu và đặt hai bản mới cạnh nhau.
Không tạo bảng phong cách mới. Không tuyên bố đã có backend ngăn thêm trùng hoặc prototype chạy khi chỉ tạo layout.
```
