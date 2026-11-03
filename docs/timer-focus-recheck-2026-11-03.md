# Kiểm tra lại focus timer trên APK UI mới — 03/11/2026

Người dùng đồng ý chạy tự động nhánh TalkBack/timer, hiểu rằng helper không thay việc nghe và vuốt của người thật. APK giữ nguyên bản UI có SHA-256 `77955787ecb33e60305b3e49ca62894ba003ab335a39f85f064084c870eea41e`; không sửa app trong lượt này.

## Kết quả

### Bổ sung kiểm tra thủ công — 04/11/2026

Người dùng trực tiếp xác nhận: sau “Ở lại”, vuốt tới Hôm nay nghe được tên tab và chạm hai lần mở lại dialog “Rời phiên thư giãn?”. Vì vậy, nhánh nghe/vuốt/kích hoạt sau Ở lại đã được kiểm chứng bằng người thật. Bằng chứng: `evidence/accessibility/2026-11-04-manual-focus/result.json`.

Đã bỏ đúng phiên thử chưa ghi nhận, trở về Home và khôi phục cài đặt trợ năng ban đầu. Không gọi model. Kết quả này không đổi snapshot tự động lịch sử thành true và không đại diện cho toàn bộ màn hình TalkBack; tên nút, lỗi form, dialog và đường quay lại ở các luồng khác còn cần nghe/vuốt.

Lượt `evidence/accessibility/2026-11-03-ui-timer-focus-attempt3/result.json`:

- 11/11 kiểm tra tiền điều kiện/chuyển trạng thái đạt. Đây là lượt phạm vi hẹp, không cộng vào bộ17hành vi cũ hoặc ARTEMIS.
- Bắt đầu phiên khi idle, tạm dừng tại02:56; Hôm nay mở dialog; Ở lại giữ paused02:56.
- Hôm nay sau Ở lại: `focusActionAccepted=true`, `focusedBeforeActivation=false`, `clickActionAccepted=true`; dialog thực sự mở lại.
- 6/7 thao tác thấy snapshot focus trước click; `behaviorPassed=true`, `allActionFocusObserved=false`. Không ghi toàn bộ trợ năng hoặc focus đạt.
- Bỏ đúng phiên vừa tạo, không bấm Ghi nhận; app về Home. `unrecordedTestSessionRemains=false`.
- TalkBack bound trong lượt thử; finally khôi phục enabled_accessibility_services=null và accessibility_enabled=0, kiểm tra sau lượt xác nhận Bound services rỗng. Không còn tự động điều khiển máy.
- `humanGesturesAndSpeechAssessed=false`, modelCalls=0. Chưa chứng minh phát âm, thứ tự vuốt thực tế hay kết luận người dùng có/không kích hoạt được bằng TalkBack.

## Attempts giữ nguyên

1. Attempt1: khi TalkBack bật, TrainingActivity mở; helper bịAndroid kết thúc exit137 ở thao tác đầu. Không khởi động timer; cài đặt được khôi phục. Serial trong chuỗi lỗi công khai đã được che, không đổi trạng thái thất bại.
2. Attempt2: helper đọc timer từ text trong khi Flutter đưa vào description. Dừng khi chưa trích được thời gian; bỏ phiên vừa tạo và khôi phục cài đặt. Snapshot thật có02:56 trong mô tả “Thời gian còn lại”.
3. Attempt3: script đọc thời gian từ node có nhãn “Thời gian còn lại”, yêu cầu chỉ có một giá trị duy nhất; kết quả ở trên. Không hạ assertion hoặc giả lập giá trị để qua test.

Script tái tạo: `scripts/lab3/native_timer_focus_audit.py`; tiền điều kiện/helper ở `docs/lab3-accessibility-check.md`. Mỗi lần phải dùng output mới. Bước nghe/vuốt sau Ở lại đã được người dùng xác nhận ngày 04/11 như phần bổ sung ở trên.
