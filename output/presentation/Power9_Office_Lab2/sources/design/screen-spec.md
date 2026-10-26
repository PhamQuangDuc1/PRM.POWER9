# 10 màn — Power9 Office Routine

Đã dựng10màn Office editable trong page03 và3flow trong page06. Trạng thái thực và kiểm tra tại docs/FIGMA-FINAL-AUDIT.md; bàn giao hiện hành tại handoff/office-figma-handoff.md. Giữ phong cách xanh biển và bốn tab.

| ID | Màn | Nội dung/hành động | Flow |
| --- | --- | --- | --- |
| S01 | Hôm nay | Logo + tên; vài việc tự chọn theo giờ/nhóm; hoàn thành/hoàn tác; entry Khám phá/Tiến độ | F01/F02/F03 |
| S02 | Ăn uống | Eat Well, hoạt động bữa trưa văn phòng và ghi nhận | F02 nhánh |
| S03 | Thư giãn | Manage Stress, phiên nghỉ 3 phút, start/pause/resume/finish | F02 |
| S04 | Kết nối | Social Bonds, rủ đồng nghiệp ăn trưa/đi bộ, tự nguyện; ghi nhận việc ngoài đời | F02 nhánh |
| S05 | Khám phá | Đủ 9 nhóm, tìm kiếm, filter nhóm/thời lượng, card → chi tiết | F01 |
| S06 | Chi tiết | Nhóm, mục tiêu, số phút, bước làm, ví dụ văn phòng; new thêm hoặc existing đổi lịch | F01/F03 |
| S07 | Lịch | Ngày làm việc, nhắc tùy chọn, giờ, giờ yên lặng; lưu/hủy/validation/retry | F01/F03 |
| S08 | Tiến độ | Tổng trên việc tự chọn, lịch sử có ngày, nhóm thói quen, xóa có xác nhận | F02 |
| S09 | Góc làm việc | Checklist 3 mục về màn hình, tư thế và mặt bàn/lối đi; ghi nhận 1 hoạt động tự kiểm tra | F02 nhánh |
| S10 | Ngủ & phục hồi | Chuẩn bị nghỉ tối, 2 gợi ý, chọn giờ nhắc tới S07 theo dữ liệu hoạt động | F01/F03 nhánh |

Top-level: S01/S02/S03/S04. S05/S08 từ S01; S06 từ S05 hoặc card đã có ở S01; S07 từ S06. S09/S10 là màn con thực hiện/hướng dẫn sau S06 với dữ liệu tương ứng; S10 mở S07. Giữ returnOrigin và filter khi Back. Wireframe, UI/variant và prototype đã được dựng; timer/tìm kiếm/nhập liệu là mô phỏng các lựa chọn trạng thái mẫu. Chưa có kiểm thử người dùng.

## Độ bao phủ
| Nhóm | Ví dụ hoạt động | Đường truy cập |
| --- | --- | --- |
| Move Often | Đi bộ giữa giờ 3 phút | S01 hoặc S05 → S06 |
| Sit Smart | Kiểm tra tư thế 2 phút | S05 → S06 |
| Eat Well | Sắp xếp bữa trưa | S02 hoặc S05 → S06 |
| Sleep Well | Chuẩn bị nghỉ tối | S05 → S06 → S07 |
| Manage Stress | Nghỉ sau họp 3 phút | S03 hoặc S05 → S06 |
| Healthy Space | Sắp xếp góc làm việc 5 phút | S05 → S06 |
| Social Bonds | Rủ đồng nghiệp ăn trưa | S04 hoặc S05 → S06 |
| Purpose | Viết việc có ý nghĩa 2 phút | S01 hoặc S05 → S06 |
| Work–Life Balance | Đặt mốc kết thúc ngày | S05 → S06 → S07 |

## State cạnh màn cha
S01-added/completed/undo/rescheduled; S03-active/paused/finished; S05-empty/reset; S06-new/existing; S07-validation/saving/error/retry; S08-empty; O01 xác nhận rời phiên, O02 xác nhận xóa.
Không cộng states/dialog vào tám màn chính. Lưu thất bại không đổi dữ liệu Home; check-in/undo phản ánh trong S08. Tiến độ riêng tư, không chỉ tiêu 9/9. Nhãn UI tiếng Việt, không hiển thị mã S/O.
