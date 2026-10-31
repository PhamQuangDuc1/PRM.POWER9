# Lab 3 — Truy vết từ Lab 2

Khung chốt 31/10/2026 trước feature. Nguồn: `design/screen-spec.md`, `handoff/flutter-handoff.md`, `ux/user-flow.md` và audit Figma đã lưu; chưa đọc lại Figma trực tiếp.

| Thiết kế | Route dự kiến | ViewModel / service | Trạng thái |
| --- | --- | --- | --- |
| Bổ sung Login | `/login` | LoginViewModel / FirebaseAuthService | UI, auth-state và xử lý lỗi đã có mã; đang kiểm chứng thiết bị |
| S01 Hôm nay | HomeShell → TodayScreen | todayOverviewProvider / ScheduleService, CompletionService | Lịch/tiến độ thật; check-in/undo; không đặt chỉ tiêu 9/9 |
| S02 Ăn uống | tab Ăn uống → FoodScreen | activityByIdProvider / CompletionService | Hướng dẫn 3 bước, ghi nhận/undo không gán thời lượng; mở Progress và Back đúng nguồn |
| S03 Thư giãn | tab Thư giãn → RelaxScreen | SessionViewModel / SessionClock, CompletionService | Timer monotonic; pause/resume/background; leave confirmation; early/full record, retry giữ thời lượng |
| S04 Kết nối | tab Kết nối → ConnectionScreen | groupActivitiesProvider / ActivityService, CompletionService | Hai hoạt động đi bộ/trò chuyện, nội dung tự nguyện, chi tiết riêng, check-in/undo và Progress |
| S05 Khám phá | MaterialPageRoute → DiscoverScreen | DiscoverViewModel / ActivityService | Có tìm/filter/group, empty/reset, retry; đọc Firestore |
| S06 Chi tiết | MaterialPageRoute → ActivityDetailScreen | activitiesProvider / ActivityService | Hiện nội dung thật từ danh mục; phân biệt mới/đã có lịch |
| S07 Lịch | ScheduleScreen.route | ScheduleViewModel / ScheduleService | Có date/time picker, validation, cancel, loading, giữ draft/retry, create/edit transaction; chờ kiểm thử thiết bị |
| S08 Tiến độ | MaterialPageRoute → ProgressScreen | todayOverviewProvider / CompletionService | Chọn ngày, done/pending, empty, undo/delete có xác nhận; schedule giữ nguyên |
| S09 Góc làm việc | ActivityDetailScreen → WorkspaceScreen | ChecklistViewModel / CompletionService | Route từ space-desk/posture-check, đủ mục mới ghi nhận, source checklist, giữ lựa chọn khi lỗi; một occurrence mỗi hoạt động/ngày |
| S10 Ngủ & phục hồi | ActivityDetailScreen → RecoveryScreen | ScheduleViewModel / ScheduleService | Nội dung nghỉ tối, mở form đúng activity, Hủy/Back về nguồn, lưu thành công trở lại S10 |
| Bổ sung Profile/demo | `/profile` | ProfileViewModel / AuthService | Có màn tài khoản/logout; khu demo sáu dịch vụ chưa triển khai |

F01/F03 và nhánh chính F02 đã smoke test trên Xperia, có đối chiếu Firestore server. F02 nhánh Ăn uống đã thử record/undo. S04/S09/S10 có mã từ 01/11; kết quả bổ sung được ghi tại `docs/workspace-verification.md`. Đây chưa phải bộ ARTEMIS >=3 lượt/test và chưa thay thế kiểm tra fidelity toàn bộ Lab 2.

Component mapping: P9/Button → P9Button (filled/loading/disabled); logo → P9Logo; tokens → P9Theme; Card → P9ActivityCard; Loading/Error/Empty → P9AsyncContent/P9Empty. NavigationBar giữ bốn tab; DiscoverGroup hiện dùng ExpansionTile. TextField, AppBar, Dialog và outline/text variants cần tiếp tục hợp nhất thành component theo handoff, chưa khẳng định design system đã đầy đủ.

F02 bổ sung P9CompletionButton, P9ProgressSummary và dialog rời phiên. Timer dùng text style displayMedium trong theme cho số đếm dễ đọc; không đặt cỡ chữ/màu cứng trong màn. Cần đồng bộ lại Figma và kiểm tra fidelity trước nộp, chưa khẳng định screenshot app khớp pixel-perfect với Lab 2.

## Quyết định và khác biệt

- Tên cài đặt/title **Power9 Office Routine**, logo gốc với nền trắng, theo người dùng. Không recolor hoặc vẽ lại.
- Login/Profile là bổ sung theo đề; không đổi bốn tab Lab 2. Login mới cần được đồng bộ vào Figma khi có quyền thao tác.
- Dùng token cuối trong handoff, ưu tiên hơn brief cũ. Font ban đầu Roboto, fallback Lab 2 cho phép; chưa bundle Be Vietnam Pro.
- Dùng Firebase project mới theo người dùng; Android config, SHA-1 và OAuth đã có. Không giả đăng nhập hay hiển thị dữ liệu cá nhân giả; chưa phải bản nộp.
