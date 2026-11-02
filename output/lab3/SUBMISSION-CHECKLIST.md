# Chốt Lab 3 trước khi nộp

Không đánh dấu toàn bộ bài đạt khi thiếu bằng chứng bên dưới. Bản ZIP hiện tại là snapshot trung thực, chưa phải xác nhận đạt 100% rubric.

## Ưu tiên 1: ba fix commits và PR review

**Đã thực hiện theo yêu cầu mới:** R01 ac4b35b, R02 38b52bc, R03 e595956; draft PR #3 https://github.com/PhamQuangDuc1/PRM.POWER9/pull/3 có năm findings/dispositions trong body. Không tạo lại các commits này. PR chưa merge; chưa có human approval. Đoạn hướng dẫn bên dưới là kế hoạch trước khi người dùng chuyển quyền Git cho trợ lý.

Người dùng tiếp tục chọn tự commit/push. Thực hiện ba cặp source/test theo `docs/lab3-commit-and-pr-guide.md`; xem diff trước từng commit để không lẫn thay đổi khác. Sau đó commit phần telemetry/test/tài liệu/evidence còn lại, push nhánh OneD và tạo PR tới nhánh nhóm chọn. Đính kèm năm findings từ `ai/code-review/lab3-review.md`, quyết định xử lý và ba SHA thực tế trên PR. Chỉ thêm URL/SHA sau khi chúng tồn tại. Không push APK/MP4/ZIP lớn; đã có ignore.

## Ưu tiên 2: video thật 5–10 phút

**Được người dùng chủ động để cuối**, sau khi chốt hướng nâng cấp UI/UX; không quay video cuối trên giao diện sắp thay đổi.

Đã có footage app E2E 6 phút 02 giây nhưng chưa có lời thuyết minh/Console. Quay theo `DEMO-RUNBOOK.md`: app, dữ liệu đúng ngày, FCM, Analytics, Crashlytics và Remote Config. Có thể dùng footage cũ nếu nói rõ ngày quay và không giả là lần thao tác hiện tại. Không quay mật khẩu, API key, token, UID hoặc tài khoản riêng. Tải video lên, lấy URL thật và kiểm tra quyền xem bằng tài khoản khác. Chỉ có file footage không đáp ứng đủ tiêu chí này.

## Ưu tiên 3: đóng ARTEMIS bằng kết quả thật

30/33 run ID xác minh; thiếu TC10[3], TC16[2], TC16[3] và Pro chủ động đủ thời lượng. Người dùng đã đồng ý tổng 50 lượt, nhưng automatic approval review vẫn chặn việc thay lệnh dừng 45 cũ. Chưa có model task mới. Không chạy đường vòng, đổi key/model/billing hoặc tính smoke cục bộ thành ARTEMIS. Nếu được gỡ chặn thì giữ used=45, cùng key/model, kiểm tra billing trước từng task và dừng ngay khi daily quota mới xuất hiện. Ngày 02/11 Home không có lịch: phải chuẩn bị đúng tiền điều kiện hôm nay trước TC10. Không dùng ảnh lịch 01/11 làm bằng chứng mới.

## Storage và các mục còn giới hạn

Cloud Storage for Firebase yêu cầu Blaze; dự án đang giữ billing tắt. Có mã uploader/Rules và emulator tests, chưa có upload production. Cần giảng viên chấp nhận phương án hiện tại hoặc một quyết định mới của chủ dự án; không tự thay Storage bằng PDF local/dịch vụ khác. Nguồn chính thức: https://firebase.google.com/docs/storage/faqs-storage-changes-announced-sept-2024 .

Fidelity Figma, TalkBack, Auth mất mạng/chuyển hai tài khoản vẫn chưa được kiểm chứng đầy đủ. Ngày 02/11 đã có smoke logout/Back/hủy login/retry và lỗi quyền thông báo trên Xperia, cùng kiểm tra tự động nhãn/vùng chạm ở 360/412 dp. Không diễn giải các kết quả đó thành toàn bộ accessibility hoặc error coverage đã đạt.

## Kiểm tra lần cuối

- Đúng tên/MSSV/nhóm và đề Lab 3 Cloud-Enabled của lớp.
- Repository có các commit mới; PR có review và SHA ba fixes.
- Báo cáo 10 trang, slide 15 trang, APK arm64, bằng chứng và manifest mở được.
- Link repo/Figma/video xem được từ tài khoản khác; ZIP/APK tải được qua kênh nộp của lớp.
- Đọc đúng pass/fail/audit; khai báo các mục chưa đạt, không ghi 100% khi còn thiếu.
