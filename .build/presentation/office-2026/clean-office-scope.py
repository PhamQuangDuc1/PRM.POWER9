from pathlib import Path
import json,shutil,re
root=Path('D:/PRM393/PRM.POWER9');build=root/'.build/presentation/office-2026';oldout=root/'output/presentation/Power9_Office_Lab2';out=root/'output/presentation/Power9_Office_Lab2_Cap_Nhat'
out.mkdir(parents=True,exist_ok=True)
if not (out/'sources').exists():shutil.copytree(oldout/'sources',out/'sources')
fig='https://www.figma.com/design/MTv5qJbn065VYJQIXausoq';stitch='https://stitch.withgoogle.com/projects/2176700449127941467';repo='https://github.com/PhamQuangDuc1/PRM.POWER9'
intro=f'Figma: {fig}\n\nStitch: {stitch}\n\nGitHub: {repo}\n'
files={
'README.md':'''# Power9 Office Routine

Ứng dụng Android tiếng Việt giúp nhân viên văn phòng tự chọn, lên lịch và ghi nhận hoạt động ngắn trong ngày làm việc. Ba persona chính ngang nhau: Huy 28 tuổi, Mai 24 tuổi và Linh 39 tuổi; đều là persona giả định.

'''+intro+'''
## Phạm vi hiện hành

9 nhóm: Move Often, Sit Smart, Eat Well, Sleep Well, Manage Stress, Healthy Space, Social Bonds, Purpose, Work–Life Balance. Một ứng dụng chung, không chọn persona và không ép hoàn thành 9/9 mỗi ngày.

Figma có 6 page, 10 màn chức năng, 3 starting point; bản 360 và 412 px. Thư viện có 37 biến, 6 text style, 1 effect style, 10 component families và 53 variants. Cả 9 nhóm Khám phá có mở/thu gọn. Kiểm tra 323 reactions không phát hiện đích hỏng.

## Tài liệu và bằng chứng

- [Persona](ux/persona.md), [IA và ba flow](ux/user-flow.md).
- [Brief](design/DESIGN.md), [10 màn](design/screen-spec.md), [quyết định thiết kế](design/design-decisions.md).
- [AI log](ai/ai-design-log.md), [3 phản biện](ai/critiques/OFFICE-3-MAIN-CRITIQUES.md), [before/after](docs/SLIDE-3-VONG-PHAN-BIEN.md).
- [Design system và component](design/component-spec.md), [audit Figma](docs/FIGMA-FINAL-AUDIT.md).
- [Flutter handoff 10 màn và hai mapping](handoff/flutter-handoff.md).
- [Slide cập nhật](output/presentation/Power9_Office_Lab2_Cap_Nhat/Power9_Office_Lab2_Cap_Nhat.pptx), [kịch bản demo](output/presentation/Power9_Office_Lab2_Cap_Nhat/Power9_Office_Kich_Ban_Cap_Nhat.docx).

## Xác nhận nguồn và giới hạn

Người dùng xác nhận ngày 27/10/2026 đã gửi nguyên văn 100% các prompt Office do trợ lý cung cấp trên dự án Stitch mới. Giữ nguyên khối prompt trong ai/prompts/OFFICE-*.md; ảnh Stitch, render kiểm chứng Chrome và Figma được ghi nguồn riêng.

Timer/tìm kiếm/giờ nhắc là mô phỏng trạng thái. Chưa có user test, TalkBack, peer handoff test hoặc ứng dụng Flutter/backend. Các mục tiêu thời gian là mục tiêu thiết kế, chưa đo thực tế. Thay đổi workspace không tự động được đẩy lên GitHub.
''',
'design/design-decisions.md':'''# Quyết định thiết kế Power9 Office Routine

Ba persona chính ngang nhau: Huy 28, Mai 24, Linh 39. Các quyết định dưới đây phản ánh bản Office hiện hành.

| Mã | Quyết định | Lý do và phản biện | Bằng chứng |
| --- | --- | --- | --- |
| D01 | Một app, ba persona ngang nhau | Nhu cầu khác nhau trong cùng môi trường văn phòng; không cần màn chọn persona | ux/persona.md; Figma 01 |
| D02 | 9 nhóm trong Khám phá, tiến độ theo việc tự chọn | Nhóm nội dung không phải chỉ tiêu 9/9 mỗi ngày | S01/S05/S08 |
| D03 | Chấp nhận sửa cấu hình font | C01: serif khác brief; Nielsen H4 Consistency and standards | font-verification.json; ảnh S07 trước/sau Chrome |
| D04 | Chấp nhận giảm banner và thẻ phụ | C02: Linh cần xác nhận tên hoạt động/ngày giờ nhanh; Nielsen H8 Minimalist design | OI01/OI02 before/after |
| D05 | Điều chỉnh state AI, giữ cùng dữ liệu | C03: form lỗi đổi hoạt động; Mai cần thử lại mà không nhập lại | S07 error/retry; office-behavior-audit.json |
| D06 | Lỗi giữ draft, Hủy giữ dữ liệu đã lưu | Visibility of system status, User control, Error recovery | F01/F03; overlay và loading-result |
| D07 | Từ chối metric sức khỏe thiếu nguồn | Không có cảm biến hay dữ liệu để đưa nhịp tim/điểm ước tính vào UI | OFFICE-OI03-expanded-review.md |
| D08 | Mở/thu gọn đồng nhất cả 9 nhóm | H3 User control và H4 Consistency; phản hồi cùng thao tác phải nhất quán | DiscoverGroup 18 variants; 27 kiểm tra trên 3 bộ lọc |
| D09 | Dùng token, Auto Layout và instance | Thay đổi nhất quán, không detach để sửa nhãn | 37 variables; 10 families/53 variants |
| D10 | Tiến độ riêng tư; quiet hours không cấm lưu lịch | Tránh áp lực xếp hạng; Linh chủ động giờ nhắc | S07/S08; 17:30 sang 18:00 vẫn 1/3 |

## Accessibility và responsive

Các cặp token đã tính theo WCAG: #031C36/#F8F9FF =16.34:1; #FFFFFF/#1E5AA8 =6.81:1; #424751/#FFFFFF =9.33:1; #BA1A1A/#FFDAD6 =5.00:1. Đây là các cặp cụ thể, không phải chứng nhận toàn bộ WCAG.

CTA52, Back/header48; body16/24 và label14/20. Kiểm tra bố cục 360/412 không thấy text overflow trong bộ kiểm tra. Trạng thái có chữ, dấu kiểm và chỉ báo ngoài màu. Chưa kiểm thử TalkBack, text scaling hay người dùng thực.

Nguồn: assets/figma/office-checkpoint.json; assets/figma/office-accordion-audit.json; docs/FIGMA-FINAL-AUDIT.md; https://www.nngroup.com/articles/ten-usability-heuristics/ ; https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html .
''',
'ai/ai-design-log.md':'''# AI design log Power9 Office Routine

'''+intro+'''
## Xác nhận prompt

Ngày 27/10/2026, người dùng xác nhận 100% các prompt Office đã được gửi nguyên văn theo nội dung trợ lý cung cấp trên dự án Stitch mới. Đây là xác nhận của người thực hiện. Khối prompt trong ai/prompts/OFFICE-*.md được giữ nguyên; không sửa lại lời prompt theo kết quả.

## Công cụ và đầu ra

Google Stitch tạo wireframe/UI nguồn; người dùng cung cấp ZIP và ảnh. Codex hỗ trợ phân tích, phản biện, kiểm chứng HTML/font, dựng lớp native Figma, nối prototype và tài liệu. Không gán tên model nền của Stitch khi chưa có thông tin công cụ xác nhận.

## Tạo UI từ wireframe

Nguồn: assets/stitch/office-final/; ai/prompts/OFFICE-UI01-from-final-wireframe.md; assets/stitch/office-ui/UI01/. Brief xác định Android tiếng Việt, 3 persona chính ngang nhau, 10 màn, 9 nhóm, 360/412, logo gốc và phong cách xanh biển.

## OI01 Typography

- Vấn đề C01: font render serif khác brief; lỗi array gộp toàn danh sách fallback thành một font-name.
- Prompt sửa: ai/prompts/OFFICE-OI01-font-root-fix.md.
- BEFORE/AFTER kiểm chứng Chrome: output/office-ui-font-check/S07-before.png và S07-after-local-fix.png; font-verification.json ghi font render thật.
- Ảnh Stitch sau sửa: assets/stitch/office-ui/OI01-after/.
- Quyết định: sửa cấu hình, giữ nhiệm vụ/bố cục; không dùng ảnh style board để chứng minh font render. Không gọi ảnh Chrome cục bộ là output Stitch.

## OI02 Mật độ nội dung

- Vấn đề C02: ảnh/banner/thẻ phụ ngoài nhiệm vụ, tên hoạt động S07 bị cắt.
- Prompt sửa: ai/prompts/OFFICE-OI02-content-density.md.
- BEFORE: assets/stitch/office-ui/OI01-after/; AFTER: assets/stitch/office-ui/OI02-after/.
- Quyết định: bỏ nội dung phụ, giữ tên và CTA. Review thấy Home thiếu hàng hoàn thành so với Tiến độ, chuyển xử lý dữ liệu ở OI03; không bịa số đo thời gian giảm.

## OI03 Hoàn thành nhiệm vụ và phục hồi

- Vấn đề C03: thiếu đường kết thúc, error đổi tên/ngày/giờ, phiên nghỉ lệch thời lượng, metric không có nguồn.
- Prompt sửa: ai/prompts/OFFICE-OI03-task-recovery.md.
- BEFORE: OI02-after; output mở rộng và review: assets/stitch/office-ui/OI03-expanded/, ai/critiques/OFFICE-OI03-expanded-review.md.
- AFTER hoàn thiện: Figma 03/06. Cùng hoạt động giữ dữ liệu xuyên form/saving/error/retry; Home và Tiến độ đồng bộ. Bỏ metric không có dữ liệu đo.
- Kiểm tra: 15 điều kiện điều hướng/dữ liệu và nhánh xóa0/3; office-behavior-audit.json, office-deletion-audit.json.

## Hoàn thiện accordion

Người dùng phát hiện chỉ nhóm07 mở sẵn. Đã dựng DiscoverGroup18variants, áp dụng 9 nhóm trên All/≤5/≤10 và UI360/412. Đã kiểm tra 27 nhóm prototype chuyển trạng thái và giữ đích của thẻ/mũi tên; đúng 3 starting point; 323 reactions, 0 đích hỏng. Nguồn: office-accordion-audit.json và office-checkpoint.json.

## Giới hạn

Kiểm tra trên lớp Figma và dữ liệu mẫu, chưa phải usability test. Timer, tìm kiếm và nhập giờ là mô phỏng. Chưa có app Flutter/backend, TalkBack hoặc peer handoff test. Mục tiêu thời gian chưa được đo với người dùng.
''',
'docs/CONTINUE.md':'''# Mốc tiếp tục Power9 Office Routine

'''+intro+'''
Đã có 6 page Figma, 10 màn, 3 flow; accordion đủ9nhóm. Thư viện37variables,6textstyles,1effectstyle,10families/53variants. Kiểm tra323reactions không có đích hỏng. Bản360/412 và states nằm trên page03.

Người dùng xác nhận 100% prompt Office đã gửi nguyên văn trên Stitch mới ngày27/10/2026. Phạm vi chỉ3persona chính ngang nhau: Huy28, Mai24, Linh39.

Đọc assets/figma/office-checkpoint.json, docs/FIGMA-FINAL-AUDIT.md, handoff/flutter-handoff.md trước khi sửa. Không rebuild các page hợp lệ. Timer là snapshot; chưa có user test/Flutter app. Bộ slide cập nhật dùng link web và trình bày phản biện trực tiếp trên slide06/07.
''',
'docs/FIGMA-OFFICE-STATUS.md':'''# Trạng thái Figma Office

'''+intro+'''
| Page | Nội dung |
| --- | --- |
|01 User Flow|3persona chính ngang nhau,IA,9nhóm,3flow và link prototype|
|02 Wireframe|10màn editable360×800|
|03 Final UI|10màn chính,states,20trạng thái nguồn,10bản412|
|04 Design System|37variables,6textstyles,1effectstyle|
|05 Components|10families/53variants;instance và bindings;DiscoverGroup18variants|
|06 Prototype|3startingpoints,323reactions,0đích hỏng trong kiểm tra cấu trúc|

Header nhóm đều mở/thu gọn; thẻ và mũi tên dẫn đúng hoạt động;≤5ẩn hoạt động10phút. Back giữ nguồn, filter và dữ liệu; có overlay, loading-result, retry, undo và xóa completion.

Chi tiết: docs/FIGMA-FINAL-AUDIT.md và assets/figma/office-checkpoint.json. Timer/tìm kiếm/giờ nhắc là snapshot; chưa có user test hoặc app/backend.
''',
'design/component-spec.md':'''# Component Power9 Office Routine

Page05 của Figma hiện hành có10families và53variants. Màn dùng instance, Auto Layout; màu/padding/gap/radius dùng variables. Font Be Vietnam Pro; nguồn IDs trong assets/figma/office-checkpoint.json.

| Family | Variants thực | Số |
| --- | --- | --- |
|Button|filled/outline/text × default/pressed/disabled/loading|12|
|TextField|default/focused/filled/error/disabled|5|
|Card|default/pressed/done|3|
|Navigation|home/eat/mind/tribe|4|
|AppBar|home/back|2|
|Dialog|confirmation/destructive|2|
|Loading|screen/list|2|
|Empty|discover/history/today|3|
|Error|screen/form|2|
|DiscoverGroup|01–09 × Collapsed/Expanded|18|

CTA cao52; Back/header≥48; body16/24,label14/20. Header accordion dùng CHANGE_TO; thẻ/mũi tên dùng NAVIGATE đến đúng detail. Giữ cùng tên layer giữa states để navigation overrides không mất.≤5giữẩn hoạt động10phút.

Dialog rời phiên đóng về đúng active/paused. Xóa bản ghi giữ lịch; Giữ lại không đổi completion. Error giữ draft, Retry có đường kết thúc. Bản Button loading không phát gửi lặp.

Không detach component để sửa nội dung. TextField error dùng cho validation, Error/form cho lỗi lưu. Tham chiếu: handoff/flutter-handoff.md và docs/FIGMA-FINAL-AUDIT.md.
''',
'assets/stitch.md':'''# Bằng chứng Stitch Power9 Office Routine

'''+intro+'''
Nguồn hiện hành: assets/stitch/office-final/ (10wireframe), office-ui/ (UI01,OI01,OI02,OI03), office-handoff-final/ (10OI02+13stateOI03). Người dùng xác nhận các prompt Office đã gửi nguyên văn100% ngày27/10/2026.

Giữ ảnh và ZIP gốc Office để chứng minh before/after. Kiểm chứng Chrome cục bộ nằm ở output/office-ui-font-check/, phải ghi nguồn riêng. Mục lục phản biện: docs/SLIDE-3-VONG-PHAN-BIEN.md; toàn văn: ai/critiques/OFFICE-3-MAIN-CRITIQUES.md.
''',
'assets/figma.md':'''# Bằng chứng Figma Power9 Office Routine

'''+intro+'''
6page hiện hành,10màn chính,3startingpoints. IDs và kết quả thực trong assets/figma/office-checkpoint.json; ảnh dùng cho trình bày có node/provenance trong sources/evidence-provenance.json của gói cập nhật.

Kiểm tra bố cục360/412, dữ liệu flow và accordion được ghi riêng trong office-six-page-audit.json,office-behavior-audit.json,office-accordion-audit.json.323reactions,0đích hỏng không thay cho usability test. Đọc docs/FIGMA-FINAL-AUDIT.md.
'''
}
names=['Hôm nay','Ăn uống','Thư giãn','Kết nối','Khám phá','Chi tiết thói quen','Lịch thói quen','Tiến độ','Góc làm việc','Ngủ & phục hồi']
check=json.loads((root/'assets/figma/office-checkpoint.json').read_text(encoding='utf8'))
for key,title,sourcepath in [('ui-selection.md','Bộ UI Office được chọn','assets/stitch/office-handoff-final/main/manifest.json'),('wireframe-selection.md','Bộ wireframe Office được chọn','assets/stitch/office-final/')]:
 text='# '+title+'\n\nNguồn: '+sourcepath+'\n\n| Mã | Màn | Figma node |\n| --- | --- | --- |\n'
 for i,name in enumerate(names):
  sid='S'+str(i+1).zfill(2);node=check['ui']['screens'][sid] if key.startswith('ui-') else check['wireframes'][sid]['id'];text+=f'|{sid}|{name}|{node}|\n'
 text+='\nBase360×800, kiểm tra412. States/dialog không cộng vào10màn chức năng. Giữ token, instances, nội dung cuộn và nguồn Back.\n';files['design/'+key]=text
