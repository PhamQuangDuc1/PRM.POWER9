# Gap review Final Assignment — Power9 Office Routine

Mốc rà soát 10/11/2026. Phạm vi sản phẩm tiếp tục là các hoạt động ngắn cho nhân viên văn phòng. Huy, Mai và Linh là ba proto-persona mobile của Lab 2. Vai trò web đề xuất là Admin quản lý nội dung Power9. Xác nhận vai trò này với giảng viên trước khi chốt phạm vi nộp.

## Phần kế thừa từ Lab 2 và Lab 3

- **Ba luồng mobile.** Tìm và lên lịch, thực hiện và ghi nhận, đổi hoặc hủy lịch. Giữ bốn tab, token thiết kế, trạng thái lỗi và đường quay lại. [Truy vết thiết kế](design-traceability.md)
- **Nền tảng mobile.** Flutter/Riverpod, Google Sign-In, Firestore, Analytics, Crashlytics, Remote Config, FCM và tạo PDF đã có. Các lượt Android thật và máy ảo cần ghi rõ nguồn. [Kịch bản và bằng chứng Lab 3](lab3-grading-runbook.md)
- **Phần kiểm thử còn mở.** ARTEMIS xác minh 32/33 lượt. TC10[3] dừng ở hộp nhập giờ. TC13 chưa tự động kiểm tra upload và Pro chưa đủ thời lượng. Bằng chứng DebugView vẫn cần đối chiếu theo từng event. [Kết quả ARTEMIS](../evidence/artemis/lab3-summary.json)
- **PDF theo phạm vi Assignment.** Giữ tạo, lưu và chia sẻ trên thiết bị. Hiện metadata được ghi sau upload trong luồng Lab 3, nên Assignment cần ghi metadata cho luồng PDF cục bộ. Backend Cloudinary dùng để demo Lab 3 được giữ riêng khỏi đường chạy Assignment No-Cost.

## Phần cần bổ sung cho Assignment

1. **Dữ liệu và vai trò.** Hiện Rules bảo vệ lịch và completion theo UID, còn client chỉ đọc được danh mục đã xuất bản. Bổ sung `users/{uid}.role`, quản lý danh mục theo quyền Admin, hàng đợi đề xuất và `announcements`. Ghi rõ trường, kiểu, quyền và chuyển trạng thái trong [data model](data-model.md). Viết Rules deny-by-default và test Emulator cho cả trường hợp cho phép lẫn từ chối trước khi nối UI.
2. **Ứng dụng mobile.** Hoàn thiện bộ `mobile/` và dùng chung model, Firestore service, token thiết kế qua `packages/core/`. Bổ sung màn hoặc phần đề xuất hoạt động và inbox đọc thông báo từ Firestore theo thời gian thực.
3. **Web Admin.** Dự kiến Flutter Web để chia sẻ Dart với mobile. Làm đăng nhập Google có chặn sai vai trò, quản lý danh mục có tìm/tạo/sửa/archive, hàng đợi duyệt có lý do, dashboard có ít nhất ba số liệu tổng hợp và một biểu đồ, và form gửi thông báo. Mỗi màn cần loading/empty/error. Deploy lên Firebase Hosting và kiểm tra URL từ cửa sổ ẩn danh.
4. **Luồng xuyên vai trò.** Nhân viên đề xuất một hoạt động ngắn từ mobile. Admin duyệt hoặc từ chối kèm lý do trên web. Mobile nhận trạng thái mới ngay từ Firestore. Khi duyệt, Admin có thể xuất bản hoạt động vào danh mục. Đề xuất có trạng thái riêng với lịch và completion cá nhân. Form Admin gửi thông báo vào inbox là một luồng riêng. Ghi actor, collection, Rules và thời gian cập nhật trong `docs/cross-role-flow.md`.
5. **Gemini trong luồng Khám phá.** Đề xuất trả JSON chứa ID hoạt động có sẵn từ nhóm thói quen và thời lượng người dùng chọn. App chỉ hiển thị ID hợp lệ trong danh mục đã xuất bản. Người dùng được chỉnh hoặc bỏ gợi ý, sau đó vẫn tự quyết định có lưu lịch hay không. Dùng Firebase AI Logic, App Check, model/prompt/cờ bật trong Remote Config, fallback tìm/lọc khi lỗi và ba event `ai_request`, `ai_result_accepted`, `ai_error`. Ghi ba ví dụ thật và một nhánh lỗi trong `docs/ai-feature.md`.
6. **Tích hợp và nghiệm thu.** App Check cho Firestore và AI Logic. Analytics và Remote Config ở cả hai client, Crashlytics ở mobile. Chạy Rules tests, ARTEMIS, checklist web và ba lượt cross-role trên bản deploy. Review AI phần code mới với tối thiểu ba findings có quyết định. Hồ sơ Assignment có README, URL web, báo cáo, slide và link video riêng.

