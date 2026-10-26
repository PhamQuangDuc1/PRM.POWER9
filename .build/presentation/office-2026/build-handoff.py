from pathlib import Path
import shutil
root=Path('D:/PRM393/PRM.POWER9');out=root/'output/presentation/Power9_Office_Lab2'
screens=[
('S01 Hôm nay','Scaffold, AppBar64, vùng cuộn664, Navigation72. Content lề16, gap16; progress và danh sách Card.','AppBar/home; Navigation/home; Card/default,done; Button/filled,outline.','Gốc1/3; sau thêm1/4; check-in2/3; sau phiên2/4; đổi lịch18:00; sau xóa0/3.','Chạm Checkin ghi nhận; Hoàn tác phục hồi. Khám phá và Tiến độ là lối tắt; chạm Tổng kết mở existing detail.','Tab Hôm nay; S05/S08 từ lối tắt; existing S06 từ hoạt động. Sau lưu hoặc ghi nhận quay về đúng snapshot nguồn.','Nội dung có thể dài hơn viewport, phải cuộn để tới CTA; không giảm cỡ chữ hoặc đè Navigation. Thay tổng/giờ chỉ sau thành công.'),
('S02 Ăn uống','AppBar64, content cuộn664, Navigation72. Tiêu đề, mô tả, hướng dẫn3bước, CTA và xem tiến độ.','AppBar/home; Navigation/eat; content cards; Button/filled,outline.','Default và snapshot sau ghi nhận bữa trưa; Loading/Error/Empty cấp màn là mở rộng triển khai, chưa có đầy đủ snapshot.','Đã thực hiện tạo occurrence hoàn thành; Xem tiến độ mở lịch sử. Chặn ghi trùng trong app thực.','Tab Ăn uống; ghi nhận mở S08 có bản ghi bữa trưa; Back quay nguồn.','Giữ từng bước dễ đọc, body16/24; không suy ra dinh dưỡng hoặc dữ liệu sức khỏe từ check-in.'),
('S03 Thư giãn','AppBar64, content664, Navigation72. Nhóm, tên, hướng dẫn, timer, trạng thái và các CTA.','AppBar/home; Navigation/mind; Button/default; Dialog/confirmation.','Idle03:00; active/paused02:15; finished00:00; early end ghi45giây; overlay active và paused riêng.','Start, pause, resume, end, record. Rời phiên mở overlay; Ở lại đóng đúng nguồn; bỏ phiên không tạo bản ghi.','Tab Thư giãn; ghi nhận tới S08 với tổng2/4; Back tới Home sau phiên. Nhánh early-end có Home/history45giây riêng.','Prototype dùng snapshot. Flutter phải dựa monotonic clock/elapsed time, xử lý app background và pause. Không ghi đủ3phút khi kết thúc sớm.'),
('S04 Kết nối','AppBar64, content664, Navigation72. Mô tả ngắn,2activity Card, ghi chú tự nguyện.','AppBar/home; Navigation/tribe; Card/default,pressed.','Danh sách đi bộ và trò chuyện; chi tiết/lịch có dữ liệu riêng cho từng hoạt động.','Chạm thẻ mở đúng chi tiết. Ứng dụng không tự gửi lời mời hoặc thông tin cho đồng nghiệp.','Tab Kết nối; đi bộ hoặc trò chuyện tới template S06 và S07.','Card và nhãn có vùng bấm lớn; không dùng cùng tên đi bộ cho hoạt động trò chuyện. Tự nguyện là nội dung bắt buộc.'),
('S05 Khám phá','AppBar64, vùng cuộn736. TextField,3filter48, tiêu đề nhóm và9DiscoverGroup. Lề16; mỗi nhóm Auto Layout.','AppBar/back; TextField/filled; DiscoverGroup18variants; Card; Empty/discover.','Tất cả;≤5ẩn hoạt động10phút;≤10; từng nhóm Collapsed/Expanded; empty và reset.','Chạm Header mở/thu gọn; thẻ/mũi tên vào detail. Filter áp dụng thời lượng. Prototype tìm kiếm dùng trạng thái mẫu, không phải gõ tự do.','Từ S01; chi tiết đi bộ theo nguồn All/≤5/≤10. Back giữ filter, expanded state và vị trí cuộn; Reset về danh sách.','Header≥48; body16,label14; card dài wrap. Trên412content rộng380. Semantics trong app phải thông báo expanded/collapsed. Không để arrow nhỏ là vùng bấm duy nhất.'),
('S06 Chi tiết thói quen','AppBar64, content736. Nhóm, tên, thời lượng, mục đích,3bước, ghi chú và CTA.','AppBar/back; Card; Button/filled. Template new/existing, dữ liệu theo activityId.','New chọn lịch; existing Tổng kết có Đổi lịch;9nhóm có hoạt động/tên/thời lượng riêng.','New mở lịch; existing mở edit. Không đổi nút thêm thành hoàn thành rồi tự phục hồi thay cho điều hướng thật.','Từ S05 hoặc S04; existing từ S01. Back về đúng nguồn, giữ query/filter. Hủy form quay về detail tương ứng.','Tên hoạt động có thể2–3dòng, không ellipsis khi quyết định lịch. Nội dung hướng dẫn cuộn, CTA không thu nhỏ.'),
('S07 Lịch thói quen','AppBar64; content736cuộn. Card hoạt động, ngày, nhắc, giờ24h, quiet hours, feedback, nút Lưu/Hủy.','AppBar/back; TextField/filled,error; Button/default,loading; Error/form.','Create12:00; edit18:00; validation, saving, error, retry; ngủ21:30. Cùng một tác vụ giữ cùng tên/ngày/giờ.','Bật nhắc cần giờ hợp lệ; tắt nhắc không bắt giờ. Lưu bất đồng bộ; chặn gửi lặp. Lỗi giữ draft. Hủy không ghi.','S06 hoặc S10 vào; thành công về Home giờ mới hoặc màn ngủ; Hủy/Back về nguồn. F03 lỗi vẫn giữ17:30trên Home.','App thực cần keyboard inset, scroll tới lỗi đầu, focus và nhãn. Prototype chọn giờ là snapshot, chưa có time picker thật.18:00–08:00chỉ hạn chế thông báo, không cấm lưu lịch.'),
('S08 Tiến độ','AppBar64; content736. Ngày, progress, nhóm đã/chưa hoàn thành, cards, privacy và action.','AppBar/back; Card/default,done; Empty/history; Dialog/destructive; Button/text.','1/3gốc;1/4sau thêm;2/3check-in;2/4phiên;45giâyearly;0/3empty sau xóa;18:00sau đổi.','Xem lại; Undo; Xóa bản ghi mở overlay. Giữ lại đóng không đổi dữ liệu; Xóa chỉ xóa completion, không xóa lịch.','Từ Home hoặc ghi nhận. Back về nguồn đúng snapshot. Empty Khám phá mở S05.','Mẫu dữ liệu phải khớp Home. Phân biệt empty history với không có lịch. Tiến độ riêng tư, không xếp hạng hoặc điểm sức khỏe.'),
('S09 Góc làm việc','AppBar64, content736. Nhóm, mô tả,3mục checklist và CTA.','AppBar/back; Card/checklist; Button/filled.','Default và Đã ghi nhận kiểm tra.','Kiểm tra màn hình, tư thế và bàn/lối đi; CTA phản hồi đã kiểm tra.','Từ mục liên quan trong nhóm tư thế/không gian; Back về Khám phá.','Tính một activity occurrence; không tự tính hoàn thành hai nhóm. App thực cần toggle semantics; không cảm biến hoặc chẩn đoán.'),
('S10 Ngủ và phục hồi','AppBar64, content736. Mô tả,2gợi ý, ghi chú và nút chọn giờ.','AppBar/back; content Card; Button/filled.','Default, form đúng Chuẩn bị nghỉ tối21:30, xác nhận đã đặt.','Chọn giờ nhắc mở S07 với dữ liệu của hoạt động này; quiet hours vẫn áp dụng.','Từ mục liên quan trong nhóm ngủ; Hủy form về S10; Back về Khám phá.','Không suy ra thời gian ngủ, chất lượng ngủ hay trạng thái đã ngủ đủ. Dùng nhắc do người dùng chủ động đặt.')
]
text='''# Bàn giao triển khai Power9 Office Routine

Ngày26/10/2026. Đây là đặc tả theo Figma hiện hành `MTv5qJbn065VYJQIXausoq`, không phải app Flutter đã chạy. Ba persona chính ngang nhau: Huy28, Mai24, Linh39, đều giả định.10màn chức năng,3starting point,323reactions được kiểm tra cấu trúc; chưa có user test hoặc peer handoff test.

## Quy ước triển khai chung

Base360×800; kiểm tra412×800. Content rộng viewport trừ32, typography không scale nhỏ. Cấu trúc Scaffold/SafeArea, AppBar64, bottom Navigation72chỉ trên S01–S04; nội dung cuộn giữa hai vùng cố định. Dùng lề16, gap12/16, CTA52, target≥48, body16/24 và label14/20.

Form giữ draft riêng với dữ liệu đã lưu. Lưu lỗi không thay Home; retry idempotent theo activityId+occurrenceDate. Lưu lịch không đồng nghĩa hoàn thành. Đổi giờ không nhân bản hoạt động. Completion và schedule là hai loại dữ liệu khác nhau; xóa completion giữ schedule.

Ngày mẫu26/10/2026, timezoneAsia/Saigon. Homegốc1/3: Viết một việc có ý nghĩa09:00đã xong, Đi bộ giữa giờ10:00, Tổng kết17:30. F01thêm đi bộ12:00thành1/4. F03đổi17:30sang18:00vẫn1/3. Quiet hours18:00–08:00không phát thông báo, vẫn lưu hoạt động.

Ứng dụng thực cần text scaling, TalkBack semantics, focus order, keyboard inset, xử lý ngày giờ và vòng đời. Prototype chỉ mô phỏng lựa chọn mẫu. Không đặt ngưỡng cắt chữ cứng cho nội dung quan trọng; wrap và scroll. Không đưa mãS01vào UI.

'''
for row in screens:
 text+='## '+row[0]+'\n\n'
 for label,value in zip(['Layout','Components','States','User interactions','Navigation','Important UI constraints'],row[1:]):text+='### '+label+'\n\n'+value+'\n\n'
