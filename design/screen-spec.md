# Bộ màn hình Power9 dùng cho Stitch và Figma

Trạng thái: đã có ảnh Stitch đủ tám chức năng, ba vòng I01–I03 và S01 dán thử vào Figma; xem design/ui-selection.md. Cấu trúc/tương tác Figma chưa kiểm chứng. Linh là persona chính theo định hướng thiết kế. Bốn persona đều giả định. Đây là inventory chuẩn thay cho danh sách generic trong ảnh checklist, cần cập nhật sheet khi nhóm thao tác.

| ID | Tên | Nội dung chính và hành động | Cấp / Flow |
| --- | --- | --- | --- |
| S01 | Hôm nay | Danh sách thói quen, thời lượng, giờ nhắc, Hoàn thành, Hoàn tác; entry Khám phá và Lịch sử | Top-level; F01/F02/F03 |
| S02 | Ăn uống | Một thói quen ăn chậm, hướng dẫn ngắn, ghi nhận hoàn thành → S08 | Top-level; F02 alternate |
| S03 | Thư giãn | Phiên 5 phút, start/pause/resume/finish; xác nhận thoát phiên | Top-level; F02 |
| S04 | Kết nối | Hoạt động với người thân có thời lượng, chọn và ghi nhận → S08 | Top-level; F02 alternate |
| S05 | Khám phá thói quen | Search có nhãn, filter 5/10 phút, card có thời lượng → S06 | Màn con từ S01; F01 |
| S06 | Chi tiết thói quen | Mục đích, thời lượng, bước làm, thêm mới hoặc đổi lịch → S07 | Màn con từ S01/S05; F01/F03 |
| S07 | Lịch thói quen | Chọn ngày, reminder tùy chọn, giờ; lưu → S01; validation, retry giữ dữ liệu | Màn con từ S06; F01/F03 |
| S08 | Lịch sử và tiến độ | Entry có ngày, icon + nhãn, tổng tuần, xác nhận xóa; empty có CTA khám phá | Màn con từ S01/S02/S03/S04; F02 |

Bottom nav: Hôm nay / Ăn uống / Thư giãn / Kết nối. Màn con có Back trả về đúng nguồn. Vào chi tiết từ danh sách nào thì Back trở lại danh sách đó với bộ lọc giữ nguyên.

## Các state phụ, không tính thêm màn

| ID | Screen cha | Nội dung / hành vi mong muốn |
| --- | --- | --- |
| S01-completed | S01 | Icon + “Đã hoàn thành”, Hoàn tác; lịch sử phản ánh trạng thái |
| S01-added | S01 | Thói quen mới xuất hiện và xác nhận lưu rõ |
| S05-empty | S05 | “Chưa có hoạt động phù hợp”; “Xóa bộ lọc” |
| S07-validation | S07 | Nhắc giờ đang bật nhưng thiếu giờ: lỗi cạnh trường |
| S07-loading | S07 | “Đang lưu…”; chặn gửi lặp |
| S07-error | S07 | Nguyên nhân dễ hiểu, “Thử lại”, giữ dữ liệu |
| S08-empty | S08 | Chưa có bản ghi, CTA Khám phá → S05 |
| O01-exit | S03 | Overlay xác nhận kết thúc/hủy phiên; Hủy giữ phiên |
| O02-delete | S08 | Overlay “Giữ lại” / “Xóa bản ghi”; hủy không xóa |

Tên màn/mã chỉ ở canvas và tài liệu; không hiển thị mã kỹ thuật trong ứng dụng. Phiên active/paused và create/edit không được đếm như màn độc lập.

## Truy vết persona

- P03 Linh → S05 card có số phút, filter dễ thấy, S07 form ngắn, S01 xác nhận.
- P01 Minh → S01 check-in trực tiếp và hoàn tác; S08 tuần đơn giản.
- P02 Huy → S01 thấy giờ, S06/S07 đổi lịch nhanh và hủy giữ giờ cũ.
- P04 Hùng → chữ đọc được, nút có nhãn trên toàn bộ màn, O02 xác nhận trước xóa.

Đây là design intent. Handoff sáu mục/màn và bằng chứng Figma được viết/đo sau khi UI chốt; không ghi file này là handoff hoàn chỉnh.

## Quy tắc đích khi hoàn thiện Figma

Bộ lọc thời lượng là tối đa: dùng nhãn ≤5 phút/≤10 phút để khớp hoạt động 3 phút trong kết quả ≤5. Giữ returnOrigin khi mở Khám phá từ S08-empty, để Back trả đúng nguồn. Các giới hạn dữ liệu và hành vi chi tiết xem handoff/flutter-handoff.md; cần đối chiếu canvas trước khi bàn giao cuối.
