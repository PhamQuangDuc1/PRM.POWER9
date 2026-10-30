# Power9 Office Routine

Ứng dụng Android tiếng Việt giúp nhân viên văn phòng tự chọn, lên lịch và ghi nhận hoạt động ngắn trong ngày làm việc. Ba persona chính ngang nhau: Huy 28 tuổi, Mai 24 tuổi và Linh 39 tuổi; đều là persona giả định.

Figma: https://www.figma.com/design/MTv5qJbn065VYJQIXausoq

Stitch: https://stitch.withgoogle.com/projects/2176700449127941467

GitHub: https://github.com/PhamQuangDuc1/PRM.POWER9

## Phạm vi hiện hành

9 nhóm: Move Often, Sit Smart, Eat Well, Sleep Well, Manage Stress, Healthy Space, Social Bonds, Purpose, Work–Life Balance. Một ứng dụng chung, không chọn persona và không ép hoàn thành 9/9 mỗi ngày.

Figma có 6 page, 10 màn chức năng, 3 starting point; bản 360 và 412 px. Thư viện có 37 biến, 6 text style, 1 effect style, 10 component families và 53 variants. Cả 9 nhóm Khám phá có mở/thu gọn. Kiểm tra 323 reactions không phát hiện đích hỏng.

## Tài liệu và bằng chứng

- [Persona](ux/persona.md), [IA và ba flow](ux/user-flow.md).
- [Brief](design/DESIGN.md), [10 màn](design/screen-spec.md), [quyết định thiết kế](design/design-decisions.md).
- [AI log](ai/ai-design-log.md), [3 phản biện](ai/critiques/OFFICE-3-MAIN-CRITIQUES.md), [before/after](docs/SLIDE-3-VONG-PHAN-BIEN.md).
- [Design system và component](design/component-spec.md), [audit Figma](docs/FIGMA-FINAL-AUDIT.md).
- [Flutter handoff 10 màn và hai mapping](handoff/flutter-handoff.md).
- [Slide Office hoàn chỉnh](output/presentation/Power9_Office_Lab2_Cap_Nhat/Power9_Office_Lab2_Hoan_Chinh.pptx), [kịch bản thuyết trình, demo và hỏi đáp](output/presentation/Power9_Office_Lab2_Cap_Nhat/Power9_Office_Kich_Ban_Cap_Nhat.docx).
- [Tải toàn bộ gói trình bày](output/presentation/Power9_Office_Lab2_Hoan_Chinh.zip), [hướng dẫn mở](output/presentation/Power9_Office_Lab2_Cap_Nhat/HUONG_DAN.md).

## Xác nhận nguồn và giới hạn

Người dùng xác nhận ngày 27/10/2026 đã gửi nguyên văn 100% các prompt Office do trợ lý cung cấp trên dự án Stitch mới. Giữ nguyên khối prompt trong ai/prompts/OFFICE-*.md; ảnh Stitch, render kiểm chứng Chrome và Figma được ghi nguồn riêng.

Timer/tìm kiếm/giờ nhắc là mô phỏng trạng thái. Chưa có user test, TalkBack, peer handoff test hoặc ứng dụng Flutter/backend. Các mục tiêu thời gian là mục tiêu thiết kế, chưa đo thực tế. Thay đổi workspace không tự động được đẩy lên GitHub.

## Bộ trình bày cập nhật ngày 27/10/2026

12 slide theo hai tài liệu hướng dẫn Lab 2. Slide 06 trình bày ba vòng cải tiến và ảnh trước/sau; slide 07 có năm phát hiện, quyết định và lý do. Mỗi slide có nguồn HTTPS bấm được. Các nguồn GitHub gắn commit `aed77f1ccd9b8721816932cc7471992fbb7b7be8` đã push, để giữ nguyên minh chứng khi main cập nhật. Đã kiểm tra 31 URL trả HTTP 200; phản hồi HTTP không thay thế quyền xem nội dung Figma/Stitch.

Kịch bản có lời nói cho 12 slide, phân bổ 10 phút, demo 5 phút, ba flow và phần hỏi đáp. Đã xem bản render của 12 slide và 8 trang kịch bản. Lượt này Figma MCP báo hết hạn mức gói Starter; số liệu thiết kế dựa trên audit và ảnh đã lưu, chưa có kiểm tra trực tiếp Figma mới.
