# Bộ prompt sửa Stitch — Office

Người dùng xác nhận ngày27/10/2026 đã gửi nguyên văn100% prompt Office do trợ lý cung cấp trên dự án Stitch mới. Khối prompt bên dưới được giữ nguyên.

```text
Trong project hiện có, tạo một bộ WIREFRAME LOW-FI mới cho Power9 Office Routine. Giữ bộ UI xanh biển hiện tại làm nguồn phong cách để dùng sau, không xóa/ghi đè. Lần này chỉ làm wireframe grayscale, chưa làm UI hoàn chỉnh.

Ứng dụng Android tiếng Việt cho nhân viên văn phòng 23–45 tuổi. Ba persona chính ngang nhau, không có persona phụ. Huy 28: ngồi lâu, cần vận động/tư thế/góc làm việc, đổi lịch khi bận. Mai 24: cần ăn uống, giảm căng thẳng và kết nối đồng nghiệp tự nguyện. Linh 39: cần ngủ/phục hồi, mục tiêu có ý nghĩa, cân bằng công việc–cuộc sống. Persona là giả định.

Chín nhóm theo gợi ý của giảng viên, phải đủ: Move Often (Vận động thường xuyên), Sit Smart (Ngồi đúng tư thế), Eat Well (Ăn uống lành mạnh), Sleep Well (Ngủ đủ, phục hồi tốt), Manage Stress (Quản lý căng thẳng), Healthy Space (Không gian tốt), Social Bonds (Kết nối đồng nghiệp), Purpose (Có mục tiêu, ý nghĩa), Work–Life Balance (Cân bằng công việc và cuộc sống). Đây là nhóm văn phòng, không thay bằng Wine @ 5/Belong/Right Tribe. Không ép hoàn thành 9/9.

Giữ tám chức năng: S01 Hôm nay; S02 Ăn uống; S03 Thư giãn; S04 Kết nối; S05 Khám phá; S06 Chi tiết; S07 Lịch; S08 Tiến độ. Giữ bốn tab Hôm nay/Ăn uống/Thư giãn/Kết nối. Home có entry Khám phá/Tiến độ. Tất cả 9 nhóm đến được qua danh mục S05 có tìm kiếm, filter nhóm và thời lượng. Chín nhóm được cuộn, không nén vào một màn.

S01: ô logo và tên app, việc tự chọn theo giờ, nút hoàn thành/hoàn tác.
S02: bữa trưa văn phòng, hướng dẫn ngắn, ghi nhận Eat Well.
S03: nghỉ 3 phút sau họp, start/pause/resume/finish và xác nhận rời.
S04: hoạt động đồng nghiệp tự nguyện, không chat hoặc tự gửi lời mời.
S05: danh mục đủ 9 nhóm, card có số phút, lọc tối đa 5/10 phút.
S06: nhóm, tên, thời lượng, mục tiêu, các bước; mới thì thêm, đã có thì đổi lịch.
S07: ngày làm việc, nhắc tùy chọn, giờ, giờ yên lặng, Lưu/Hủy; lỗi giữ form.
S08: lịch sử có ngày và nhóm, tiến độ trên số việc tự chọn, không xếp hạng.

Tạo 8 frame 360×800; mã OW00-S01…S08 chỉ ở tên frame, không trên UI. Nội dung cuộn; label ≥14, body 16, target ≥48×48, lề 16. Logo ở wireframe chỉ là ô giữ chỗ 40×40; đừng vẽ lại logo. Tách states empty danh mục, validation/loading/error lịch, empty tiến độ và dialog khỏi default.

Ba luồng đại diện ba persona chính: Mai tìm/thêm S01→S05→S06→S07→S01; Huy nghỉ/ghi nhận S01→S03→S08 (nhánh S02/S04); Linh đổi mốc tổng kết ngày và kiểm tra giờ yên lặng S01→S06→S07→S01. Đánh giá riêng nhu cầu và tiêu chí của cả ba, không ưu tiên một người rồi coi hai người còn lại là hỗ trợ. Hủy giữ lịch cũ, lỗi lưu có retry, Back về đúng nguồn. Không thêm login/onboarding chỉ để tăng số màn. Dừng ở wireframe để phản biện trước.
```

