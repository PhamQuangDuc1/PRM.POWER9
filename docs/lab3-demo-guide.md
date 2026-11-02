# Hướng dẫn sử dụng và demo Power9 — Lab 3

Bản hướng dẫn ngày 03/11/2026, cho APK trong `output/lab3`. Đây là kịch bản thao tác, không phải chứng nhận mọi tiêu chí đã đạt. Không cần đồng bộ Figma; video để sau theo yêu cầu người dùng.

## Chuẩn bị

1. Cài `Power9-Lab3-debug-arm64.apk` trên máy Android arm64. Mở mạng và đăng nhập bằng tài khoản Google kiểm thử. Người dùng tự chọn tài khoản, không quay lúc nhập mật khẩu.
2. Chọn ngày kiểm thử trên Tiến độ; xem dữ liệu có sẵn trước khi thao tác. Chỉ xóa lịch/completion vừa tạo trong buổi demo. Không dùng nút xóa để reset dữ liệu thật.
3. Kiểm tra ngày trên máy, quyền thông báo và mức pin. Lịch theo ngày; dữ liệu hôm qua không tự chuyển sang hôm nay.
4. Nếu demo Firebase Console, mở sẵn đúng project/app; tránh lộ email, UID, FID, token và khóa API. Console do người có quyền đăng nhập.
5. `report_upload_enabled` hiện tắt: demo PDF trên máy được; không nói đã upload production. Không bật billing trong buổi demo.

## Đường đi nhanh trong app

| Nơi bắt đầu | Dùng để làm gì |
| --- | --- |
| Hôm nay | Xem lịch ngày hiện tại, mở chi tiết, check-in/hoàn tác, Khám phá và Tiến độ |
| Khám phá hoạt động | Tìm/lọc danh mục, đọc hướng dẫn, chọn hoạt động và đặt lịch |
| Ăn uống | Đọc hoạt động bữa trưa, ghi nhận và mở Tiến độ |
| Thư giãn | Phiên có timer thực, tạm dừng/tiếp tục/kết thúc/ghi nhận |
| Kết nối | Hoạt động đi bộ/trò chuyện, chi tiết và check-in theo cấu hình |
| Tiến độ | Chọn ngày, xem đã làm/chưa làm, mở lịch chưa hoàn thành để sửa/xóa; xuất PDF |
| Biểu tượng chuông | Quyền/kết nối thông báo và inbox theo tài khoản |
| Biểu tượng Tài khoản | Xem phiên, đăng xuất; bản debug có Kiểm thử Firebase |

## F01 — Khám phá và tạo lịch

1. Hôm nay → **Khám phá hoạt động**. Nhập một chuỗi không khớp để minh họa trạng thái rỗng; xóa từ khóa/reset bộ lọc để thấy danh sách lại.
2. Chọn **Đi bộ giữa giờ** → đọc mục đích và cách thực hiện → **Chọn lịch hoạt động**.
3. Bật **Nhắc hoạt động**, chưa chọn giờ rồi bấm **Lưu lịch**. App phải báo thiếu giờ và giữ form; chưa coi đây là lịch đã lưu.
4. Chọn giờ hợp lệ hoặc tắt Nhắc hoạt động; kiểm tra ngày rồi **Lưu lịch**. Chờ xác nhận, trở về nguồn và kiểm tra lịch mới trên Hôm nay hoặc Tiến độ đúng ngày.
5. Trên Firestore Console, đối chiếu đúng tài khoản kiểm thử: một schedule cho hoạt động/ngày, có ngày, giờ tùy chọn và trạng thái nhắc.

Câu trình bày: “Danh mục lấy từ Firestore. ViewModel kiểm tra form; chỉ báo thành công sau khi backend xác nhận. Một hoạt động có tối đa một lịch cho một ngày.”

Lưu ý: giờ/nhắc hiện là lựa chọn lưu trong lịch; không hứa app đã có bộ lập lịch thông báo cục bộ tự động theo giờ. FCM là luồng riêng.

## F03 — Sửa, hủy và xóa lịch (CRUD)

1. Hôm nay → chạm lịch vừa tạo → **Đổi lịch**. Đổi giờ rồi **Hủy**: giờ cũ vẫn giữ.
2. Mở lại **Đổi lịch**, chọn giờ mới và **Lưu lịch**: giờ cập nhật, số lịch không tăng; document ID/createdAt giữ nguyên.
3. Với lịch tương lai, vào **Tiến độ**, chọn đúng ngày rồi mở mục chưa hoàn thành để sửa/xóa. Ngày của lịch đang sửa bị khóa; muốn chuyển ngày thì tạo lịch mới và xóa lịch cũ sau khi kiểm tra.
4. Từ chi tiết lịch, chọn **Xóa lịch hoạt động** → **Giữ lịch** để minh họa hủy; lịch không đổi.
5. Khi sẵn sàng dọn dữ liệu thử, mở lại và xác nhận **Xóa lịch**. Lịch biến mất sau xác nhận backend.

