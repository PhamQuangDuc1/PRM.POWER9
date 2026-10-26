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
- [Slide Office hiện có](output/presentation/Power9_Office_Lab2/Power9_Office_Lab2_12_Slides.pptx), [kịch bản demo Office hiện có](output/presentation/Power9_Office_Lab2/Power9_Office_Kich_Ban_Thuyet_Trinh_Va_Demo.docx). Việc cập nhật slide đang tạm dừng, chờ người dùng push và xác nhận làm tiếp.

## Xác nhận nguồn và giới hạn

Người dùng xác nhận ngày 27/10/2026 đã gửi nguyên văn 100% các prompt Office do trợ lý cung cấp trên dự án Stitch mới. Giữ nguyên khối prompt trong ai/prompts/OFFICE-*.md; ảnh Stitch, render kiểm chứng Chrome và Figma được ghi nguồn riêng.

Timer/tìm kiếm/giờ nhắc là mô phỏng trạng thái. Chưa có user test, TalkBack, peer handoff test hoặc ứng dụng Flutter/backend. Các mục tiêu thời gian là mục tiêu thiết kế, chưa đo thực tế. Thay đổi workspace không tự động được đẩy lên GitHub.