## OC00 — Gửi trợ lý AI sau khi có ảnh thật
```text
Đánh giá bộ ảnh Power9 Office Routine đính kèm theo ba persona Huy/Mai/Linh, đủ chín nhóm văn phòng, 10 heuristic Nielsen và accessibility trong đề Lab 2. Nêu tối thiểu 5 phát hiện có căn cứ nếu ảnh thực sự cho phép; không bịa hoặc suy đoán số đo từ overview mờ. Mỗi finding: ID, màn/state, bằng chứng quan sát, persona/task bị ảnh hưởng, heuristic có tên, mức độ, đề xuất sửa và cách kiểm tra lại. Phân biệt lỗi nội dung, bố cục, tương tác và vấn đề chưa kiểm chứng. Đặc biệt kiểm tra truy cập đủ 9 nhóm, đổi lịch khi bận, giờ yên lặng, CTA new/existing, Back, lỗi/empty/loading, đồng bộ Home/history. Cuối cùng đề xuất accept/modify/reject kèm lý do để người thiết kế quyết định. Giữ phong cách UI hiện tại; không yêu cầu làm lại diện mạo nếu không có lỗi chứng minh.
```

## OW01 — Chỉ dùng sau review
Không gửi nguyên mục này khi chưa điền finding.
```text
Sửa WIREFRAME OW00 theo các finding đã được chọn dưới đây, tạo OW01 và giữ OW00 để so sánh.
[Điền ID, màn, vấn đề quan sát, quyết định và cách sửa thực tế.]
Giữ nguyên những phần không bị finding tác động. Kiểm tra lại ba flow, đủ 9 nhóm văn phòng, Back/Hủy và trạng thái phục hồi. Chưa chuyển sang UI. Xuất overview và tám frame để so sánh trước/sau.
```

## OU00 — UI sau khi chốt wireframe
```text
Dùng wireframe OW01 đã chốt làm nguồn bố cục/nội dung và bộ UI XANH BIỂN hiện có làm nguồn phong cách. Chuyển sang UI Power9 Office Routine; không thiết kế lại diện mạo. Giữ ảnh/phong cách ảnh, nhịp card, typography tiếng Việt, nút và cách phân cấp gần nguồn cũ; chỉ thay ảnh không còn hợp ngữ cảnh gia đình bằng ảnh văn phòng tương đương.

Làm theo DESIGN.md hiện hành. Giữ đủ chín nhóm văn phòng và tám màn đã chốt; không trở lại chín tên Blue Zones nguyên văn. Bốn tab giữ như wireframe. Không tự thay flow hoặc thêm chức năng.

Dùng đúng ảnh logo power9-logo-3d.png đính kèm do người dùng thiết kế. Logo giữ nguyên màu/tỉ lệ trong vùng 40×40 ở Home cạnh tên Power9 Office Routine, tên có thể hai dòng. Không vẽ lại logo bằng AI. Nếu không đặt được đúng ảnh, giữ placeholder và ghi rõ để thay file thật trong Figma; không tạo logo gần giống. Không lấy gradient 3D làm nền UI.

Khung 360×800, kiểm tra 412, body 16, nhãn ≥14, target ≥48×48, nội dung cuộn. Tách default/populated, empty, validation, loading, error, new/existing và dialog. Không hiện mã kỹ thuật trên UI. Cung cấp tám màn, states cạnh màn cha và overview; giữ nguồn wireframe và UI cũ để đối chiếu. Chưa tuyên bố prototype hoạt động hoặc accessibility đã đạt nếu chưa kiểm tra.
```

## OI01–OI03 — Khung vòng cải tiến, chưa chạy
Sau critique UI, chọn ba vấn đề khác nhau có bằng chứng. Mỗi lần gửi:
```text
Vòng [OIxx], vấn đề duy nhất: [tên finding khác những vòng trước].
Màn bị ảnh hưởng: [ID/state].
Bằng chứng trước sửa: [ảnh và mô tả].
Persona/task bị cản: [người và nhiệm vụ].
Quyết định: [accept/modify], lý do [heuristic/persona/ràng buộc].
Sửa cụ thể: [thay đổi].
Giữ phong cách UI xanh biển và logo gốc. Không sửa phần không liên quan.
Điều kiện kiểm tra sau sửa: [hành vi/số đo/bố cục quan sát được].
Giữ BEFORE và xuất AFTER tương ứng, không tính state là màn chính mới.
```

## Log mỗi lần thực hiện
Run ID; thời gian thực; công cụ/mode/model chỉ khi hiển thị; prompt nguyên văn; file đầu vào; output overview/từng màn; toàn văn critique; bảng quyết định và lý do; before/after; kết quả kiểm tra và việc chưa xong.
