# Đặc tả thành phần Figma Power9

## Trạng thái

Đây là hướng dẫn dựng thư viện, chưa chứng minh đã tạo component trong file Figma. Dùng page 04 Design System cho token, page 05 Components cho các component set. Màn UI phải dùng instance, không dùng bản sao detached.

## Nền tảng trước khi ráp màn

1. Tạo token màu theo DESIGN.md, kiểu chữ 24/32, 20/28, 16/24, 14/20.
2. Tạo biến khoảng cách 4/8/12/16/24/32, radius 8/12/16; effect style cho hai mức bóng.
3. Màu/spacing/radius phải được bind hoặc áp style phù hợp trên component. Không chỉ vẽ bảng màu rồi gán cứng mọi control.
4. Cấu trúc các container liên quan dùng Auto Layout; text wrap thay vì scale nhỏ; icon + nhãn có khoảng cách 8.
5. Tên/variant tiếng Anh kỹ thuật giữ để đối chiếu Flutter; mô tả trong component dùng tiếng Việt.

## Chín nhóm bắt buộc

| Tên component | Thuộc tính/biến thể tối thiểu | Kích thước và nội dung | Dùng ở đâu |
| --- | --- | --- | --- |
| P9/Button | kind=filled/outline/text, state=default/pressed/disabled/loading | Cao 52, radius12, label14/20, padding ngang16, target≥48. Loading giữ label/ngữ cảnh và không đổi kích thước | CTA, Retry, Reset, Save, Cancel |
| P9/TextField | state=default/focused/filled/error/disabled | Nhãn trên, helper/error dưới, phần control≥48, radius8, padding12. Không chỉ đỏ để báo lỗi | Search S05, giờ S07 nếu dùng input |
| P9/Card | state=default/pressed, interactive=true/false | Padding16, gap12, radius16, surface trắng; nếu tappable thì pressed có phản hồi | Hoạt động, hướng dẫn, lịch sử |
| P9/Navigation | selected=home/eat/mind/tribe | Bốn đích bằng nhau, icon+label; mỗi destination target≥48; label cho phép đủ chỗ | S01–S04 |
| P9/AppBar | variant=default/actions, back=true/false | Title đúng màn, Back target≥48, không ghép mã nội bộ vào title | Cả tám màn |
| P9/Dialog | variant=confirmation/destructive | Title ngắn, nội dung rõ, hai nút đúng ngữ cảnh; xóa có nhãn Xóa bản ghi, hủy Giữ lại | O01/O02 |
| P9/Loading | variant=screen/list | Skeleton theo cấu trúc hoặc spinner+nhãn, nằm trong viewport, có đường kết thúc | Tải danh sách, chuyển trạng thái |
| P9/Empty | context=discover/history/today | Icon, thông báo, một hành động rõ; không xuất hiện cùng populated | S05/S08/S01 |
| P9/Error | context=screen/form, retry=true | Nguyên nhân dễ hiểu, Retry; dữ liệu form còn nguyên nếu lỗi lưu | S07 và màn tải lỗi |

Không buộc mọi tổ hợp thuộc tính phải tồn tại nếu không dùng, nhưng toàn bộ required states theo đề phải có trong nhóm thích hợp. Mỗi màn dùng instance của đúng variant; không đặt các trạng thái khác nhau thành loose frame rồi gọi là component variants.

## Trạng thái tương tác

- Nút pressed khác default bằng fill/opacity, không giảm target.
- Disabled phải có lý do ở ngữ cảnh (chưa chọn hoạt động, đang gửi), không chỉ mờ mà không giải thích.
- TextField error chỉ khi validation fail; lỗi mạng là P9/Error của form, không báo trường hợp lệ bị sai.
- Nav selected có nền + icon/nhãn, không chỉ thay màu chữ.
- Dialog là overlay khi prototype; đóng/hủy giữ dữ liệu.
- Thêm property text/boolean cho nội dung/icon để instance thay nội dung mà không detach.

## Bằng chứng cần chụp

- Component set cùng variants và Auto Layout panel.
- Một biến màu/spacing được bind trong component.
- Một instance trên Final UI và liên kết tới component gốc.
- Chuyển selected tab, button loading, input error, dialog.
- Không đánh hoàn thành chín nhóm từ một ảnh bảng phong cách Stitch.
