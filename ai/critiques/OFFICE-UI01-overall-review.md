# UI01 — phản biện tổng thể 10 màn

Nguồn: assets/stitch/office-ui/UI01/overview-01.png và overview-02.png do người dùng cung cấp, canvas 51%. Reviewer: Codex. Đối chiếu wireframe đã xuất ZIP, brief UI01 và 3 persona chính ngang nhau. Đây là review hình ảnh, không đọc font thực trong layer/code, không đo contrast/target/frame hoặc thử prototype. Chưa xác nhận nguyên văn prompt thực gửi.

## Prompt phản biện

Đánh giá cả bộ UI01 theo Huy/Mai/Linh, 10 heuristic Nielsen, accessibility và wireframe đã chốt. Phân biệt quan sát, suy luận và điều chưa kiểm chứng. Nêu ít nhất 5 phát hiện có bằng chứng theo màn; đưa ra cách sửa và tiêu chí kiểm tra. Gom thành tối đa 3 chủ đề vòng cải tiến, không yêu cầu mỗi màn 1 lượt. Không suy ra có 3 vòng hoàn tất từ 3 chủ đề dự kiến.

## Toàn văn phản biện

Giữ: palette xanh/trắng nhìn nhất quán; đã có dấu hiệu logo người dùng (chưa đối chiếu asset/pixel); 4 tab vẫn tồn tại, nhóm và task chính được giữ; Home và Tiến độ cùng 1/3; Khám phá thể hiện đủ 9 nhóm. Đây là UI có màu đầu tiên, không tiếp tục áp yêu cầu grayscale/góc vuông của low-fi. Chưa chốt Final UI.

| ID | Màn / bằng chứng | Persona và căn cứ | Quyết định đề xuất / cách kiểm tra |
| --- | --- | --- | --- |
| U01 | Cả bộ: chữ có hình thức serif, đặc biệt tên app/heading/body, trong khi style board ghi Be Vietnam Pro | Cả 3; Consistency and standards; brief sans-serif tiếng Việt | Accept: dùng Be Vietnam Pro thực trên toàn text, Roboto fallback. Kiểm tra layer hoặc computed font, ảnh không đủ chứng minh font-name. Không chỉ đổi style board |
| U02 | S01 có card Thói quen sống thọ Power 9; S05 ghi Power9 Blue Zones; S07 banner nói cân bằng nhịp sinh học/năng lượng, ngoài wireframe | Cả 3; Match between system and real world / minimalist design; tên 9 nhóm là phát triển văn phòng, không nguyên văn nguồn | Accept: giữ tên Power9 Office Routine; bỏ nhãn dễ gây hiểu nhầm sản phẩm chính thức và các mô tả hiệu quả không có căn cứ. Nguồn cảm hứng ghi trong hồ sơ, không cần banner trên Home |
| U03 | S02 thêm Khoảnh khắc hiện diện; S06 thêm tag Nạp năng lượng, Dễ dàng và diễn giải từng bước; S09 có thẻ mục tiêu/ảnh; S08 có thẻ Khoảng lặng tích cực | Mai/Huy/Linh cần thao tác ngắn; Aesthetic and minimalist design / efficiency | Accept: bỏ nội dung thêm, rút về cấu trúc/task đã chốt. Giữ màu và thành phần chức năng, không quay về wireframe |
| U04 | S04/S06/S07/S10 có ảnh lớn; S06 dài hơn các màn khác trong ảnh | Mai cần nhanh tới CTA đặt lịch; Linh cần thấy thiết lập; không tự kết luận frame sai từ ảnh | Modify: ảnh chỉ giữ nơi phục vụ quyết định thật; banner trang trí trên form/chi tiết không cần. Không phải cứ là UI thì cấm ảnh; ưu tiên tác vụ và nguồn style đã chọn |
| U05 | S07 tên hoạt động bị cắt thành Rủ đồng nghiệp đi b…; S08 nhóm/tên mô tả cũng ellipsis ở ảnh | Recognition rather than recall; Mai/Linh cần xác nhận đúng việc trước lưu | Accept: tên hành động chính được xuống dòng, không cắt mất ý nghĩa; metadata phụ có thể rút gọn theo quy tắc |
| U06 | S01 gọi 1/3 hoạt động là Tiến độ ngày; S08 gọi 1/3 là TỔNG QUAN TIẾN ĐỘ và kèm số lặp; nội dung thêm chiếm diện tích | Cả 3; consistency/minimalist design | Modify: thống nhất câu 1/3 hoạt động đã chọn hoàn thành, thể hiện theo hành vi tự chọn. Không đồng nhất thành sức khỏe/tuổi thọ hoặc đủ 9 nhóm |
| U07 | S03 có action loa nhưng không thấy chức năng âm thanh trong brief; nhiều màn thêm logo vào header, title viết hoa mỗi từ | Consistency and standards / scope | Accept: bỏ action không có task; logo Home là bắt buộc, màn con ưu tiên Back/title; thống nhất sentence case. Không sửa chức năng chỉ vì icon đẹp |

Accessibility chưa đạt căn cứ: font có vẻ nhỏ ở overview nhưng cần layer/code để kết luận số đo. Cần ≥14 cho nhãn/trợ giúp/nav, body ưu tiên16; hit area≥48; contrast 4.5:1/3:1 theo loại; root360×800 + kiểm tra412 và scroll. Màn có chiều cao hiển thị khác nhau chưa chứng minh root sai. Không tuyên bố logo đúng file hoặc có 3 flow hoạt động từ screenshot.

## Gom 3 chủ đề cải tiến

1. OI01 — Typography và tính nhất quán nhận diện: xử lý U01 và case title; ảnh hiện tại là BEFORE. Sửa toàn bộ text trong 1 lượt, giữ nội dung/bố cục để so đúng vấn đề.
2. OI02 — Mật độ thông tin và trung thành wireframe: U02/U03/U04/U07; bỏ nội dung/ảnh/action ngoài nhiệm vụ, không phá palette hoặc làm lại low-fi. Chốt prompt sau khi xem OI01.
3. OI03 — Khả năng hoàn thành tác vụ và phục hồi: U05/U06 và các lỗi flow có bằng chứng từ output/preview; cần state new/existing, retry/undo và phiên nghỉ khi thích hợp. Không bịa lỗi hoặc tính state đơn thuần là vòng cải tiến.

Tất cả là kế hoạch đề xuất, chưa có AFTER hoặc vòng hoàn tất. Quyết định cuối thuộc người thiết kế; không ghi đã accept hết hoặc đạt rubric. Không cần tạo lại UI từ đầu, không yêu cầu sửa lẻ từng màn.
