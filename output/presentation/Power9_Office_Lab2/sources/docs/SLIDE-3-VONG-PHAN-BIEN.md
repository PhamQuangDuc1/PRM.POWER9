# Hồ sơ 3 vòng phản biện chính để lên slide

Người dùng xác nhận27/10/2026: các prompt Office đã gửi nguyên văn100% trên Stitch mới. Các nhận xét dưới đây ghi theo mốc đánh giá; kết quả hiện hành xem office-checkpoint.json và FIGMA-FINAL-AUDIT.md.


Ngày cập nhật: 26/10/2026. Sản phẩm: Power9 Office Routine. 3 persona chính ngang nhau: Huy 28, Mai 24, Linh 39. Dùng bảng này làm mục lục bằng chứng; không lấy các lượt sửa wireframe hoặc sửa font thất bại cộng thành vòng chính mới.

## Quy tắc lưu

- Giữ ảnh nguồn và prompt cũ, không ghi đè ảnh BEFORE bằng AFTER.
- Prompt phản biện AI và prompt yêu cầu Stitch sửa là 2 loại bằng chứng riêng.
- Toàn văn 3 phản biện chính: [OFFICE-3-MAIN-CRITIQUES.md](../ai/critiques/OFFICE-3-MAIN-CRITIQUES.md). Review ảnh ban đầu: [UI01 tổng thể](../ai/critiques/OFFICE-UI01-overall-review.md).
- Prompt được chuẩn bị trong repo chưa tự động là prompt thực đã gửi. Đối chiếu nội dung chat/screenshot prompt hoặc xác nhận của người dùng khi hoàn thiện nộp bài; không tái tạo prompt từ trí nhớ rồi gọi là nguyên văn.
- Accept/modify/reject ghi đúng quyết định người thiết kế và lý do; các nhãn đề xuất của AI chưa tự coi là người dùng đã duyệt. Không cần bịa reject để đủ nhãn.
- Chỉ dùng kết quả đã có bằng chứng. Không suy ra font-family/contrast/target hoặc prototype đạt từ overview.

## Tổng quan trạng thái

| Vòng | Vấn đề chính | Hiện trạng | Chưa được tuyên bố |
| --- | --- | --- | --- |
| 1 — OI01 | Typography và tính nhất quán font | Đã chẩn đoán code, thử sửa cục bộ, nhận ảnh Stitch sau sửa có chữ sans-serif | Chưa kiểm tra ZIP cuối cả 10 màn, kích thước/contrast/target toàn bộ |
| 2 — OI02 | Mật độ nội dung và trung thành nhiệm vụ | Đã nhận 2 ảnh AFTER, quan sát ảnh/banner/thẻ phụ giảm và tên S07 đầy đủ | Chưa kiểm thử task; Home thiếu hàng hoàn thành so với Tiến độ, chuyển xử lý vòng 3 |
| 3 — OI03 | Hoàn thành task và phục hồi lỗi | Đã có AFTER mở rộng: validation/loading/error, Home1/4, đổi giờ, phiên nghỉ và dialog; đã review hồi quy | State form đổi dữ liệu, tổng phiên3/5 phút lệch, có metric ngoài phạm vi; chưa kiểm tra3 flow |

## Vòng 1 — Typography và khả năng đọc

**Thông điệp slide:** Font thực tế không khớp design system; sửa cấu hình font giúp UI hiển thị sans-serif rõ ràng hơn.

**Vấn đề:** UI nhìn như serif dù bảng phong cách ghi Be Vietnam Pro. Ảnh hưởng cả 3 persona khi đọc tên hoạt động, hướng dẫn và form.

**Căn cứ:** Nielsen Consistency and standards; yêu cầu typography thống nhất và hỗ trợ tiếng Việt. Không nói font serif tự nó vi phạm accessibility; vấn đề ở đây là khác brief và khác hệ thống font đã định nghĩa.

**Nguyên nhân tìm được:** Cả 10 HTML trong ZIP OI01 gộp danh sách fallback thành 1 font-name:

```js
// Trước
body: ['"Be Vietnam Pro, Roboto, sans-serif"']
// Sửa
body: ['Be Vietnam Pro', 'Roboto', 'sans-serif']
```

**Lý do chọn cách sửa:** Giữ bố cục, palette và logo người dùng đã chọn; sửa nguyên nhân code thay vì chạy lại thiết kế hoặc chỉ thay chữ trên style board.

**Kết quả đã kiểm tra:** Chrome trên S01/S07 trước sửa render Times New Roman; sau thay cấu hình cục bộ render Be Vietnam Pro. Ảnh Stitch mới cho thấy chữ sans-serif. Hai loại bằng chứng này phải ghi nguồn riêng, không gọi ảnh thử cục bộ là output Stitch.

### Bằng chứng và liên kết