for name,title in [('figma-next-steps.md','Hướng dẫn bảo trì Figma'),('lab2-completion-plan.md','Danh sách kiểm tra bài Office'),('lab2-status.md','Trạng thái bài Office'),('stitch-to-figma-guide.md','Quy trình Stitch và Figma Office'),('evidence-register.md','Mục lục bằng chứng Office')]:
 files['docs/'+name]='# '+title+'\n\n'+intro+'\nPhạm vi:3persona chính ngang nhau,9nhóm văn phòng,10màn,3flow. Đã dựng đủ6page và nối prototype; không tạo lại các page hợp lệ.\n\nNguồn hiện hành: [AI log](../ai/ai-design-log.md), [before/after](SLIDE-3-VONG-PHAN-BIEN.md), [audit](FIGMA-FINAL-AUDIT.md), [component](../design/component-spec.md), [handoff](../handoff/flutter-handoff.md).\n\nTrước khi chấm: thử quyền link, tập3flow, kiểm tra nguồn web trên slide. Prompt đã được người dùng xác nhận nguyên văn100%; timer/tìm kiếm/giờ là snapshot, chưa có user test hay app Flutter.\n'
files['docs/language-conventions.md']='# Quy ước ngôn ngữ Office\n\nTên sản phẩm Power9 Office Routine. Nội dung tiếng Việt có dấu; tên kỹ thuật component/token giữ để đối chiếu Flutter. Huy28,Mai24,Linh39là ba persona chính ngang nhau. Dùng nhãn trạng thái rõ; không đưa mãS01–S10vào nội dung ứng dụng.\n'
files['handoff/office-figma-handoff.md']='# Handoff Power9 Office Routine\n\nBản hiện hành đầy đủ tại [flutter-handoff.md](flutter-handoff.md):10màn,6mục/màn và hai bảng mapping. Nguồn Figma: '+fig+' .\n'
for rel,text in files.items():(root/rel).write_text(text,encoding='utf8')
# Keep prompt bodies byte-for-byte unchanged; replace only their status preambles.
for p in (root/'ai/prompts').glob('OFFICE-*.md'):
 s=p.read_text(encoding='utf8');idx=s.find('```')
 confirmation='Người dùng xác nhận ngày27/10/2026 đã gửi nguyên văn100% prompt Office do trợ lý cung cấp trên dự án Stitch mới. Khối prompt bên dưới được giữ nguyên.\n\n'
 if idx>=0:s=s.splitlines()[0]+'\n\n'+confirmation+s[idx:]
 else:s=s.splitlines()[0]+'\n\n'+confirmation+'\n'.join(s.splitlines()[1:])
 p.write_text(s,encoding='utf8')
