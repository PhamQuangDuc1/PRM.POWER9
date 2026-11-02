# Đối chiếu CRUD Lab 3

## Kết quả sau triển khai

Đã bổ sung Delete ở chi tiết lịch, confirmation/cancel, loading/error/retry, bảo vệ đổi tài khoản và giữ completion history. Lịch tương lai ở Tiến độ mở được chi tiết để sửa/xóa. Flutter48/48 đạt, analyzer sạch; native CRUD trên Xperia đã được đối chiếu với Firestore trong evidence/flows/crud/native-crud-result.json: create/read/update/delete, cancel không ghi, xóa lịch giữ completion, rồi cleanup đúng dữ liệu thử. Không coi demo native là ARTEMIS. Phần audit dưới mô tả baseline trước bổ sung để giữ lý do thay đổi.

Kiểm tra ngày 02/11/2026 tại commit ddd088e. Phạm vi: đọc hai đề gốc, các services, ViewModels, screens và Security Rules. Đây là audit mã/UI, không phải lượt kiểm thử thiết bị mới. Không thay đổi runtime trong lần kiểm tra này.

## Hai bản đề có yêu cầu khác nhau

- **Cloud-Enabled Mobile App (Firebase, Patrol, AI Code Review)**, 18 trang: đây là chuẩn đã chọn cho dự án, nội dung dùng ARTEMIS. Mục 3 trang 2–3 yêu cầu đủ màn và ba flow Lab 2, dữ liệu thật API/Firestore, export/upload; rubric trang 12 yêu cầu dữ liệu/nội dung đúng thiết kế. Không có yêu cầu CRUD chung cho thực thể chính hoặc CRUD cho mọi collection.
- **From Design to Working App with Flutter and Firebase**, 17 trang: mục 3 trang 2 yêu cầu dữ liệu create/read/update/delete thật. Mục 6.3 trang 5 yêu cầu đầy đủ CRUD cho **main entity**, ít nhất hai collection/subcollection, query/filter/sort và realtime listener. Trang 13 có tiêu chí Data operations 10/100 và video phải thể hiện create/edit/delete main entity. Bản này dùng MobAI, có tùy chọn object storage khác; không trộn riêng điều kiện thuận lợi của bản này vào chuẩn Cloud-Enabled.

Ngay cả bản thứ hai cũng không yêu cầu mọi collection đều có CRUD. Cần chọn rõ thực thể chính và chứng minh đủ bốn thao tác trên cùng thực thể, qua app và dữ liệu thật.

## Hiện trạng Power9

| Phần dữ liệu | Thực tế trong app | Đánh giá |
| --- | --- | --- |
| Lịch cá nhân / schedules | Create từ Khám phá; read Home/Progress/Detail; update giờ/nhắc qua Đổi lịch. Có delete service và Rules, nhưng không có action ViewModel hoặc nút UI gọi xóa lịch. | CRUD qua giao diện chưa đầy đủ; thiếu Delete. |
| Bản ghi thực hiện / completions | Create từ check-in/checklist/timer, read Tiến độ; delete qua Hoàn tác/Xóa bản ghi. Rules cấm update. | Bất biến là quyết định nghiệp vụ hợp lý; không nên cho sửa giây đo thật chỉ để đủ CRUD. |
| Danh mục / activities | Client đọc hoạt động published; client write bị Rules cấm, catalog do script quản lý. | Hợp lý cho danh mục dùng chung. Không nên cho người dùng sửa/xóa danh mục chung. |
| PDF / reports | Generate và preview/share local có; upload production chưa đạt. Metadata Rules cho create/read, không update/delete. | Thiếu upload là yêu cầu riêng của Lab 3; không giải quyết bằng cách thêm CRUD local. |
| Notifications | Nhận message, đọc lịch sử riêng theo user, markRead; không có xóa inbox. | Xóa là tiện ích có thể bổ sung; không tự suy ra tiêu chí CRUD main entity. |
| Account | Google Sign-In, đọc name/email, sign-out; chưa có edit/delete account. | Auth không phải main entity CRUD; logout không phải delete account. Các nhánh lỗi/evidence vẫn được đánh giá riêng. |

Chứng cứ mã:

- `lib/services/firestore_schedule_service.dart:15` watchDay có query theo ngày, snapshots realtime, sort giờ; `:31` save tạo hoặc update bằng transaction; `:68` delete tồn tại ở service.
- `lib/screens/activity_detail_screen.dart:98` chỉ có Chọn lịch/Đổi lịch. `lib/viewmodels/schedule_viewmodel.dart` gọi save, không gọi delete.
- `lib/screens/schedule_screen.dart:67` khóa đổi ngày khi editing. Đây là giới hạn nghiệp vụ hiện hành, không có nghĩa thao tác update hoàn toàn vắng mặt.
- `lib/screens/progress_screen.dart:165` Xóa bản ghi; lời xác nhận tại `:174` ghi rõ giữ lịch hoạt động.
- `firebase/firestore.rules:5` danh mục chỉ đọc; `:9` schedules có ownership và CRUD ở Rules; `:31` completions cho create/read/delete, `:48` cấm update; `:50` reports, `:61` cấm update/delete.

## Kiến nghị phù hợp

Chọn **lịch hoạt động cá nhân** làm main entity. Bổ sung Hủy/Xóa lịch ở chi tiết lịch hiện có: dialog xác nhận, loading chống bấm lặp, lỗi/retry, chỉ cập nhật UI sau backend xác nhận; giữ completion đã làm để bảo toàn lịch sử. Không đồng nhất với Xóa bản ghi hoàn thành. Kiểm thử owner/cross-user, thành công, hủy dialog và lỗi mạng; cập nhật test plan và Figma/traceability khi triển khai.

Không cần mở CRUD toàn danh mục, sửa duration của completion hoặc thêm web admin chỉ để đủ số thao tác. Đổi ngày có thể là cải tiến sau: dateKey nằm trong document ID và bị Rules khóa, nên phải thiết kế chuyển lịch nguyên tử/chống trùng, không chỉ mở DatePicker.

Theo chuẩn Cloud-Enabled hiện hành, thiếu Delete lịch chưa tự động là vi phạm CRUD được ghi trong đề; nhưng là thiếu sót sử dụng thực tế đáng bổ sung. Theo bản From Design có CRUD main entity, app hiện chưa chứng minh đầy đủ CRUD qua giao diện. Mọi tỷ lệ tiến độ trước đây là ước lượng công việc, không phải xác nhận đáp ứng cả hai rubric.
