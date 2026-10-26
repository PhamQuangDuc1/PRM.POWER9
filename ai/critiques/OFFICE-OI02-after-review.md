# OI02 — phản biện kết quả giảm mật độ

Nguồn: assets/stitch/office-ui/OI02-after/overview-01.png và overview-02.png; BEFORE tại OI01-after/. Reviewer: Codex. Review screenshot, chưa đọc ZIP sau sửa hoặc bấm prototype.

## Kết quả quan sát được

- S01 bỏ card sống thọ và badge Power9; ngày đã là Thứ Hai 26/10/2026.
- S02 bỏ Khoảnh khắc hiện diện, giữ hoạt động/3 bước/CTA.
- S03 bỏ action loa; timer và Bắt đầu còn rõ.
- S04 bỏ ảnh bìa lớn; S05 bỏ nhãn Power9 Blue Zones, vẫn thấy 9 nhóm.
- S06 bỏ ảnh/tag thừa và diễn giải phụ trong từng bước; S07 bỏ banner, tên Rủ đồng nghiệp đi bộ đọc đầy đủ thay ellipsis.
- S08 bỏ Khoảng lặng tích cực; S09 bỏ thẻ ảnh và mẹo; S10 bỏ ảnh phòng ngủ, giữ nhiệm vụ và chọn giờ.
- Palette/logo phần lớn giữ, typography vẫn có hình thức sans-serif. Logo S05 hiện placeholder P9 trong khi màn khác dùng logo ảnh: chưa coi là asset đã đồng bộ toàn bộ.

Các thay đổi đáp ứng chủ đề Aesthetic and minimalist design / Match between system and real world; Mai bớt khối cần đọc trước CTA, Huy có checklist gọn hơn, Linh có lịch/tiến độ ít nhiễu hơn. Không có số đo task time để tuyên bố tăng tốc cụ thể.

## Hồi quy và việc còn lại

**D01 — S01/S08 chưa cùng cách biểu diễn dữ liệu.** S01 chỉ thấy Đi bộ giữa giờ 10:00 và Tổng kết công việc 17:30, nhưng tóm tắt vẫn 1/3; S08 có thêm Viết một việc có ý nghĩa 09:00 đã hoàn thành. Không thấy nhãn Chưa hoàn thành hoặc filter ở Home, nên nếu Home chủ ý chỉ liệt kê việc còn lại thì cần nói rõ. Với wireframe đích danh sách đủ 3 việc, đề xuất khôi phục hàng hoàn thành + Hoàn tác. Không yêu cầu 1 vòng sửa nhỏ riêng, gom vào OI03 task/state.

**D02 — S06 nhãn nhóm sát/có phần khuất app bar.** Không kết luận overlap vì ảnh có thể ở vị trí cuộn; kiểm tra vùng cuộn/header khi nối prototype hoặc có ZIP. Không tự yêu cầu rebuild.

**D03 — static screenshot chưa chứng minh flow.** Vẫn cần new/existing, save/loading/error/retry, check-in/undo, phiên nghỉ và đích Back. C03 trước đó có bằng chứng code ZIP cũ; không mặc định code mới giống hệt khi chưa nhận.

## Quyết định và slide

Đề xuất chấp nhận thay đổi mật độ nhìn được làm AFTER vòng 2; giữ open issue D01 trong vòng 3 trước Final UI. Không tuyên bố bộ UI đã hoàn hảo hoặc flow chạy được. Prompt thực gửi và quyết định cuối của người dùng vẫn cần đối chiếu khi hoàn thiện hồ sơ.

Chữ slide: “Vòng 2 — Giảm mật độ nội dung. BEFORE: banner, ảnh và thẻ phụ đẩy nội dung tác vụ xuống. Cải tiến: bỏ khối ngoài nhiệm vụ, giữ cấu trúc, màu và logo. AFTER: Lịch hiển thị tên hoạt động đầy đủ; các màn chính gọn hơn. Phát hiện cần sửa tiếp: danh sách Home phải khớp Tiến độ.”
