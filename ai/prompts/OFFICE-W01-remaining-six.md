# Mở rộng có mục đích — 10 màn, dựng 6 màn còn lại

Người dùng xác nhận ngày27/10/2026 đã gửi nguyên văn100% prompt Office do trợ lý cung cấp trên dự án Stitch mới. Khối prompt bên dưới được giữ nguyên.


Trạng thái: kế hoạch/prompt chuẩn bị, chưa chạy. Thay lượt bốn màn trong OFFICE-W01-remaining-four.md theo yêu cầu mới của người dùng. Không đổi tên/xóa lịch sử.

## Phạm vi mới

Giữ S01 Hôm nay, S05 Khám phá, S06 Chi tiết, S07 Lịch. Dựng cùng lượt S02 Ăn uống, S03 Thư giãn, S04 Kết nối, S08 Tiến độ, S09 Góc làm việc, S10 Ngủ & phục hồi. Tổng 10 màn chức năng; states/dialog vẫn không tính thêm màn.

S09 hỗ trợ Huy với checklist góc làm việc liên quan Sit Smart/Healthy Space. S10 hỗ trợ Linh với hoạt động chuẩn bị nghỉ liên quan Sleep Well. Purpose/Work–Life Balance giữ đường từ Home/Khám phá → S06 → S07. Cả ba persona vẫn chính ngang nhau; số màn không cần chia đều.

## Nội dung prompt

Giữ brief và phong cách từ lượt bốn màn, bổ sung:
- S09 màn con có Back, nhãn Ngồi đúng tư thế · Không gian tốt, tên hoạt động Kiểm tra góc làm việc, 2 phút. Checklist ba mục tự kiểm tra: vị trí màn hình thuận tiện; ghế/bàn và tư thế ngồi thoải mái; mặt bàn/lối đi gọn. Một nút Đã kiểm tra, không chứng nhận công thái học hoặc cảm biến tự đo. Dùng cấu hình hành động duy nhất, không tự tính hoàn thành hai nhóm vì một lần check-in.
- S10 màn con có Back, nhóm Ngủ và phục hồi, tên Chuẩn bị nghỉ tối. Hai gợi ý ngắn: tạm dừng xử lý công việc; dành thời gian thư giãn trước khi ngủ. Một CTA Chọn giờ nhắc mở S07 với đúng hoạt động. Không điểm giấc ngủ, đo ngủ, chẩn đoán hoặc CTA đã ngủ đủ.
- S05/S06 giữ bố cục: chỉ bổ sung liên kết ngữ cảnh tới S09 từ chi tiết Kiểm tra góc làm việc và S10 từ chi tiết Chuẩn bị nghỉ tối. Chưa tạo thêm frame/variant của S05/S06 trong lượt này. S09 là checklist thực hiện sau khi đọc chi tiết; S10 là hướng dẫn chuẩn bị nghỉ và chọn nhắc.
- S08 giữ dữ liệu khớp Home hiện có, không tự thêm bản ghi hoàn thành từ S09/S10 mới dựng.

S02/S03/S04 là các tab hiện có; S08/S09/S10 là màn con không bottom navigation. Giữ đúng 4 tab, không tăng thành 6 tab. Chỉ dựng default của 6 màn, chưa state lỗi/loading/empty hoặc UI màu.

Prompt đầy đủ gửi người dùng trong chat ở lượt mở rộng 10 màn. Cần lưu nguyên văn prompt thực gửi vào log khi có xác nhận/output; nội dung tóm tắt ở đây không thay thế prompt thực gửi.