| Loại | File |
| --- | --- |
| Prompt phản biện C01 và toàn văn phản hồi | [3 phản biện chính, mục C01](../ai/critiques/OFFICE-3-MAIN-CRITIQUES.md) |
| BEFORE rõ lỗi serif, nhóm màn 1 | [OI01-attempt overview 1](../assets/stitch/office-ui/OI01-attempt/overview-01.png) |
| BEFORE rõ lỗi serif, nhóm màn 2 | [OI01-attempt overview 2](../assets/stitch/office-ui/OI01-attempt/overview-02.png) |
| ZIP giữ nguyên để đọc nguyên nhân | [OI01-source/source.zip](../assets/stitch/office-ui/OI01-source/source.zip) |
| Manifest/hash của nguồn | [manifest.json](../assets/stitch/office-ui/OI01-source/manifest.json) |
| Prompt yêu cầu sửa nguyên nhân | [OFFICE-OI01-font-root-fix.md](../ai/prompts/OFFICE-OI01-font-root-fix.md) |
| Kiểm chứng font thật Chrome | [font-verification.json](../output/office-ui-font-check/font-verification.json) |
| BEFORE render kiểm chứng S07 | [S07-before.png](../output/office-ui-font-check/S07-before.png) |
| AFTER sửa thử cục bộ S07 | [S07-after-local-fix.png](../output/office-ui-font-check/S07-after-local-fix.png) |
| AFTER Stitch nhóm màn 1 | [OI01-after overview 1](../assets/stitch/office-ui/OI01-after/overview-01.png) |
| AFTER Stitch nhóm màn 2 | [OI01-after overview 2](../assets/stitch/office-ui/OI01-after/overview-02.png) |
| Review AFTER | [OFFICE-OI01-after-review.md](../ai/critiques/OFFICE-OI01-after-review.md) |

**Chữ ngắn có thể đặt trên slide:**

> Vòng 1 — Đồng bộ typography. Phát hiện font serif khác design system. AI tìm lỗi cấu hình fallback; đề xuất sửa array fontFamily và giữ thiết kế hiện có. Kiểm chứng cục bộ S01/S07 render đúng Be Vietnam Pro; ảnh Stitch sau sửa đã hiển thị sans-serif. Chưa đo lại toàn bộ accessibility.

**Bố trí:** 2 ảnh crop cùng màn S01 hoặc S07 trước/sau, cùng vùng và tỉ lệ; dưới ảnh ghi nguồn Stitch hoặc render cục bộ. Bên cạnh có 3 dòng Vấn đề / Quyết định / Kết quả. Giữ overview gốc khi crop ảnh lên slide.

## Vòng 2 — Mật độ nội dung và nhiệm vụ văn phòng

**Thông điệp dự kiến:** Bỏ khối phụ ngoài nhiệm vụ để hoạt động và hành động chính rõ hơn; giữ UI xanh biển và logo.

**Vấn đề đã quan sát:** Home thêm thẻ sống thọ; Khám phá có nhãn Power9 Blue Zones; Chi tiết/Lịch có ảnh bìa, nhãn và mô tả thêm; Tiến độ/Góc làm việc có thẻ phụ. Tên hoạt động Lịch bị cắt. Người dùng cần xử lý việc ngắn, không đọc các lời dẫn dài trước khi thao tác.

**Căn cứ:** Nielsen Aesthetic and minimalist design, Match between system and real world, Recognition rather than recall. 9 nhóm văn phòng là hướng phát triển theo gợi ý của thầy, không phải 9 tên gốc hoặc sản phẩm chính thức Blue Zones.

**Đề xuất quyết định:** Bỏ/rút gọn nội dung ngoài wireframe, giữ hướng dẫn và tên hành động cần thiết; không cấm mọi ảnh trong UI theo nguyên tắc chung, không đưa UI trở lại skeleton.

| Loại | File/trạng thái |
| --- | --- |
| Prompt phản biện C02 và toàn văn phản hồi | [3 phản biện chính, mục C02](../ai/critiques/OFFICE-3-MAIN-CRITIQUES.md) |
| BEFORE nhóm màn 1 | [OI01-after overview 1](../assets/stitch/office-ui/OI01-after/overview-01.png) |
| BEFORE nhóm màn 2 | [OI01-after overview 2](../assets/stitch/office-ui/OI01-after/overview-02.png) |
| Prompt yêu cầu sửa | [OFFICE-OI02-content-density.md](../ai/prompts/OFFICE-OI02-content-density.md) |
| AFTER nhóm màn 1 | [OI02-after overview 1](../assets/stitch/office-ui/OI02-after/overview-01.png) |
| AFTER nhóm màn 2 | [OI02-after overview 2](../assets/stitch/office-ui/OI02-after/overview-02.png) |
| Review kết quả | [OFFICE-OI02-after-review.md](../ai/critiques/OFFICE-OI02-after-review.md): giảm mật độ quan sát được, còn hồi quy dữ liệu Home cần xử lý |

**Mẫu chữ slide sau khi có kết quả:**

