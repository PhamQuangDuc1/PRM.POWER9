# Bước tiếp theo trong Figma

## Trạng thái hiện tại

Đã lưu V00, W00, W01, I01, P00b, I02 và I03 cùng review. Có ảnh bố cục cho tám chức năng UI và ba vòng cải tiến khác mục tiêu. Chưa có bằng chứng đã dựng tokens/components hoặc nối prototype trong Figma.

Nguyên văn prompt thực gửi cần đối chiếu với file đã chuẩn bị nếu nhóm có sửa. Ảnh tổng quan không thay thế ảnh rõ từng màn hoặc dữ liệu lớp.

## Thử chuyển một màn trước

1. Trong Stitch chọn đúng S01 Hôm nay xanh biển từ I01, không chọn toàn canvas hoặc bộ wireframe.
2. Mở nút Export đang có trên thanh trên cùng. Xem các lựa chọn thực tế trong menu.
3. Nếu có tùy chọn Figma hoặc Copy to Figma, dùng tùy chọn đó và dán vào **03 Final UI** của file nhóm.
4. Nếu menu chỉ có ảnh/code hoặc không có tùy chọn Figma, lưu ảnh menu để chọn đường chuyển phù hợp; không mặc định phải cài plugin nhập HTML.
5. Kiểm tra bản dán: chọn chữ có sửa được không, có lớp con không. Một image layer là ảnh tham chiếu, chưa phải UI editable.
6. Chỉ sau khi thử một màn thành công mới chuyển các bản đã chọn còn lại theo design/ui-selection.md.

Chức năng export có thể thay đổi; hướng dẫn trên có điều kiện theo menu thật, không khẳng định một tài khoản cụ thể chắc chắn có Figma export.

## Menu Export đã quan sát

Ảnh assets/figma/import-check/F01-stitch-export-figma-menu.png xác nhận có lựa chọn Figma và nút Convert khi S01 xanh biển được chọn. Tiếp tục Convert. Nếu có lệnh sao chép sau chuyển đổi thì dùng lệnh đó, mở page 03 Final UI và dán. Nếu công cụ trả file hoặc yêu cầu thao tác khác, làm theo đầu ra thật thay vì mặc định đã vào clipboard. Chưa đánh dấu nhập thành công trước khi nhìn thấy lớp trong Figma.

## Chọn đúng nguồn

| Màn | Nguồn |
| --- | --- |
| S01 | I01 xanh biển |
| S02, S03, S04 | P00b xanh biển |
| S05 có kết quả, S07 hợp lệ, S08 có dữ liệu | I02 |
| S06 mới và đã thêm | I03 |

Các state I02 đặt cạnh màn cha. Wireframe chọn theo design/wireframe-selection.md và đưa vào page **02 Wireframe**. Không nhập mọi khung trùng làm bộ UI cuối.

## Việc cần hoàn thiện sau khi chuyển

1. Kiểm tra đúng sáu page và sắp thứ tự theo đề.
2. Tạo frame base 360×800; các nguồn đã thấy có 390×884 hoặc 390×1169, cần chỉnh layout và vùng cuộn. Không co toàn bộ nội dung khiến chữ/target nhỏ.
3. Tạo tokens ở 04 Design System và components ở 05 Components; dùng Auto Layout, variants, token bindings và instances trên màn.
4. Chỉnh tiêu đề còn lộ mã, rút copy thừa, thống nhất dữ liệu mẫu và khoảng cách.
5. Tách default/loading/empty/error và các hộp thoại, chuẩn hóa theo component.
6. Nối ba flow ở 06 Prototype: starting point, Back/Hủy, overlay, loading → result, retry/undo và nhánh thay thế.
7. Đo contrast/target/font; kiểm tra viewport 360/412. Ghi kết quả thật vào design-decisions.md.
8. Hoàn thiện screen spec và handoff sáu mục mỗi màn, hai bảng ánh xạ.
9. Export ảnh tám màn và ảnh cấu trúc/binding/variants/prototype; kiểm tra link quyền xem bằng cửa sổ chưa đăng nhập.

Không cần tạo thêm một bộ màn Stitch chỉ để sửa những điểm có thể chỉnh nhất quán khi dựng component trong Figma.
