# Quyết định thiết kế và trạng thái kiểm chứng

D01–D03 là đầu vào thiết kế; D04–D06 ghi nhận yêu cầu nhóm và phản biện C00 trên output V00. Số quyết định quan trọng giữ ≤10; thêm bằng chứng sau khi có output.

| ID | Quyết định | Loại / nguồn | Lý do | Bằng chứng và trạng thái |
| --- | --- | --- | --- | --- |
| D01 | Một ứng dụng, Linh là persona chính, giữ ba persona hỗ trợ | Chấp nhận định hướng thiết kế của nhóm | Một bài chung, cần mục tiêu chính rõ; vẫn thể hiện khác biệt bốn persona | ux/persona.md; quyết định đã ghi, UI chưa xác minh |
| D02 | Dùng bộ S01–S08 Power9 thay inventory generic trong sheet | Điều chỉnh bản mẫu checklist cho nội dung sản phẩm | Không cần đăng nhập/onboarding để giải quyết task ngắn; tận dụng bốn tab wireframe | design/screen-spec.md; chưa cập nhật sheet live |
| D03 | Bỏ chat realtime, recipe product, dark theme khỏi scope này | Từ chối mở rộng phạm vi | Ưu tiên ba task cốt lõi, bằng chứng AI và prototype hoàn chỉnh | DESIGN.md và plan; UI chưa tạo |

## Quyết định sau khi xem V00

| ID | Quyết định | Loại / nguồn | Lý do | Bằng chứng và trạng thái |
| --- | --- | --- | --- | --- |
| D04 | Đổi accent xanh lá sang xanh biển #1E5AA8 | Điều chỉnh theo yêu cầu nhóm | Nhận diện thị giác mong muốn; giữ palette có contrast đề xuất phù hợp | ảnh tổng quan V00 xanh lá; DESIGN.md mới và I01 prompt; output xanh biển chưa có. Không tính đổi màu riêng là UX iteration |
| D05 | Dùng tiếng Việt có dấu và title đúng S01/S05/S06/S07 | Chấp nhận UX01/UX02, khớp yêu cầu nội dung đã có | Linh/Hùng cần biết đang ở màn nào; Nielsen match/visibility/consistency | C00 và V00; I01 chưa chạy |
| D06 | Dùng “Xem chi tiết” cho action đi S05 → S06 | Điều chỉnh UX06 theo tiêu chí phản hồi tác vụ | Tách điều hướng khỏi cam kết thêm thói quen, tránh người dùng hiểu sai | C00 và V00; I01 chưa chạy |

D07: Điều chỉnh wireframe theo WF01–WF03: tách tên màn khỏi Quay lại, rút mô tả dài và đặt trạng thái phụ riêng. Lý do: nhận biết tác vụ rõ cho Linh/chú Hùng, kiểm tra bố cục trước trang trí. Bằng chứng trước: W00 overview; prompt W01 sẵn sàng, chưa có ảnh sau.

D08: Điều chỉnh trạng thái của S05/S07/S08 theo UX03/UX04/UX08: tách có dữ liệu/rỗng, hợp lệ/thiếu giờ/đang lưu/lưu lỗi để phản hồi không mâu thuẫn và giữ dữ liệu khi thử lại. Bằng chứng trước: I01 và P00b overview; ảnh sau I02 và review ai/critiques/I02-review.md đã có; tách trạng thái được cải thiện, tương tác chưa kiểm tra.

D09: Điều chỉnh S06 theo UX05 thành hai ngữ cảnh chưa thêm/đã thêm, CTA thêm/đổi lịch tương ứng; tránh hiểu nhầm thêm trùng. Đã có ảnh I03 và review ai/critiques/I03-review.md: hai ngữ cảnh/CTA được phân biệt; điều hướng chưa kiểm tra.

D10: Chuẩn hóa viewport trong Figma theo yêu cầu đề. I02 cho thấy khung 390×884 và I03 có khung 390×1169; cần base 360×800, vùng cuộn và kiểm tra 412. Chưa đánh đạt kích thước. UX03/UX04/UX05 đã có khuyến nghị trong C00, chưa ghi là đã sửa. Mỗi quyết định cần before/after khi có output.

## Accessibility checklist

| Hạng mục | Kết quả hiện tại | Bằng chứng cần có |
| --- | --- | --- |
| Contrast văn bản | Các cặp token đề xuất đã tính, xem DESIGN.md; chưa pass UI thực tế | Màu thật/opacity theo màn và phép đo |
| Touch target ≥48×48 dp | Là constraint trong prompt, chưa đo output | Bounds component thật |
| Body ≥14 sp | Brief đề xuất 16 sp, chưa đo output | Figma text properties |
| Không chỉ dùng màu | Đã yêu cầu icon + nhãn trong brief | Ảnh output và states |
| 360/412 dp | Chưa kiểm tra | Frame resize, Auto Layout/constraints |
| Token binding/instances | Chưa kiểm tra | Figma panel trên component và instance |

Không đánh “đã kiểm tra” trong sheet chỉ vì prompt có yêu cầu.
