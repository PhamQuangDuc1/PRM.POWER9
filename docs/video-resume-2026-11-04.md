# Checkpoint tạm dừng — lịch sử 04/11/2026

**Đã tiếp tục theo yêu cầu người dùng và hoàn tất video/slide.** File chính `output/lab3/Power9_Lab3_Demo_Final.mp4`, slide Final_Video_20261104; metadata và kiểm tra cuối ở `evidence/video/2026-11-04/final-review.json`. Không còn chờ nhấn Tiếp tục cho các lệnh dưới đây. Phần còn lại giữ như checkpoint lịch sử để truy vết.

Người dùng yêu cầu tạm dừng vì sắp hết token và sẽ nhấn Tiếp tục khi có thể. Không tiếp tục render, điều khiển máy, gọi dịch vụ hoặc model trong lúc chờ. Không có goal được tạo cho công việc này.

## Đã lưu

- Toàn bộ cảnh app thật: khám phá/tìm rỗng/validation/tạo lịch; hủy sửa giữ giờ cũ; lưu sửa 11:00 không tăng số lịch; check-in/undo; timer ghi đúng 19 giây; giữ/xóa lịch nhưng giữ completion; tạo PDF có 2 hoạt động và mở Android print preview.
- Console thật: Firestore activities/move-walk, DebugView chưa nhận event (Debug Device=0), issue fatal Crashlytics lịch sử 31/10, Remote Config upload=false, chiến dịch Messaging lịch sử 01/11. Không gửi thông báo mới hoặc publish cấu hình.
- Mới bổ sung Login thật: `01-login-public.mp4` 10 giây, người dùng tự chọn lại A ngoài thời gian ghi, `01-home-after-signin.mp4` 26 giây. Đã đối chiếu cục bộ đúng tài khoản ban đầu và về Home. Bộ chọn Google không được ghi hình. Định danh giữ trong `.build/video-20261104/auth-private.json`, không xuất công khai.
- Người dùng chọn giọng nữ Hoài My neural thay giọng Windows và Google. Cả 9 file lời đọc đã có tại `output/lab3/video-20261104/narration/`; manifest `narration.json`. Tổng lời đọc 315,75 giây. Tạo qua Edge TTS không dùng API key/billing; không tiêu thụ ARTEMIS. Các câu đã cache trong `.build/video-20261104/tts-parts/`; không cần gọi TTS lại.
- Raw footage và các lượt công cụ thất bại chỉ nằm ignored tại `.build/video-20261104/raw/`. Các lượt thất bại không được ghi là đạt. Không đưa raw Console có tên người xuất bản hoặc Chrome profile vào gói nộp.
- Dữ liệu demo đã dọn qua app, đối chiếu server cả bốn document thử đều không còn: `evidence/video/2026-11-04/server-before-cleanup.json` và `server-after-cleanup.json`. Dữ liệu có trước được giữ. Analytics debug/FA properties đã khôi phục; UIAutomator đã dừng; app về Home tài khoản A sau đăng nhập lại.

## Bản video hiện có vẫn là bản dựng trước lần bổ sung Login

`output/lab3/video-20261104/Power9_Lab3_Demo_HoaiMy_20261104.mp4`: 395,04 giây, 1920×1080, H.264/AAC, khoảng 14,7 MB. Đã decode toàn bộ video/âm thanh thành công, mean=-20,3 dB và peak=-4,5 dB. Có SRT 64 mục cùng tên.

**Chưa đánh dấu bản cuối:** file trên được dựng trước khi quay thêm Login. Kiểm tra hình còn thấy font không có ký tự mũi tên. Source đã sửa thay mũi tên bằng dấu `/` và đã thêm ghép Login 8 giây → thẻ chuyển cảnh bảo vệ riêng tư 2 giây → Home mới 24 giây. Các thay đổi source này chưa chạy lại. `video-manifest.json` vẫn `finalPlaybackAndPrivacyReviewComplete=false`.

## Tiếp tục đúng chỗ

1. Chỉ khi người dùng nhấn Tiếp tục: chạy bằng Python có sẵn, không cần điện thoại/model/dịch vụ TTS:

   ```powershell
   & .build/tools/artemis/.venv/Scripts/python.exe scripts/lab3/build_demo_video.py --force
   & .build/tools/artemis/.venv/Scripts/python.exe .build/video-quality-review-20261104.py
   ```

2. Kiểm tra hình các frame trong `.build/video-20261104/final-qa/`: Login và Home, chữ không tràn, PDF thật, các trạng thái quan trọng. Đặc biệt Remote Config phải che cả cột người xuất bản; Chrome tab/address/profile và avatar Firebase đã được cắt khỏi hình. File `quality-check.json` chứa kết quả decode/audio và vẫn cần xác nhận visual review.
3. Kiểm tra đủ các frame, không chỉ 3 ảnh đã xem ở lượt trước. Đã xem bản dựng cũ: `09-results.png`, `08-remote-config.png`, `03-edit.png`; mặt nạ Remote Config che đúng vị trí. Ký tự mũi tên mất glyph đã sửa ở source, cần xác nhận sau render lại.
4. Cập nhật manifest theo đúng hash bản mới, trạng thái QA và flow Login; sao chép file cuối/soft subtitles/poster sang tên chính dễ tìm nếu cần. Cập nhật README/checklist/build-config/CONTINUE, kịch bản theo thời lượng thật khoảng 6 phút 35 giây. Chưa upload/chia sẻ công khai vì chưa có đích nộp/quyền xem.
5. Slide xuất trước kết quả TalkBack thủ công và video: nếu đồng bộ tiếp slide thì đọc skill presentations, cập nhật theo bằng chứng mới, render/verify trước khi thay các file chính. Chưa thực hiện cập nhật PPTX trong lượt quay này.

Source dựng: `scripts/lab3/build_demo_video.py`. Có font BeVietnamPro trong assets; file text cho FFmpeg phải dùng newline LF, CRLF từng gây giãn dòng gấp đôi và đã sửa. Bản dựng giữ tốc độ video thật, chỉ cắt phần chờ; không dùng video native để cộng ARTEMIS.

## Các giới hạn giữ nguyên

- ARTEMIS 32/33; TC10[3] chưa chạy lại, Pro chưa đạt. Budget vẫn 49/50, batch bốn task trước đã dùng đủ; không tự gọi lượt thứ năm.
- TalkBack sau Ở lại đã có người dùng nghe/vuốt/kích hoạt xác nhận; các luồng khác chưa kiểm tra hết.
- DebugView buổi quay chưa nhận sự kiện; log SDK không thay server. Không tự ghi Analytics server đạt.
- Spark/billing tắt, upload=false; không bật dịch vụ trả phí hoặc đổi key/model để né quota.
- Branch `codex/lab3-review-and-slides`; giữ OneD. Không commit/push/merge mới.
- Một lần mở URL Console trực tiếp đã hiện lỗi truy cập; đã Back về trang trước và xác nhận Firestore hoạt động bình thường. Không đổi tài khoản Console, quyền, billing hoặc dữ liệu. Không dùng lại helper điều hướng URL nếu không cần.
