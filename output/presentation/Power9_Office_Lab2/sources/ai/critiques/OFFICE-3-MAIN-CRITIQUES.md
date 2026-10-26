# 3 prompt phản biện chính — Power9 Office Routine

Người dùng xác nhận27/10/2026: các prompt Office đã gửi nguyên văn100% trên Stitch mới. Các nhận xét dưới đây ghi theo mốc đánh giá; kết quả hiện hành xem office-checkpoint.json và FIGMA-FINAL-AUDIT.md.


Reviewer: Codex. Nguồn: 2 ảnh UI01, 2 ảnh sau lần sửa OI01; ZIP UI tại assets/stitch/office-ui/OI01-source/source.zip, bản giải nén giữ nguyên và manifest kèm hash. 3 persona chính ngang nhau: Huy 28, Mai 24, Linh 39. Đây là 3 phiên đánh giá theo 3 vấn đề khác nhau, chưa đồng nghĩa đã hoàn thành 3 vòng cải tiến Stitch/Figma.

## C01 — Typography và khả năng đọc

### Prompt nguyên văn dùng cho phản biện này

```text
Phản biện typography của 10 màn Power9 Office Routine theo 3 persona chính Huy/Mai/Linh, Nielsen Consistency and standards và accessibility. Đối chiếu ảnh với HTML ZIP mới, tìm nguyên nhân chữ serif dù yêu cầu Be Vietnam Pro. Nếu có thể, kiểm tra computed CSS và font thực được render. Nêu màn, bằng chứng, nguyên nhân, đề xuất sửa, tiêu chí kiểm chứng. Phân biệt kiểm tra cục bộ và sửa thật trên Stitch; không tự tuyên bố hoàn tất.
```

### Toàn văn phản biện C01

**C01-F01 — cấu hình font sai, cả 10 màn.** Trong mọi HTML, các family display/body/label/headline/helper/body-medium chứa chuỗi dạng `['"Be Vietnam Pro, Roboto, sans-serif"']`. Cả danh sách bị bao trong dấu nháy kép nên trình duyệt tìm 1 font tên “Be Vietnam Pro, Roboto, sans-serif”, thay vì font chính và 2 fallback. Class font-body ghi đè khai báo font đúng ở base. Đây là lỗi cấu hình, không phải chỉ thiếu import hay sở thích chọn font.

Đã kiểm chứng bằng Chrome ở S01 và S07: trước sửa, computed family là 1 tên được quote; Chrome báo font thực Times New Roman. Khi đổi array thành `['Be Vietnam Pro', 'Roboto', 'sans-serif']`, font thực trở thành Be Vietnam Pro (Bold/SemiBold), font tải thành công, không request thất bại. File bằng chứng output/office-ui-font-check/font-verification.json; ảnh BEFORE và AFTER-local-fix cùng thư mục. Cả 10 HTML có cùng lỗi tĩnh, nhưng chỉ 2 màn được thử thay cấu hình trong browser. Không suy ra đã kiểm chứng động cả 10.

Tác động: Huy cần đọc nhanh, Mai cần nhãn rõ, Linh cần form dễ theo dõi. Typography thực tế khác design system, làm hierarchy và reflow sai. Đề xuất **accept** sửa cấu hình font cho mọi family; giữ icon font riêng. Không tạo thêm vòng riêng cho từng màn.

**C01-F02 — reflow sau sửa cần kiểm tra.** Ảnh thử S01 sau đổi font có tên hoạt động bị ellipsis và CTA thấp hơn nội dung; đây là ảnh kiểm chứng cục bộ, chưa phải kết quả Stitch. Tên hoạt động cần wrap, kiểm tra 360/412, nav/footer không đè nhau. Không coi sửa đúng tên font là đã đạt mọi yêu cầu font size/contrast/target. Tiêu chí vòng C01: computed/rendered font đúng trên output mới; chữ Việt đúng dấu, không overlap, giữ icon. Quyết định cuối của người dùng chưa được ghi nhận; sửa trong Stitch chưa thực hiện.

## C02 — Mật độ nội dung và phù hợp ngữ cảnh văn phòng

### Prompt nguyên văn dùng cho phản biện này

