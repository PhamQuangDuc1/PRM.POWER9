# Persona giả định cho Power9

## Phạm vi và nguồn thông tin

Bốn persona dưới đây do nhóm đề xuất để thảo luận trong Lab 2. Tất cả thông tin là **giả định (Assumed)**, chưa phải kết quả khảo sát, phỏng vấn hay kiểm thử. Không dùng nhãn Observed khi chưa có bằng chứng. Mục tiêu UX là tiêu chí dự kiến để kiểm thử, chưa phải kết quả đã đạt.

Cả bốn cùng miền Power9 nhưng khác bối cảnh, nhu cầu và hướng thiết kế. Mục 6 của đề yêu cầu một persona chính cho một bài. Nếu làm một sản phẩm chung, nhóm cần chốt persona chính và vai trò của ba persona còn lại; nếu mỗi thành viên làm một hướng riêng, ghi rõ persona chính và bộ deliverable của từng hướng. Bốn persona không tự động có nghĩa phải xây bốn ứng dụng.

## P01 — Minh — Power9 Campus

- **Tuổi / vai trò:** 20 tuổi, sinh viên CNTT; đại diện nhóm 18–23 tuổi.
- **Bối cảnh:** Lịch học thay đổi theo ngày, thường làm bài buổi tối và dùng điện thoại giữa các tiết học.
- **Mục tiêu:** Duy trì những việc nhỏ như đi bộ, nghỉ ngắn và dành thời gian cho bạn bè.
- **Pain points:** Hay quên check-in; đặt quá nhiều mục tiêu rồi bỏ dở; khó biết hôm nay cần làm gì.
- **Thói quen thiết bị:** Dùng Android thường xuyên, thích thao tác nhanh bằng một tay.
- **Nhu cầu accessibility:** Chữ dễ đọc; trạng thái hoàn thành có cả biểu tượng và nhãn.
- **Problem statement:** Minh cần cách chọn và theo dõi một vài thói quen Power9 phù hợp lịch học để duy trì chúng mà không tốn nhiều thời gian.
- **Mục tiêu UX đề xuất:** Check-in một thói quen trong tối đa 3 thao tác từ Home.
- **Hướng UI:** Home tập trung “Hôm nay”, nút check-in rõ, tiến độ tuần đơn giản.
- **Tình huống sử dụng đề xuất:** Sau khi đi bộ giữa hai tiết học, Minh mở Home và đánh dấu hoạt động vừa hoàn thành trước khi vào lớp.
- **Cách kiểm thử đề xuất:** Từ Home có thói quen đã thêm, yêu cầu check-in hoạt động đi bộ; đếm số thao tác tới khi có phản hồi hoàn thành. Kiểm tra hoàn tác nếu bấm nhầm.

## P02 — Huy — Power9 Desk Reset

- **Tuổi / vai trò:** 28 tuổi, lập trình viên; đại diện nhóm 24–35 tuổi.
- **Bối cảnh:** Làm việc chủ yếu trên máy tính, có nhiều cuộc họp, thường bỏ qua giờ nghỉ khi bận.
- **Mục tiêu:** Xen kẽ vận động nhẹ và thời gian thư giãn vào ngày làm việc.
- **Pain points:** Thông báo đến lúc đang họp; kế hoạch quá cứng; chỉnh lịch thói quen mất nhiều bước.
- **Thói quen thiết bị:** Dùng Android trong giờ nghỉ, thường xem nhanh thông báo rồi quay lại công việc.
- **Nhu cầu accessibility:** Nội dung ngắn, phân cấp rõ; vùng chạm đủ lớn để thao tác nhanh.
- **Problem statement:** Huy cần quản lý thói quen Power9 theo lịch làm việc linh hoạt để thực hiện chúng vào thời điểm thuận tiện.
- **Mục tiêu UX đề xuất:** Đổi lịch của một thói quen trong dưới 30 giây.
- **Hướng UI:** Lịch và thời điểm thực hiện nổi bật, thao tác sửa nhanh, thông báo dẫn đến đúng thói quen.
- **Tình huống sử dụng đề xuất:** Cuộc họp kéo dài trùng giờ nghỉ vận động; Huy đổi giờ nhắc sang sau cuộc họp và xác nhận giờ mới.
- **Cách kiểm thử đề xuất:** Từ Home có thói quen đã lên lịch, đo thời gian tới khi lưu giờ mới thành công. Kiểm tra hủy sửa và lỗi lưu có thể thử lại mà không mất lựa chọn.

## P03 — Linh — Power9 Family Routine

