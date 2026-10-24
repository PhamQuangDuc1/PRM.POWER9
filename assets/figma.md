# Danh mục bằng chứng Figma

File: https://www.figma.com/design/xqBod46IwxD7E9thJZLWqr/Untitled

Người dùng xác nhận file có sáu page. Ảnh sheet cho thấy nhóm đánh dấu bước tạo page là đã làm; agent chưa đọc được cấu trúc file trực tiếp do quyền connector.

## Cần export và kiểm tra sau Stitch

- S01–S08 Final UI PNG → assets/figma/.
- 6 page theo thứ tự, 3 flow/starting points, overlay/loading.
- Tokens bound to component, Auto Layout/variants, instances trên màn.
- Bounds/type/contrast thật và layout 360/412.
- Link view mở được chưa đăng nhập.

Không dùng screenshot checkbox để thay bằng chứng token binding hoặc prototype chạy được. Xem docs/stitch-to-figma-guide.md.

## Thử xuất một màn từ Stitch

Ảnh assets/figma/import-check/F01-stitch-export-figma-menu.png cho thấy đã chọn S01 Hôm nay xanh biển, menu Export có Figma được chọn và nút Convert. Chưa có bằng chứng đã Convert thành công hoặc nhập vào Figma. Menu thông báo HTML sẽ được xử lý qua code.to.design. Bước tiếp theo Convert rồi kiểm tra đầu ra và lớp chữ trong page 03 Final UI.

## Đã dán thử S01

Ảnh assets/figma/import-check/F02-home-pasted-figma.png cho thấy S01 Hôm nay xuất hiện trên Final UI và nhóm Layers Html → Body đang đóng. Sáu page có đúng thứ tự nội dung nhưng chưa có tiền tố số. Chưa kiểm tra editable text, kích thước, Auto Layout hoặc tokens/components. Mốc tiếp tục: docs/CONTINUE.md.

## Đã xác nhận lớp chữ S01 chỉnh sửa được

Ảnh assets/figma/import-check/F03-home-editable-text.png cho thấy text layer đang được chỉnh, panel Text/ Typography hiển thị Be Vietnam Pro, SemiBold, cỡ 20, line height 28. Tiêu đề thử nghiệm có chuỗi thêm vào; cần khôi phục Hôm nay. Bằng chứng xác nhận text editable, chưa xác nhận toàn bộ component/token binding hoặc viewport.

## Phase 1 qua MCP

Đã tạo nền tảng, components và UI editable; mã node: assets/figma/node-map.json. 8 màn chính đều 360×800; biến thể là khung phụ, không tăng số màn chức năng. Đã xem ảnh render mẫu Home/Lịch/Chi tiết và sửa hàng nút. Page 02 có 8 wireframe, page 01 có 3 sơ đồ. Lệnh gom section chưa chạy do quota Starter; prototype/412/toàn bộ QA chưa hoàn thành. Xem phase-checkpoint.json.