> Vòng 2 — Giảm mật độ nội dung. [Finding và ảnh BEFORE]. Quyết định [do người dùng chốt] vì [persona/heuristic]. AFTER [ảnh thật và thay đổi quan sát được]. Kết quả [đã kiểm tra], còn hạn chế [nếu có].

Không đưa mẫu có chỗ trống lên slide nộp hoặc viết “đã hoàn thành” lúc này.

**Cập nhật sau khi nhận AFTER:** Có thể dùng chữ thực tế: “Vòng 2 — Bỏ banner, ảnh và thẻ phụ ngoài nhiệm vụ; giữ UI xanh biển. Lịch hiển thị tên hoạt động đầy đủ, các màn gọn hơn. Qua review phát hiện Home thiếu hàng hoàn thành so với Tiến độ, đưa vào vòng 3 để đồng bộ.” Không tuyên bố đo được thời gian thao tác giảm.

## Vòng 3 — Luồng thao tác và phục hồi lỗi

**Thông điệp dự kiến:** UI không chỉ đổi trạng thái nút; người dùng cần đi hết nhiệm vụ, Back/Hủy đúng và phục hồi được khi lỗi.

**Khoảng trống đã tìm trong code:**
- S06 chỉ đổi text CTA rồi phục hồi, chưa chuyển tới S07.
- S07 timeout báo thành công rồi history.back, chưa chứng minh validation hoặc cập nhật Home.
- S03 có timer start/pause nhưng chưa có nhánh ghi nhận history hoàn chỉnh; hành vi nút khi hết giờ cần sửa/kiểm tra.
- Chưa có variant create/edit và đường recovery đủ cho nhiệm vụ Linh/Huy.

**Căn cứ:** Nielsen Visibility of system status, User control and freedom, Error prevention, Help users recognize diagnose and recover from errors.

**Đề xuất quyết định:** Dựng các variant và prototype 3 flow trong Figma/khả năng công cụ thực có; không bắt code backend cho Lab 2. Lỗi giữ form; Hủy giữ dữ liệu cũ; thành công phải phản ánh ở Home/history. State không tính là màn chính mới.

| Loại | File/trạng thái |
| --- | --- |
| Prompt phản biện C03 và toàn văn phản hồi | [3 phản biện chính, mục C03](../ai/critiques/OFFICE-3-MAIN-CRITIQUES.md) |
| Nguồn code bằng chứng ban đầu | [OI01-source manifest](../assets/stitch/office-ui/OI01-source/manifest.json) |
| BEFORE hình ảnh chính thức cho vòng 3 | [OI02-after nhóm 1](../assets/stitch/office-ui/OI02-after/overview-01.png), [nhóm 2](../assets/stitch/office-ui/OI02-after/overview-02.png) |
| Prompt sửa vòng 3 | [OFFICE-OI03-task-recovery.md](../ai/prompts/OFFICE-OI03-task-recovery.md), đã chuẩn bị từ output vòng 2; chưa chạy |
| AFTER từng phần | [OI03-partial overview](../assets/stitch/office-ui/OI03-partial/overview-01.png), [review](../ai/critiques/OFFICE-OI03-partial-review.md) |
| AFTER mở rộng mới nhất | [Ảnh1](../assets/stitch/office-ui/OI03-expanded/overview-01.png), [ảnh2](../assets/stitch/office-ui/OI03-expanded/overview-02.png), [review và lỗi còn lại](../ai/critiques/OFFICE-OI03-expanded-review.md); chưa là bằng chứng prototype đạt |

**Điều kiện kiểm tra:** Mai tìm/thêm → Home có việc mới; Huy thực hiện/ghi nhận → history; Linh đổi lịch → Home giờ mới. Có Back/Hủy đúng nguồn, ít nhất 1 overlay và 1 loading→result; kiểm tra ít nhất 1 nhánh lỗi/retry/undo. Không tuyên bố chạy được chỉ từ screenshot.

**Mẫu chữ slide sau khi có kết quả:**

> Vòng 3 — Hoàn thiện thao tác và phục hồi. BEFORE [ngõ cụt/thiếu state có bằng chứng]. Quyết định [cách xử lý và lý do]. AFTER [flow/state thật]. Demo [happy path và nhánh phục hồi đã thử].

## Checklist khi lắp slide cuối

- [ ] Mỗi vòng có vấn đề khác nhau, không chỉ đổi giao diện bề ngoài.
- [ ] Có prompt thực gửi, toàn văn phản biện và quyết định có lý do.
- [ ] Có before/after cùng màn/vùng đủ rõ, giữ nguồn gốc.
- [ ] Phân biệt ảnh Stitch, render cục bộ và Figma.
- [ ] Vòng 2/3 chỉ đánh hoàn tất khi có output và kiểm tra.
- [ ] Không trình bày các lượt sửa font chưa đạt thành các vòng khác nhau.
- [ ] Các phát biểu trên slide khớp artifact cuối, không gán số đo chưa kiểm tra.