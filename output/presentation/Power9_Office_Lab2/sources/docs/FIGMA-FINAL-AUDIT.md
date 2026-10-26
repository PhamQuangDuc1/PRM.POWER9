# Power9 Office — kết quả rà soát Figma

Người dùng xác nhận27/10/2026: các prompt Office đã gửi nguyên văn100% trên Stitch mới. Các nhận xét dưới đây ghi theo mốc đánh giá; kết quả hiện hành xem office-checkpoint.json và FIGMA-FINAL-AUDIT.md.


> **Finding accordion đã xử lý:** cả9nhóm hiện có mở/thu gọn thật bằng interactive variants, thẻ hoạt động và mũi tên vector dẫn đúng chi tiết.27/27nhóm trong3bộ lọc đã qua kiểm tra chuyển trạng thái và bảo toàn navigation;18nhóm trong UI360/412đã đồng bộ. Tổng hiện hành323reactions,0đích hỏng,3startingpoints. Thư viện thêmP9/DiscoverGroup18variants, thành10families/53variants. Ảnh đọc lại preview412đã xem; chi tiết tại `assets/figma/office-accordion-audit.json`. Các số266reactions/9sets bên dưới là mốc trước bổ sung accordion. Đã đánh dấu hoàn tất tại `assets/figma/office-checkpoint.json` → `accordionFollowup`.

Ngày 26/10/2026. File hiện hành: https://www.figma.com/design/MTv5qJbn065VYJQIXausoq

## Sáu page

| Page | Kết quả trực tiếp |
| --- | --- |
| 01 User Flow | 3 persona chính ngang nhau; IA, 9 nhóm, 3 flow; sửa ghi chú triển khai cũ và gắn3link chạy prototype |
| 02 Wireframe | 10 frame360×800,107text editable; giữ nội dung đã dựng |
| 03 Final UI | 10màn360×800,20state dữ liệu/phục hồi và overlay;10bản412×800 riêng;147text và38instances trong bộ10màn chính |
| 04 Design System | 37variables:12primitive+12semantic alias+8spacing+5radius;6textstyles Be Vietnam Pro;1effectstyle; đã xem screenshot toàn board |
| 05 Components | 9sets/35variants; AutoLayout, text properties, token bindings; logo gốc, icon vector, icon Empty/Loading; sửa copy dialog destructive |
| 06 Prototype | 3startingpoints;266reactions;96frame gồm snapshots dữ liệu, lọc, lỗi, overlay và nguồn điều hướng. Đây là10màn chức năng, không phải96màn khác nhau |

## Đã sửa trong lượt rà soát

- AppBar đặt logo trong master, tránh thêm node vào instance. Giữ logo gốc người dùng.
- Hàng bộ lọc Khám phá cao48; mặc định Tất cả; nhánh≤5loại hoạt động10phút; Back từ chi tiết/form giữ nguồn bộ lọc.
- Tạo dữ liệu chi tiết/lịch/tiến độ riêng cho các hoạt động trong9nhóm. Trò chuyện không còn mở dữ liệu đi bộ; các nhóm khác không dùng sai hoạt động mẫu.
- Thêm nhánh phụ Ăn uống, Kết nối, Góc làm việc, Ngủ và lịch nghỉ tối.
- Chuẩn hóa F01: đi bộ12:00; loading/error/retry giữ dữ liệu; sau thêm Home/history1/4,25%.
- Chuẩn hóa F03: tổng kết17:30→18:00; lỗi không sửa Home; sau lưu không tăng tổng; giải thích không phát thông báo trong giờ yên lặng.
- Active/paused có overlay riêng; Giữ lại đóng về đúng ngữ cảnh. Phiên3phút sau ghi nhận hiển thị2/4; kết thúc sớm ghi45giây trên cả Home/history.
- Check-in2/3 và Hoàn tác về đúng bản gốc1/3.
- Bổ sung Xóa bản ghi→overlay Giữ lại/Xóa→history trống và Home0/3, giữ hoạt động trong lịch.
- Thay glyph điều hướng bằng icon vector; bổ sung icon Empty/Loading và copy dialog destructive.
- Cập nhật status/link trên page01; giữ nguyên các màn wireframe, token và component hợp lệ.

## Kiểm tra và bằng chứng

- Đã xem ảnh tổng quan10màn, form lịch,412Home, bộ lọc sau sửa, component Navigation, Design System, save-error, overlay rời phiên, history trống và overlay xóa.
- Kiểm tra10màn360 và10màn412: không phát hiện text rộng hơn parent hoặc width0; CTA trong bộ chính cao≥48; không có imagefill toàn màn.
- Kiểm tra đích của266reactions:0đích thiếu hoặc ở sai page. Đúng3startingpoints.
-15kiểm tra về dữ liệu/điều hướng đều qua: lọc/Back,1/4và25%, lỗi giữ form, giờ mới/giờ cũ,2/4,45giây,Undo,9nhóm. Kiểm tra bổ sung xóa: Home vàhistory đều0/3.
- Kiểm tra cú pháp script bằng `node scripts/figma/check-office-scripts.cjs`. Đây là cú pháp JavaScript, không thay thế kết quả Figma trực tiếp ở trên.

JSON thực: `assets/figma/office-checkpoint.json`, `office-ui-result.json`, `office-six-page-audit.json`, `office-library-audit.json`, `office-prototype-final-audit.json`, `office-behavior-audit.json`, `office-empty-history-audit.json`, `office-deletion-audit.json`.

## Giới hạn được ghi đúng

Timer là mô phỏng bằng snapshot03:00/02:15/00:00 và transition; không phải countdown từng giây. Chưa có playthrough với người dùng thực hoặc số đo thời gian hoàn thành tác vụ. Không xác nhận backend, gửi thông báo, hoặc ứng dụng Flutter đã chạy. Tìm kiếm/nhập giờ là các lựa chọn trạng thái mẫu trong prototype.