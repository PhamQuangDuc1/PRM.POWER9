# I02 — Trạng thái nhất quán và phục hồi lỗi

Trạng thái: SẴN SÀNG CHẠY, chưa có ảnh sau.
Ảnh trước: I01 overview cho S05/S07; P00b overview cho S08.
Vấn đề: UX03/UX04 trong C00 và I01-review; UX08 trong P00b-review.
Chỉ xử lý ba màn và biến thể của chúng. Giữ các màn khác, không tạo lại toàn bộ bộ tám màn.

```text
Thực hiện vòng I02 của Power9 Family Routine: sửa TRẠNG THÁI MÂU THUẪN và PHỤC HỒI LỖI trên ba màn UI XANH BIỂN đang có:
S05 Khám phá thói quen, S07 Lịch thói quen, S08 Lịch sử và tiến độ.
Không chỉnh bộ wireframe đen–trắng W00/W01. Không tạo lại S01/S02/S03/S04/S06.

Ảnh hiện tại cho thấy:
S05 có thẻ kết quả nhưng đồng thời có khối không có kết quả.
S07 có giờ đã chọn, cảnh báo thiếu giờ và lỗi kết nối cùng lúc.
S08 có bản ghi hoàn thành nhưng đồng thời báo chưa có hoạt động.
Sửa dựa trên các vấn đề này, không đổi phong cách hoặc thêm tính năng.

BA MÀN CƠ SỞ ĐƯỢC CHỌN:
1. I02-S05-populated:
Tiêu đề UI “Khám phá thói quen”. Giữ ô tìm, bộ lọc 5 phút, thẻ kết quả và “Xem chi tiết”.
XÓA khối không có kết quả khỏi màn đang có kết quả.

2. I02-S07-valid:
Tiêu đề UI “Lịch thói quen”. Giữ ngày, nhắc giờ đang bật, giờ 20:30 hợp lệ, “Lưu lịch”, “Hủy”.
KHÔNG hiện lỗi thiếu giờ hoặc lỗi mạng trên bản hợp lệ này.

3. I02-S08-populated:
Tiêu đề UI “Lịch sử và tiến độ”. Giữ tổng tuần và ba bản ghi có ngày.
XÓA khối chưa có hoạt động và nút khám phá của empty state khỏi bản đang có dữ liệu.
Không đưa “I01 S08” hoặc mã kỹ thuật vào tiêu đề.

TẠO CÁC BIẾN THỂ RIÊNG, KHÔNG GHÉP VÀO BA MÀN CƠ SỞ:
- I02-S05-empty: giữ search/bộ lọc, không có thẻ kết quả; thông báo không có hoạt động phù hợp và một nút “Xóa bộ lọc”. Hành động này trở về kết quả sau khi bỏ bộ lọc.
- I02-S07-validation: nhắc giờ bật nhưng chưa chọn giờ; lỗi “Vui lòng chọn giờ nhắc” cạnh trường. Không đồng thời có lỗi mạng.
- I02-S07-saving: giữ dữ liệu đã chọn, nút “Đang lưu…” kèm chỉ báo và không cho gửi lặp. Chỉ thành công mới cập nhật Home.
- I02-S07-error: nguyên nhân “Chưa lưu được vì mất kết nối”; giữ giá trị đã nhập, nút “Thử lại”, có Hủy để về lịch cũ. Không hiện thông báo thiếu giờ khi đã có giờ.
- I02-S08-empty: không có bản ghi, tổng tuần bằng 0 hoặc ẩn phần tổng, thông báo “Chưa có hoạt động nào được ghi nhận”, một nút “Khám phá thói quen” dẫn S05.

Nếu phải tạo khung mới thay vì sửa đè, dùng đúng các tên I02 ở trên và giữ bản trước làm so sánh. Sắp ba màn cơ sở ở hàng trên, các biến thể ở khu vực dưới có nhãn riêng. Không tạo một màn ứng dụng dài chứa tất cả các lỗi/rỗng cùng lúc. Các biến thể không phải màn chức năng mới.

Giữ bảng màu: nền #F5F8FD, thẻ #FFFFFF, chữ chính #152C46, chữ phụ #4C627A, nút chính #1E5AA8, nền được chọn #EAF2FC, lỗi #A7332A. Mọi nhãn có dấu, Be Vietnam Pro hoặc Roboto; mã kỹ thuật chỉ ở tên khung.
Khung cơ sở 360×800, chữ nội dung 16, nhãn tối thiểu 14, vùng chạm ≥48×48; nội dung cuộn không bị che.
Không tuyên bố đã nối prototype hoặc đo accessibility khi mới tạo bố cục.
```
