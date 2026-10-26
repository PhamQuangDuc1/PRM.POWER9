# Kiểm tra ZIP wireframe Office — 26/10/2026

Nguồn người dùng: D:/Download/stitch_power9_office_routine_wireframe.zip. Bản gốc giữ tại assets/stitch/office-final/; giải nén nguyên trạng vào export-original/. SHA-256 và inventory: assets/stitch/office-final/manifest.json. Chỉ kiểm tra, không sửa HTML/PNG nguồn.

## Kết luận

Đủ 10 thư mục S01–S10, mỗi thư mục có code.html và screen.png, kèm 1 DESIGN.md nguồn. Giữ bộ này là wireframe đã chốt về nội dung/bố cục, có giới hạn kỹ thuật cần chuẩn hóa khi lên UI/Figma. Không yêu cầu người dùng dựng lại cả bộ.

Đã render HTML gốc bằng Chrome tại 360×800 và 412×800 sau khi tải thành công Tailwind CSS và fonts từ các URL nguồn. Không phát hiện tràn ngang trong 20 trường hợp. PNG render lại ở output/office-wireframe-audit/S01-360.png…S10-360.png; gallery xem-truoc.html. Đây là ảnh render cục bộ từ nguồn Stitch, không phải ảnh export Stitch mới hoặc bằng chứng canvas đã được sửa.

## Các điểm thực tế

| Mục | Kết quả | Hành động |
| --- | --- | --- |
| PNG gốc | 6 ảnh toàn đen: S02/S03/S04/S05/S07/S09; kiểm tra pixel và xem mẫu S07 | Giữ nguyên làm bằng chứng lỗi export, dùng ảnh render lại để kiểm tra nội dung |
| Kích thước PNG gốc | Rộng 487, cao thay đổi 287–1242; không phải bộ PNG 360×800 | Không suy từ kích thước ảnh ra root frame canvas; UI/Figma phải base 360×800 |
| Tên chức năng | H1 đủ và đúng S01–S10 | Tên thư mục dùng để ánh xạ, không hiển thị mã kỹ thuật trong UI |
| Độ rộng HTML | Không tràn ngang ở 360/412 khi CSS tải đủ | Giữ bố cục responsive; chưa coi toàn bộ responsive/accessibility đã đạt |
| Độ cao trang | Tại 360: S05 915, S07 841, S10 808; các trang khác 800 | Đây là độ cao tài liệu cuộn khi render, không tự kết luận mất nội dung. UI cần viewport cố định và vùng cuộn rõ |
| Font nhỏ | Có nhãn 11–13px trên nhiều màn; S03 tab 11px, S07 trợ giúp 12/13px, S05 filter 13px | UI đặt nhãn/trợ giúp/navigation ≥14, body ưu tiên 16; chưa đạt yêu cầu chữ toàn bộ |
| Vùng chạm | Có Back 24/40px, S02 step buttons 24×24, S05 filter cao 36px, S07 switch cao 24px | Mở vùng tương tác ≥48×48; cần xét label/wrapper cho input visually-hidden, không suy từ input 1×1 rằng toàn label không bấm được |
| Navigation | HTML còn href=# và các field minh họa, một số JS rời rạc | Chưa phải prototype 3 flow hoàn chỉnh hoặc dữ liệu dùng chung |

Audit máy: output/office-wireframe-audit/audit.json. Lần render đầu thiếu mạng nên CSS không tải được; kết quả không dùng đánh giá. Lần sau cho phép tải tài nguyên nguồn: tailwindLoaded=true, failedRequests=[] cho cả 20 trường hợp. Kết quả smallControls chỉ liệt kê hộp element nhỏ, cần phân biệt label/hit-wrapper trước khi kết luận.

## Bước tiếp theo

Chuyển sang UI đầu tiên cho cả 10 màn trong 1 lượt, giữ wireframe nguồn. Dùng design/DESIGN.md và prompt ai/prompts/OFFICE-UI01-from-final-wireframe.md; logo người dùng tại assets/brand/power9-logo-3d.png. Chưa chạy prompt, chưa có UI Office. Sau output UI: phản biện tổng thể theo 3 persona/Nielsen/accessibility, chọn vấn đề thật để cải tiến. Không tự tính việc render/export hoặc đổi màu là vòng UX hoàn tất.
