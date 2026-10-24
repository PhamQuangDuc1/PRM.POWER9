# Thực hiện Stitch trước rồi chuyển sang Figma

## Bước hiện tại

Đã có ảnh V00/W00/W01/I01/P00b/I02/I03 và các review. Dừng tạo thêm bộ Stitch. Chuyển một màn thử theo docs/figma-next-steps.md; chọn nguồn theo design/ui-selection.md và design/wireframe-selection.md. Các bước initial bên dưới là tài liệu tham chiếu, không phải yêu cầu chạy lại.

## Quy trình initial tham chiếu

1. Mở Google Stitch ở https://stitch.withgoogle.com/ bằng tài khoản của bạn. Tìm lại project cũ nếu còn; tạo project mới tên Power9 Family Routine nếu cần.
2. Mở design/DESIGN.md để xem brief đã lưu. Không bỏ qua bước này khi trình bày trình tự làm bài.
3. Mở ai/prompts/P00-stitch-initial.md, sao chép **chỉ nội dung trong khối text** vào Stitch. Nếu sửa prompt, lưu nguyên văn bản thật đã gửi.
4. Chụp prompt trước khi gửi hoặc ngay sau khi gửi, kèm ảnh project/canvas và đầu ra từng màn. Ghi Run ID, công cụ/mode hiển thị và URL project nếu có.
5. Lưu vào assets/stitch/V00/ theo hướng dẫn assets/stitch.md. Không đổi tên ảnh cũ thành một phiên bản mới chưa chạy.
6. Nếu thiếu màn, dùng P00b để bổ sung và ghi như bước hoàn thiện độ bao phủ màn hình, không gọi đó là ba vòng cải tiến UX.
7. Gửi ảnh đầu ra cho Codex để chạy critique bằng C00. Sau đó mới chốt và thực hiện I01–I03 dựa trên vấn đề thật.

**Phiên hiện tại:** đã thử chụp cửa sổ foreground qua Windows và mở ảnh xác minh thành công; ảnh thử là Codex, không phải Stitch. Chưa có công cụ điều khiển Stitch trực tiếp được kết nối. StitchDesign đã có trong môi trường; kỹ năng hỗ trợ semantic DESIGN.md, chưa cung cấp công cụ điều khiển Stitch được xác minh.

## Bằng chứng tối thiểu mỗi lần chạy

- Run ID, mã phiên bản và screen ID.
- Công cụ/mode/model nếu UI hiển thị; không đoán tên model.
- Đường dẫn file chứa prompt nguyên văn đã gửi; screenshot của prompt giúp đối chiếu.
- Output tổng quan và ảnh đủ rõ cho từng screen ID.
- Critique prompt + toàn bộ câu trả lời AI.
- Bảng finding → accept/modify/reject → lý do → màn sửa.
- Ảnh before và after cùng screen ID, cùng vùng hiển thị, lưu riêng bản gốc.
- Nếu thất bại hoặc thiếu màn, ghi đúng hiện trạng; prompt sẵn có không có nghĩa đã chạy.

Tên gợi ý: V00-S01-home.png, V00-S05-discover.png; I01-before-S05.png và I01-after-S05.png. Lưu nội dung gốc, không chỉnh UI trong ảnh rồi gọi là Stitch output. Có thể crop để slide dễ đọc nhưng giữ bản gốc và ghi nguồn.

## Ba vòng cải tiến

Chạy C00 trên V00 trước. Chọn ba vấn đề khác nhau được chứng minh bằng ảnh. Dùng các draft trong I01-I03-drafts.md làm điểm bắt đầu, điền finding cụ thể trước khi gửi.

Mỗi vòng: lưu BEFORE → ghi prompt thật → chạy → lưu AFTER → đánh giá lại → ghi quyết định. Không chạy cả ba prompt mù khi chưa xem kết quả. Nếu tính năng bị lỗi hoặc thay đổi, ghi lỗi thật và xử lý, không tạo output giả.

## Chuyển sang file Figma hiện có sau khi chốt Stitch

File nhóm: https://www.figma.com/design/xqBod46IwxD7E9thJZLWqr/Untitled

Người dùng xác nhận đã có sáu page. Giữ file hiện tại, không tạo file mới hoặc thêm page thứ bảy chỉ để chứa nguồn.

