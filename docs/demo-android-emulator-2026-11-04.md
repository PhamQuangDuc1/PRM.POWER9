# Demo Power9 trên Android Emulator — 8–10 phút

Kịch bản trình bày trực tiếp trên máy tính, thay thiết bị Xperia. Chuẩn bị ngày 04/11/2026. Các bước dưới đây là kế hoạch demo, chưa phải kết quả chạy trên máy ảo. Bằng chứng kiểm thử Xperia giữ nguyên nguồn thiết bị.

## Chuẩn bị trước buổi trình bày

- Mở Android Studio → Device Manager → chạy **Small_Phone**. AVD hiện có Google Play, kiến trúc x86_64. Đợi màn hình Android và mạng hoạt động. Không cập nhật SDK/AVD sát giờ demo.
- Build APK x86_64 bằng cùng mã nguồn hiện hành, rồi cài vào đúng emulator. APK đang bàn giao có target ARM64 cho Xperia; không dùng nó làm bản cài mặc định cho AVD x86_64. Có helper `scripts/lab3/prepare_emulator_demo.ps1` để build/cài sau khi đã bật AVD; helper không đăng nhập thay người dùng.
- Đăng nhập tài khoản Google kiểm thử trên emulator, mở Power9 và xác nhận vào Hôm nay. Tài khoản A dùng cùng Firebase thật sẽ thấy dữ liệu của A; dữ liệu không tự trở thành dữ liệu mới chỉ vì đổi thiết bị. Không chuyển token hoặc sao chép dữ liệu ứng dụng từ Xperia.
- Dùng tài khoản kiểm thử riêng cho buổi demo nếu có. Kiểm tra trước lịch Đi bộ giữa giờ và phiên Thư giãn của ngày đang chọn; không sửa/xóa dữ liệu có từ trước. Nếu trùng fixture kiểm thử cũ, chuẩn bị hoạt động/ngày khác trước buổi diễn tập.
- Chạy thử một lượt: đăng nhập, tạo/sửa/hủy lịch, check-in/undo, timer, PDF và mở lại app. Kiểm tra riêng quyền thông báo và Google Play services của AVD. Không suy rằng mọi quyền trên máy ảo giống Android 11 của Xperia.
- Mở sẵn: app, slide, Firebase Console đúng project **Power9 Office Routine**, ảnh DebugView đã che thông tin riêng và video dự phòng. Sắp cửa sổ app bên trái, Console bên phải; phóng chữ đủ đọc.
- Console mở sẵn Firestore → activities → move-walk; Crashlytics; Remote Config; Messaging. Chỉ trình bày dữ liệu chung hoặc dữ liệu thử đã xác định. Che email, UID, token và trình chọn tài khoản khi chia sẻ màn hình.
- Giữ Spark, billing tắt và `report_upload_enabled=false`. Không gửi FCM, gây crash, Publish Remote Config hoặc nâng gói trong buổi demo mặc định.

Sau khi bật AVD, chạy `adb devices` để lấy ID dạng `emulator-5554` (dùng ID thực tế), rồi chạy từ thư mục dự án:

```powershell
./scripts/lab3/prepare_emulator_demo.ps1 -DeviceId emulator-5554
```

Helper xuất bản cài riêng `output/lab3/Power9-Lab3-emulator-x64-debug.apk`, giữ nguyên APK Xperia trong gói bàn giao. Không truyền serial Xperia vào helper này.

## Kịch bản thao tác và lời nói

