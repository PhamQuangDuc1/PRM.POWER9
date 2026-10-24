# Đánh giá wireframe W00

## Nguồn và giới hạn

Ảnh gốc: assets/wireframe/W00/W00-overview-user-provided.png, nhóm cung cấp và được lưu nguyên trạng, có manifest SHA256. Mức thu phóng hiển thị 32%, chưa đủ đo cỡ chữ sp, vùng chạm dp, kích thước khung hoặc cấu trúc lớp.

Ảnh thể hiện tám bố cục riêng. Nhận diện theo nội dung từ trái sang phải: S05, S06, S07, S01, S03, S02, S04, S08. Bảng phong cách bên dưới không được tính thêm màn. UI xanh lá V00 vẫn thấy một phần phía trên, được giữ riêng.

Đã có bằng chứng đủ tám màn low-fi về mặt nội dung. Chưa đồng nghĩa đủ tám màn Final UI hoặc prototype chạy được.

## Điểm phù hợp

- Dùng phần lớn đen–trắng/xám, khối đơn giản và khung ảnh giữ chỗ.
- Home có danh sách, nút hoàn thành và lối vào khám phá/lịch sử.
- Khám phá có tìm kiếm, bộ lọc số phút và nhãn “Xem chi tiết”.
- Lịch có ngày, nhắc giờ, Lưu/Hủy; chi tiết có thời lượng và CTA thêm.
- Đã có bố cục riêng cho Ăn uống, Thư giãn, Kết nối và Lịch sử.
- Trên S05 không thấy bảng rỗng trộn ngay dưới danh sách như V00; trên S07 không thấy các khối lỗi trộn như V00. Đây là quan sát bộ wireframe, không được dùng để ghi I02 của Final UI đã hoàn thành.

## Điều cần chỉnh

| Mã | Bằng chứng | Ảnh hưởng | Cách chỉnh và kiểm tra |
| --- | --- | --- | --- |
| WF01 | Các thanh trên S05/S06/S07/S08 lặp dòng có “Quay lại Chi tiết thói quen” | Khó nhận diện tác vụ, lẫn nhãn Back với tên màn | Tách biểu tượng/nhãn Quay lại khỏi title; đặt đúng bốn tên theo screen spec |
| WF02 | S06 có nhiều thẻ hướng dẫn dài; S04 có mô tả nhiều dòng bên trong các lựa chọn | Bản phác thảo khó quét nhanh, phần giải thích chiếm ưu thế so với cấu trúc | Giữ chữ thật cho title/nhãn/thời lượng/CTA; mục đích ≤2 dòng, mỗi bước 1 dòng ngắn; đoạn dài biểu diễn bằng các nét xám |
| WF03 | Ảnh chỉ cho thấy tám màn cơ sở và bảng phong cách | Chưa có bằng chứng cho rỗng/thiếu giờ/đang lưu/lưu lỗi/hộp thoại riêng | Nếu chưa tồn tại, tạo các biến thể phụ; nếu đã có ngoài vùng ảnh, giữ và chụp riêng, không tạo trùng |

WF01–WF03 là nhận xét theo ảnh tổng quan. Không suy ra rằng các biến thể chắc chắn không tồn tại ngoài vùng chụp.

## Wireframe có nhiều chữ có sai không?

Không có quy định wireframe phải ít chữ tuyệt đối. Cần chữ thật để kiểm tra nhãn, thứ bậc, độ dài và các quyết định của người dùng. “Low-fi” nói về mức chi tiết thị giác, không có nghĩa bỏ hết nội dung.

Trong bài này nên rút phần giải thích dài để nổi rõ bố cục và hành động, đồng thời giữ tên hoạt động, số phút, giờ nhắc, nút và thông báo quan trọng. Không thay toàn bộ bằng chữ giả vì sẽ không kiểm tra được tiếng Việt thật.

## Bước sau

Dùng ai/prompts/W01-wireframe-refinement.md cho việc chỉnh low-fi có mục tiêu: title đúng, chữ gọn và trạng thái tách riêng. W01 chưa chạy. W01 không thay thế ba vòng I01–I03 của UI hoàn thiện đã lên kế hoạch.

Sau khi có ảnh W01, đánh giá lại. Khi bố cục phù hợp, chạy I01 xanh biển trên bộ UI V00, không biến wireframe thành UI hoàn thiện một cách không lưu dấu phiên bản.
