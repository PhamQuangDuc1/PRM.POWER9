# Mốc tiếp tục Power9 Lab 2

## Chặn kết nối mới nhất

Plugin Figma hiện được báo installed/enabled, nhưng create_session, get_metadata và use_figma đều trả Unknown tool. Không suy ra quyền/quota tài khoản mới. Chưa có mutation canvas trong lần thử mới; cần nạp lại kết nối trong Codex rồi kiểm tra. Yêu cầu đang chờ: hoàn thiện prototype từ đúng nguồn Stitch, không dùng bộ UI giản lược.

## Ưu tiên sửa nguồn trước tiên

Người dùng chỉ ra UI native dựng lại khác ảnh Stitch. Không tiếp tục coi bộ đó là Final UI được duyệt. Đọc docs/source-fidelity-repair.md; nguồn đúng đã đóng gói trong output/stitch-source/ thành 8 màn chính, states và wireframe riêng. Cần khôi phục bố cục/ảnh/kiểu chữ theo nguồn, chỉ sửa tối thiểu theo yêu cầu đề. MCP đang hết lượt nên chưa sửa canvas.


## Bộ ảnh render nguồn Stitch

Đã render 8 màn chính + 6 trạng thái từ HTML nguồn bằng Chrome ở rộng360, có ảnh viewport360×800 và ảnh full, đã kiểm tra font/ảnh và xem mẫu. Gói: output/Power9-Prototype-PNG-Stitch.zip; preview: output/prototype-render/xem-truoc.html. Đây là bộ PNG tĩnh + hướng dẫn hotspot, KHÔNG phải Figma prototype đã nối và KHÔNG thay Final UI editable. Kết quả Home sau thêm/đổi lịch và active/paused phiên thở vẫn phải dựng để flow nhất quán.

## Ba phase

1. Nền tảng/UI: đã tạo tokens, styles, components và 8 màn 360×800 cùng biến thể trong Figma; đã review ảnh mẫu Home, Lịch, Chi tiết và sửa hàng nút bị cắt.
2. Luồng/kiểm tra: đã tạo 8 wireframe và IA + 3 sơ đồ native liên kết màn; chưa nối prototype, chưa kiểm tra 412 và toàn bộ accessibility.
3. Hồ sơ/nộp: tài liệu và handoff đích đã soạn; cần đồng bộ với triển khai cuối, slide/demo và kiểm tra link.

## Trạng thái Figma thực tế

- File: https://www.figma.com/design/xqBod46IwxD7E9thJZLWqr/Untitled
- Session: 16f0cac8-4722-4aa0-994f-d1e1e3d12419.
- Sáu page đã được đổi đúng tên 01–06; không tạo page thứ bảy.
- Page 03 có 8 màn chính mới cùng 16 khung trạng thái/dialog. Bản Home nhập cũ giữ riêng tại vị trí nguồn.
- 29 biến màu/khoảng cách/radius/size, 4 text styles, 2 effect styles.
- 9 component sets, 30 variants, 144 instances trong bộ UI/state mới.
- Mã node thật: assets/figma/node-map.json và assets/figma/phase-checkpoint.json.
- Wireframe node IDs và flow frame thật nằm trong phase-checkpoint.json.

## Chặn hiện tại

Figma MCP báo hết lượt gói Starter ở lệnh gom section. Không phải lỗi quyền Editor; không tự đoán thời điểm reset hạn mức. Lệnh scripts/figma/06-organize-final-ui.js CHƯA ĐƯỢC THỰC THI.

Người dùng muốn Final UI nhìn rõ đúng 8 màn chính. Cần gom tám root S01–S08 vào section chính, states/dialog vào section phụ thu gọn, nguồn nhập vào section đối chiếu. Lệnh đã lưu; không chạy lại script tạo màn để tránh trùng.

## Việc tiếp theo

1. Khi MCP dùng lại được, chạy script gom section trước; xác nhận chỉ tám màn trong khu chính.
2. Hoàn thiện prototype trên page 06: clone bản UI/state đã chọn và gắn phản ứng, starting points, Back/Hủy, overlay, loading → result, retry/undo.
3. Kiểm tra 412, contrast/target/type và chuẩn hóa dữ liệu mẫu. UI dựng bằng component đã chỉnh gọn so với ảnh nguồn, cần chụp bằng chứng cuối.
4. Dùng mã nguồn scripts/figma/ làm bản ghi những gì đã tạo. Một số sửa visual được thực hiện sau script; không tự xóa/rebuild từ đầu.
5. Đồng bộ handoff, slide, README, thử link và nộp; repo chưa được agent commit/push.

## Nguồn ZIP

Đã giải nén assets/stitch/export-original/: 37 bộ HTML/PNG + 3 thư mục phong cách. Bản nguồn giữ nguyên. Chọn nguồn theo docs/stitch-zip-inventory.md và assets/stitch/export-manifest.json.

Bốn persona đều giả định, Linh chính. Tài liệu hiện hành dùng tiếng Việt; giữ nguyên nguồn tiếng Anh để đối chiếu. Không nêu phân chia khối lượng cá nhân hoặc lịch chạy gấp trong hồ sơ.