- **Tuổi / vai trò:** 36 tuổi, nhân viên hành chính có con nhỏ; đại diện nhóm 30–45 tuổi.
- **Bối cảnh:** Chia thời gian cho công việc, việc nhà và chăm con; thường chỉ có những khoảng nghỉ ngắn.
- **Mục tiêu:** Duy trì hoạt động cá nhân và dành thời gian chất lượng cho người thân.
- **Pain points:** Kế hoạch dài khó thực hiện; dễ quên hoạt động đã làm; khó chọn việc phù hợp thời gian đang có.
- **Thói quen thiết bị:** Dùng Android vào buổi sáng và tối, thường bị gián đoạn khi thao tác.
- **Nhu cầu accessibility:** Nhãn dễ hiểu, form ngắn, phản hồi lưu thành công rõ ràng.
- **Problem statement:** Linh cần chọn và theo dõi những thói quen Power9 ngắn, phù hợp nhịp sinh hoạt gia đình để dễ duy trì mỗi ngày.
- **Mục tiêu UX đề xuất:** Tìm và thêm một thói quen có thời lượng phù hợp trong dưới 60 giây.
- **Hướng UI:** Hiển thị thời lượng ngay trên card, gợi ý hoạt động ngắn, nội dung gần gũi.
- **Tình huống sử dụng đề xuất:** Buổi tối, khi con đã ngủ, Linh có 5 phút rảnh và muốn tìm một hoạt động thư giãn ngắn để thêm vào hôm nay.
- **Cách kiểm thử đề xuất:** Từ Home, yêu cầu tìm hoạt động tối đa 5 phút và thêm vào hôm nay; đo thời gian tới khi có xác nhận lưu. Kiểm tra không có kết quả phù hợp và thử lại khi lưu lỗi.

## P04 — Chú Hùng — Power9 Active Age

- **Tuổi / vai trò:** 61 tuổi, giáo viên nghỉ hưu; đại diện nhóm 55–65 tuổi.
- **Bối cảnh:** Có thời gian đi bộ, chăm cây và gặp bạn bè; đang tập dùng ứng dụng để ghi nhận sinh hoạt hằng ngày.
- **Mục tiêu:** Biết hôm nay có hoạt động gì và xem lại những việc đã hoàn thành.
- **Pain points:** Chữ nhỏ; biểu tượng không có nhãn; quá nhiều lựa chọn; lo bấm nhầm hoặc xóa dữ liệu.
- **Thói quen thiết bị:** Dùng Android cho liên lạc và đọc tin; quen thao tác chạm hơn các cử chỉ ẩn.
- **Nhu cầu accessibility:** Chữ lớn, contrast rõ, nút có nhãn, xác nhận trước khi xóa.
- **Problem statement:** Chú Hùng cần ứng dụng Power9 có điều hướng đơn giản và phản hồi rõ để tự theo dõi thói quen một cách tự tin.
- **Mục tiêu UX đề xuất:** Từ Home, tìm và đánh dấu hoàn thành một hoạt động trong dưới 30 giây mà không cần hướng dẫn.
- **Hướng UI:** Danh sách rõ ràng, ít nội dung mỗi màn hình, nút lớn, tiến độ dễ hiểu.
- **Tình huống sử dụng đề xuất:** Sau buổi đi bộ sáng, chú mở Home, tìm hoạt động đi bộ và ghi nhận hoàn thành; sau đó xem lại hoạt động vừa ghi.
- **Cách kiểm thử đề xuất:** Từ Home có hoạt động đi bộ, đo thời gian tới khi có phản hồi hoàn thành, không chỉ dẫn vị trí nút. Kiểm tra xác nhận trước khi xóa và thao tác hủy để giữ dữ liệu.

## So sánh tác động lên thiết kế

| Hướng | Nội dung ưu tiên trên Home | Bố cục | Tương tác nổi bật | Tiêu chí dự kiến |
| --- | --- | --- | --- | --- |
| Campus | Việc hôm nay, tiến độ tuần | Danh sách gọn, CTA dễ với một tay | Check-in trực tiếp, hoàn tác | Check-in ≤3 thao tác |
| Desk Reset | Giờ thực hiện, nhắc nhở tiếp theo | Lịch / danh sách theo giờ, sửa nhanh | Đổi lịch, hủy sửa, retry | Đổi lịch <30 giây |
| Family Routine | Hoạt động ngắn, số phút đang có | Card có thời lượng, lọc thời gian | Tìm, thêm nhanh, xác nhận lưu | Tìm và thêm <60 giây |
| Active Age | Việc hôm nay và đã hoàn thành | Danh sách thoáng, chữ và nút lớn | Nút có nhãn, xác nhận xóa | Tìm và hoàn thành <30 giây, không hướng dẫn |

Sự khác biệt phải xuất hiện trong bố cục, nội dung và tương tác, không chỉ đổi tên hoặc màu. Chưa có dữ liệu chứng minh đạt các mục tiêu UX; ghi kết quả thực tế sau khi kiểm thử prototype.

## Định hướng thiết kế và kiểm chứng

- Bốn persona là cơ sở thảo luận và kiểm tra tính phù hợp của thiết kế.
- Chốt một tình huống cụ thể cho mỗi người; các tình huống trên là đề xuất để nhóm duyệt.
- Nhóm thực hiện một bài chung, giữ bốn persona trong cùng hồ sơ thiết kế.
- Định hướng thiết kế: một ứng dụng Power9 chung, Linh (P03) là persona chính; Minh, Huy và chú Hùng là persona hỗ trợ để kiểm tra bố cục, nội dung và tương tác. Tham chiếu quyết định D01 trong design/design-decisions.md.
- Khi có khảo sát/phỏng vấn, bổ sung nguồn và ngày thu thập; chỉ đổi thông tin được chứng minh sang Observed.
