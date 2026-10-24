# Bộ giao diện được chọn và phần cần hoàn thiện

## Tám màn chức năng

| Mã | Màn hình | Nguồn được chọn hiện tại | Ghi chú |
| --- | --- | --- | --- |
| S01 | Hôm nay | I01 xanh biển | Giữ đường khám phá/lịch sử và check-in |
| S02 | Ăn uống | P00b | Bỏ mã kỹ thuật ở title khi dựng Figma |
| S03 | Thư giãn | P00b | Bỏ mã title; cần active/paused/finished và hành vi thoát khi prototype |
| S04 | Kết nối | P00b | Bỏ mã title; không tạo thêm ứng dụng xã hội |
| S05 | Khám phá thói quen | I02 có kết quả | Giữ bản rỗng riêng |
| S06 | Chi tiết thói quen | I03: chưa thêm / đã thêm | Mặc định S06-new; bản S06-existing cạnh bên dùng cho đổi lịch |
| S07 | Lịch thói quen | I02 hợp lệ | Thiếu giờ/đang lưu/mất kết nối là state riêng |
| S08 | Lịch sử và tiến độ | I02 có dữ liệu | Rỗng riêng, sửa title còn sót ở bản rỗng |

Đường dẫn ảnh và review trong assets/stitch.md và ai/ai-design-log.md. Không chọn khung xanh lá làm bản UI cuối; giữ để chứng minh before/after.

## Chuẩn hóa trong Figma

- Có bằng chứng khung I02 là 390×884 và khung I03 là 390×1169. Kiểm tra toàn bộ và dựng base 360×800 theo đề, không co tất cả chữ/nút.
- Kiểm tra thêm rộng 412; dùng Auto Layout, constraints và vùng cuộn.
- Bỏ mã kỹ thuật khỏi chữ trên UI; chỉ đặt mã ở tên frame.
- Thống nhất thông tin mẫu, phông, spacing, component và token bindings.
- Tách default/loading/empty/error/validation thành đúng biến thể của màn cha; chúng không làm tăng số màn chức năng.
- Tạo dialog overlay và nối retry/reset/save/cancel/Back theo flow.
- Kiểm tra thông số, không đánh đạt chỉ vì prompt hoặc phản hồi Stitch nói đã đạt.