Điểm cần phân biệt: **xóa lịch không xóa lịch sử hoàn thành**. Có thể demo rõ bằng cách check-in lịch thử trước khi xóa; lịch biến mất nhưng bản ghi vẫn hiện ở Tiến độ/ngoài lịch. Sau cùng chỉ hoàn tác completion vừa thử.

## F02a — Check-in và hoàn tác

1. Tạo một lịch kiểm thử chưa có completion. Trên Hôm nay bấm **Đã thực hiện**.
2. Kiểm tra tiến độ tăng; vào Tiến độ thấy hoạt động đã ghi nhận.
3. Bấm **Hoàn tác**: bản ghi hoàn thành mất, lịch vẫn còn.
4. Nếu dùng **Xóa bản ghi**, thử **Giữ lại** trước, rồi xác nhận **Xóa** chỉ với bản ghi thử.

Câu trình bày: “Schedule là việc đã chọn; completion là việc đã làm. Check-in không đo thời gian nên durationSeconds là null, không tự gán số phút của danh mục.”

## F02b — Timer thư giãn

1. Tab **Thư giãn** → **Bắt đầu … phút**. Đợi thực tế vài giây → **Tạm dừng**. Đợi thêm để thấy thời gian không giảm khi paused.
2. Chọn tab khác → dialog **Rời phiên thư giãn?** → **Ở lại**: phiên vẫn giữ.
3. **Tiếp tục**; có thể chuyển app ra nền rồi quay lại để kiểm tra thời gian tiếp tục theo đồng hồ thực.
4. **Kết thúc sớm** → xem số giây thực tế → **Ghi nhận phiên**. Tiến độ phải hiện duration thực; không cần giả chạy đủ ba phút để demo nhanh.
5. Nhánh hủy: bắt đầu phiên kiểm thử khác khi chưa có completion, rời tab → **Bỏ phiên**; không tạo completion.

Nếu đã ghi nhận hoạt động hôm nay, app đưa sang xem tiến độ thay vì ghi trùng. Muốn thử lại, chỉ hoàn tác bản ghi do demo vừa tạo. Với demo phiên đầy đủ, phải đợi đủ thời lượng thật.

## Các nhánh màn hình bổ sung

- **Ăn uống:** đọc hướng dẫn → ghi nhận bữa trưa → xem Tiến độ → hoàn tác dữ liệu thử.
- **Góc làm việc:** Khám phá → hoạt động checklist/Góc làm việc → thử ghi khi chưa chọn đủ; chọn đủ các mục rồi ghi nhận một completion. Nếu lưu lỗi, lựa chọn phải còn để thử lại.
- **Ngủ & phục hồi:** Khám phá → hoạt động nghỉ tối → mở form lịch; **Hủy/Back** về đúng nguồn. Lưu lịch chỉ thể hiện kế hoạch, không suy ra người dùng đã ngủ hay tạo chỉ số sức khỏe.
- **Kết nối:** mở hoạt động đi bộ/trò chuyện, đọc hướng dẫn, đặt lịch hoặc check-in khi được cấu hình cho phép.

## Lỗi mạng và phục hồi

Chỉ thử trên tài khoản và bản ghi demo. Tắt mạng trước khi lưu/ghi nhận, quan sát trạng thái lỗi và draft/lựa chọn được giữ; bật lại mạng rồi thử lại. Đối chiếu backend để xác nhận không nhân đôi dữ liệu. Không đánh dấu đạt chỉ vì app không văng; cũng không coi một thao tác offline dùng cache thành kiểm chứng backend thành công.

## PDF

**Tiến độ → chọn ngày → biểu tượng Xuất báo cáo PDF → Tạo PDF → Xem / lưu PDF**. Android mở print preview; có thể chọn Lưu dưới dạng PDF. Đối chiếu ngày, số hoạt động, giờ và duration với app. Sau khi sửa dữ liệu, dùng **Tạo lại PDF** vì PDF là snapshot tại thời điểm tạo.

**Chia sẻ PDF** mở share sheet; người dùng tự chọn nơi gửi. Cloud upload hiện chưa kích hoạt, không dùng PDF local để minh họa upload Storage.

## Auth và dữ liệu riêng

