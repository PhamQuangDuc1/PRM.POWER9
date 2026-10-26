# Quyết định thiết kế Power9 Office Routine

Ba persona chính ngang nhau: Huy 28, Mai 24, Linh 39. Các quyết định dưới đây phản ánh bản Office hiện hành.

| Mã | Quyết định | Lý do và phản biện | Bằng chứng |
| --- | --- | --- | --- |
| D01 | Một app, ba persona ngang nhau | Nhu cầu khác nhau trong cùng môi trường văn phòng; không cần màn chọn persona | ux/persona.md; Figma 01 |
| D02 | 9 nhóm trong Khám phá, tiến độ theo việc tự chọn | Nhóm nội dung không phải chỉ tiêu 9/9 mỗi ngày | S01/S05/S08 |
| D03 | Chấp nhận sửa cấu hình font | C01: serif khác brief; Nielsen H4 Consistency and standards | font-verification.json; ảnh S07 trước/sau Chrome |
| D04 | Chấp nhận giảm banner và thẻ phụ | C02: Linh cần xác nhận tên hoạt động/ngày giờ nhanh; Nielsen H8 Minimalist design | OI01/OI02 before/after |
| D05 | Điều chỉnh state AI, giữ cùng dữ liệu | C03: form lỗi đổi hoạt động; Mai cần thử lại mà không nhập lại | S07 error/retry; office-behavior-audit.json |
| D06 | Lỗi giữ draft, Hủy giữ dữ liệu đã lưu | Visibility of system status, User control, Error recovery | F01/F03; overlay và loading-result |
| D07 | Từ chối metric sức khỏe thiếu nguồn | Không có cảm biến hay dữ liệu để đưa nhịp tim/điểm ước tính vào UI | OFFICE-OI03-expanded-review.md |
| D08 | Mở/thu gọn đồng nhất cả 9 nhóm | H3 User control và H4 Consistency; phản hồi cùng thao tác phải nhất quán | DiscoverGroup 18 variants; 27 kiểm tra trên 3 bộ lọc |
| D09 | Dùng token, Auto Layout và instance | Thay đổi nhất quán, không detach để sửa nhãn | 37 variables; 10 families/53 variants |
| D10 | Tiến độ riêng tư; quiet hours không cấm lưu lịch | Tránh áp lực xếp hạng; Linh chủ động giờ nhắc | S07/S08; 17:30 sang 18:00 vẫn 1/3 |

## Accessibility và responsive

Các cặp token đã tính theo WCAG: #031C36/#F8F9FF =16.34:1; #FFFFFF/#1E5AA8 =6.81:1; #424751/#FFFFFF =9.33:1; #BA1A1A/#FFDAD6 =5.00:1. Đây là các cặp cụ thể, không phải chứng nhận toàn bộ WCAG.

CTA52, Back/header48; body16/24 và label14/20. Kiểm tra bố cục 360/412 không thấy text overflow trong bộ kiểm tra. Trạng thái có chữ, dấu kiểm và chỉ báo ngoài màu. Chưa kiểm thử TalkBack, text scaling hay người dùng thực.

Nguồn: assets/figma/office-checkpoint.json; assets/figma/office-accordion-audit.json; docs/FIGMA-FINAL-AUDIT.md; https://www.nngroup.com/articles/ten-usability-heuristics/ ; https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html .
