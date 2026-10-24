# I01 — Đánh giá bản xanh biển

## Bằng chứng

Ảnh: assets/stitch/I01/I01-overview-user-provided.png, bản gốc nhóm cung cấp, có manifest SHA256. Prompt dự kiến: ai/prompts/I01-blue-vietnamese-labels.md; chưa xác minh toàn bộ nguyên văn thực gửi từ ảnh.

Mức thu phóng 32%. Có bảng phong cách xanh biển, bốn màn xanh biển nhận diện theo nội dung là S01/S07/S06/S05, xen các màn xanh lá S05/S06. Không tính các khung cũ cùng chức năng thành màn mới.

## Kết quả của vòng I01

| Mục tiêu | Quan sát | Kết luận trong phạm vi ảnh |
| --- | --- | --- |
| UX01: tiếng Việt có dấu | Các thanh xanh biển dùng Hôm nay, Lịch thói quen, Chi tiết thói quen, Khám phá thói quen | Đã cải thiện phần tiêu đề; chữ nhỏ vẫn cần ảnh rõ/lớp chữ |
| UX02: tên màn đúng tác vụ | Bốn tên xanh biển phân biệt đúng chức năng | Đạt mục tiêu quan sát tổng quan |
| UX06: nhãn xem/thêm mơ hồ | Thẻ khám phá xanh biển dùng Xem chi tiết | Đã cải thiện nhãn, chưa chứng minh đích tương tác |
| Hướng xanh biển | Bốn màn và bảng phong cách đã chuyển xanh biển | Đã có đầu ra theo hướng màu; chưa đo mã màu/contrast thực tế |

I01 có thay đổi về ngôn ngữ và nhận biết tác vụ, không chỉ đổi màu. Có ảnh V00 và I01 để đối chiếu. Ghi nhận đã thực hiện và review vòng này, không đồng nghĩa mọi UI/accessibility đều đạt.

## Lỗi còn thấy đúng như critique trước

- UX03: S05 xanh biển vẫn có danh sách kết quả và bảng không có kết quả cùng màn.
- UX04: S07 xanh biển vẫn trộn giờ đã chọn, lỗi thiếu giờ và lỗi kết nối/lưu.
- UX05: S06 xanh biển vẫn có dấu hiệu đã thêm nhưng bật nút thêm mới.
- Đây là mục tiêu cho I02/I03 đã lên kế hoạch; không chạy lại I01 hoặc tạo thêm wireframe để giải quyết chúng.

## Bộ UI tạm được chọn

Chọn bốn màn xanh biển theo nội dung S01/S05/S06/S07; không chọn hai khung xanh lá xen kẽ trong ảnh mới. Giữ nguyên khung cũ làm nguồn so sánh. Bộ đang có chỉ gồm bốn chức năng Final UI, không phải sáu hoặc tám.

Các màn S02/S03/S04/S08 cần bổ sung bằng P00b. Sau đó sửa states I02 và ngữ cảnh thêm/sửa I03, rồi hoàn thiện Figma.

## Giới hạn

Chưa đo font/vùng chạm/contrast, kiểm tra khung 360×800 và rộng 412, token/Auto Layout/instances hoặc prototype. Chưa xác nhận bất kỳ mục tiêu thời gian UX nào.
