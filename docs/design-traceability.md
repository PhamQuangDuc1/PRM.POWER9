# Lab 3 — Truy vết từ Lab 2

Khung chốt 31/10/2026 trước feature. Nguồn: `design/screen-spec.md`, `handoff/flutter-handoff.md`, `ux/user-flow.md` và audit Figma đã lưu; chưa đọc lại Figma trực tiếp.

| Thiết kế | Route dự kiến | ViewModel / service | Trạng thái |
| --- | --- | --- | --- |
| Bổ sung Login | `/login` | LoginViewModel / FirebaseAuthService | UI, auth-state và xử lý lỗi đã có mã; đang kiểm chứng thiết bị |
| S01 Hôm nay | HomeShell → TodayScreen | daySchedulesProvider / ScheduleService | Có lịch thật, loading/empty/error; completion/tiến độ chưa dựng |
| S02 Ăn uống | tab Ăn uống | groupActivitiesProvider / ActivityService | Tạm hiển thị danh mục nhóm, chưa có flow ghi nhận |
| S03 Thư giãn | tab Thư giãn | groupActivitiesProvider / ActivityService | Tạm hiển thị danh mục nhóm; timer chưa dựng |
| S04 Kết nối | tab Kết nối | groupActivitiesProvider / ActivityService | Có danh mục tự nguyện; flow ghi nhận chưa dựng |
| S05 Khám phá | MaterialPageRoute → DiscoverScreen | DiscoverViewModel / ActivityService | Có tìm/filter/group, empty/reset, retry; đọc Firestore |
| S06 Chi tiết | MaterialPageRoute → ActivityDetailScreen | activitiesProvider / ActivityService | Hiện nội dung thật từ danh mục; phân biệt mới/đã có lịch |
| S07 Lịch | ScheduleScreen.route | ScheduleViewModel / ScheduleService | Có date/time picker, validation, cancel, loading, giữ draft/retry, create/edit transaction; chờ kiểm thử thiết bị |
| S08 Tiến độ | `/progress` | ProgressViewModel / CompletionService | Chưa triển khai |
| S09 Góc làm việc | `/workspace` | ChecklistViewModel / CompletionService | Chưa triển khai |
| S10 Ngủ & phục hồi | `/recovery` | ActivityViewModel / ScheduleService | Chưa triển khai |
| Bổ sung Profile/demo | `/profile` | ProfileViewModel / AuthService | Có màn tài khoản/logout; khu demo sáu dịch vụ chưa triển khai |

F01 và F03 đã có mã và build, chờ kiểm chứng end-to-end trên Xperia. F02 chưa triển khai. Giữ đủ phạm vi cũ; không coi danh sách nhóm tạm thời là S02/S03/S04 hoàn chỉnh.

Component mapping: P9/Button → P9Button (filled/loading/disabled); logo → P9Logo; tokens → P9Theme; Card → P9ActivityCard; Loading/Error/Empty → P9AsyncContent/P9Empty. NavigationBar giữ bốn tab; DiscoverGroup hiện dùng ExpansionTile. TextField, AppBar, Dialog và outline/text variants cần tiếp tục hợp nhất thành component theo handoff, chưa khẳng định design system đã đầy đủ.

## Quyết định và khác biệt

- Tên cài đặt/title **Power9 Office Routine**, logo gốc với nền trắng, theo người dùng. Không recolor hoặc vẽ lại.
- Login/Profile là bổ sung theo đề; không đổi bốn tab Lab 2. Login mới cần được đồng bộ vào Figma khi có quyền thao tác.
- Dùng token cuối trong handoff, ưu tiên hơn brief cũ. Font ban đầu Roboto, fallback Lab 2 cho phép; chưa bundle Be Vietnam Pro.
- Dùng Firebase project mới theo người dùng; Android config, SHA-1 và OAuth đã có. Không giả đăng nhập hay hiển thị dữ liệu cá nhân giả; chưa phải bản nộp.