```text
Phản biện mật độ nội dung toàn bộ 10 màn UI so với wireframe đã chốt. Dùng 3 persona chính Huy/Mai/Linh và Nielsen Aesthetic and minimalist design, Match between system and real world. Chỉ ra banner, ảnh, nhãn hoặc mô tả làm loãng nhiệm vụ. Phân biệt cảm hứng Blue Zones với 9 nhóm văn phòng do đề tài phát triển. Đề xuất giữ/bỏ/rút gọn có lý do và tiêu chí kiểm tra, không biến UI màu trở lại low-fi hoặc yêu cầu làm lại từng màn.
```

### Toàn văn phản biện C02

**C02-F01 — nội dung nguồn dễ gây hiểu nhầm, S01/S05/S07.** S01 thêm “Thói quen sống thọ Power 9”; S05 ghi “Power9 Blue Zones”; S07 banner thêm mô tả cân bằng nhịp sinh học/năng lượng. Những nhãn này không có trong task của wireframe. 9 nhóm văn phòng không phải nguyên văn 9 nguyên tắc Blue Zones và sản phẩm chưa được chứng nhận. Đề xuất **accept** bỏ nhãn dễ bị hiểu là sản phẩm chính thức hoặc hứa hiệu quả, giữ Power9 Office Routine và nguồn cảm hứng trong hồ sơ. Không cần bỏ mọi tham chiếu nguồn khỏi bài thuyết trình.

**C02-F02 — khối phụ làm loãng task, S02/S06/S08/S09.** S02 thêm Khoảnh khắc hiện diện; S06 thêm Nạp năng lượng/Dễ dàng và nhiều diễn giải phụ; S08 có Khoảng lặng tích cực; S09 có thẻ Thói quen Power9/Mẹo tư thế chuẩn. Huy cần checklist nhanh, Mai cần quyết định hoạt động, Linh cần mục tiêu/tiến độ rõ. Đề xuất **accept** bỏ thẻ không giúp quyết định, giữ đúng hướng dẫn ngắn đã chốt. Riêng mẹo chi tiết có thể chuyển sang tài liệu/hướng dẫn mở rộng, không tăng màn lúc này.

**C02-F03 — ảnh lớn ở form/chi tiết, S06/S07/S10.** Ảnh bìa chiếm không gian trên task mà chưa có nhu cầu chứng minh. Đề xuất **modify**: bỏ banner S07, ưu tiên không ảnh ở S06/S10; có thể giữ ảnh nhỏ ở S04 nếu phù hợp phong cách người dùng đã thích. Không áp quy tắc “UI không được dùng ảnh”; quyết định dựa trên tác vụ và vị trí CTA.

**C02-F04 — action chưa có phạm vi, S03.** Icon loa hiện diện nhưng brief không có âm thanh. Đề xuất **accept** bỏ nếu chưa định nghĩa chức năng. Tiêu chí C02: 10 màn giữ 9 nhóm và task chính, nội dung ngắn hơn, CTA không bị đẩy khỏi vùng thao tác bởi khối thêm, không thêm chức năng lạ, logo/màu/font đã chốt được bảo toàn. Chưa có AFTER C02.

## C03 — Luồng thao tác, phản hồi và phục hồi lỗi

### Prompt nguyên văn dùng cho phản biện này

```text
Phản biện khả năng hoàn thành 3 nhiệm vụ: Mai tìm/thêm, Huy thực hiện/ghi nhận, Linh đổi lịch/giờ yên lặng. Kiểm tra ảnh và HTML hiện có, theo Nielsen Visibility of system status, User control and freedom, Error prevention, Help users recognize diagnose and recover from errors. Nêu ít nhất 1 nhánh lỗi/phục hồi thực sự cần thiết. Phân biệt animation minh họa với navigation/data đã hoạt động; đề xuất các state và điều hướng cần dựng trong Figma, không bắt buộc code backend cho Lab 2.
```

### Toàn văn phản biện C03

**C03-F01 — đường chọn lịch chưa đi tới form, S06.** JS btn-schedule chỉ đổi nội dung thành “Đang mở bộ chọn lịch…” rồi phục hồi sau 700ms, không điều hướng S07. Đây là phản hồi giả lập chưa hoàn tất task Mai thêm hoạt động. Đề xuất **accept** nối S06-new → S07-create và Back giữ nguồn trong Figma. Không cần code backend.

