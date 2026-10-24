# W00 — Tạo bộ bố cục phác thảo Power9

Trạng thái: SẴN SÀNG CHẠY, chưa có đầu ra. Bộ phác thảo ít chi tiết (wireframe low-fi) độc lập với V00, không tính là vòng I01. Tạo bộ khung mới trong cùng project Stitch và giữ nguyên bốn màn xanh lá.

Sao chép nội dung khối text vào Stitch. Nếu không tạo đủ một lần, lưu kết quả và yêu cầu tiếp tục đúng các mã còn thiếu.

```text
Tạo MỘT BỘ WIREFRAME LOW-FI MỚI cho ứng dụng Android Power9 Family Routine trong project hiện có. Giữ nguyên toàn bộ màn UI hoàn thiện và bảng phong cách đang có. Bộ mới dùng để kiểm tra bố cục, nội dung và luồng trước khi chỉnh UI xanh biển.

Chỉ dùng trắng, xám nhạt, xám đậm và đen. Không dùng màu thương hiệu, gradient, ảnh thật, minh họa trang trí hoặc bóng đổ. Dùng khối chữ nhật, thẻ viền, biểu tượng đơn giản kèm nhãn; khung ảnh gạch chéo chỉ khi cần. Dùng nội dung tiếng Việt CÓ DẤU thật, không dùng chữ giả hoặc bỏ dấu trên thanh tiêu đề.

Một ứng dụng chung: persona chính giả định là Linh, phụ huynh bận rộn cần tìm và thêm hoạt động 5 phút. Persona hỗ trợ: Minh cần hoàn thành nhanh; Huy cần đổi lịch nhanh; chú Hùng cần chữ/nút rõ và dễ phục hồi bấm nhầm.

Tạo TÁM MÀN KHÁC NHAU, khung cơ sở 360×800 dp. Nội dung dài cuộn bên trong, không bị thanh điều hướng che. Nội dung 16, nhãn tối thiểu 14, vùng chạm tối thiểu 48×48, lề 16. Mã W00-Sxx chỉ nằm trong tên khung, không nằm trên thanh tiêu đề ứng dụng.

S01 — khung “W00-S01 Hôm nay”:
Thanh tiêu đề “Hôm nay”, lời chào ngắn và “1/3 thói quen đã hoàn thành”.
Có lối vào “Khám phá thói quen” và “Lịch sử và tiến độ”.
Danh sách gồm “Thở chậm · 5 phút · 20:30”, “Đi bộ nhẹ · 10 phút”, “Gọi hỏi thăm người thân · 5 phút”.
Việc chưa làm có nút “Hoàn thành” và lối xem chi tiết; một việc đã làm có dấu kiểm + “Đã hoàn thành” và “Hoàn tác”.
Thanh điều hướng dưới gồm biểu tượng VÀ chữ: Hôm nay / Ăn uống / Thư giãn / Kết nối.

S02 — khung “W00-S02 Ăn uống”:
Tiêu đề “Ăn uống”; hoạt động “Ăn chậm, chú ý cảm giác no”.
Thời lượng, hướng dẫn ngắn, một nút chính “Ghi nhận hoàn thành”, lối “Xem lịch sử”.
Thanh điều hướng chọn Ăn uống. Không thêm công thức, mục tiêu calo hoặc cam kết sức khỏe.

S03 — khung “W00-S03 Thư giãn”:
Tiêu đề “Thư giãn”; “Thở chậm · 5 phút”; bộ đếm viền đơn giản 05:00.
Nút chính “Bắt đầu”, hướng dẫn ngắn, lối xem lịch sử.
Trạng thái đang chạy/tạm dừng đặt thành biến thể riêng nếu cần, không hiện tất cả nút mâu thuẫn trên bản mặc định.
Thanh điều hướng chọn Thư giãn.

S04 — khung “W00-S04 Kết nối”:
Tiêu đề “Kết nối”; danh sách ngắn hoạt động ngoài đời như “Gọi hỏi thăm người thân · 5 phút”.
Có một hoạt động được chọn, nút “Ghi nhận hoàn thành”, lối “Xem lịch sử”.
Thanh điều hướng chọn Kết nối. Không tạo trò chuyện thời gian thực hoặc bạn bè trực tuyến giả.

S05 — khung “W00-S05 Khám phá thói quen”:
Quay lại; tiêu đề “Khám phá thói quen”; ô nhập có nhãn “Tìm thói quen”.
Bộ lọc “Tất cả”, “5 phút”, “10 phút”; mục 5 phút được chọn có dấu kiểm và viền.
Thẻ kết quả có tên, số phút, mô tả ngắn và “Xem chi tiết”.
Ví dụ: “Thở chậm · 5 phút”, “Gọi hỏi thăm người thân · 5 phút”.
Không đặt thông báo không có kết quả dưới danh sách đang có kết quả.

S06 — khung “W00-S06 Chi tiết thói quen”:
Quay lại; tiêu đề “Chi tiết thói quen”.
“Thở chậm”, thời lượng “5 phút”, mục đích ngắn, ba bước đánh số.
Ngữ cảnh CHƯA THÊM: một nút chính “Thêm vào hôm nay” dẫn S07.
Không vừa báo đã có trong lịch vừa bật nút thêm mới.
Ngữ cảnh đã thêm là biến thể riêng có giờ nhắc và “Đổi lịch”.

S07 — khung “W00-S07 Lịch thói quen”:
Quay lại; tiêu đề “Lịch thói quen”; hoạt động và thời lượng.
Chọn ngày, công tắc nhắc giờ có nhãn rõ; khi bật, có trường giờ với một giờ buổi tối đã chọn.
Một nút chính “Lưu lịch”; “Hủy” giữ dữ liệu cũ.
Bản mặc định hợp lệ không hiện lỗi thiếu giờ hoặc lỗi mạng. Tách thiếu giờ, đang lưu và lưu lỗi thành biến thể riêng.

S08 — khung “W00-S08 Lịch sử và tiến độ”:
Quay lại; tiêu đề “Lịch sử và tiến độ”.
Tổng số hoạt động hoàn thành trong tuần đơn giản, không biểu đồ trang trí.
Danh sách có ngày, tên hoạt động, số phút và dấu kiểm + “Đã hoàn thành”.
Nếu có xóa, dùng hành động phụ có nhãn mở hộp thoại xác nhận.
Không đặt thông báo rỗng trong danh sách có dữ liệu.

GIỮ CÁC ĐƯỜNG ĐI:
F01: S01 → S05 chọn 5 phút → S06 → S07 lưu → S01 có hoạt động mới và xác nhận rõ.
F02: S01 → S03 kết thúc phiên → S08; nhánh khác S02 hoặc S04 → S08; hoàn thành ngay Home có hoàn tác.
F03: S01 → S06 đã thêm → S07 đổi giờ → S01 hiển thị giờ mới; hủy giữ lịch cũ.

Sau tám màn cơ sở, đặt riêng các biến thể:
S05-empty: không có kết quả, một nút “Xóa bộ lọc”.
S07-validation: bật nhắc nhưng chưa chọn giờ, lỗi cạnh trường.
S07-saving: “Đang lưu…”.
S07-error: nguyên nhân dễ hiểu, “Thử lại”, giữ dữ liệu đã nhập.
S08-empty: chưa có bản ghi, một nút “Khám phá thói quen”.
O01: xác nhận thoát phiên; hủy quay lại phiên đang chạy.
O02: xác nhận xóa với “Giữ lại” / “Xóa bản ghi”.

Sắp tám màn thành hai hàng, mỗi hàng bốn khung có tên. Các trạng thái phụ ở khu vực riêng. Hộp thoại, bảng phong cách và biến thể không tính thêm màn.
Nếu giới hạn tạo sinh không cho đủ tám màn, ưu tiên S01/S05/S06/S07, báo rõ mã còn thiếu; không thay bằng onboarding/đăng nhập chung chung.
```
