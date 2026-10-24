# Ba luồng cần nối trong Figma

Các mũi tên dưới đây là hướng dẫn, CHƯA phải kết nối đã tồn tại trong file.

## F01 — Thêm hoạt động
S01 Khám phá → S05 Xem chi tiết → S06-new Thêm vào hôm nay → S07 Lưu lịch → S07-saving → S01 kết quả thêm.

- Không có kết quả: S05-empty → Xóa bộ lọc → S05.
- Thiếu giờ: S07-validation → Chọn giờ → S07.
- Lỗi lưu: S07-error → Thử lại → S07-saving → kết quả thành công.
- Kết quả Home sau thêm cần dựng state tương ứng, không dùng ảnh Home gốc để khẳng định đã phản ánh dữ liệu mới.

## F02 — Hoàn thành và xem lại
S01 → S03 Bắt đầu → trạng thái phiên active/paused → Kết thúc → S08 có bản ghi.
Nhánh khác: S02 hoặc S04 Ghi nhận hoàn thành → S08.
Thoát phiên phải có dialog O01; xóa bản ghi có dialog O02. PNG S03 hiện chỉ có bản sẵn sàng, các state active/paused/finished vẫn cần dựng hoặc tái sử dụng từ Figma. Chưa có bằng chứng nối chúng.

## F03 — Đổi lịch
S01 Chi tiết → S06-existing Đổi lịch → S07 sửa giờ → S07-saving → Home có giờ mới.
Hủy giữ lịch cũ; Back trả đúng màn nguồn.
Bản S07 ảnh hiện có là một trạng thái minh họa; phải dựng kết quả thay đổi giờ nhất quán khi demo.

## Hotspot tham khảo từ DOM nguồn

Tọa độ bên dưới theo ảnh full rộng360; vùng nhỏ hơn48 phải mở rộng khi làm hotspot. Chưa kiểm thử click trong Figma.

