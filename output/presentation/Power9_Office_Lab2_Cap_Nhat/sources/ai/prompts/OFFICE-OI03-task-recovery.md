# OI03 — nhiệm vụ, dữ liệu và phục hồi

Người dùng xác nhận ngày27/10/2026 đã gửi nguyên văn100% prompt Office do trợ lý cung cấp trên dự án Stitch mới. Khối prompt bên dưới được giữ nguyên.

```text
VÒNG CẢI TIẾN OI03 — HOÀN THÀNH NHIỆM VỤ VÀ PHỤC HỒI LỖI.

Dùng đúng bộ 10 màn UI sau giảm mật độ, giữ bộ đó làm BEFORE. Giữ font đã sửa, palette xanh/trắng, logo gốc và cấu trúc 10 màn. Không thêm chức năng mới hoặc làm lại diện mạo. Mã frame chỉ ngoài canvas.

VẤN ĐỀ CẦN GIẢI QUYẾT
Home chỉ thấy 2 việc nhưng ghi1/3, còn Tiến độ có3 việc. Cần đồng bộ dữ liệu và phân biệt chưa thêm/đã thêm, lưu thành công/thất bại, hoàn thành/hoàn tác. Ảnh tĩnh hoặc nút chỉ đổi chữ chưa chứng minh người dùng đi hết task.

1. CHUẨN HÓA TRẠNG THÁI GỐC
S01 và S08 cùng ngày26/10/2026 và cùng3 hoạt động:
- 09:00 Viết một việc có ý nghĩa — đã hoàn thành.
- 10:00 Đi bộ giữa giờ — chưa hoàn thành.
- 17:30 Tổng kết công việc — chưa hoàn thành.
Tóm tắt cả2 là1/3 hoạt động đã chọn hoàn thành. Home hiện đủ3 hàng, không âm thầm ẩn việc đã xong. Có Hoàn tác cho việc hoàn thành. Hoàn tác cập nhật cả checkbox, danh sách lịch sử và số đếm; chỉ ghi dữ liệu mẫu, không tuyên bố backend thật.
Giữ tên hoạt động chính đầy đủ bằng wrap; không ellipsis ở S01/S07/S08. Header không đè nhãn nhóm khi cuộn. Thay placeholder P9 bằng đúng logo ảnh gốc nếu còn, không vẽ lại logo.

2. FLOW MAI — TÌM VÀ THÊM
S01 → S05 → nhóm Kết nối → S06-new Rủ đồng nghiệp đi bộ → S07-create → đang lưu → S01-added.
- S06-new chỉ có Chọn lịch thực hiện, không Đổi lịch.
- Ngày và giờ do người dùng chọn; chưa đồng bộ lịch công ty.
- Bật nhắc mà thiếu giờ: lỗi cạnh trường, giữ form, chưa lưu.
- Lưu lỗi: thông báo dễ hiểu, Thử lại/Hủy; giữ lựa chọn, không đổi Home.
- Thử lại → đang lưu → thành công, không thêm trùng.
- S01-added có việc mới12:00 chưa hoàn thành; S08 cùng snapshot là1/4, không vẫn1/3.
- Back từ S06 giữ nhóm/filter S05; Hủy form về đúng S06, không thêm việc.

3. FLOW HUY — THỰC HIỆN VÀ GHI NHẬN
S01 → tab S03 → Bắt đầu → đang chạy → tạm dừng/tiếp tục → kết thúc → ghi nhận → S08-updated.
- Tạo biến thể active/paused/finished với đúng CTA, chưa kết thúc thì không ghi nhận.
- Rời phiên đang chạy hoặc paused mở dialog xác nhận: Tiếp tục phiên / Bỏ phiên. Ở lại giữ đúng trạng thái trước dialog; bỏ không ghi nhận.
- Sau ghi nhận chỉ tạo1 bản ghi, Home và Tiến độ cùng dữ liệu. Không đánh hoàn thành bằng việc mở màn hoặc bấm Bắt đầu.
- Để demo nhanh có thể có hotspot trên canvas tới finished, không chèn nút kỹ thuật vào sản phẩm.

4. FLOW LINH — ĐỔI LỊCH KHI BẬN
Starting snapshot độc lập từ dữ liệu gốc1/3, không nối tiếp snapshot đã thêm của Mai.
S01 Tổng kết công việc17:30 → S06-existing → Đổi lịch → S07-edit18:00 → đang lưu → S01-rescheduled.
- S06-existing có Đổi lịch, không CTA thêm mới.
- Hủy giữ17:30; lỗi lưu giữ18:00 trên form nhưng Home giữ17:30.
- Thành công cập nhật18:00, không thêm bản sao, số đếm vẫn1/3.
- 18:00 trùng giờ yên lặng18:00–08:00: nói rõ thông báo sẽ không phát; vẫn có thể lưu hoạt động, không tự đổi giờ hoặc phá giờ yên lặng. Người dùng có thể sửa giờ/tắt nhắc trước khi lưu.

5. GIỚI HẠN VÀ TỔ CHỨC OUTPUT
Giữ đúng10 màn chức năng; states/dialog đặt cạnh màn cha, không tính là màn mới. Chỉ bổ sung variants cần cho3 flow và recovery nêu trên, tái dùng state đang lưu/lỗi thay vì nhân đôi vô ích. Tên frame nêu rõ flow và snapshot để không nhầm số đếm.
Không thêm banner, ảnh, slogan hoặc style board. Nội dung cuộn, target≥48×48, nhãn≥14, body16, base360×800 và kiểm tra412.

Nếu Stitch hỗ trợ nối tương tác, nối đúng3 flow với Back/Hủy/retry/undo và overlay. Nếu không hỗ trợ, chỉ tạo các frame/state cần thiết và bảng ánh xạ starting point→hành động→đích để nối trong Figma; không giả vờ đã có prototype chạy được.
Đầu ra: bộ sau OI03 với dữ liệu nhất quán và state đủ để review3 nhiệm vụ. Giữ BEFORE, dừng để tôi chụp và kiểm tra tổng thể.
```
