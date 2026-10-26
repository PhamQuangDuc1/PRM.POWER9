# Component Power9 Office Routine

Page05 của Figma hiện hành có10families và53variants. Màn dùng instance, Auto Layout; màu/padding/gap/radius dùng variables. Font Be Vietnam Pro; nguồn IDs trong assets/figma/office-checkpoint.json.

| Family | Variants thực | Số |
| --- | --- | --- |
|Button|filled/outline/text × default/pressed/disabled/loading|12|
|TextField|default/focused/filled/error/disabled|5|
|Card|default/pressed/done|3|
|Navigation|home/eat/mind/tribe|4|
|AppBar|home/back|2|
|Dialog|confirmation/destructive|2|
|Loading|screen/list|2|
|Empty|discover/history/today|3|
|Error|screen/form|2|
|DiscoverGroup|01–09 × Collapsed/Expanded|18|

CTA cao52; Back/header≥48; body16/24,label14/20. Header accordion dùng CHANGE_TO; thẻ/mũi tên dùng NAVIGATE đến đúng detail. Giữ cùng tên layer giữa states để navigation overrides không mất.≤5giữẩn hoạt động10phút.

Dialog rời phiên đóng về đúng active/paused. Xóa bản ghi giữ lịch; Giữ lại không đổi completion. Error giữ draft, Retry có đường kết thúc. Bản Button loading không phát gửi lặp.

Không detach component để sửa nội dung. TextField error dùng cho validation, Error/form cho lỗi lưu. Tham chiếu: handoff/flutter-handoff.md và docs/FIGMA-FINAL-AUDIT.md.
