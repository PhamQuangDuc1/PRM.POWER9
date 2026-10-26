# Ba persona — Power9 Office Routine

Cả ba là persona giả định, chưa khảo sát/phỏng vấn. Một sản phẩm chung cho nhân viên văn phòng 23–45 tuổi; không có màn chọn persona. Tuổi là phạm vi thiết kế của bài, không đại diện toàn bộ người lao động.

**Theo yêu cầu bổ sung của giảng viên do người dùng xác nhận: Huy, Mai và Linh đều là persona chính, có mức ưu tiên ngang nhau.** Mỗi người có vấn đề, nhiệm vụ và tiêu chí kiểm thử riêng; thiết kế phải đáp ứng cả ba. Không phân vai chính/phụ.

Đầu vào hiện hành theo gợi ý của thầy được người dùng xác nhận trong ảnh: **Move Often, Sit Smart, Eat Well, Sleep Well, Manage Stress, Healthy Space, Social Bonds, Purpose, Work–Life Balance**. Đây là chín nhóm thói quen văn phòng được dùng để thiết kế Power9 Office Routine, có cảm hứng kế thừa từ Power 9; không gọi chúng là nguyên văn chín nguyên tắc Blue Zones. Persona dưới đây là đầu vào để bắt đầu sửa wireframe trên Stitch.

## P01 — Huy, 28 tuổi — persona chính
- Vai trò: lập trình viên làm việc tại văn phòng, nhiều cuộc họp.
- Thói quen thiết bị (giả định): dùng máy tính cho công việc, xem Android nhanh giữa các phiên làm việc; thường thao tác điện thoại một tay.
- Nhu cầu accessibility: vùng chạm ≥48×48 dp, chữ nội dung ưu tiên 16 sp, trạng thái có nhãn ngoài màu; tránh nhắc nhấp nháy khi đang tập trung.
- Bối cảnh: làm việc trên máy tính phần lớn ngày, thường ngồi liên tục và bỏ giờ nghỉ khi tập trung; góc làm việc dễ bừa bộn.
- Mục tiêu: xen kẽ vận động, tự kiểm tra tư thế và sắp xếp góc làm việc phù hợp trong những khoảng nghỉ ngắn.
- Khó khăn: quên đứng dậy, ít chú ý tư thế, thông báo tới giữa cuộc họp; kế hoạch cứng khiến dễ bỏ sau một ngày bận.
- Nhóm thói quen ưu tiên: **Move Often** — vận động thường xuyên; **Sit Smart** — ngồi đúng tư thế; **Healthy Space** — không gian tốt.
- Problem statement: Huy cần các hành động ngắn về vận động, tư thế và góc làm việc, với giờ nhắc linh hoạt để thực hiện được giữa các phiên làm việc.
- Tình huống: họp kéo dài qua 10:00; chuyển đi bộ 3 phút sang 10:30.
- Tác động lên wireframe Stitch: Home có giờ và thời lượng; card “Đứng dậy đi lại 3 phút”, “Kiểm tra tư thế”, “Sắp xếp góc làm việc”; cho đổi lịch nhanh, nhắc tùy chọn, hủy/lỗi giữ lịch cũ.
- Tiêu chí dự kiến: đổi lịch <30 giây; check-in ≤3 thao tác từ Hôm nay.

## P02 — Mai, 24 tuổi — persona chính, nhân viên marketing mới
- Thói quen thiết bị (giả định): dùng Android kiểm tra lịch và thông báo vào giờ nghỉ; ưu tiên nội dung ngắn, thao tác tìm kiếm quen thuộc.
- Nhu cầu accessibility: nhãn tiếng Việt rõ, ô tìm kiếm có nhãn, bộ lọc có trạng thái chọn ngoài màu; không buộc hiểu biểu tượng hoặc thuật ngữ tiếng Anh.
- Bối cảnh: mới đi làm, lịch chiến dịch thay đổi; thường ăn trưa vội hoặc một mình và căng thẳng khi gần hạn nộp.
- Mục tiêu: duy trì giờ ăn, có khoảng nghỉ để giảm căng thẳng và kết nối tự nguyện với đồng nghiệp.
- Khó khăn: dễ bỏ bữa khi bận, chưa biết bắt chuyện với ai, lời khuyên chung chung và hoạt động nhóm gây áp lực.
- Nhóm thói quen ưu tiên: **Eat Well** — ăn uống lành mạnh; **Manage Stress** — quản lý căng thẳng; **Social Bonds** — kết nối đồng nghiệp.
- Problem statement: Mai cần chọn những hành động ăn uống, nghỉ ngắn và kết nối dễ bắt đầu để hòa nhập với nhịp làm việc mà không cảm thấy bị ép tham gia.
- Tình huống: trước giờ trưa, tìm “Rủ đồng nghiệp ăn trưa”, xem hướng dẫn ngắn và thêm vào lịch hôm nay.
- Tác động lên wireframe Stitch: danh mục theo chín nhóm với nhãn tiếng Việt; lọc thời lượng; card “Ăn trưa đúng giờ”, “Nghỉ thư giãn 3 phút”, “Rủ đồng nghiệp ăn trưa”; không tự gửi lời mời.
- Tiêu chí dự kiến: tìm và thêm một hoạt động phù hợp trong <60 giây; nhận biết rõ hoạt động nào dành cho cá nhân, hoạt động nào có thể làm cùng đồng nghiệp.

