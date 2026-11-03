# Checklist hiện hành — 04/11/2026

## Đã chuẩn bị

- [x] APK UI mới với 8 ảnh minh họa, main APK và build-config khớp nhau.
- [x] 49 Flutter tests, analyzer sạch; kiểm tra 15 màn ở 360/412 dp, chữ 1,5 lần.
- [x] Auth offline/retry/logout/Back và A → B → A; dọn đúng dữ liệu thử.
- [x] ARTEMIS TC16[2] và TC16[3] có trace/log Analytics độc lập; tổng 32/33 run ID.
- [x] Slide 15 trang cập nhật, ghi chú/nguồn, bảng và biểu đồ chỉnh sửa được; PPTX/PDF mở trong PowerPoint.
- [x] Timeline và lời đọc cho video cuối 6 phút 35 giây, giữ Spark.
- [x] Giữ billing tắt, khôi phục Analytics debug, tắt daemon và UIAutomator sau lượt chạy.
- [x] TalkBack nhánh sau “Ở lại”: người dùng nghe tên Hôm nay, vuốt tới và chạm hai lần mở lại dialog; đã dọn phiên thử và khôi phục cài đặt.

## Chưa đạt hoặc chưa thực hiện

- [x] DebugView server: ảnh bổ sung 04/11 xác minh view_activity và activity_id=move-walk. Video buổi quay trước đó vẫn giữ trạng thái chờ lịch sử.
- [ ] TC10[3]: final UI assertion thất bại; trace/server không chứng minh giờ 11:00.
- [ ] Pro chủ động 15–30 phút: lượt mới 3 phút 9 giây và mở Profile trái giới hạn. Không tự retry vượt 4 lượt vừa được đồng ý.
- [x] TalkBack: người dùng xác nhận ba phần nhãn/trạng thái, validation, dialog, PDF và đường quay lại; phạm vi ở evidence/accessibility/2026-11-04-manual-flows/result.json. Bộ chọn Google không thuộc lượt này.
- [x] Video app + Firebase Console thật, Login/Home, lời đọc Hoài My, phụ đề 64 mục; decode hình/tiếng và rà bố cục/quyền riêng tư đạt.
- [ ] Đồng bộ báo cáo PDF mốc cũ nếu dùng báo cáo đó để nộp với số liệu mới.
- [x] Commit/push trên OneD, tạo [PR #4](https://github.com/PhamQuangDuc1/PRM.POWER9/pull/4) vào main; PR #3 đóng và nhánh review cũ đã xóa an toàn. Chưa merge.

## Bỏ khỏi phạm vi triển khai vì chi phí

- Storage production/Blaze: người dùng yêu cầu không bật. Giữ report_upload_enabled=false. Đây là ngoại lệ phạm vi do chủ dự án chọn, không tự coi tiêu chí upload trong đề đã đạt.
- Không dùng model/key trả phí, không đổi key/model để né quota, không kích hoạt dịch vụ trả phí khác.

Bản slide hiện hành: `Power9_Lab3_Final_Video_20261104.pptx` và PDF cùng tên. Kịch bản: `docs/video-script-spark-2026-11-04.md`. Không đưa raw Profile/debug, email, UID, token hoặc model key vào gói công khai.

Video chính: `Power9_Lab3_Demo_Final.mp4` và SRT cùng tên. Đã dọn dữ liệu thử, khôi phục debug và về Home A. Chưa upload hoặc thay quyền xem.
