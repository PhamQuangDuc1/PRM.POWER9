# Kiểm thử Firestore Rules

Yêu cầu Node >=20, Firebase CLI 15.33.0, Java từ Android Studio JBR. Dependency test được pin trong package.json/package-lock.json riêng, không trộn với pubspec Flutter.

```powershell
Set-Location firebase/tests
npm ci
Set-Location ../..
$env:JAVA_HOME = 'C:/Program Files/Android/Android Studio/jbr'
$env:PATH = "$env:JAVA_HOME/bin;$env:PATH"
firebase emulators:exec --only firestore --project demo-power9 "node firebase/tests/firestore-rules.test.cjs"
```

`demo-power9` là project emulator, không phải cloud project thật. Test từ chối chạy nếu thiếu FIRESTORE_EMULATOR_HOST. Seed alice/bob nằm trong emulator, không được đưa lên dữ liệu thật.

8 test kiểm tra owner CRUD, cross-user denial, signed-out denial, published query/client không ghi catalog, sai type/field/nhắc thiếu giờ, lịch không nhắc được bỏ giờ, ID ngẫu nhiên bị chặn và metadata/catalog không được giả mạo. Log PERMISSION_DENIED trong các assertFails là kết quả mong đợi. Log lần chạy thành công ở `evidence/firestore/rules-run.txt`.

Seed catalog trên cloud riêng biệt, chạy từ root:

```powershell
node scripts/firebase/seed-catalog.cjs --project power9-office-se180724
```

Script dùng firebase-tools global đã đăng nhập. Không tạo service-account key; không in token. Do dùng internal API của CLI, nếu đổi version cần kiểm tra lại. Không ghi lịch hoặc completion cá nhân.
