# Runner cục bộ — 04/11/2026

Đã kiểm tra 29 test offline đạt trong 4,68 giây. Kết quả máy đọc: `evidence/artemis/runner-offline-20261104.xml`. Không khởi động daemon, không điều khiển điện thoại, không gọi model; bộ đếm vẫn 49/50. Không thay key/model, billing hoặc kết quả ARTEMIS lịch sử.

## Chặn riêng tư

`e2e_test/runtime/privacy_guard.py` kiểm tra hierarchy trước khi `AndroidAdbDriver.get_screen_data` trả frame cho tầng agent; chặn email, nhãn Profile/debug, app ngoài phạm vi và nội dung thông báo không phải đồng hồ/pin. Thiếu hierarchy hoặc hierarchy hỏng thì dừng. Nút Tài khoản/Account/Profile bị chặn theo bounds trước khi phát lệnh tap. Một lần chặn khóa tiếp observation/tap/swipe/input/key của instance driver đó. Lỗi chỉ có mã lý do, không chứa nội dung bị chặn.

Launcher bật guard trong process chính và worker. `sitecustomize.py` cài guard sau các adapter nhập liệu; không import được guard thì worker thoát mã 78. Test khởi động subprocess với driver ARTEMIS thật xác nhận adapter vẫn được bọc, không tạo kết nối thiết bị/model.

Các test khác dùng hierarchy tổng hợp, xác minh chặn trước input, không trả frame riêng tư, khóa sau lỗi, xử lý nhãn trùng text/description, cho phép Home và print preview. Đây là kiểm chứng các đường gọi đã nêu; chưa phải kiểm toán toàn bộ lối xuất dữ liệu, chưa chạy guard trên thiết bị thật và không bảo đảm ảnh không có mọi dạng dữ liệu riêng tư. Vì vậy chưa dùng kết quả này để kết luận Pro an toàn hoặc đạt.

## TC10 và viewport

Goal yêu cầu đọc tổng số lịch trước, cuộn toàn bộ thẻ lên trên thanh tab, xác nhận chi tiết thực sự mở; không lặp tap cũ hoặc tự báo thành công khi chưa thao tác. Kết quả cuối phải ở tab Hôm nay, thấy giờ đích và tổng số lịch không đổi. Assertion cuối có thể cuộn vùng nội dung để đọc thẻ; không click, sửa hoặc tạo dữ liệu thay model. Giới hạn số lần cuộn vẫn làm test fail khi không thấy thẻ.

Test offline xác minh thẻ bị cắt/thẻ cao một pixel hoặc nằm ở thanh tab không được coi là nhìn thấy trọn vẹn; nhận dạng Home bằng tiêu đề và tab Hôm nay được chọn. Không dùng việc kiểm tra cục bộ này để cộng run ID: TC10[3] vẫn failed, ARTEMIS vẫn 32/33.

## Môi trường và bước tiếp theo

Lượt test sandbox đầu bị treo khi Windows asyncio tạo socketpair nội bộ, chưa vào thân coroutine. Đã dừng lượt đó và chạy lại cùng test ngoài sandbox; 29/29 đạt. Không phải lỗi app hoặc một lượt gọi model.

Trước khi dùng một lượt mới cần kiểm tra guard trên màn hình công khai của máy thật, chuẩn bị fixture theo ngày hiện tại và phân bổ lượt còn lại với người dùng: batch trước chỉ cho đúng bốn task, đã dùng đủ. Không tự chạy lượt thứ năm hoặc ghi Pro đạt từ một phiên ngắn. Nếu chạy TC10 vẫn phải giữ trace và đối chiếu cancel/save thực tế, không chỉ dựa JSON do model trả về.
