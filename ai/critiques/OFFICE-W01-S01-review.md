# AI phản biện OFFICE-W01-S01 — mức độ chi tiết và mật độ Home

Đầu vào: screenshot Stitch before-overview.png trong assets/stitch/office-new/OFFICE-W01-S01/ và screenshot tham khảo Google do người dùng cung cấp. Chỉ đánh giá nội dung ảnh, không đọc trang web hoặc kiểm tra prototype. Người dùng muốn wireframe sơ bộ, đơn giản hơn bản đầu. Reviewer: Codex.

## Prompt phản biện

Đối chiếu screenshot S01 với mục tiêu low-fidelity, ba persona chính Huy/Mai/Linh và phản hồi người dùng rằng màn quá nhiều thông tin. Đánh giá theo Nielsen và accessibility; chỉ nêu điều có căn cứ từ ảnh. Ghi phát hiện theo màn, tác động, mức ưu tiên và cách sửa. Không kết luận đạt kích thước/contrast/scroll từ ảnh canvas thu nhỏ. Phân biệt vấn đề do brief yêu cầu với lỗi công cụ. Không bịa đủ số lỗi.

## Toàn văn phản biện

Nhận định: cấu trúc chức năng Home đã hiện diện nhưng độ chi tiết gần mid-fi hơn wireframe sơ bộ mà người dùng mong muốn. Brief trước đã yêu cầu các nội dung này, nên mật độ không chỉ là lỗi Stitch. Cần giảm độ chi tiết thể hiện, đồng thời giữ nhãn chức năng để wireframe còn dùng được cho phản biện task.

| ID | Phát hiện tại S01 | Tác động / căn cứ | Ưu tiên | Đề xuất |
| --- | --- | --- | --- | --- |
| WF01 | Header, tiến độ, hai shortcut và danh sách chiếm nhiều dải trước khi xem hết hoạt động | Nielsen: Aesthetic and minimalist design; Huy/Mai/Linh đều cần nhìn nhanh | P1 | Bỏ card tiến độ riêng, giữ dòng 1/3; gom lối tắt dưới danh sách |
| WF02 | Mỗi card lặp giờ, chip nhóm, tên đầy đủ, số phút và cụm nút | Nielsen: Aesthetic and minimalist design; làm bản low-fi dày hơn mục tiêu | P1 | Dùng ba hàng hoạt động: checkbox, nhãn ngắn, giờ; chưa cần chip nhóm/thời lượng/nút kép ở low-fi S01 |
| WF03 | Đã hoàn thành nằm trong thành phần có hình thức giống nút, cạnh nút Hoàn tác | Nielsen: Consistency and standards / Visibility of system status; cần phân biệt trạng thái và hành động | P2 | Thể hiện checkbox đã chọn và tên hoạt động; hoãn mô tả undo sang state/annotation sau |
| WF04 | Nhãn shortcut Khám phá thói quen xuống hai dòng trong khi Xem tiến độ một dòng | Nielsen: Recognition rather than recall / consistency; nhịp hai shortcut chưa đều | P2 | Dùng nhãn ngắn Khám phá và Tiến độ, không tạo hai card shortcut lớn |
| WF05 | Ảnh chỉ thấy đầu card 17:30 phía trên navigation | Linh cần đến được mục cuối; Nielsen: Flexibility and efficiency of use | Cần kiểm tra | Đây chưa phải bằng chứng bị che hoặc không cuộn được. Bản low-fi gọn hơn giúp thấy đủ ba hàng; kiểm tra cuộn sau khi có ảnh/preview rõ |

Giữ: một ứng dụng chung, nhãn tiếng Việt, mục Hôm nay, bốn điểm đến navigation, không chọn persona, tiến độ trên việc tự chọn. Không đưa chín nhóm vào Home; danh mục đầy đủ sẽ ở Khám phá. Ba hàng hoạt động minh họa không có nghĩa bỏ các nhu cầu persona khác.

Accessibility: screenshot canvas thu nhỏ không xác minh được body size, target 48×48, contrast, keyboard hoặc vùng cuộn. Chữ thật cần có ở tiêu đề, điều hướng, nút và tên hoạt động ngắn; các dòng mô tả phụ mới dùng placeholder. Không biến toàn bộ màn thành các vạch không có ý nghĩa.

## Quyết định đề xuất và trạng thái

Theo phản hồi rõ của người dùng, chấp nhận giảm mật độ và chuyển về low-fi đơn giản; sửa brief trước thay vì đổ lỗi cho công cụ. Giữ bốn tab như hướng hiện tại. Prompt sửa tại ai/prompts/OFFICE-W02-S01-simplify.md. Chưa gửi lệnh sửa, chưa có ảnh AFTER, chưa xác minh cải tiến hoặc tính là vòng hoàn tất. Không tính đổi grayscale đơn thuần là một vòng UX.