## Phạm vi web xem crash

Đề Assignment quy định Crashlytics trên mobile. Yêu cầu bổ sung về Admin xem crash trên web cần chốt nguồn dữ liệu và mức cập nhật với giảng viên. Màn này được đánh dấu riêng với bốn màn và form thông báo bắt buộc. Kiến trúc No-Cost dùng Firebase Hosting, Firestore và client SDK, nên cần xác nhận phương án trước khi tích hợp dữ liệu crash vào web.

## Checklist nghiệm thu theo đề giảng viên

- [x] Rà khoảng trống Lab 2 và Lab 3, giữ chủ đề Power9 Office Routine.
- [ ] Xác nhận vai trò web với giảng viên. Mobile phục vụ User. Web phục vụ Admin.
- [ ] Data model ghi trường, kiểu, quyền CRUD, chuyển trạng thái và màn sử dụng. Rules kiểm tra cả trường hợp cho phép và từ chối theo vai trò trên Emulator.
- [ ] Mobile giữ các luồng Lab 2/Lab 3 và có inbox thông báo Firestore. PDF Assignment lưu/chia sẻ trên máy và ghi metadata trong Firestore.
- [ ] Web Admin có đăng nhập, quản lý danh mục, hàng đợi duyệt, dashboard có ít nhất ba số liệu và một biểu đồ, cùng form gửi thông báo. Kiểm tra trạng thái loading, empty và error.
- [ ] Mobile và web dùng chung package Dart, dữ liệu và token thiết kế. Firebase Hosting phục vụ web. Phạm vi No-Cost không dùng Cloud Functions, Cloud Storage, App Hosting hoặc server riêng.
- [ ] Luồng đề xuất → duyệt/từ chối → mobile cập nhật realtime. Đo thời gian cập nhật và chạy ba lần trên bản deploy.
- [ ] Firebase AI Logic trả gợi ý có cấu trúc, có xác nhận của người dùng và fallback. Remote Config quản lý model, prompt và cờ bật. App Check bảo vệ Firestore và AI Logic.
- [ ] Analytics và Remote Config có trên mobile và web. Crashlytics chạy trên mobile. Xác nhận riêng cách đáp ứng yêu cầu bổ sung về xem crash trên web.
- [ ] Có ARTEMIS, Rules tests, checklist web, ít nhất ba findings review code mới, và bộ nộp Assignment gồm URL web, README, báo cáo 10–15 trang, slide 12–15 trang và video 8–12 phút theo đề.

## Tiến độ triển khai

- Đã có code form đề xuất và danh sách kết quả trên mobile sau cờ build `POWER9_ASSIGNMENT`. Web Flutter có Google Sign-In, chặn tài khoản thiếu role Admin và hàng đợi duyệt kèm lý do.
- Firestore Rules và model/service chia sẻ đã có cho hai role và luồng đề xuất. Xem [cách chạy web trên Emulator](../web/README.md) và [quyền theo collection](data-model.md).
- Kiểm thử cục bộ 10/11: 19 Firestore Rules tests và 53 Flutter tests đạt. Rules tests kiểm tra đề xuất của chủ tài khoản, từ chối tài khoản khác, ngăn tự nâng role và xác nhận Admin chỉ quyết định một lần. Chưa tính đây là lượt chạy xuyên mobile–web trên bản deploy.
- Web có Google Sign-In và chặn sai role, quản lý danh mục, duyệt/xuất bản, dashboard tổng hợp và form thông báo. Bản responsive đã lên [Firebase Hosting](https://power9-office-se180724.web.app/). Phiên trình duyệt mới đã mở được Google Sign-In. Thao tác Admin và luồng xuyên vai trò đã kiểm thử trên Emulator theo lựa chọn của nhóm. [Bằng chứng web](../evidence/assignment/web-emulator/)
- PDF Assignment lưu và chia sẻ trên máy, đồng thời ghi metadata theo UID. Đã gọi Gemini thật ba lần từ Android Emulator qua App Check debug, thử nhánh lỗi và tắt bằng Remote Config. Flutter đạt 56 và Rules đạt 23. App Check production và ba lượt xuyên vai trò trên bản deploy chưa được xác minh trong phạm vi Emulator. [Tính năng AI](ai-feature.md) · [Luồng xuyên vai trò](cross-role-flow.md)
