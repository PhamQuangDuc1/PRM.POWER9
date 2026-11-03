# ARTEMIS sau nâng cấp UI — kết quả bốn lượt đã đồng ý

## Phạm vi

Người dùng xác nhận đúng bốn lượt trong tổng trần 50, giữ used=45, ảnh/cây Power9 gửi Google Gemini, giữ key/model và không bật billing. Duyệt mới đã cho phép cập nhật limit=50 và khởi động. Đã dùng bốn lượt, bộ đếm 49/50; không tự dùng lượt thứ năm.

| Lượt | Kết quả | Bằng chứng |
| --- | --- | --- |
| TC10[3] | Chưa đạt | Trace e0877c09-385d-43b1-afe9-e05ff0f75e09. Assertion UI cuối thất bại; server minuteOfDay=null và timestamp không đổi. Model báo 11:00 nhưng trace lặp chạm card, chưa chứng minh hủy/lưu. Giữ failed và audit không verified. |
| TC16[2] | Đạt | Trace 10b6b2a3-d8a4-4f6c-b73f-34f1f7b95f8b. view_activity(activity_id=move-walk), native SDK FA-SVC lọc marker và thời điểm của lượt chạy. |
| TC16[3] | Đạt | Trace 9bd3602d-1b3c-4211-9ebb-f0f18e6e1879. Trace và native SDK log độc lập, đúng event/params. |
| Pro | Chưa đạt | Trace c967f5fe-aa85-49cd-b05d-79c106f46008. 189,02 giây, 9 bước được ghi, kết thúc trước mức tối thiểu 900 giây. Không bù bằng thời gian chờ hoặc sleep. |

Tổng hợp: **32/33 run ID** được xác minh, gồm 31 pytest passes hợp lệ và 1 audit lịch sử; 10/11 ca đủ ba lượt. Giữ lại 62 attempts. Kiểm tra native và Auth A → B → A không cộng vào ARTEMIS.

## Vi phạm phạm vi Pro

Goal cấm mở Profile/debug nhưng bước 4 mở Tài khoản rồi quay lại. Trong 9 khung phân biệt có 1 khung Profile chứa email; khung đó có thể đã được gửi tới Google Gemini trong quá trình model quan sát. Không sao chép ảnh/cây đó vào bằng chứng công khai, replay hoặc slide; raw trace giữ ignored để audit. Không ghi nhận Pro đạt và không gọi model thêm. Audit công khai chỉ chứa số khung và boolean, không có email.

## Kết thúc

- Đã dọn lịch fixture move-walk ngày 03/11 do lượt này tạo qua exact-document server API. Kiểm tra createdAt/updatedAt khớp fixture và completion vắng; delete có updateTime precondition. Bằng chứng: `evidence/artemis/ui-fixture-cleanup.json`. Đây là cleanup, không thay test app delete.
- Đã khôi phục Analytics debug=.none. và FA/FA-SVC về giá trị ban đầu. Xác nhận Home, dừng UIAutomator và tắt daemon bằng API quản lý cục bộ.
- Billing API xác nhận false. Người dùng yêu cầu bỏ phần phát sinh phí: giữ Spark, report_upload_enabled=false; Storage production bỏ khỏi phạm vi thực hiện nhưng không đánh dấu đạt rubric.
- Slide hiện hành phản ánh 32/33, Pro 3 phút 9 giây chưa đạt, UI và hai tài khoản đã kiểm chứng. Video cuối và nghe/vuốt TalkBack vẫn cần thực hiện bằng người thật.
