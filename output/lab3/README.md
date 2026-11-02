# Gói Lab 3 Power9 Office Routine

Cập nhật 02/11/2026. Đây là snapshot mã, bản cài và bằng chứng thật; các tiêu chí còn thiếu được khai báo riêng.

## Bản trình bày hiện hành

- **Power9_Lab3_Designer.pptx**: deck 15 slide để thuyết trình và chỉnh sửa; thay bố cục cũ.
- **Power9_Lab3_Slides.pdf**: bản đọc xuất trực tiếp từ PowerPoint.
- **Power9_Lab3_Designer_preview.png**: ảnh bìa từ PowerPoint.
- **designer-slide-notes.json** và **slide-content.json**: nội dung/nguồn/giới hạn theo từng slide.
- **Power9_Lab3_Report.pdf**: báo cáo 10 trang đã cập nhật PR và ba fix commits.

Deck giữ logo gốc và ảnh app thật, có notes và nguồn theo slide; bảng, biểu đồ ARTEMIS và sơ đồ kiến trúc chỉnh sửa được. Ảnh giữ ngày ghi trong notes, chưa phải bản nâng cấp UI/UX tương lai. Đã mở deck và xem đủ 15 slide xuất từ PowerPoint. Chi tiết tái tạo ở docs/lab3-presentation-design.md.

## Git và review

[Draft PR #3](https://github.com/PhamQuangDuc1/PRM.POWER9/pull/3), nhánh codex/lab3-review-and-slides vào main. Theo yêu cầu mới, trợ lý đã tự commit/push và tạo PR; không merge.

- R01 ac4b35b: date payload sai kiểu fallback an toàn.
- R02 38b52bc: bỏ kết quả inbox refresh đến muộn.
- R03 e595956: khôi phục messaging khi sign-out lỗi và phiên còn nguyên.
- f45500f: runner/E2E evidence, Analytics debug marker và kiểm tra responsive/trợ năng.

Năm findings/dispositions có trong PR body và ai/code-review/lab3-review.md. Không giả định human approval hoặc merge.

## Kết quả kiểm chứng

43/43 Flutter tests đạt, analyzer sạch, APK debug arm64 cuối đã build/cài. Hai tests render 14 widget màn ở 360/412 dp, chữ 1,5× và kiểm tra nhãn/vùng chạm Android; không thay TalkBack hoặc fidelity Figma. 18 Rules tests là mốc trước, không phải chạy lại ngày 02/11.

ARTEMIS có 11 ca ×3 run ID; 30/33 xác minh =29 pytest pass hợp lệ +1 delayed-terminal audit. Giữ 59 attempts, gồm failures. TC10[3] và TC16[2–3] chưa đạt. Pro cũ bị quota, 0 bước UI; 926,82 giây chờ không tính là khám phá. Người dùng cho phép tổng 50 lượt nhưng auto-review chặn resume theo lệnh dừng cũ; chưa có model task mới. Không đổi key/model hoặc billing.

Native smoke ngày 02/11 xác minh quyền thông báo Android 11 bị tắt → lỗi/retry → khôi phục; logout/Back/hủy Google picker/retry và người dùng đăng nhập lại. Không xuất tài khoản/picker, không tính các smoke này thành ARTEMIS.

## APK, video và bằng chứng

Power9-Lab3-debug-arm64.apk là bản cài arm64, có marker tổng hợp debug để lọc đúng SDK log, không có model API key. Build config ghi ở build-config.json. APK/MP4/ZIP lớn được ignore, không push vào Git.

Power9_Lab3_E2E_Footage.mp4 dài 6 phút 02 giây, không audio/Console, chỉ là footage bổ sung. Quay trước khi bổ sung Analytics marker; footage-metadata.json ghi SHA APK ở thời điểm quay. **Video cuối được người dùng chủ động để sau khi chốt hướng UI/UX.** Kịch bản ở DEMO-RUNBOOK.md; chưa có URL video đã công bố.

Mở evidence/artemis/replay/index.html sau giải nén: viewer offline 33 runs/257 ảnh gốc đã lọc. Raw prompt/UI dump/SQLite/model credential không có trong gói. manifest.json chứa SHA256 các tệp. Chi tiết ở docs/lab3-e2e-results.md.

## Còn thiếu trước khi tuyên bố 100%

Ba run ID ARTEMIS, Pro chủ động đủ thời lượng, upload Storage production, video app/Console có thuyết minh, TalkBack/fidelity và một số Auth error coverage. Storage vẫn khóa report_upload_enabled=false theo lựa chọn billing-off; PDF local/emulator không thay upload thật. Không tự đổi dịch vụ hoặc bật billing.

Repository: https://github.com/PhamQuangDuc1/PRM.POWER9

Figma: https://www.figma.com/design/MTv5qJbn065VYJQIXausoq