**Tài khoản → Đăng xuất** phải về Login. Bấm Back/mở lại không được lộ màn riêng tư. Hủy bộ chọn Google phải giữ Login và cho thử lại. Thử mất mạng phải có lỗi phù hợp, khôi phục mạng rồi đăng nhập lại.

Để demo cách ly tài khoản, cần hai tài khoản kiểm thử: tạo dấu nhận biết riêng ở A, logout → đăng nhập B, kiểm tra lịch/tiến độ/inbox không lẫn A; logout B → về A, dấu nhận biết vẫn đúng. Không yêu cầu hai tài khoản đều rỗng; không chụp email/picker công khai. Đây là kịch bản cần kiểm chứng riêng, không suy ra từ unit tests.

## Firebase và Analytics

1. Analytics: bật debug cho đúng package bằng ADB theo tài liệu kiểm chứng, mở DebugView đúng thiết bị/app. Thao tác thật: xem chi tiết, tìm kiếm, tạo/sửa/xóa lịch, check-in/undo, tạo PDF, đăng nhập/logout. Mở event và params; log SDK có marker chỉ chứng minh SDK xử lý, không thay ảnh server DebugView. Tắt debug sau demo.
2. Remote Config: **Tài khoản → Kiểm thử Firebase → Tải cấu hình mới**. Nếu minh họa thay đổi trên Console, dùng hai tham số đã có, quan sát hành vi không rebuild rồi trả về giá trị ban đầu. Không thay quyền bảo mật hoặc bật upload để giả Storage.
3. Crashlytics: trình bày fatal/nonfatal đã có trên Console. Nếu cần tạo crash mới, làm sau các luồng chính, xác nhận nút debug và mở lại app để gửi báo cáo; không bấm giữa demo CRUD/timer.
4. FCM: người có quyền gửi test message tới đúng thiết bị; quan sát thông báo và chạm mở app/inbox. Foreground/background/terminated là ba trạng thái riêng; không đồng nhất Force stop với terminated. Dữ liệu gửi thử chỉ là nội dung chung.

## TalkBack

Bật TalkBack trong trợ năng Android. Chạm một lần để chọn, chạm hai lần để kích hoạt, vuốt trái/phải để chuyển mục, cuộn bằng hai ngón. Kiểm tra Login, bốn tab, tìm kiếm, form lịch/lỗi, dialog hủy/xóa, timer và Tiến độ/PDF. Cần nghe nhãn/trạng thái rõ, focus không kẹt và quay về hợp lý khi đóng dialog. Chỉ thử xác nhận xóa với dữ liệu demo. Tắt lại nếu trước đó máy không dùng TalkBack.

## Kịch bản trình bày gọn 8–10 phút

| Thứ tự | Nội dung | Điều cần chứng minh |
| --- | --- | --- |
| 1 | Login và Hôm nay | Phiên thật, bốn tab, dữ liệu đúng ngày |
| 2 | Khám phá → validation → tạo lịch | Dữ liệu Firestore, form giữ trạng thái, tạo một lịch |
| 3 | Sửa giờ/Hủy/Lưu | Hủy không ghi; cập nhật không nhân đôi |
| 4 | Check-in → Undo; timer pause/resume/end | Completion độc lập; thời gian đo thực |
| 5 | Xóa lịch: Giữ lịch rồi xác nhận | Có xác nhận; giữ lịch sử; dọn đúng dữ liệu thử |
| 6 | Tiến độ → PDF | PDF thật, ngày/duration khớp; cloud upload chưa bật |
| 7 | Firebase Console | Event/params, Crashlytics và Remote Config; FCM nếu chuẩn bị sẵn |
| 8 | Logout/Back và kết luận phạm vi | Private route đóng; báo đúng các tiêu chí còn thiếu |

Nếu trình bày đầy đủ checklist, bổ sung các nhánh Góc làm việc, Ngủ & phục hồi, lỗi mạng, hai tài khoản và TalkBack sau lượt demo gọn. Không ép tất cả bằng chứng vào một video ngắn bằng cách bỏ qua tiền điều kiện.

## Kết thúc buổi demo

- Hoàn tác/xóa đúng dữ liệu vừa tạo; giữ dữ liệu có trước. Trả mạng, quyền, cấu hình và TalkBack về trạng thái ban đầu.
- Đăng nhập lại tài khoản kiểm thử ban đầu; trả app về Hôm nay.
- Nêu rõ Storage production và ARTEMIS/Pro theo trạng thái bằng chứng hiện hành. Không dùng phần demo native này để cộng thêm run ARTEMIS.
- Mã và review: https://github.com/PhamQuangDuc1/PRM.POWER9/pull/3 .