# Remove stale confirmations/status from the actual presentation sources.
for p in [root/'docs/FIGMA-FINAL-AUDIT.md',root/'docs/SLIDE-3-VONG-PHAN-BIEN.md',root/'ai/critiques/OFFICE-3-MAIN-CRITIQUES.md']:
 s=p.read_text(encoding='utf8');s=s.replace('Không chạy lại các script cũ FamilyRoutine.','');s='# '+s.splitlines()[0].lstrip('# ')+'\n\nNgười dùng xác nhận27/10/2026: các prompt Office đã gửi nguyên văn100% trên Stitch mới. Các nhận xét dưới đây ghi theo mốc đánh giá; kết quả hiện hành xem office-checkpoint.json và FIGMA-FINAL-AUDIT.md.\n\n'+'\n'.join(s.splitlines()[1:]);p.write_text(s,encoding='utf8')
for rel in ['docs/OFFICE-UPDATE-GUIDE.md']:
 p=root/rel;s=p.read_text(encoding='utf8');s='\n'.join(line for line in s.splitlines() if 'Family' not in line);p.write_text(s+'\n',encoding='utf8')
# Sync the clean current sources; retain genuine Office before/after images.
for p in (out/'sources').rglob('*.md'):
 rel=p.relative_to(out/'sources');actual=root/rel
 if actual.exists() and str(rel)!='README.md':shutil.copy2(actual,p)
(out/'sources/README.md').write_text('# Nguồn Power9 Office Routine\n\n'+intro+'\nPrompt đã được người dùng xác nhận nguyên văn100%. Nguồn bấm trên slide dùng HTTPS; các bản sao trong sources giúp đọc offline. Giữ before/after Office và ghi rõ Stitch/Chrome/Figma. Thay đổi workspace chưa tự động đăng lên GitHub.\n',encoding='utf8')
print('Current Office documentation cleaned; prompt bodies preserved; sources synced')