| Thời gian | Thao tác trực tiếp | Lời trình bày gợi ý / điểm cần thấy |
| --- | --- | --- |
| 00:00–00:35 | Slide mở đầu → emulator đã đăng nhập, Hôm nay | “Đây là Power9 Office Routine, hỗ trợ hoạt động ngắn trong ngày làm việc. Ứng dụng dùng Flutter, MVVM và Firebase. Hôm nay em demo trên Android Emulator; bộ bằng chứng kiểm thử thiết bị thật được thực hiện riêng trên Xperia.” |
| 00:35–01:30 | Hôm nay → Khám phá; tìm chuỗi không khớp → xóa; thử bộ lọc ≤5 phút, sau đó bỏ lọc nếu Đi bộ không nằm trong kết quả → Đi bộ giữa giờ | “Danh mục lấy từ Firestore. Tìm kiếm và bộ lọc giúp chọn hoạt động phù hợp; trạng thái rỗng có đường quay về danh sách.” Đọc hướng dẫn và thời lượng gợi ý, không gọi đó là thời lượng đã thực hiện. |
| 01:30–02:25 | Chọn lịch → chọn ngày demo → bật Nhắc hoạt động → Lưu khi chưa có giờ → thấy lỗi; tắt nhắc rồi Lưu → về Hôm nay | “Form kiểm tra thiếu giờ trước khi lưu. Sau khi lưu thành công, lịch xuất hiện đúng ngày. Một hoạt động có tối đa một lịch trong một ngày. Giờ nhắc hiện được lưu trong lịch; app chưa tự phát thông báo theo giờ này.” |
| 02:25–03:30 | Mở lịch → Đổi lịch → chọn 11:00 → Hủy → kiểm tra giờ cũ; mở lại → đổi 11:00 → Lưu → kiểm tra giờ và tổng số lịch | “Hủy không ghi thay đổi; Lưu cập nhật lịch hiện có. Tổng số lịch không tăng.” Trong picker ưu tiên chế độ nhập văn bản, kiểm tra cả giờ/phút trước OK. Đây là demo tính năng, không thay run ARTEMIS TC10[3]. |
| 03:30–04:10 | Hôm nay → Đã thực hiện → thấy tiến độ tăng → Hoàn tác → lịch vẫn còn | “Lịch là kế hoạch; completion là bản ghi đã làm. Hoàn tác completion không xóa lịch. Check-in không đo thời gian nên không tự gán số phút gợi ý làm thời lượng thực.” |
| 04:10–05:10 | Thư giãn → Bắt đầu 3 phút → đợi vài giây → Tạm dừng → Hôm nay → Ở lại → Tiếp tục → Kết thúc sớm → Ghi nhận phiên | “Timer dùng thời gian thực; tạm dừng không cộng thời gian chờ. Dialog tránh mất phiên khi chuyển tab. Em kết thúc sớm để demo và chỉ ghi nhận số giây thực đã chạy.” Không chỉnh đồng hồ hoặc tua timer. |
| 05:10–05:55 | Trở lại lịch Đi bộ → ghi nhận → mở chi tiết → Xóa lịch hoạt động → Giữ lịch; mở lại → Xóa lịch → Tiến độ | “Giữ lịch hủy thao tác xóa. Khi xác nhận xóa, kế hoạch biến mất nhưng lịch sử đã thực hiện vẫn còn.” Chỉ xác nhận trên lịch vừa tạo trong demo. |
| 05:55–06:40 | Tiến độ đúng ngày → Xuất báo cáo PDF → Tạo PDF → Xem / lưu PDF | “PDF là ảnh chụp dữ liệu tại thời điểm tạo, gồm ngày, hoạt động và thời lượng thực nếu có. Khi dữ liệu đổi cần tạo lại. Cloud upload đang tắt vì dự án giữ Spark; PDF local chưa chứng minh upload Storage production.” Đối chiếu ít nhất một hoạt động và số giây timer. |
| 06:40–07:45 | Console: Firestore move-walk → DebugView → mở view_activity, Parameters, activity_id | “Firestore lưu danh mục và dữ liệu theo tài khoản. Với Analytics, em đối chiếu tên event và tham số trên server, không chỉ dựa vào log thiết bị.” Cần thấy `view_activity`, `activity_id=move-walk`. Nếu phiên live chưa nhận, mở ảnh bằng chứng ngày 04/11 đã che thông tin riêng và nói rõ đó là lượt đã kiểm chứng trước. |
| 07:45–08:25 | Console: Crashlytics → Remote Config → Messaging | “Đây là issue và bằng chứng thông báo của các lượt trước. Remote Config hiện giữ upload=false. Em không coi việc mở Console là bằng chứng vừa gây crash hoặc vừa gửi thông báo thành công.” Chỉ giải thích chức năng và bằng chứng đã có. |
| 08:25–09:15 | Slide kết quả và giới hạn | “Bản UI có tám ảnh minh họa; 49 Flutter tests đạt và analyzer sạch ở bản đã kiểm chứng. Đổi hai tài khoản A–B–A và checklist TalkBack đã được kiểm tra trên Xperia. ARTEMIS xác minh 32/33 run ID; TC10[3] chưa đạt, Pro chưa đủ thời lượng. Storage production chưa triển khai theo quyết định giữ gói miễn phí.” |
| 09:15–09:30 | Quay về Hôm nay, kết thúc | “Phần demo cho thấy luồng từ chọn hoạt động, lập lịch, ghi nhận đến xuất báo cáo. Các kết quả và giới hạn đều có bằng chứng riêng trong hồ sơ.” |

