# Upload PDF Lab 3 qua Cloudinary

Backend này chạy trên máy phát triển và chỉ lắng nghe loopback. App gửi Firebase ID token và bytes PDF. Backend xác minh token, lấy UID từ token, giới hạn tệp 10 MiB, lưu asset Cloudinary ở chế độ authenticated và trả link tải có hiệu lực 10 phút. Cùng một PDF của cùng người dùng sử dụng lại cùng ID asset. App ghi metadata Firestore sau khi cloud chấp nhận. Link đã cấp có thể được dùng bởi người có link cho đến khi hết hạn.

## Mở backend

Chạy các lệnh sau trong PowerShell. Nhập khóa từ Cloudinary Console vào các prompt, giữ cửa sổ mở trong lúc demo.

```powershell
Set-Location 'E:\FALL2026\PRM\PRM.POWER9\firebase\report-upload'
npm.cmd ci
$env:FIREBASE_PROJECT_ID = 'power9-office-se180724'
$env:CLOUDINARY_CLOUD_NAME = 'che7jy9k'
$env:CLOUDINARY_API_KEY = Read-Host 'Cloudinary API Key'
$secret = Read-Host 'Cloudinary API Secret' -AsSecureString
$env:CLOUDINARY_API_SECRET = [System.Net.NetworkCredential]::new('', $secret).Password
Remove-Variable secret
npm.cmd start
```

Dùng Node.js 22 trở lên. Khi thấy `Power9 report backend listening on 127.0.0.1:8787`, chạy app từ cửa sổ PowerShell thứ hai. Khi đóng backend, đóng cửa sổ PowerShell chứa biến môi trường. Nếu dùng file `.env`, file đó được Git bỏ qua.

## Chạy bản Lab 3 trên máy ảo

```powershell
Set-Location 'E:\FALL2026\PRM\PRM.POWER9'
$env:ANDROID_HOME = 'C:\Android\sdk-local'
$env:JAVA_HOME = 'C:\Android\jdk'
$adb = 'C:\Android\sdk-local\platform-tools\adb.exe'
& $adb -s emulator-5554 reverse tcp:8787 tcp:8787
& 'C:\dev\flutter\bin\flutter.bat' run -d emulator-5554 --dart-define=POWER9_REPORT_UPLOAD_URL=http://127.0.0.1:8787/reports
```

Trên Android thật kết nối USB, thay `emulator-5554` bằng serial trong `adb devices` ở cả hai lệnh. ADB reverse chuyển cổng localhost của Android về máy chạy backend.

Bản debug với endpoint loopback bật nút upload để demo. Bản chạy bình thường tiếp tục theo cờ Remote Config và dùng Firebase Storage nếu không cấu hình endpoint Cloudinary. Endpoint HTTP loopback chỉ được cho phép trong bản debug.

## Kiểm tra kết quả

1. Đăng nhập Power9 và mở **Tiến độ → Xuất báo cáo PDF → Tạo PDF → Lưu lên đám mây**. Quan sát tiến độ gửi và kết quả xác nhận.
2. Bấm **Sao chép liên kết PDF** rồi mở link bằng trình duyệt trong 10 phút. Kiểm tra PDF trùng nội dung trên app. Trong Cloudinary Media Library, xác nhận asset thuộc nhóm `power9-reports` và có delivery type authenticated.
3. Lưu ảnh tiến độ, kết quả và PDF mở được. Che URL có chữ ký và định danh người dùng trước khi dùng ảnh công khai.
4. Có thể chạy `npm.cmd test` để kiểm tra backend cục bộ. Test dùng verifier và Cloudinary giả lập để kiểm tra từ chối yêu cầu trái phép, dữ liệu sai định dạng và phân tách theo UID.
