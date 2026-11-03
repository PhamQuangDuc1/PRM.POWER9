# Gói Lab 3 Power9 — 04/11/2026

Video và slide đã hoàn thiện theo bằng chứng hiện có, giữ Spark và billing tắt. Các tiêu chí kiểm thử còn thiếu được nêu riêng, không ghi toàn bộ Lab 3 đạt 100%.

## File dùng để nộp hoặc xem lại

- [Video cuối](Power9_Lab3_Demo_Final.mp4): 6 phút 35 giây, 1920×1080, H.264/AAC, giọng nữ Hoài My tổng hợp.
- [Phụ đề tiếng Việt](Power9_Lab3_Demo_Final.srt): 64 mục; để cạnh video với cùng tên để trình phát tự nhận.
- [Slide PowerPoint](Power9_Lab3_Designer.pptx) và [PDF slide](Power9_Lab3_Slides.pdf): 15 trang, đã mở/xuất bằng PowerPoint. Bản định danh mới là Power9_Lab3_Final_Video_20261104.pptx/PDF, cùng nội dung với các tên chính.
- [APK hiện hành](Power9-Lab3-debug-arm64.apk): UI mới có 8 ảnh minh họa. Hash APK và metadata tại build-config.json.
- [Timeline và lời đọc](../../docs/video-script-spark-2026-11-04.md).
- [Metadata video](video-20261104/video-manifest.json) và [kết quả kiểm tra](../../evidence/video/2026-11-04/final-review.json).

Video có Login thật và Home sau khi người dùng tự chọn lại tài khoản A. Màn chọn Google không ghi hình. Các luồng app chạy thật trên Xperia, giữ tốc độ thực, có cắt nối được ghi rõ. Console gồm Firestore, DebugView, Crashlytics, Remote Config và Messaging. Đã cắt Chrome tab/address/profile, avatar Firebase và che tên người xuất bản cấu hình.

Đã giải mã toàn bộ hình/tiếng, kiểm tra thời lượng, âm lượng và rà 18 khung hình theo các cảnh. Chưa có lượt người thật nghe/xem trọn bản cuối. Dữ liệu demo đã dọn qua app và đối chiếu server; Analytics debug khôi phục, máy về Home A.

## Kết quả và giới hạn

- 49 Flutter tests đạt, analyzer sạch. Responsive 15 màn ở 360/412 dp với chữ 1,5 lần. Hai tài khoản A sang B rồi về A đã đối chiếu lịch, lịch sử và inbox.
- TalkBack sau “Ở lại” đã có người dùng nghe/vuốt/kích hoạt xác nhận. Ba phần kiểm tra thủ công bổ sung đã được người dùng xác nhận đạt; phạm vi ở evidence/accessibility/2026-11-04-manual-flows/result.json. Snapshot tự động lịch sử giữ nguyên.
- ARTEMIS 32/33 run ID, TC10[3] còn failed. Native demo sửa giờ 11:00 trong video không thay lượt ARTEMIS này. Pro mới nhất 189,02 giây, chưa đạt thời lượng. Budget đã dùng 50/50, không tự gọi thêm lượt.
- DebugView server đã nhận view_activity/activity_id=move-walk ở bằng chứng bổ sung 04/11 trong evidence/analytics/2026-11-04. DebugView trong buổi quay trước đó có Debug Device=0, chưa nhận event. Log SDK là bằng chứng riêng, không thay xác nhận server. Crashlytics hiển thị issue test crash cũ 31/10, Messaging hiển thị chiến dịch 01/11; không gửi FCM hoặc gây crash mới trong buổi quay.
- Storage production bỏ khỏi phạm vi theo quyết định chi phí. Giữ billing tắt và report_upload_enabled=false; PDF local không được tính là upload production.
- Power9_Lab3_Report.pdf là báo cáo mốc trước, chưa đồng bộ số liệu mới. Footage cũ Power9_Lab3_E2E_Footage.mp4 và các bản Final_Spark/UI_Update là tư liệu lịch sử.

Các bảng và biểu đồ slide vẫn chỉnh sửa được. Đợt cập nhật mới chỉ thay hình slide 8, 12, 15; 12 slide khác giống từng pixel với bản trước. Notes và nguồn được đồng bộ. Raw footage, định danh và các lượt công cụ lỗi giữ trong .build, không đưa vào gói công khai.

Nhánh bàn giao là OneD; [PR #4 OneD → main](https://github.com/PhamQuangDuc1/PRM.POWER9/pull/4) là PR hiện hành. PR #3 đã đóng và nhánh cũ đã xóa sau khi bảo toàn toàn bộ commit và kiểm tra bundle dự phòng. Không merge vào main. APK/video và narration giữ cục bộ, không nằm trong Git PR; PPTX/PDF và bằng chứng đã lọc được đưa vào PR. Kịch bản demo Android Emulator và helper chuẩn bị máy ảo có trong docs/scripts, chưa diễn tập trên AVD.
