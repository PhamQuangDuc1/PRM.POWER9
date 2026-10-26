# Bộ trình bày Power9 Office Routine

Hoàn thiện 27/10/2026 theo hai tài liệu hướng dẫn PRM323 Lab2 được cung cấp.

## Cách sử dụng

1. Giải nén toàn bộ gói, giữ PowerPoint, Word và thư mục sources cạnh nhau.
2. Mở Power9_Office_Lab2_12_Slides.pptx. Có12 slide, nguồn bấm được ở chân mỗi slide, speaker notes có lời nói và nguồn chi tiết. Slide 05có toàn văn bản prompt lưu trong notes.
3. Mở Power9_Office_Kich_Ban_Thuyet_Trinh_Va_Demo.docx để tập bài nói10 phút, demo5 phút và hỏi đáp. Thời gian là phân bổ dự kiến, chưa đo thực tế.
4. Slide 11có3 link bắt đầu prototype. Kịch bản chỉ đúng nhãn nút, đường lỗi/Thử lại, overlay và kết quả cần thấy. Dùng nhánh45 giây để tránh chờ3 phút.
5. Khi mở nguồn cục bộ từ slide, nếu PowerPoint hỏi cho phép mở tệp, chỉ mở các tệp trong sources của gói này.

## Liên kết dự án do người dùng cung cấp

- Stitch: https://stitch.withgoogle.com/projects/2176700449127941467
- Figma: https://www.figma.com/design/MTv5qJbn065VYJQIXausoq/Untitled?node-id=10-14
- GitHub: https://github.com/PhamQuangDuc1/PRM.POWER9

## Phạm vi và giới hạn

Hồ sơ theo Office Routine,3 persona chính ngang nhau,10 màn chức năng,3 flow,10 component families / 53 variants. Kiểm tra323 reactions không có đích hỏng là kiểm tra cấu trúc; chưa thay cho playthrough với người dùng. Timer/tìm kiếm/giờ nhắc là mô phỏng trạng thái, chưa có app Flutter/backend.

Trước buổi chấm cần tập demo, kiểm tra quyền xem link ở cửa sổ chưa đăng nhập, đối chiếu prompt thực gửi trong Stitch. Link dự án không tự chứng minh toàn bộ lịch sử prompt; công cụ web chưa đọc được nội dung dự án Stitch. Các ảnh đã xuất có xuất xứ riêng. Bản tổng quan10 UIđược lưu trước bổ sung accordion, còn ảnh ACCORDION.png là cập nhật cuối.

Các tài liệu AI log và review giữ cả lịch sử. Phần hoàn thiện Figma và nguồn hiện hành được chỉ ra trong checkpoint/audit. Những thay đổi mới trong workspace chưa tự động được đẩy lên GitHub.