## P03 — Linh, 39 tuổi — persona chính, trưởng nhóm hành chính
- Thói quen thiết bị (giả định): dùng laptop trong giờ làm và Android khi di chuyển; thao tác hay bị ngắt bởi cuộc gọi, tin nhắn.
- Nhu cầu accessibility: chữ dễ đọc, form có nhãn và lỗi cạnh trường; Back/Hủy rõ, lỗi không xóa dữ liệu; trạng thái lưu không chỉ dựa vào thông báo thoáng qua.
- Bối cảnh: nhiều cuộc họp, có gia đình; thường kiểm tra công việc vào buổi tối nên giờ nghỉ và giờ ngủ thiếu ổn định.
- Mục tiêu: xác định việc có ý nghĩa trong ngày, kết thúc công việc theo mốc đã chọn và duy trì giờ nghỉ/ngủ đều đặn.
- Khó khăn: tin nhắn ngoài giờ, việc phát sinh, khó tách việc ưu tiên khỏi việc gấp; cảm giác có lỗi khi nghỉ.
- Nhóm thói quen ưu tiên: **Sleep Well** — ngủ đủ, phục hồi tốt; **Purpose** — có mục tiêu, ý nghĩa; **Work–Life Balance** — cân bằng công việc và cuộc sống.
- Problem statement: Linh cần tổ chức mục tiêu ngày, mốc kết thúc công việc và nhắc nghỉ do mình chủ động đặt để duy trì thời gian phục hồi bên cạnh trách nhiệm công việc và gia đình.
- Tình huống: đặt 17:30 tổng kết ngày, tắt nhắc ngoài giờ và dành thời gian ăn tối cùng gia đình.
- Tác động lên wireframe Stitch: card “Một việc có ý nghĩa hôm nay”, “Kết thúc ngày làm việc”, “Chuẩn bị nghỉ tối”; thiết lập ngày làm việc và giờ yên lặng, không nhắc trong giờ ngủ; tiến độ riêng tư, không bảng xếp hạng.
- Tiêu chí dự kiến: đặt lịch và giờ yên lặng <60 giây; nhận biết trạng thái đã lưu không cần hướng dẫn.

## Độ bao phủ chín nhóm thói quen

| Nhóm theo gợi ý của thầy | Persona ưu tiên | Nhu cầu cần thể hiện khi dựng Stitch |
| --- | --- | --- |
| Move Often — Vận động thường xuyên | Huy | Nhắc đi lại ngắn, hoãn khi bận |
| Sit Smart — Ngồi đúng tư thế | Huy | Checklist tự kiểm tra tư thế và vị trí thiết bị |
| Eat Well — Ăn uống lành mạnh | Mai | Sắp xếp giờ ăn và hành động ăn uống đơn giản |
| Sleep Well — Ngủ đủ, phục hồi tốt | Linh | Nhắc chuẩn bị nghỉ do người dùng tự đặt |
| Manage Stress — Quản lý căng thẳng | Mai | Phiên thư giãn ngắn, có thể dừng |
| Healthy Space — Không gian tốt | Huy | Checklist sắp xếp góc làm việc |
| Social Bonds — Kết nối đồng nghiệp | Mai | Hoạt động kết nối tự nguyện ngoài đời |
| Purpose — Có mục tiêu, ý nghĩa | Linh | Ghi một việc có ý nghĩa trong ngày |
| Work–Life Balance — Cân bằng công việc và cuộc sống | Linh | Mốc kết thúc công việc, giờ yên lặng |

Các nhóm ưu tiên giúp phân biệt nhu cầu thiết kế; mọi persona đều có thể dùng cả chín nhóm. Không chia thành ba app hoặc buộc hoàn thành 9/9 mỗi ngày.

## Kiểm chứng
Ba nhiệm vụ đại diện bắt buộc: **F01 Mai tìm và thêm hoạt động; F02 Huy thực hiện và ghi nhận; F03 Linh điều chỉnh lịch khi công việc thay đổi.** Kiểm tra tiêu chí riêng của từng persona; không dùng kết quả một người thay cho cả ba.
Các tiêu chí trên chưa được đo. Kiểm thử tìm/thêm, hoàn thành/hoàn tác, đổi lịch/hủy; ghi thời gian, số thao tác và lỗi thực tế. Nút có nhãn, vùng chạm ≥48×48, tiếng Việt rõ. Không có persona sinh viên hoặc nghỉ hưu trong phạm vi hiện hành.
