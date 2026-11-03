# Kiểm tra trợ năng native Power9

Đây là công cụ kiểm chứng Android11/Xperia của Lab3, không đóng vào APK và không gọi ARTEMIS/model. Script thay đổi trợ năng tạm thời, thao tác form/timer/PDF rồi khôi phục service trong finally. Không thay kiểm tra nghe và vuốt TalkBack bằng người thật.

Ngày 04/11/2026 người dùng đã nghe/vuốt và xác nhận Hôm nay sau “Ở lại” kích hoạt lại được dialog. Xem `evidence/accessibility/2026-11-04-manual-focus/result.json`. Sau đó người dùng hoàn thành ba phần nghe/vuốt: điều hướng và bộ lọc, validation/hủy sửa và giữ lịch, Ăn uống/Kết nối/Thông báo/PDF, Góc làm việc/Phục hồi/Tài khoản. Cả ba câu trả lời đều là “Đã thử đủ, nghe rõ và thao tác được”. Bằng chứng: `evidence/accessibility/2026-11-04-manual-flows/result.json`. Checklist thủ công đã đạt trong phạm vi này; không bao gồm bộ chọn Google hoặc mọi trạng thái có thể có. Cài đặt trợ năng và Analytics debug ban đầu đã khôi phục. Giữ nguyên snapshot tự động lịch sử.

## Tiền điều kiện

- Dùng tài khoản kiểm thử, máy mở khóa và Power9 ở Hôm nay. Không có phiên timer chưa ghi nhận cần giữ; activity timer hôm nay chưa có completion để có thể bắt đầu. Không chạy khi người dùng đang chọn tài khoản hoặc dùng máy.
- `uiautomator2`/UiAutomation khác phải dừng; helper giữ TalkBack bằng FLAG_DONT_SUPPRESS_ACCESSIBILITY_SERVICES. Không cho hai công cụ cùng chiếm UiAutomation.
- SDK Android34 để compile, build-tools36.0.0/d8, JDK và ADB. Đã chạy trên Android11; helper dùng reflection của UiAutomation và có thể không tương thích Android/OEM khác.
- Không chạy helper trên Tài khoản, debug, bộ chọn Google hoặc màn dữ liệu riêng. Chỉ các màn sản phẩm trong script được phép lưu nodes. Không commit serial/tokens hoặc raw Logcat.

## Tái tạo helper

Chạy từ root repository trong PowerShell; đặt đường dẫn SDK/JDK phù hợp máy. Các đường dẫn sau chỉ là mẫu, không phải lệnh đã chạy trên mọi môi trường.

```powershell
$sdkPath = $env:ANDROID_SDK_ROOT
$jdkPath = $env:JAVA_HOME
New-Item -ItemType Directory -Force .build/a11y-classes,.build/a11y-dex | Out-Null
& "$jdkPath/bin/javac.exe" -encoding UTF-8 --release 8 -classpath "$sdkPath/platforms/android-34/android.jar" -d .build/a11y-classes scripts/lab3/P9AccessibilityAudit.java
& "$sdkPath/build-tools/36.0.0/d8.bat" --min-api 30 --output .build/a11y-dex .build/a11y-classes/P9AccessibilityAudit.class
& "$jdkPath/bin/jar.exe" cf .build/p9-a11y.jar -C .build/a11y-dex classes.dex
& $env:POWER9_ADB -s $env:POWER9_DEVICE_SERIAL push .build/p9-a11y.jar /data/local/tmp/p9-lab3-a11y.jar
python scripts/lab3/native_accessibility_audit.py --run-device-accessibility --output .build/a11y-new-attempt
```

`POWER9_ADB` là đường dẫn adb.exe; `POWER9_DEVICE_SERIAL` đặt riêng trong môi trường cục bộ. Python chỉ dùng thư viện chuẩn. Output phải là thư mục mới để không ghi đè attempts cũ. Khi chạy trên tài khoản kiểm thử khác, kiểm tra/cập nhật precondition bảo toàn bản ghi bữa trưa trong script; không tự tạo hoặc xóa dữ liệu để làm assertion đạt.

## Cách đọc kết quả

### Chỉ kiểm tra lại nhánh timer sau khi đổi UI

Sau khi helper đã được build/push, có thể chạy phạm vi hẹp mà không đi qua form/PDF:

```powershell
python scripts/lab3/native_timer_focus_audit.py --run-device-accessibility --output evidence/accessibility/<new-attempt-directory>
```

Vẫn cần POWER9_DEVICE_SERIAL/POWER9_ADB cục bộ và tiền điều kiện ở trên. Script chỉ dùng Android accessibility focus/click, bật TalkBack tạm và giữ các service có sẵn, bắt đầu một phiên mới khi timer idle, pause → Hôm nay → Ở lại → Hôm nay lần nữa → Bỏ phiên. Không ghi completion. Nếu TalkBack mở TrainingActivity lúc bật, script đưa Power9 lên foreground và chỉ kiểm tra cây Power9. Cài đặt được khôi phục trong finally; kết quả cleanup và trạng thái phiên được ghi riêng nếu lỗi.

`behaviorPassed` xác nhận các chuyển trạng thái; `todayAfterStay.focusedBeforeActivation` là snapshot focus của đúng bước còn thiếu; `allActionFocusObserved` xét tất cả thao tác trong lượt. Giữ riêng ba giá trị này, không đổi lỗi lịch sử thành pass. `humanGesturesAndSpeechAssessed` luôn false cho lượt tự động này.

- `automaticChecksPassed` chỉ đúng khi các assertion trong lượt đó đạt; không đổi failure lịch sử thành pass.
- `focusActionAccepted`/`clickActionAccepted` là phản hồi của Android API. `focusedBeforeActivation` kiểm tra trạng thái focus thực sau khoảng chờ giới hạn. Không đồng nhất request được chấp nhận với người dùng nghe/điều khiển được hoàn toàn.
- `*-nodes.json` ghi text/description/hint, selected/checkable/checked/enabled và liveRegion từ Android. Không suy nhãn ô tìm kiếm thiếu chỉ vì bỏ qua getHintText.
- Validation form phải có live region, không tạo lịch. Timer được bắt đầu/tạm dừng/bỏ phiên, không ghi completion. PDF chỉ tạo trên thiết bị; cloud upload vẫn khóa.
- Sau lỗi, kiểm tra settings đã khôi phục; nếu bị dừng cứng ngoài finally thì tắt TalkBack thủ công và mở lại Power9. Trước chạy phải ghi lại service cũ, không xóa cấu hình trợ năng của người dùng khác.
- Bằng chứng thực tế ngày03/11 ở `evidence/accessibility/2026-11-03`; đọc kèm `docs/lab3-verification-2026-11-03.md`. Người dùng đã chọn kiểm tra tự động trước; phần nghe/vuốt vẫn cần một lượt thủ công sau.