Google từng công bố chức năng Paste to Figma; UI và lựa chọn export có thể thay đổi theo tài khoản/phiên bản. Hướng dẫn có điều kiện, không khẳng định mọi tài khoản hiện có một menu giống nhau.

1. Lưu PNG/ảnh bằng chứng phiên bản Stitch cuối trước khi export.
2. Chọn một màn thử (S01). Nếu có lệnh “Copy to Figma”, “Paste to Figma” hoặc export Figma, thực hiện lệnh đó, mở page **03 Final UI** rồi dán bằng Ctrl+V.
3. Kiểm tra chữ sửa được và layer con tồn tại. Nếu chỉ có một image layer, đó là ảnh tham chiếu, chưa phải UI editable.
4. Nếu thành công, chuyển các màn còn lại; đặt tên S01–S08 nhất quán và đặt state bên cạnh màn cha. Giữ bản import gốc trong một section cùng page để so sánh nếu cần.
5. Nếu không có export phù hợp hoặc chỉ xuất được PNG, đặt ảnh làm tham chiếu trong section cùng page và dựng lại bằng frame/text/shape; không coi PNG là component. Không kết luận cần một mode cụ thể chỉ từ hướng dẫn cũ.
6. Page **02 Wireframe** dùng bố cục low-fi của cùng tám màn; dùng output W00 mới và ghi đúng thứ tự thực hiện, không chỉ đổi màu Final UI rồi ghi đã làm low-fi từ trước.
7. Page **04 Design System**: định nghĩa semantic color Variables, text/effect styles và spacing/radius phù hợp từ brief.
8. Page **05 Components**: dựng chín nhóm component bằng Auto Layout/variants, bind tokens và thay các control trong Final UI bằng instances. Import xong chưa có nghĩa đạt yêu cầu này.
9. Page **01 User Flow**: đưa ba sơ đồ và flow–screen mapping từ ux/user-flow.md vào; kiểm tra mọi màn có đường đến.
10. Page **06 Prototype**: đặt ba starting point, nối Back/cancel đúng, dialog overlay và loading → result. Thử cả alternate/error paths, không chỉ đường chính.
11. Kiểm tra 360×800 và rộng 412 dp; đo contrast, target và font từ lớp thật. Export Final UI vào assets/figma/.
12. Chụp bằng chứng binding/variants/instances và thử link quyền xem bằng cửa sổ chưa đăng nhập.

## Minh chứng Figma cần chụp

- Danh sách đúng sáu page.
- Tổng quan tám màn khác nhau, có tên ID.
- Component set với variants và Auto Layout ở panel.
- Một instance trên màn, liên kết về component.
- Token binding hoặc style đang thực sự áp dụng.
- Prototype starting points, overlay và loading → result.
- Bố cục ở 360/412; ảnh đo contrast/target/type.
- Link mở được chưa đăng nhập.

## Đối chiếu sheet

Ảnh checklist người dùng cung cấp xác nhận nhóm đã đánh dấu một số hạng mục “Đã làm”, nhưng cột “Đã kiểm tra & Xác nhận” còn trống. Không coi checkbox là kiểm chứng chất lượng.

Thay inventory generic Onboarding/Login/Home/Search/Detail/Create Form/Notification/Profile bằng bộ S01–S08 trong screen-spec.md nếu sheet đang dùng bộ đó. Giữ F01–F03, I01–I03, D01–D03 nhất quán. Đánh “đã làm” khi artifact có thật, “đã kiểm tra” sau khi mở và đối chiếu; không cập nhật sheet thay người dùng trong phiên này.

## Nguồn hướng dẫn chức năng

- Google Developers Blog, giới thiệu Stitch và Paste to Figma, 20/05/2025: https://developers.googleblog.com/en/stitch-a-new-way-to-design-uis/
- Google Labs, cập nhật Stitch ngày 19/05/2026 (cho thấy luồng export thay đổi): https://blog.google/innovation-and-ai/models-and-research/google-labs/stitch-updates/
- OpenAI, Computer Use (khả năng UI/screenshot và cách bật, không xác nhận quyền đã có trong chat): https://learn.chatgpt.com/docs/computer-use
