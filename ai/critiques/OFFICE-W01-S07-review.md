# Review OFFICE-W01-S07 — Lịch mặc định

Nguồn: assets/stitch/office-new/OFFICE-W01-S07/before-overview.png. Reviewer: Codex. Đánh giá screenshot, chưa kiểm tra layer hoặc chạy form. Không lấy lời xác nhận trong sidebar Stitch làm bằng chứng đo lường.

Giữ: form một cột; tóm tắt đúng hoạt động, ngày thực hiện một lần, nhắc đang bật, trường giờ, giờ yên lặng với nhãn hôm sau, nút Lưu lịch nổi bật và Hủy phân cấp phụ. Không bottom navigation. Trợ giúp giải thích nhắc bị tắt trong giờ yên lặng, không cấm lên lịch.

| ID | Phát hiện có bằng chứng | Persona / heuristic | Đề xuất |
| --- | --- | --- | --- |
| S07-01 | App bar ghi Chi Tiết Thói Quen dù nội dung là form đặt lịch | Cả ba; Visibility of system status / Consistency and standards | Đổi thành Lịch thói quen, giúp biết đang ở bước khác S06 |
| S07-02 | Giờ nhắc 12:00 CH, khoảng yên lặng 06:00 CH–08:00 SA, không đúng định dạng 24h đã chọn | Huy/Mai/Linh; Consistency and standards / Error prevention | Dùng 12:00 và 18:00–08:00 hôm sau, bỏ SA/CH; không đổi giá trị thời gian thực |

Cần kiểm tra sau, chưa coi là lỗi chắc chắn: chú thích dưới công tắc và trường ngày trông nhỏ ở canvas thu nhỏ, cần đo ≥14; target Hủy và công tắc cần đo ≥48; Back/Hủy không lưu; tắt nhắc ẩn giờ; validation/error giữ dữ liệu; lưu tạo hoạt động chưa hoàn thành và đúng ngày; frame 360×800 và responsive. Ảnh chưa chứng minh các hành vi này.

Đề xuất giữ cấu trúc, sửa hai vấn đề trước khi tiếp tục. Không thêm nội dung hoặc state vào form mặc định. Nếu control giờ native phụ thuộc locale trình duyệt, dùng biểu diễn text 24h cho wireframe thay vì hứa input native sẽ luôn hiển thị 24h. Logic/locale picker thực phải ghi lại khi handoff.

Prompt sửa: ai/prompts/OFFICE-W02-S07-fix.md, chưa gửi, chưa có AFTER. Chưa tự tính vòng sửa hoàn tất.
