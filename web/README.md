# Power9 Admin — Final Assignment

Cổng Flutter Web cho Admin. Đăng nhập bằng Google, kiểm tra role, xem số liệu tổng hợp, quản lý danh mục, duyệt và xuất bản đề xuất, gửi thông báo vào inbox mobile. Dùng model, service đề xuất, service thông báo và theme từ `packages/core`.

## Chạy cục bộ

1. Từ thư mục repo, chạy `firebase emulators:start --only auth,firestore --project demo-power9`. Dùng Java 21 cho Firebase CLI hiện tại.
2. Từ thư mục gốc, chạy `node firebase/seed-assignment-demo.mjs` để tạo tài khoản **admin@power9.test** và thêm các mục danh mục còn thiếu vào Emulator.
3. Mở [web Admin cục bộ](http://127.0.0.1:8081/) nếu server demo đang chạy. Nếu cần tự chạy, trong terminal khác chạy `cd web` và `flutter run -d chrome --dart-define=POWER9_USE_EMULATORS=true`. Chọn **Đăng nhập với Google → admin@power9.test** trong popup Auth Emulator.
4. Từ thư mục gốc, nối cổng và chạy bản debug Assignment trên Android Emulator:

   ```powershell
   $adb = 'C:\Android\sdk-local\platform-tools\adb.exe'
   & $adb -s emulator-5554 reverse tcp:8080 tcp:8080
   & $adb -s emulator-5554 reverse tcp:9099 tcp:9099
   flutter run -d emulator-5554 --dart-define=POWER9_ASSIGNMENT=true --dart-define=POWER9_USE_EMULATORS=true
   ```

5. Trên mobile chọn **Vào bằng User thử nghiệm**, rồi vào **Khám phá → Đề xuất hoạt động**. Gửi đề xuất, giữ màn **Đề xuất của tôi** mở, sau đó duyệt kèm lý do trên web. Trong **Lịch sử xử lý**, chọn **Xuất bản** và kiểm tra **Khám phá**. Để kiểm tra inbox, giữ màn **Thông báo** trên mobile rồi gửi tin thử trong mục **Thông báo** của web. Kiểm thử quyền nằm ở `firebase/tests/firestore-rules.test.cjs`.

Hai cờ trên kích hoạt Firebase Auth và Firestore Emulator cho bản debug. Phiên thử nghiệm sử dụng Firebase app riêng, không cần tài khoản Google thật. Bản Lab 3 chạy theo cấu hình mặc định. Chỉ bật `POWER9_ASSIGNMENT=true` để chạy Assignment trên Firebase thật sau khi môi trường đó đã có Rules phù hợp.

## Cấu hình Firebase Web

Bản dùng Firebase thật cần Web App đã đăng ký và Google Sign-In đã bật. Dùng `POWER9_FIREBASE_PROJECT_ID`, `POWER9_FIREBASE_WEB_API_KEY`, `POWER9_FIREBASE_WEB_APP_ID`, `POWER9_FIREBASE_MESSAGING_SENDER_ID` và `POWER9_FIREBASE_WEB_MEASUREMENT_ID` từ cấu hình Web App. Đặt role Admin đầu tiên tại `users/{uid}` trong Firestore Console. Tham số Remote Config `admin_announcements_enabled` bật hoặc tắt form, mặc định bật. Đăng ký App Check cho Web App bằng reCAPTCHA Enterprise và truyền site key công khai qua `POWER9_WEB_APP_CHECK_SITE_KEY`.

Build release trong `web/` bằng `flutter build web --output build/hosting` kèm các build defines trên, sau đó chạy `firebase deploy --only hosting,firestore:rules --project <project-id>` từ thư mục gốc. Thư mục Hosting tách riêng khỏi bản Emulator. Kiểm tra cả Android và web với App Check trước khi bật enforcement trên Firestore. Theo dõi các điều kiện nghiệm thu ở [gap review](../docs/gap-review.md).
