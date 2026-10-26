# IA và ba flow — Power9 Office Routine

Ba flow đã nối trong Figma page06; kiểm tra cấu trúc/dữ liệu đã qua, chưa có kiểm thử người dùng thực. Huy 28, Mai 24 và Linh 39 đều là persona chính ngang nhau, hiện là giả định. F01 đại diện Mai, F02 đại diện Huy, F03 đại diện Linh.

## IA
- Bốn tab kế thừa UI hiện có: S01 Hôm nay / S02 Ăn uống / S03 Thư giãn / S04 Kết nối.
- S01 mở S05 Khám phá và S08 Tiến độ. Mọi nhóm trong chín nhóm đến được qua S05.
- S05 → S06 Chi tiết → S07 Lịch → S01 sau lưu; S01 card đã có → S06-existing → S07-edit.
- S02/S03/S04 ghi nhận → S08. Back từ S08 về đúng nguồn; từ S06 về đúng danh sách và giữ lọc.
- Chín nhóm: Move Often, Sit Smart, Eat Well, Sleep Well, Manage Stress, Healthy Space, Social Bonds, Purpose, Work–Life Balance.

## F01 — Tìm và thêm hoạt động
Mai tìm hoạt động phù hợp thời gian rảnh. Start S01; goal thêm một hoạt động ≤5 phút; end S01 có việc mới. Target <60 giây, chưa đo.
```mermaid
flowchart TD
 A["Start: S01 Hôm nay"] --> B["S05: lọc nhóm và tối đa 5 phút"]
 B --> C{"Có kết quả?"}
 C -->|Không| D["Xóa bộ lọc"]
 D --> B
 C -->|Có| E["S06: Rủ đồng nghiệp đi bộ"]
 E --> F["S07: đặt ngày và nhắc tùy chọn"]
 F -->|Hủy| E
 F --> G{"Hợp lệ?"}
 G -->|Không| H["Lỗi cạnh trường, giữ dữ liệu"]
 H --> F
 G -->|Có| I["Đang lưu"]
 I --> J{"Lưu thành công?"}
 J -->|Không| K["Lỗi lưu, giữ form"]
 K -->|Thử lại| I
 J -->|Có| L["End: S01 có việc mới và xác nhận"]
```

## F02 — Thực hiện, ghi nhận và xem lại
Huy nghỉ sau họp. Start S01; goal hoàn thành một phiên; end S08 có bản ghi. Check-in trực tiếp từ Home ≤3 thao tác là mục tiêu riêng, không tính thời gian thực hiện phiên.
```mermaid
flowchart TD
 A["Start: S01 Hôm nay"] --> B["S03: Bắt đầu nghỉ 3 phút"]
 B --> C["Đang thực hiện"]
 C -->|Tạm dừng| D["Đã tạm dừng"]
 D -->|Tiếp tục| C
 C --> E["Kết thúc và ghi nhận"]
 E --> Z["End: S08 có bản ghi"]
 C -->|Rời phiên| O["Overlay xác nhận"]
 O -->|Ở lại| C
 O -->|Bỏ phiên| A
 A -->|Bữa trưa| F["S02: Ghi nhận Eat Well"]
 F --> Z
 A -->|Kết nối| G["S04: Ghi nhận Social Bonds"]
 G --> Z
 A -->|Hoàn thành trực tiếp| H["S01 Đã hoàn thành"]
 H -->|Hoàn tác| A
 H -->|Xem tiến độ| Z
 Z -->|Back| R["Về đúng màn nguồn, giữ trạng thái"]
```
Rời từ paused phải phục hồi paused nếu chọn ở lại. Chưa kết thúc không tự ghi nhận. Hoàn tác và xóa có xác nhận phải đồng bộ Home/history.

## F03 — Đổi lịch khi bận
Linh có mốc tổng kết ngày 17:30 trùng cuộc họp; cần chuyển sang 18:00 và kiểm tra giờ yên lặng. Start S01; goal lưu lịch phù hợp và giữ quyền chủ động nhắc ngoài giờ; end Home giờ mới. Mục tiêu đặt lịch/giờ yên lặng <60 giây, chưa đo. Huy cũng có thể dùng cùng form để đổi lịch vận động.
```mermaid
flowchart TD
 A["Start: S01 tổng kết ngày 17:30"] --> B["S06-existing: Đổi lịch"]
 B --> C["S07-edit: chọn 18:00"]
 C -->|Hủy| B
 B -->|Back| A
 C --> D{"Hợp lệ?"}
 D -->|Không| E["Lỗi trường, giữ lựa chọn"]
 E --> C
 D -->|Có| F["Đang lưu"]
 F --> G{"Lưu thành công?"}
 G -->|Không| H["Lỗi lưu, Home vẫn 17:30"]
 H -->|Thử lại| F
 H -->|Hủy| B
 G -->|Có| I["End: S01 giờ mới 18:00"]
```

## Mapping
| Flow | Màn chính | Alternate/error |
| --- | --- | --- |
| F01 | S01/S05/S06/S07 | S05 empty, S07 validation/loading/error/retry, hủy |
| F02 | S01/S03/S08 | S02/S04, paused, overlay, check-in/undo, S08 empty |
| F03 | S01/S06/S07 | hủy/Back, validation/loading/error/retry |

Cả tám màn đều có vai trò. S06 là template dùng cho cả chín nhóm; khác dữ liệu không tính thêm màn. Chưa tích hợp lịch công ty. Giờ yên lặng là lựa chọn cá nhân, không khóa việc tạo hoạt động ngoài giờ.
