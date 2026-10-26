# OI03 — state đã mở rộng, chưa chốt Final toàn bộ

Nguồn: assets/stitch/office-ui/OI03-expanded/overview-01.png, overview-02.png. Reviewer: Codex. Chỉ đánh giá ảnh; chưa kiểm tra toàn canvas, layer hoặc chạy prototype. Không xác nhận lời Completed hoặc ảnh state là bằng chứng liên kết chạy được.

## Đã có bằng chứng tiến bộ

Nhìn thấy form đổi lịch18:00 có giải thích giờ yên lặng; validation thiếu giờ; loading; lỗi lưu/Thử lại; Home thêm hoạt động12:00 với1/4; Home đổi giờ17:30→18:00 với1/3; phiên nghỉ paused/finished và dialog Tiếp tục phiên/Bỏ phiên. Đây là độ bao phủ state tốt hơn OI03-partial. Không cần thêm frame mới lúc này.

## Các điểm ngăn chốt state cuối

1. **Đứt dữ liệu form cùng flow:** validation là Rủ đồng nghiệp đi bộ; loading có Tổng kết công việc và các trường lặp/nhóm/ghi chú mới; error đổi thành Thiền & Thở sâu buổi sáng,06:15 SA,20 phút và ngày21/04… Không phải lỗi lưu giữ dữ liệu của tác vụ trước. Cần dùng cùng template và dữ liệu cho từng nhánh create/edit; không coi các hoạt động khác là cùng snapshot.
2. **Phiên nghỉ sai thời lượng/trạng thái:** bản trước nghỉ3 phút; một paused ghi phiên05 phút, đã hoàn thành02:45 và còn02:15. Một khung khác cũng paused00:55; chưa thấy chắc chắn active có Tạm dừng. Finished là3 phút. Cần thống nhất tổng03:00, paused giữ thời gian thật của snapshot, active/paused có đúng CTA. Không bắt buộc mọi snapshot cùng số giây, nhưng tổng phải nhất quán.
3. **Nội dung ngoài phạm vi tái xuất hiện:** nhịp tim ước tính72bpm, mô tả cortisol, âm thanh bật, điểm84%, nhắc trước10 phút, tần suất lặp, địa điểm/4 đồng nghiệp, banner phụ và logo lặp. Chưa có nguồn dữ liệu/tính năng tương ứng; bỏ, giữ nhiệm vụ và quy tắc nhắc đã chốt. Không thêm chức năng mới để hợp thức hóa các nhãn này.
4. **Title/state lệch nguồn:** state S03 đang dùng header Chi tiết thói quen thay Thư giãn. Không để state đổi tên chức năng hoặc tự mất ngữ cảnh điều hướng. Overlay giữ nền và hành vi quay lại đúng active/paused.
5. **Chưa chứng minh data sau ghi nhận/Back:** thấy ảnh dialog và Home1/4 không đủ chứng minh save/retry/undo/history và3 starting point hoạt động. Cần kiểm tra trong prototype Figma, không tạo thêm màn chỉ để tăng số lượng.

## Quyết định đề xuất

Giữ10 màn chính từ OI02 và Home/History đã khôi phục đủ3 việc ở OI03 theo snapshot gốc. OI03 có AFTER từng phần, chưa đạt toàn bộ mục tiêu hành vi. Giữ các state đúng làm nguồn tham chiếu, không lấy state sai nội dung làm Final UI. Dừng prompt tạo frame thêm; chuẩn hóa state hiện có và nối Figma ở bước sau. Chưa sửa canvas trong lần review này.

## Lời dùng cho slide vòng3 ở hiện trạng này

“AI phát hiện thiếu trạng thái và dữ liệu chưa đồng bộ. Đã bổ sung validation, loading, error/retry, phiên nghỉ và dialog rời phiên. Review AFTER phát hiện form đổi dữ liệu và thời lượng nghỉ không nhất quán; giữ mở để chuẩn hóa trong prototype. Chưa tuyên bố3 flow đã kiểm thử thành công.”

Khi sửa xong/có demo mới thay câu kết bằng kết quả được kiểm chứng. Không trình bày3 vòng đều đạt chỉ để đủ slide.
