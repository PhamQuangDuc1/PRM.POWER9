# Firebase — thiết lập Power9 Office Routine

Ngày 31/10/2026. Project mới theo người dùng: `power9-office-se180724`. Display name: Power9 Office Routine. Không bật billing trong bước khởi tạo này.

## Android và Google Sign-In

- Package: `vn.power9.power9_office_routine`.
- Firebase app ID: `1:613232000873:android:f65f6f74ecdc93e31407f8`.
- SHA-1 debug máy hiện tại: `C7:6A:FC:43:6F:75:CA:11:8F:E1:0B:C9:09:D4:00:6A:60:73:DB:31`.
- Người dùng bật Google provider trong Authentication, chọn support email, public-facing name Power9 Office Routine và Save.
- Đã lấy cấu hình mới và kiểm tra có OAuth web client cho đúng project/package. Android Gradle áp dụng Google Services plugin 4.4.4.
- Cấu hình app: `android/app/google-services.json`, `lib/firebase_options.dart`. Đây là định danh client, không phải service-account credential. Access control phải nằm ở Rules/backend, không dựa vào việc giấu file config.
- Không commit debug keystore, login token Firebase CLI, API secret, service-account key. Máy build khác cần đăng ký SHA của máy đó; release cần SHA của certificate release riêng.

## Công cụ và thao tác

FlutterFire CLI 1.4.1 được gọi bằng `dart pub global run flutterfire_cli:flutterfire` vì cache/bin chưa có trong PATH. Cấu hình lại khi cần:

```powershell
dart pub global run flutterfire_cli:flutterfire configure --project=power9-office-se180724 --platforms=android --android-package-name=vn.power9.power9_office_routine --yes
```

Sau khi provider/SHA thay đổi, tải lại SDK config. Firebase CLI không ghi đè file `--out` đã tồn tại: tải ra file tạm trong `.build/`, kiểm tra project/package/OAuth rồi mới thay `android/app/google-services.json`. Không cần người dùng tự chỉnh JSON.

## Chưa hoàn thành

- Google Sign-In đã vào Home trên Xperia; Users console và các nhánh Auth còn thiếu minh chứng nên chưa đóng toàn bộ tiêu chí.
- Firestore Standard/model lịch/Rules đã thiết lập và kiểm thử. Storage/billing, FCM, Analytics property/event, Crashlytics và Remote Config chưa thiết lập đầy đủ.
- Google Sign-In thành công không có nghĩa đã đáp ứng sáu dịch vụ hoặc các flow Lab 2.
