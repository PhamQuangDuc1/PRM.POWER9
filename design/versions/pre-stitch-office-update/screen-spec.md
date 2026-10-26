# Tám màn — Power9 Office Routine

Đặc tả hướng mới; chưa phải bằng chứng Figma hoàn tất. Nguồn và cách điều chỉnh: [định hướng](../docs/office-direction.md).

| ID | Màn | Nội dung và hành động |
| --- | --- | --- |
| S01 | Hôm nay | Hành động tự chọn theo giờ; hoàn thành/hoàn tác; không chỉ tiêu 9/9 |
| S02 | Bữa trưa có chú ý | Hai mục riêng H04 80% Rule và H05 Plant Slant; ghi nhận riêng từng hành động |
| S03 | Nghỉ giữa giờ | H03 Downshift, phiên 3 phút; bắt đầu/tạm dừng/tiếp tục/kết thúc |
| S04 | Kết nối | H06 Wine @ 5 điều chỉnh không cồn, H07 Belong điều chỉnh cộng đồng, H09 Right Tribe; tự nguyện ngoài đời |
| S05 | Chín thói quen | Đủ H01–H09, tên gốc + nhãn Việt + ví dụ; tìm kiếm/lọc ≤5/≤10 phút |
| S06 | Chi tiết thói quen | Ý nghĩa gốc, áp dụng văn phòng, phần điều chỉnh, hành động/thời lượng, nguồn; thêm hoặc đổi lịch |
| S07 | Lịch văn phòng | Ngày làm việc, giờ, nhắc tùy chọn, giờ yên lặng; lưu/hủy; chưa tích hợp lịch công ty |
| S08 | Tiến độ cá nhân | Lịch sử theo hành động/nguyên tắc; hoàn thành trên số việc tự chọn; không điểm sức khỏe |

Điều hướng chính: Hôm nay / Chín thói quen / Tiến độ. S02/S03/S04 mở từ hoạt động tương ứng hoặc chi tiết. S06/S07 Back giữ nguồn và bộ lọc.
States: Home completed/undo/added/rescheduled; danh mục empty/reset; lịch validation/saving/error/retry; tiến độ empty; phiên active/paused/finished; xác nhận rời phiên và xóa. Không tính states là màn mới.
Huy → S01/S03/S07; Mai → S04/S05/S06; Linh → S06-H08/S07/S08. H01/H02/H08 có dữ liệu trong danh mục/chi tiết dù không có màn chuyên đề riêng.