text+='''## Mapping token sang Flutter

| Figma token hoặc style | Giá trị | Flutter dự kiến |
| --- | --- | --- |
|color/surface|#F8F9FF|ColorScheme.surface / scaffoldBackgroundColor|
|color/surface-container-lowest|#FFFFFF|P9Colors.surfaceCard|
|color/surface-container-low|#EFF4FF|ColorScheme.surfaceContainerLow|
|color/surface-container|#E5EEFF|ColorScheme.surfaceContainer|
|color/primary|#004287|P9Colors.primaryStrong|
|color/primary-container|#1E5AA8|ColorScheme.primary|
|color/on-surface|#031C36|ColorScheme.onSurface|
|color/on-surface-variant|#424751|ColorScheme.onSurfaceVariant|
|color/outline|#737782|ColorScheme.outline|
|color/outline-variant|#C2C6D3|ColorScheme.outlineVariant|
|color/error|#BA1A1A|ColorScheme.error|
|color/error-container|#FFDAD6|ColorScheme.errorContainer|
|P9/Display|24/32Bold|TextTheme.headlineSmall|
|P9/Headline|20/28SemiBold|TextTheme.titleLarge|
|P9/Body|16/24Regular|TextTheme.bodyLarge|
|P9/Body Medium|16/24Medium|TextTheme.titleMedium|
|P9/Label|14/20Medium|TextTheme.labelLarge|
|P9/Helper|14/20Regular|TextTheme.bodyMedium|
|spacing/4,8,12,16,24,32|dp|P9Spacing constants|
|spacing/48,52|target/CTA|P9Sizes.minTarget / primaryButtonHeight|
|radius/8,12,16,24,999|dp|BorderRadius constants|
|P9/Card shadow|offset0,2;blur8;opacity0.06|BoxShadow|

12màu semantic alias primitive cùng tên trongP9Primitives. App phải giữ đúng vai trò, không suy ra palette bằngColorScheme.fromSeedrồi bỏ các giá trị đã chốt. Token white của CTA dùng surface-container-lowest.

## Mapping component sang widget

| Figma family | Flutter dự kiến | Biến thể và hành vi |
| --- | --- | --- |
|P9/Button|FilledButton,OutlinedButton,TextButton|kind filled/outline/text;default/pressed/disabled/loading|
|P9/TextField|TextFormField|default/focused/filled/error/disabled|
|P9/Card|Card+InkWell|default/pressed/done;Title+Meta|
|P9/Navigation|NavigationBar|selected home/eat/mind/tribe|
|P9/AppBar|AppBar|home/back;logo gốc;target Back48|
|P9/Dialog|AlertDialog hoặc modal|confirmation/destructive;đóng về đúng origin|
|P9/Loading|CircularProgressIndicator hoặc skeleton|screen/list;phải có đường kết thúc|
|P9/Empty|Custom widget|icon,message,action;discover/history/today|
|P9/Error|Custom error widget|screen/form;giữ dữ liệu,Retry|
|P9/DiscoverGroup|ExpansionTile hoặc custom widget|Group01–09×Collapsed/Expanded;Header48;card và arrow cùng đích|

## Giới hạn và bước kiểm chứng khi hiện thực

Timer trong Figma là snapshot03:00/02:15/00:00,early-end45giây. Flutter cần clock thật, pause/resume/background đúng; chưa có backend hoặc notification integration. Tìm kiếm/nhập giờ prototype là lựa chọn mẫu. Cần người khác dựng thử một màn chỉ từ handoff, kiểm tra TalkBack/text scaling và chạy usability task để đo những mục tiêu thời gian. Chưa khẳng định các bước này đã làm.

Nguồn: `assets/figma/office-checkpoint.json`, `docs/FIGMA-FINAL-AUDIT.md`, `assets/figma/office-accordion-audit.json`; https://docs.flutter.dev/cookbook/design/themes .
'''
# Add spaces around measurement tokens in prose without altering colors or identifiers.
for a,b in [('Ngày26','Ngày 26'),('Huy28','Huy 28'),('Mai24','Mai 24'),('Linh39','Linh 39'),('10màn','10 màn'),('3starting point','3 starting point'),('323reactions','323 reactions')]:text=text.replace(a,b)
dest=root/'handoff/flutter-handoff.md';legacy=root/'handoff/legacy-family-handoff.md'
if not legacy.exists():shutil.copy2(dest,legacy)
dest.write_text(text,encoding='utf8')
copy=out/'sources/handoff/flutter-handoff.md';copy.parent.mkdir(parents=True,exist_ok=True);copy.write_text(text,encoding='utf8')
(root/'.build/presentation/office-2026/handoff-screens.json').write_text(__import__('json').dumps(screens,ensure_ascii=False,indent=2),encoding='utf8')
print('Office handoff:10screens x6sections;2mapping tables')