## Nhánh mở rộng khi giảng viên hỏi

- **Đăng nhập:** nếu đã diễn tập thành công trên AVD, đăng xuất → cho thấy Login → đăng nhập Google → về Hôm nay. Người dùng tự chọn tài khoản. Không mở màn này giữa luồng timer hoặc khi đang có form chưa lưu. Tính thêm khoảng một phút.
- **TalkBack:** trình bày kết quả nghe/vuốt thủ công trên Xperia với phạm vi cụ thể. Muốn biểu diễn trên AVD phải thử trước bằng TalkBack của AVD; không coi bằng chứng Xperia là xác nhận máy ảo.
- **Hai tài khoản:** mở audit A–B–A đã có. Chỉ demo đổi thật nếu cả hai tài khoản kiểm thử đã sẵn sàng trên AVD và biết baseline dữ liệu; không cần tạo tài khoản mới giữa buổi.
- **Mất mạng:** chỉ biểu diễn sau khi đã diễn tập và còn thời gian. Chỉ thử trên dữ liệu demo, phục hồi mạng và kiểm tra kết quả; dữ liệu cache hiển thị được không chứng minh server đã lưu.
- **FCM:** nếu yêu cầu gửi thật, dùng token của emulator được lấy riêng, không dùng token Xperia. Kiểm tra quyền và nhận thông báo trước buổi demo. Kịch bản mặc định dùng bằng chứng lịch sử.

## Nếu gặp trục trặc

| Tình huống | Cách xử lý khi đang trình bày |
| --- | --- |
| Google login chưa vào được | Không chỉnh cấu hình Firebase ngẫu nhiên tại chỗ. Dùng video dự phòng, nói rõ cảnh đã quay trên Xperia; sau buổi kiểm tra lỗi đăng nhập AVD. |
| Có lịch/completion từ trước | Chọn dữ liệu thử đã chuẩn bị hoặc bỏ nhánh ghi mới; không xóa dữ liệu cũ để làm demo đạt. |
| DebugView live đang chờ | Mở `evidence/analytics/2026-11-04/debugview-view-activity-params.png`; chỉ rõ event/param và ngày của bằng chứng. |
| PDF chưa có print service | Giữ màn báo cáo, dùng bằng chứng PDF/video đã có và giải thích sự cố trên AVD. Không tuyên bố đã mở thành công trên emulator. |
| Emulator chậm hoặc treo | Chuyển sang `output/lab3/Power9_Lab3_Demo_Final.mp4`, nói rõ đây là video ghi trên Xperia. Video cũ có trạng thái DebugView chờ; dùng ảnh mới để bổ sung kết quả server sau đó. |

## Sau demo

Chỉ dọn lịch/completion do chính lượt demo tạo, bảo toàn dữ liệu có trước. Nếu bật Analytics debug riêng cho emulator, khôi phục giá trị ban đầu. Không thay token thiết bị mặc định của các script Xperia bằng token máy ảo. Kết quả ARTEMIS đang giữ trần 50/50; kịch bản này không cho phép gọi thêm model hoặc chạy lại tests có ghi dữ liệu.
