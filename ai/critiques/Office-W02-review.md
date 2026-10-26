# AI phản biện Office W02

Ngày 26/10/2026. Reviewer: Codex. Đầu vào thực tế: output/office-wireframe.html, ảnh output/office-wireframe-overview.png và kết quả output/office-wireframe-check.json. Đây là review wireframe local, chưa phải review canvas Figma hoặc kiểm thử người dùng.

## Kết quả

- Có tám màn 360×800 và đủ chín nguyên tắc trong danh mục; truy cập được chi tiết từng mục.
- Tách 80% Rule/Plant Slant; ghi rõ điều chỉnh Wine @ 5/Belong; Loved Ones First vẫn là người thân.
- Màn Hôm nay dùng vài hoạt động tự chọn, không chỉ tiêu 9/9. Ba tab ưu tiên danh mục chín nguyên tắc thay bốn chủ đề chung.
- Kiểm tra bằng Playwright: tìm kiếm không có kết quả/xóa lọc, chín nội dung chi tiết, check-in/hoàn tác tại chỗ; không lỗi JavaScript hoặc tràn ngang ở từng khung. Chưa chứng minh ba flow hoàn chỉnh.

## Vấn đề phải sửa trước UI

| Mức | Vấn đề thực tế | Điều chỉnh W03 / điều kiện đạt |
| --- | --- | --- |
| P1 | S01 mở chi tiết không đặt lại nguyên tắc; có thể còn dữ liệu vừa xem | Truyền ID và nguồn khi mở, Back về đúng nguồn |
| P1 | Lưu lịch chỉ báo mô phỏng, Home chưa đổi; hoàn thành chưa cập nhật lịch sử | Đồng bộ Home/lịch/tiến độ; kiểm tra thêm, sửa, hủy và hoàn tác theo ba flow |
| P1 | Chưa có validation theo giờ yên lặng, loading/lỗi lưu/retry | Bổ sung trạng thái riêng; lỗi giữ form và Home giữ lịch cũ |
| P2 | H01/H02/H08 nằm trong danh mục dài, không thấy cùng lúc ở viewport | Giữ danh mục cuộn; có tổng số kết quả và khả năng tìm theo tên/nhãn Việt; không nén chín card |
| P2 | Trên ảnh, nội dung card dưới cùng bị khuất do viewport cuộn | Giữ cuộn nội dung; bảo đảm thao tác cuối cùng kéo tới được ở 360 và 412 |
| P2 | Điều khiển mặc định của trình duyệt vẫn có màu xanh | Dùng accent xám trong wireframe; màu thương hiệu chỉ áp ở UI sau khi W03 đạt |

Kết luận: hướng nội dung đã trở về Power 9 trong ngữ cảnh văn phòng; W02 chưa được chốt làm wireframe hoàn chỉnh. Không chuyển nhãn sang Final UI trước khi giải quyết P1. Không bịa ba vòng cải tiến từ bộ cũ.
