# UI01 — từ wireframe Office đã chốt

Người dùng xác nhận ngày27/10/2026 đã gửi nguyên văn100% prompt Office do trợ lý cung cấp trên dự án Stitch mới. Khối prompt bên dưới được giữ nguyên.

```text
Từ đúng 10 wireframe Power9 Office Routine đang chọn, tạo 1 bộ UI hoàn chỉnh đầu tiên gồm 10 màn tương ứng. Giữ nguyên bộ wireframe để đối chiếu. Bộ UI mới đặt tên OFFICE-UI01-S01 đến OFFICE-UI01-S10 trên canvas, không ghi mã trong giao diện.

ĐÂY LÀ GIAI ĐOẠN UI, KHÔNG PHẢI LÀM LẠI WIREFRAME.
Giữ nhiệm vụ, thứ tự nội dung chính, điều hướng và dữ liệu mẫu đã chốt. Không tự thêm login, onboarding, tài khoản, chuông, chat, HR hoặc màn chức năng khác. Không tạo bảng style riêng ở lượt này.

SẢN PHẨM
3 persona chính ngang nhau: Huy 28 (vận động/tư thế/góc làm việc/lịch linh hoạt), Mai 24 (ăn uống/giảm căng thẳng/kết nối), Linh 39 (phục hồi/mục tiêu/cân bằng). Không chọn persona trong app. Giữ đủ 9 nhóm văn phòng qua Khám phá; không đổi về 9 tên nguyên tắc Blue Zones gốc; không ép 9/9 mỗi ngày. Số lượng, thứ tự và thời lượng dùng chữ số.

PHONG CÁCH UI
Kế thừa phong cách xanh biển bình tĩnh của UI tham chiếu tôi cung cấp. Nếu không có ảnh tham chiếu, theo chính xác bảng màu và thông số dưới, không tự nhận đã xem UI cũ.
- Nền #F5F8FD, surface/card #FFFFFF.
- Chữ chính #152C46, chữ phụ #4C627A.
- Nút/action chính #1E5AA8, chữ trên nút #FFFFFF.
- Nền selected #EAF2FC, viền điều khiển #71839A.
- Đỏ #A7332A chỉ khi có lỗi, đi cùng nhãn; chưa tạo error state ở lượt này.
- Font Be Vietnam Pro, Roboto fallback; title 24/32, heading 20/28, body 16/24, label/navigation/trợ giúp tối thiểu 14/20.
- Spacing 4/8/12/16/24/32; lề 16.
- Radius input 8, button 12, card 16. Bóng nhẹ khi cần phân cấp, không lạm dụng card lồng nhau.
- Không gradient neon, glow, ảnh nền lớn hoặc dashboard dày thông tin. Không tự thêm ảnh trang trí vào các màn.
- Không mang quy tắc góc vuông/grayscale của low-fi sang UI: có thể bo góc và dùng màu theo token trên, nhưng không đổi cấu trúc nhiệm vụ.

LOGO
Dùng nguyên ảnh power9-logo-3d.png tôi đính kèm do tôi tự thiết kế. Đặt vùng 40×40 tại header Home, giữ tỉ lệ và màu, cạnh tên Power9 Office Routine. Bỏ dòng Hệ thống đồng hành và v1.0 nếu còn trong wireframe. Không vẽ lại/recolor/crop logo, không dùng gradient logo làm nền toàn UI. Nếu không chèn đúng asset, giữ placeholder rồi báo rõ để thay file thật trong Figma; không tạo logo gần giống.

10 MÀN VÀ ĐIỀU HƯỚNG
S01 Hôm nay: giữ 3 việc/giờ, 1/3 hoàn thành, Khám phá/Tiến độ; check-in tách với chạm tên mở chi tiết. Không cào bằng nhu cầu 3 persona bằng cách tạo 3 hồ sơ trên Home.
S02 Ăn uống: bữa trưa có chú ý, 3 bước ngắn, Đã thực hiện, Xem tiến độ.
S03 Thư giãn: Nghỉ sau cuộc họp, timer 03:00 và Bắt đầu; chưa bắt đầu thì chưa hoàn thành.
S04 Kết nối: 2 hoạt động đồng nghiệp tự nguyện, chọn hoạt động tới Chi tiết; không tự gửi lời mời.
S05 Khám phá: đủ 9 nhóm, tìm kiếm/filter thời lượng áp dụng hoạt động, mở nhóm Kết nối với 2 hoạt động, danh mục cuộn.
S06 Chi tiết thói quen: Rủ đồng nghiệp đi bộ, 5 phút, mục đích/3 bước, tự nguyện, Chọn lịch thực hiện. Trạng thái chưa thêm, không Đổi lịch hoặc Hoàn thành trên màn này.
S07 Lịch thói quen: đúng tên hoạt động, ngày 26/10/2026, nhắc bật 12:00, giờ yên lặng 18:00–08:00 hôm sau, Lưu lịch/Hủy. Giờ 24h. Tắt nhắc không bắt giờ; lưu không đồng nghĩa hoàn thành; không tự dời giờ nhắc vào lúc khác.
S08 Tiến độ: khớp Home 1/3 và đúng tên/giờ 3 hoạt động; riêng tư, không ranking/điểm tuổi thọ.
S09 Góc làm việc: checklist 3 mục và Đã kiểm tra; đây là 1 hoạt động, không tự tính 2 nhóm hoàn thành. Không cảm biến/chẩn đoán.
S10 Ngủ & phục hồi: Chuẩn bị nghỉ tối, 2 gợi ý, Chọn giờ nhắc tới S07 với đúng dữ liệu. Không đo giấc ngủ hoặc xác nhận Đã ngủ đủ.

Chỉ S01–S04 có 4 tab Hôm nay/Ăn uống/Thư giãn/Kết nối; chọn đúng tab bằng icon, nhãn và chỉ báo ngoài màu.
S05–S10 có Back và đúng tên chức năng, không bottom navigation. Back trở về đúng nguồn, giữ nhóm/bộ lọc khi cần; Hủy không lưu. S06/S07 là template dùng chung theo dữ liệu hoạt động; chưa tạo thêm frame biến thể.

CHUẨN HÓA TỪ KIỂM TRA ZIP
- Frame gốc 360×800 cho cả 10, không desktop wrapper có khoảng trắng 2 bên; kiểm tra thêm rộng 412.
- Nội dung dài cuộn trong vùng giữa app bar và footer/navigation, không cắt CTA ở S05/S07/S10 hoặc thu nhỏ chữ để ép vừa.
- Tất cả chữ nhãn/trợ giúp/navigation ≥14, sửa các chữ 11–13 còn sót từ nguồn. Body ưu tiên 16.
- Vùng chạm thật ≥48×48 cho Back, checkbox, switch, filter và link phụ; hình icon có thể nhỏ hơn nhưng hit area phải đủ.
- Text thông thường tương phản ≥4.5:1; chữ lớn/điều khiển theo yêu cầu ≥3:1. Không chỉ dựa màu truyền đạt trạng thái.
- Không đưa mã S01–S10 vào app bar, nội dung hoặc nút. Tên frame bên ngoài ví dụ OFFICE-UI01-S07 — Lịch thói quen; bên trong chỉ Lịch thói quen.

ĐẦU RA
Đúng 10 màn UI mặc định trong 1 bộ riêng, xếp 2 hàng × 5 màn theo S01–S10. Giữ wireframe gốc. Chưa tạo empty/loading/error/dialog hoặc màn chức năng khác trong lượt này. Chưa coi prototype hoặc accessibility đã đạt nếu chưa kiểm tra thật.
Dừng sau bộ UI đầu tiên để tôi chụp và phản biện tổng thể trước các vòng cải tiến.
```