**C03-F02 — lưu luôn báo thành công, S07.** JS btn-save luôn hiện Đang lưu, rồi Đã lưu thành công và history.back bằng timeout. Không có validation hoặc nhánh lỗi, không chứng minh cập nhật Home. Hủy cũng history.back, phụ thuộc browser history chứ không ghi nhớ đúng source. Đề xuất **accept** dựng validation giữ form, loading, success về Home có hoạt động mới, error/retry không làm mất lựa chọn; Cancel giữ lịch cũ. Chưa kết luận server có lỗi vì đây là HTML mô phỏng, không có server.

**C03-F03 — chưa phân biệt create/edit, S06/S07.** Bộ hiện chỉ thể hiện activity chưa thêm; chưa có variant hành động Đổi lịch để Linh/Huy chỉnh lịch mà không thêm trùng. Đề xuất **accept** variant S06-existing/S07-edit, không tính thành màn chức năng mới. Lỗi lưu giữ lịch cũ ở Home, dữ liệu mới ở form để retry.

**C03-F04 — kết thúc phiên chưa ghi nhận, S03.** Code có start/pause và đổi text khi timer về 0, nhưng không có nhánh lưu history. Khi bấm nút sau hết giờ, code có thể lại vào nhánh start vì isRunning=false, thay vì ghi nhận; đây là phân tích tĩnh, chưa chạy chờ 180 giây. Đề xuất **accept** state finished có CTA ghi nhận rõ, đồng bộ Home/S08, overlay xác nhận bỏ phiên khi rời; bắt đầu không đồng nghĩa hoàn thành.

**C03-F05 — tên bị cắt và thiếu bằng chứng đồng bộ, S01/S07/S08.** S07 cắt tên hoạt động; S08 cắt metadata. Tên chính phải wrap để Mai/Linh xác nhận đúng hoạt động; có thể rút gọn metadata phụ. Home và history hiện cùng 1/3 trong ảnh nhưng không chứng minh check-in/undo cập nhật qua màn. Đề xuất **modify** quy tắc text và dựng state hoàn tác đồng bộ trong prototype.

Tiêu chí C03: 3 starting point đi hết task, có ít nhất 1 overlay và 1 loading→result; nhánh validation/error/retry/undo có đích đúng, Cancel/Back đúng nguồn; không ngõ cụt. Thực hiện trong Figma/prototype hoặc khả năng Stitch thực có, không bịa tính năng công cụ. Hiện chưa có bằng chứng đạt và chưa có AFTER.

## Cách trình bày lên slide

| Vòng | Vấn đề riêng | Bằng chứng BEFORE | Bằng chứng AFTER cần có | Trạng thái |
| --- | --- | --- | --- | --- |
| 1 / C01 | Font thực khác design system | UI01/OI01 và cấu hình quote sai | S01/S07 đã thử cục bộ; còn cần output Stitch/Figma đúng font | Chẩn đoán và thử sửa cục bộ, chưa xong trên Stitch |
| 2 / C02 | Nội dung/ảnh thêm làm loãng nhiệm vụ | UI01/OI01 các màn S01/S02/S06/S07/S08/S09/S10 | Ảnh bộ sau giảm mật độ, giữ task | Chưa thực hiện sửa |
| 3 / C03 | Flow chưa hoàn tất và thiếu phục hồi | Code S06/S07/S03 và bộ state hiện có | 3 flow bấm được, overlay, loading, retry/undo, ảnh đối chiếu | Chưa thực hiện sửa |

Slide mỗi vòng: tên vấn đề → 1 ảnh before/after cùng màn → heuristic/persona → quyết định và lý do → kết quả kiểm tra thật. Có thể dùng S01 hoặc S07 cho nhiều vòng nếu mỗi vòng khác vấn đề và có ảnh giai đoạn riêng. Không đổi tên 3 prompt thành 3 vòng đã hoàn tất khi chỉ mới viết prompt. C01 lần sửa trước chưa đạt là phần lịch sử của cùng vòng, không tự tính thêm 1 vòng.

Các quyết định accept/modify trong tài liệu là đề xuất của AI; người dùng cần xác nhận/chỉnh và ghi lý do thực tế. Không yêu cầu bịa reject chỉ để đủ 3 nhãn. Log cần lưu prompt thực gửi Stitch riêng với prompt phản biện của AI; đó là 2 loại bằng chứng khác nhau.