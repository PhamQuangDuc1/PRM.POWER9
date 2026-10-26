# Design System: Power9 Office Routine

Brief hiện hành cho Stitch, cập nhật 26/10/2026. Giữ phong cách UI xanh biển hiện có mà người dùng cho biết thầy khá ưng. Đây là đầu vào thiết kế, chưa phải kết quả đã tạo.

## 1. Visual Theme & Atmosphere
Ứng dụng di động tiếng Việt cho nhân viên văn phòng 23–45 tuổi. Huy 28, Mai 24 và Linh 39 đều là persona chính ngang nhau theo yêu cầu của thầy. Mật độ 4/10, biến đổi bố cục 2/10, chuyển động 2/10. Gọn, dễ đọc, có thể thao tác giữa giờ làm. Giữ nhịp card, ảnh, header và cách phân cấp của nguồn Stitch xanh biển. Không tạo trang giới thiệu kiểu landing page.

Chín nhóm nội dung: Move Often, Sit Smart, Eat Well, Sleep Well, Manage Stress, Healthy Space, Social Bonds, Purpose, Work–Life Balance. Trên UI ưu tiên nhãn Việt: Vận động / Tư thế / Ăn uống / Ngủ & phục hồi / Giảm căng thẳng / Không gian / Kết nối / Mục đích / Cân bằng. Chi tiết dùng tên đầy đủ.

## 2. Color Palette & Roles
| Token | Giá trị | Vai trò |
| --- | --- | --- |
| background | #F5F8FD | Nền xanh rất nhạt |
| surface | #FFFFFF | Card/form |
| text.primary | #152C46 | Chữ chính |
| text.secondary | #4C627A | Chữ phụ |
| action.primary | #1E5AA8 | Nhấn xanh biển, nút chính |
| action.onPrimary | #FFFFFF | Chữ trên nút xanh |
| surface.selected | #EAF2FC | Mục đang chọn |
| border.control | #71839A | Viền điều khiển |
| feedback.error | #A7332A | Lỗi, đi cùng nhãn/biểu tượng |

Đây là token đích kế thừa brief cũ; chưa phải phép lấy mẫu từ ảnh hoặc xác nhận đã bind Figma. Logo nhiều sắc độ là tài sản nhận diện riêng, không dùng các sắc đó tạo thêm màu nhấn chức năng.

## 3. Typography Rules
Giữ Be Vietnam Pro của nguồn nếu dùng được, Roboto là fallback cho tiếng Việt. Title 24/32, heading 20/28, body 16/24, label 14/20. Body không dưới 14 sp. Không tự thay bằng font khác để làm mới phong cách. Chữ dài xuống dòng; không cố định chiều cao cắt dấu tiếng Việt.

## 4. Component Stylings
- Button: cao 52, radius 12; một primary theo nhiệm vụ; default/pressed/disabled/loading.
- Card: radius 16; trắng, phân cấp nhẹ; tên, nhóm, thời lượng, giờ nếu đã đặt. Cả card bấm được phải có pressed.
- Inputs: label trên ô, lỗi cạnh trường, giữ dữ liệu sau lỗi; default/focused/filled/error/disabled.
- Navigation: giữ Hôm nay / Ăn uống / Thư giãn / Kết nối; trạng thái chọn có biểu tượng/nhãn ngoài màu.
- App bar: Home có logo gốc vùng 40×40 và tên app có thể hai dòng; màn con có Back + tiêu đề.
- Dialog: xác nhận rời phiên và xác nhận xóa; lựa chọn giữ lại/hủy rõ.
- Loading: skeleton hoặc trạng thái đang lưu không gây nhảy bố cục; error/empty riêng khỏi dữ liệu populated.
- Logo: assets/brand/power9-logo-3d.png của người dùng, không vẽ lại/recolor/crop. Nếu không đặt được đúng asset trong Stitch, dùng chỗ trống đúng kích thước rồi thay file thật trong Figma.

## 5. Layout Principles
Frame 360×800, kiểm tra thêm 412. Nội dung cuộn trong vùng giữa app bar/navigation. Lề 16; spacing 4/8/12/16/24/32. Radius input 8, button 12, card 16. Elevation surface 0; card 0/2/8 rgba(21,44,70,0.08); overlay 0/8/24 rgba(21,44,70,0.16). Vùng chạm ≥48×48. Auto Layout/constraints, không tràn ngang.

10 màn hiện hành: S01 Hôm nay, S02 Ăn uống, S03 Thư giãn, S04 Kết nối, S05 Khám phá, S06 Chi tiết, S07 Lịch, S08 Tiến độ, S09 Góc làm việc, S10 Ngủ & phục hồi. S09/S10 là màn con có Back, không thêm tab chính. Mọi nhóm thói quen truy cập qua S05; không cần 9 màn riêng cho 9 nhóm. Không nhét 9 card vào Home hay 1 viewport. Wireframe nguồn đã nhận ZIP tại assets/stitch/office-final/; xem docs/OFFICE-WIREFRAME-ZIP-AUDIT.md trước khi lên UI.

## 6. Motion & Interaction
Phản hồi nhấn nhẹ, chuyển cảnh 120–200 ms khi hữu ích, không loop trang trí. Ưu tiên khả năng tập trung và giảm chuyển động theo persona hơn hiệu ứng mặc định của skill. Chỉ animate opacity/transform. Không dùng animation làm bằng chứng đã hoàn thành tác vụ.

Home check-in/undo đồng bộ history. S06-new thêm, S06-existing đổi lịch. S07 lưu/hủy/retry có trạng thái riêng, chỉ cập nhật Home khi lưu thành công. Nhắc tùy chọn; thiếu giờ chỉ là lỗi khi bật nhắc. Giờ yên lặng áp dụng cho nhắc tự động; thói quen nghỉ/ngủ vẫn có thể do người dùng chủ động đặt ngoài giờ làm, giao diện giải thích nếu giờ nhắc bị tắt.

## 7. Anti-Patterns
Không đổi toàn bộ palette/layout, không gradient neon hoặc bóng phát sáng; không biến logo 3D thành toàn bộ ngôn ngữ giao diện. Không emoji thay icon, không mã kỹ thuật trên UI. Không đánh giá sức khỏe/tuổi thọ, ép 9/9, chat/HR/ranking. Không coi ảnh nguyên màn là editable UI. Không gắn nhãn đã kiểm tra accessibility nếu chưa đo từ output.

## 8. Trình tự và giới hạn
Đã nhận ZIP 10 wireframe, giữ nguyên nguồn; đã render/kiểm tra cục bộ tại 360/412. Bước hiện tại: OFFICE-UI01 từ wireframe đã chốt, dùng prompt ai/prompts/OFFICE-UI01-from-final-wireframe.md → review/cải tiến theo bằng chứng → Figma. UI01 chưa chạy, chưa có UI Office hoặc prototype đã kiểm chứng. Không dựng lại wireframe chỉ để sửa lỗi PNG export.
