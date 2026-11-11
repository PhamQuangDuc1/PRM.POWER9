# Gợi ý hoạt động bằng Gemini

Trong **Khám phá**, người dùng chọn nhóm hoạt động và khoảng thời gian 3, 5 hoặc 10 phút. App lọc danh mục Firestore đã xuất bản theo hai lựa chọn và giới hạn thời lượng của Remote Config. Firebase AI Logic gọi Gemini Developer API với tối đa 30 ứng viên, mỗi ứng viên chỉ có ID, mã nhóm và thời lượng. Nội dung tìm kiếm, lịch cá nhân, tên và email không đi vào prompt.

Gemini trả JSON dạng `{"activity_ids":["move-walk"]}`. App đối chiếu với danh mục ứng viên, bỏ ID lạ và trùng, rồi hiển thị tối đa 3 mục có nhãn AI. Người dùng có thể đổi nhóm hoặc thời lượng để tạo lại, bỏ gợi ý, hoặc mở chi tiết một mục để tự đặt lịch. Chọn gợi ý chưa tạo lịch.

- Remote Config quản lý `discover_ai_enabled`, `discover_ai_model` và `discover_ai_prompt`. Cờ mặc định tắt. Model mặc định là `gemini-3.5-flash-lite`.
- App Check dùng Play Integrity cho Android. Bản debug có thể chọn debug provider với `--dart-define=POWER9_APP_CHECK_DEBUG=true` và token đã đăng ký trong project. AI yêu cầu lấy được App Check token trước khi gửi.
- Analytics ghi `ai_request`, `ai_result_accepted` và `ai_error`. Mất mạng, hết quota, lỗi App Check hoặc JSON lỗi đều giữ nguyên chức năng tìm và lọc thủ công.
- Test Flutter đã xác nhận bỏ ID lạ, bỏ mục trùng, giới hạn ba mục và phát hiện JSON lỗi. Các lượt dưới đây dùng bản Android debug trên Emulator kết nối Firebase thật, với token App Check debug đăng ký riêng cho lượt kiểm thử. Các sự kiện Analytics đã nối trong code và chưa đối chiếu trên DebugView ở lượt này.

## Kết quả gọi Gemini thật

- **Tất cả nhóm, tối đa 3 phút.** Đi bộ giữa giờ (3 phút), Kiểm tra tư thế (2 phút), Nghỉ sau họp (3 phút). [Ảnh kết quả](../evidence/assignment/web-emulator/19-ai-result-3m.png)
- **Tất cả nhóm, tối đa 5 phút.** Đi bộ giữa giờ (3 phút), Kiểm tra tư thế (2 phút), Nghỉ sau họp (3 phút). [Ảnh kết quả](../evidence/assignment/web-emulator/18-ai-result-5m.png)
- **Tất cả nhóm, tối đa 10 phút.** Đi bộ giữa giờ (3 phút), Kiểm tra tư thế (2 phút), Nghỉ sau họp (3 phút). [Ảnh kết quả](../evidence/assignment/web-emulator/19-ai-result-10m.png)

Cả ba lượt đều trả về cùng bộ hoạt động, hợp lệ với từng giới hạn. Mở gợi ý Đi bộ giữa giờ đưa người dùng đến chi tiết hoạt động.

Trước khi token debug được đăng ký, App Check trả lỗi và màn hình hiển thị hướng dẫn tìm/lọc thủ công. [Ảnh nhánh lỗi](../evidence/assignment/web-emulator/17-ai-fallback.png)

Sau ba lượt thành công, đổi `discover_ai_enabled` thành `false` trên Firebase và mở lại app. Mục Gemini ẩn đi, Khám phá vẫn có danh mục. Token App Check debug tạm đã được thu hồi sau lượt kiểm thử. [Ảnh tắt bằng Remote Config](../evidence/assignment/web-emulator/20-ai-remote-config-off.png)

[Firebase AI Logic models](https://firebase.google.com/docs/ai-logic/models)
