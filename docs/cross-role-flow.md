# Luồng xuyên vai trò của Power9

1. **User trên Android → Khám phá → Đề xuất hoạt động.** App tạo `activityProposals/{uid}~{id}` ở trạng thái `pending`. Rules kiểm tra UID của người gửi và dữ liệu biểu mẫu. Web Admin nhận đề xuất trong hàng đợi qua Firestore snapshot.
2. **Admin trên web → Duyệt đề xuất.** Admin lưu lý do cùng trạng thái `approved` hoặc `rejected`. Rules xác minh role Admin và chỉ cho quyết định một lần từ `pending`. Android nhận kết quả và lý do trong **Đề xuất của tôi**.
3. **Admin trên web → Lịch sử xử lý → Xuất bản.** Transaction tạo hoạt động đã xuất bản và ghi `publishedActivityId` vào đề xuất. Android thấy hoạt động trong **Khám phá** qua query `published == true`.
4. **Admin trên web → Thông báo.** Admin xem trước và xác nhận gửi. Rules chỉ cho Admin tạo `announcements/{id}`. Inbox Android đọc Firestore qua snapshot và cập nhật khi đang mở.

Đã kiểm tra cả duyệt, từ chối, xuất bản và inbox trên Firebase Emulator. Thời gian cập nhật và ba lượt trên bản Hosting cần đo riêng khi có tài khoản thật cho các vai trò. [Bằng chứng kiểm thử](test-report.md)
