# OI01 — lệnh sửa theo nguyên nhân đã kiểm chứng

Người dùng xác nhận ngày27/10/2026 đã gửi nguyên văn100% prompt Office do trợ lý cung cấp trên dự án Stitch mới. Khối prompt bên dưới được giữ nguyên.

```text
Tiếp tục xử lý OI01 trên đúng 10 màn UI hiện tại, KHÔNG coi lần sửa font trước đã đạt. Giữ các bản trước để đối chiếu; không tạo thêm chức năng hoặc màn ngoài bộ UI.

Tôi đã kiểm tra HTML export và tìm ra nguyên nhân chính xác:
Trong tailwind.config.theme.extend.fontFamily, các key display/body/label/headline/helper/body-medium đang gộp toàn bộ danh sách font thành 1 tên trong dấu nháy kép, ví dụ:
body: ['"Be Vietnam Pro, Roboto, sans-serif"']
Đây là 1 font-name sai, không phải 3 family. Chrome render Times New Roman dù đã có Google Fonts link. Class font-body ghi đè khai báo base đúng.

Sửa TẤT CẢ các key fontFamily liên quan thành array 3 phần tử tách riêng:
body: ['Be Vietnam Pro', 'Roboto', 'sans-serif']
display: ['Be Vietnam Pro', 'Roboto', 'sans-serif']
label: ['Be Vietnam Pro', 'Roboto', 'sans-serif']
headline: ['Be Vietnam Pro', 'Roboto', 'sans-serif']
helper: ['Be Vietnam Pro', 'Roboto', 'sans-serif']
'body-medium': ['Be Vietnam Pro', 'Roboto', 'sans-serif']

Nếu cấu hình dùng chuỗi CSS thì giá trị phải là:
font-family: "Be Vietnam Pro", Roboto, sans-serif;
KHÔNG phải:
font-family: "Be Vietnam Pro, Roboto, sans-serif";

Giữ Google Fonts import Be Vietnam Pro đang có. Không thêm dấu nháy bao quanh cả danh sách. Không đổi font icon Material Symbols.
Áp dụng sửa cùng nguyên nhân cho toàn bộ 10 màn. Giữ palette, logo, nội dung, ảnh và điều hướng ở vòng này; chỉ reflow khi cần để text không đè/cắt nhau. Tên hoạt động chính được xuống dòng thay vì ellipsis khi font mới rộng hơn. Không giảm font để ép vừa.

Kiểm tra computed family có 3 phần riêng và font thực được render là Be Vietnam Pro, không Times New Roman. Việc thử cục bộ trên S01/S07 đã cho kết quả đúng sau đổi array; cần sửa trên output thật của Stitch. Kiểm tra 360/412 và icon không biến thành chữ. Chưa đo được thì báo chưa đo, không tự tuyên bố đạt.

Chỉ sửa typography của 10 màn, giữ các bản trước. Mã OI01/S01–S10 chỉ ở tên frame ngoài canvas. Dừng để tôi chụp và đối chiếu trước khi chuyển C02/OI02.
```