| Màn | Nhãn control nguồn | x | y | rộng | cao |
| --- | --- | --- | --- | --- | --- |
| S01 | notifications | 260 | 8 | 48 | 48 |
| S01 | add_circle Khám phá Thêm thói quen mới | 16 | 256 | 158 | 118 |
| S01 | history Tiến độ Lịch sử 7 ngày qua | 186 | 256 | 158 | 118 |
| S01 | more_horiz | 288 | 552 | 48 | 52 |
| S01 | check Hoàn thành | 32 | 622 | 205 | 52 |
| S01 | Chi tiết | 245 | 622 | 83 | 52 |
| S01 | Hoàn tác | 249 | 719 | 78 | 48 |
| S01 | more_horiz | 288 | 821 | 48 | 48 |
| S01 | check Hoàn thành | 32 | 890 | 296 | 52 |
| S01 | close | 286 | 992 | 48 | 48 |
| S01 | home Hôm nay | 16 | 1126 | 68 | 49 |
| S01 | restaurant Ăn uống | 108 | 1126 | 64 | 49 |
| S01 | self_improvement Thư giãn | 196 | 1126 | 66 | 49 |
| S01 | groups Kết nối | 287 | 1126 | 57 | 49 |
| S02 | notifications | 244 | 8 | 48 | 48 |
| S02 | check_circle Ghi nhận hoàn thành | 32 | 900 | 296 | 52 |
| S02 | auto_graph Xem lịch sử thói quen ăn uống local_fire_department 7 ngày liên tiếp duy trì chánh niệm chevron_right | 16 | 992 | 328 | 86 |
| S02 | today Hôm nay | 16 | 1246 | 64 | 48 |
| S02 | restaurant Ăn uống | 104 | 1246 | 64 | 48 |
| S02 | self_improvement Thư giãn | 192 | 1246 | 64 | 48 |
| S02 | diversity_3 Kết nối | 280 | 1246 | 64 | 48 |
| S03 | notifications | 244 | 8 | 48 | 48 |
| S03 | play_arrow Bắt đầu phiên | 40 | 534 | 280 | 52 |
| S03 | history Xem lịch sử các phiên thư giãn Tổng cộng 32 buổi · 160 phút tích lũy chevron_right | 16 | 1098 | 328 | 88 |
| S03 | today Hôm nay | 16 | 1322 | 64 | 48 |
| S03 | restaurant Ăn uống | 104 | 1322 | 64 | 48 |
| S03 | self_improvement Thư giãn | 192 | 1322 | 64 | 48 |
| S03 | diversity_3 Kết nối | 280 | 1322 | 64 | 48 |
| S04 | notifications | 244 | 8 | 48 | 48 |
| S04 | check_circle Ghi nhận hoàn thành | 16 | 1081 | 328 | 52 |
| S04 | history Xem lịch sử gắn kết gia đình | 16 | 1141 | 328 | 52 |
| S04 | today Hôm nay | 16 | 1265 | 64 | 48 |
| S04 | restaurant Ăn uống | 104 | 1265 | 64 | 48 |
| S04 | self_improvement Thư giãn | 192 | 1265 | 64 | 48 |
| S04 | diversity_3 Kết nối | 280 | 1265 | 64 | 48 |
| S05 | arrow_back Quay lại | 8 | 12 | 99 | 40 |
| S05 | more_vert | 276 | 12 | 40 | 40 |
| S05 | Tất cả | 16 | 176 | 76 | 38 |
| S05 | check 5 phút | 100 | 176 | 99 | 38 |
| S05 | 10 phút | 207 | 176 | 81 | 38 |
| S05 | 15+ phút | 295 | 176 | 90 | 38 |
| S05 | Xem chi tiết chevron_right | 179 | 412 | 149 | 40 |
| S05 | Xem chi tiết chevron_right | 179 | 594 | 149 | 40 |
| S05 | Xem chi tiết chevron_right | 179 | 776 | 149 | 40 |
| S05-empty | arrow_back Quay lại | 8 | 12 | 99 | 40 |
| S05-empty | more_vert | 276 | 12 | 40 | 40 |
| S05-empty | cancel | 292 | 78 | 48 | 48 |
| S05-empty | 5 phút close | 16 | 146 | 96 | 36 |
| S05-empty | 10 phút | 120 | 146 | 81 | 36 |
| S05-empty | Buổi sáng | 209 | 146 | 100 | 36 |
| S05-empty | Trước khi ngủ | 317 | 146 | 128 | 36 |
| S05-empty | Cho trẻ em | 453 | 146 | 110 | 36 |
| S05-empty | restart_alt Xóa bộ lọc | 40 | 568 | 280 | 52 |
| S05-empty | Đọc sách 15 phút | 101 | 692 | 158 | 32 |
| S05-empty | Uống nước buổi sáng | 86 | 732 | 187 | 32 |
| S05-empty | Đi dạo cùng con | 105 | 772 | 151 | 32 |
| S06-existing | arrow_back_ios Quay lại | 16 | 8 | 86 | 48 |
| S06-existing | more_vert | 260 | 8 | 48 | 48 |
| S06-existing | edit_calendar Đổi lịch | 16 | 1039 | 328 | 52 |
| S06-existing | calendar_month Xem lịch thói quen gia đình | 16 | 1123 | 328 | 48 |
| S06-new | arrow_back_ios Quay lại | 16 | 8 | 86 | 48 |
| S06-new | more_vert | 260 | 8 | 48 | 48 |
| S06-new | play_arrow Thử ngay | 222 | 943 | 110 | 40 |
| S06-new | add Thêm vào hôm nay | 16 | 1031 | 328 | 52 |
| S06-new | Quay lại danh sách | 99 | 1135 | 163 | 48 |
| S07 | arrow_back | 12 | 8 | 48 | 48 |
| S07 | more_vert | 264 | 10 | 44 | 44 |
| S07 | event_available Hôm nay (T3, 24/10) | 16 | 186 | 164 | 48 |
| S07 | calendar_today Ngày mai | 180 | 186 | 164 | 48 |
| S07 | check | 296 | 432 | 48 | 28 |
| S07 | save Lưu lịch | 16 | 716 | 328 | 52 |
| S07 | Hủy (Giữ nguyên lịch cũ) | 16 | 778 | 328 | 52 |
| S07-error | arrow_back | 12 | 8 | 48 | 48 |
| S07-error | more_vert | 264 | 10 | 44 | 44 |
| S07-error | sync Thử lại ngay | 84 | 212 | 93 | 84 |
| S07-error | check | 284 | 689 | 44 | 28 |
| S07-error | refresh Thử lại lưu lịch | 16 | 1135 | 328 | 52 |
| S07-error | undo Hủy (Về lịch cũ) | 16 | 1197 | 328 | 52 |
| S07-saving | arrow_back | 12 | 8 | 48 | 48 |
| S07-saving | more_vert | 264 | 10 | 44 | 44 |
| S07-saving | Đang lưu… | 16 | 870 | 328 | 52 |
| S07-saving | Hủy | 16 | 932 | 328 | 48 |
| S07-validation | arrow_back | 12 | 8 | 48 | 48 |
| S07-validation | more_vert | 264 | 10 | 44 | 44 |
| S07-validation | access_time Chọn giờ | 250 | 331 | 94 | 40 |
| S07-validation | check Lưu lịch | 16 | 594 | 328 | 52 |
| S07-validation | close Hủy (Giữ nguyên lịch cũ) | 16 | 646 | 328 | 52 |
| S08 | arrow_back_ios_new Quay lại | 8 | 8 | 105 | 48 |
| S08 | delete | 292 | 466 | 48 | 48 |
| S08 | delete | 292 | 598 | 48 | 48 |
| S08 | delete | 292 | 714 | 48 | 48 |
| S08-empty | arrow_back_ios_new Quay lại | 8 | 8 | 105 | 48 |
| S08-empty | Khám phá thói quen arrow_forward | 28 | 740 | 304 | 52 |
