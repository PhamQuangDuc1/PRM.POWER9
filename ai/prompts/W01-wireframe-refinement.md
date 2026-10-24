# W01 — Rút chữ và sửa tiêu đề wireframe

Trạng thái: SẴN SÀNG CHẠY, chưa có ảnh sau.
Ảnh trước: assets/wireframe/W00/W00-overview-user-provided.png.
Nhận xét: ai/critiques/W00-review.md, WF01–WF03.

Sao chép khối dưới vào cùng project Stitch. Giữ bản W00 làm đối chiếu, chỉ chỉnh bộ low-fi; không sửa UI xanh lá hoặc chạy chuyển xanh biển ở bước này.

```text
Chỉnh bộ WIREFRAME LOW-FI Power9 vừa tạo thành phiên bản W01. Giữ tám màn và các đường đi hiện có. Không chỉnh bộ UI hoàn thiện xanh lá V00. Không đổi wireframe sang xanh biển; tiếp tục dùng trắng/xám/đen, khối đơn giản.

MỤC TIÊU 1 — TÊN MÀN ĐÚNG:
Dòng “Quay lại” và tên màn phải là hai thành phần riêng trong thanh tiêu đề; không lặp “Quay lại Chi tiết thói quen” trên các màn khác nhau.
S01: Hôm nay.
S02: Ăn uống.
S03: Thư giãn.
S04: Kết nối.
S05: Khám phá thói quen.
S06: Chi tiết thói quen.
S07: Lịch thói quen.
S08: Lịch sử và tiến độ.
Mọi chữ có dấu. Mã W01-Sxx chỉ ở tên khung. Bốn màn cấp cao S01–S04 có điều hướng dưới đúng mục; màn con có Quay lại về đúng nguồn.

MỤC TIÊU 2 — CHỮ NGẮN, BỐ CỤC RÕ:
Wireframe cần chữ thật cho tên màn, tên hoạt động, số phút, giờ nhắc, nhãn trường và nút. Giữ nguyên các thông tin quan trọng này.
Mỗi mô tả thẻ chỉ tối đa một dòng ngắn; nếu có giải thích dài hơn, dùng 2–3 nét xám biểu diễn nội dung mở rộng thay vì chép cả đoạn.
S06: mục đích tối đa hai dòng; ba bước ngắn “Ngồi thoải mái”, “Hít vào nhẹ”, “Thở ra chậm”, mỗi bước một dòng; không cần cả đoạn hướng dẫn trong từng thẻ.
S04: các lựa chọn có tên + thời lượng; mô tả tối đa một dòng, không thêm khối lời khuyên dài dưới CTA.
S02: giữ tên, thời lượng và ba ý hướng dẫn ngắn; không làm nhỏ chữ để nhét nội dung.
S01: giữ check-in trực tiếp, phản hồi hoàn thành/hoàn tác và lối khám phá/lịch sử.
S05: giữ search có nhãn, bộ lọc thời gian, kết quả có số phút và “Xem chi tiết”.
S07: giữ ngày, công tắc nhắc giờ, trường giờ, Lưu/Hủy; không thêm bước biểu mẫu.
S08: giữ tổng tuần và ba bản ghi ví dụ có ngày; không thêm biểu đồ phức tạp.
Không dùng chữ giả cho nhãn hoặc thông báo cần người dùng ra quyết định.

MỤC TIÊU 3 — TRẠNG THÁI PHỤ RIÊNG:
Nếu các khung sau đã tồn tại ngoài vùng canvas đang thấy thì giữ chúng, không tạo trùng. Nếu chưa có, thêm ở một khu vực riêng:
S05-empty: không có kết quả, một nút “Xóa bộ lọc”.
S07-validation: bật nhắc nhưng thiếu giờ; lỗi cạnh trường.
S07-saving: “Đang lưu…”, chặn gửi lặp.
S07-error: lưu chưa thành công, “Thử lại”, giữ giá trị đã nhập.
S08-empty: chưa có bản ghi, nút “Khám phá thói quen”.
O01: xác nhận thoát phiên, hủy quay lại phiên.
O02: xác nhận xóa, “Giữ lại” / “Xóa bản ghi”.
Không trộn các trạng thái mâu thuẫn vào màn mặc định và không tính chúng thành màn thứ chín.

Giữ khung cơ sở 360×800, vùng chạm tối thiểu 48×48, chữ nội dung 16 và nhãn tối thiểu 14. Nội dung dài cuộn bên trong, không bị điều hướng che.
Sắp tám màn cơ sở theo thứ tự S01–S08 trong hai hàng bốn màn. Đặt các trạng thái phụ bên dưới, tên khung rõ để chụp bằng chứng.
Không tuyên bố đã đo accessibility hoặc nối prototype khi mới tạo bố cục.
```
