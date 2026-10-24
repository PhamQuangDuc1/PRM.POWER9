# Các prompt cải tiến dự thảo

Trạng thái: CHƯA CHẠY. Bộ này đã đồng bộ mục tiêu với critique C00. I01 có file sẵn để chạy; I02/I03 cần điền phiên bản thật sau vòng trước. Lưu bản thực gửi riêng nếu chỉnh nội dung. Ảnh trước/sau phải từ đầu ra thật.

## I01 — Ngôn ngữ và nhận biết tác vụ

Dùng ai/prompts/I01-blue-vietnamese-labels.md, xử lý UX01/UX02/UX06 và yêu cầu đổi màu xanh biển. Đổi màu không được tính riêng là một vòng UX.

## I02 — Tính nhất quán của trạng thái và phục hồi lỗi

```text
Chỉ chỉnh [mã màn/phiên bản thật] của Power9. Xử lý UX03/UX04 đã thấy trong V00 và xác minh lại còn tồn tại ở bản hiện tại.
Tách S05 có kết quả khỏi S05 không có kết quả; tách S07 mặc định hợp lệ, thiếu giờ, đang lưu và lưu lỗi. Không đồng thời hiển thị phản hồi mâu thuẫn.
Không có kết quả phải có “Xóa bộ lọc”. Chỉ báo thiếu giờ khi bật nhắc và chưa chọn giờ. Lưu lỗi giữ giá trị đã nhập và có “Thử lại”; hủy không thay lịch cũ.
Giữ bảng màu xanh biển đã duyệt, nhãn tiếng Việt có dấu, mã màn và luồng đúng. Không sửa bộ wireframe W00.
Kiểm chứng: [mô tả các ảnh trạng thái và đường đi thật cần kiểm tra]. Không tuyên bố tương tác đã hoạt động chỉ từ ảnh.
```

## I03 — Hành động chính đúng ngữ cảnh

```text
Chỉ chỉnh [mã màn/phiên bản thật] của Power9. Xử lý UX05: màn chi tiết vừa báo đã thêm vừa bật nút thêm mới.
Tạo hai ngữ cảnh riêng của S06: chưa thêm có một hành động chính “Thêm vào hôm nay”; đã thêm hiển thị lịch hiện tại và một hành động chính “Đổi lịch”, không cho thêm trùng qua nút thêm đang bật.
Đi tới S07 ở đúng chế độ tạo/sửa; Quay lại và Hủy không thay dữ liệu đã lưu. Không đếm hai biến thể S06 thành hai màn độc lập.
Giữ màu, nhãn và bố cục đã duyệt; không sửa bộ W00.
Kiểm chứng: [ảnh hai ngữ cảnh, trạng thái S07 và đường đi trước/sau]. Không khẳng định đã ngăn thêm trùng ở backend vì đây chỉ là prototype.
```

Nếu vòng trước đã sửa một vấn đề, đánh giá lại để chọn mục tiêu khác có bằng chứng; không tạo lại lỗi để đủ ba vòng.
