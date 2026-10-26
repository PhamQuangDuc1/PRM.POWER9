from pathlib import Path
from zipfile import ZipFile,ZIP_DEFLATED
from lxml import etree as E
from urllib.parse import unquote
import json,hashlib,sys,shutil
sys.stdout.reconfigure(encoding='utf8')
root=Path('D:/PRM393/PRM.POWER9');out=root/'output/presentation/Power9_Office_Lab2';build=root/'.build/presentation/office-2026';sources=out/'sources'
pptx=out/'Power9_Office_Lab2_12_Slides.pptx';docx=out/'Power9_Office_Kich_Ban_Thuyet_Trinh_Va_Demo.docx'
assert pptx.exists() and docx.exists()
readme='''# Bộ trình bày Power9 Office Routine

Hoàn thiện27/10/2026 theo hai tài liệu hướng dẫn PRM323 Lab2 được cung cấp.

## Cách sử dụng

1. Giải nén toàn bộ gói, giữ PowerPoint, Word và thư mục sources cạnh nhau.
2. Mở Power9_Office_Lab2_12_Slides.pptx. Có12slide, nguồn bấm được ở chân mỗi slide, speaker notes có lời nói và nguồn chi tiết. Slide05có toàn văn bản prompt lưu trong notes.
3. Mở Power9_Office_Kich_Ban_Thuyet_Trinh_Va_Demo.docx để tập bài nói10phút, demo5phút và hỏi đáp. Thời gian là phân bổ dự kiến, chưa đo thực tế.
4. Slide11có3link bắt đầu prototype. Kịch bản chỉ đúng nhãn nút, đường lỗi/Thử lại, overlay và kết quả cần thấy. Dùng nhánh45giây để tránh chờ3phút.
5. Khi mở nguồn cục bộ từ slide, nếu PowerPoint hỏi cho phép mở tệp, chỉ mở các tệp trong sources của gói này.

## Liên kết dự án do người dùng cung cấp

- Stitch: https://stitch.withgoogle.com/projects/2176700449127941467
- Figma: https://www.figma.com/design/MTv5qJbn065VYJQIXausoq/Untitled?node-id=10-14
- GitHub: https://github.com/PhamQuangDuc1/PRM.POWER9

## Phạm vi và giới hạn

Hồ sơ theo Office Routine,3persona chính ngang nhau,10màn chức năng,3flow,10componentfamilies/53variants. Kiểm tra323reactions không có đích hỏng là kiểm tra cấu trúc; chưa thay cho playthrough với người dùng. Timer/tìm kiếm/giờ nhắc là mô phỏng trạng thái, chưa có app Flutter/backend.

Trước buổi chấm cần tập demo, kiểm tra quyền xem link ở cửa sổ chưa đăng nhập, đối chiếu prompt thực gửi trong Stitch. Link dự án không tự chứng minh toàn bộ lịch sử prompt; công cụ web chưa đọc được nội dung dự án Stitch. Các ảnh đã xuất có xuất xứ riêng. Bản tổng quan10UIđược lưu trước bổ sung accordion, còn ảnhACCORDION.png là cập nhật cuối.

Các tài liệu AI log và review giữ cả lịch sử. Phần hoàn thiện Figma và nguồn hiện hành được chỉ ra trong checkpoint/audit. Những thay đổi mới trong workspace chưa tự động được đẩy lên GitHub.
'''
for a,b in [('Hoàn thiện27','Hoàn thiện 27'),('12slide','12 slide'),('Slide05','Slide 05'),('Slide11','Slide 11'),('3link','3 link'),('10phút','10 phút'),('5phút','5 phút'),('45giây','45 giây'),('3phút','3 phút'),('3persona','3 persona'),('10màn','10 màn'),('3flow','3 flow'),('10componentfamilies/53variants','10 component families / 53 variants'),('323reactions','323 reactions'),('10UI','10 UI'),('ảnhACCORDION','ảnh ACCORDION')]:readme=readme.replace(a,b)
(out/'HUONG_DAN_MO_BO_TRINH_BAY.md').write_text(readme,encoding='utf8')
# Refresh copied handoff and preserve its existing repo history.
shutil.copy2(root/'handoff/flutter-handoff.md',sources/'handoff/flutter-handoff.md')
current='''\n\n## Mốc Office hoàn thiện cho slide ngày27/10/2026

Nguồn dự án người dùng cung cấp: https://stitch.withgoogle.com/projects/2176700449127941467 và https://www.figma.com/design/MTv5qJbn065VYJQIXausoq/Untitled?node-id=10-14 .

Slide dùng ba mục tiêu cải tiến khác nhau: typography (C01, kiểm chứng Chrome cục bộ), mật độ nhiệm vụ (C02, ảnh Stitch OI02), và giữ ngữ cảnh/phục hồi (C03, AFTER Figma). Giữ rõ nhãn ảnh; không gọi render cục bộ là output Stitch. Bản UI01 lưu có toàn văn nhưng chưa đối chiếu đủ chat thực gửi.

Kết quả Figma hiện hành:10màn,3startingpoints,37variables,10families/53variants,323reactions,0đích hỏng. Bổ sung accordion cho cả9nhóm có27kiểm tra theo3bộ lọc. Đây là kiểm tra cấu trúc/dữ liệu, chưa phải user test. Nguồn: assets/figma/office-checkpoint.json,office-accordion-audit.json,office-behavior-audit.json; docs/FIGMA-FINAL-AUDIT.md.
'''
for rel in ['ai/ai-design-log.md','design/design-decisions.md']:
 p=root/rel;s=p.read_text(encoding='utf8')
 if 'Mốc Office hoàn thiện cho slide ngày27/10/2026' not in s:p.write_text(s+current,encoding='utf8')
 shutil.copy2(p,sources/rel)
(sources/'README.md').write_text((sources/'README.md').read_text(encoding='utf8')+'\nGitHub dự án: https://github.com/PhamQuangDuc1/PRM.POWER9\n',encoding='utf8')
# Validate visible per-slide sources, source hyperlinks and retained notes.
ns={'a':'http://schemas.openxmlformats.org/drawingml/2006/main','p':'http://schemas.openxmlformats.org/presentationml/2006/main'}
issues=[];slide_checks=[];links=[]
with ZipFile(pptx) as z:
 for n in range(1,13):
  slide=E.fromstring(z.read(f'ppt/slides/slide{n}.xml'));texts=slide.findall('.//a:t',ns);visible=' '.join(t.text or '' for t in texts)
  rels=E.fromstring(z.read(f'ppt/slides/_rels/slide{n}.xml.rels'));hrefs=[r.attrib['Target'] for r in rels if r.attrib.get('Type','').endswith('/hyperlink')]
  assert 'Nguồn' in visible and len(hrefs)>=2
  for href in hrefs:
   links.append(href)
   if not href.startswith(('http://','https://','file:')):
    if not (out/unquote(href.replace('\\','/'))).exists():issues.append({'slide':n,'missingSource':href})
  notes=z.read(f'ppt/notesSlides/notesSlide{n}.xml');assert b'NGU' in notes
  slide_checks.append({'slide':n,'visibleSource':True,'hyperlinks':len(hrefs)})
 assert any('2176700449127941467' in x for x in links)
 assert any('MTv5qJbn065VYJQIXausoq' in x for x in links)
with ZipFile(docx) as z:
 s=E.fromstring(z.read('word/styles.xml'));d=E.fromstring(z.read('word/document.xml'))
 assert not s.findall('.//{http://schemas.openxmlformats.org/wordprocessingml/2006/main}pBdr')
 assert not d.findall('.//{http://schemas.openxmlformats.org/wordprocessingml/2006/main}pBdr')
assert not issues,issues
manifest=[]
for p in sorted(sources.rglob('*')):
 if p.is_file() and p.name!='manifest.json':manifest.append({'file':p.relative_to(out).as_posix(),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
(sources/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf8')
receipt={'date':'2026-10-27','slideCount':12,'slideSources':slide_checks,'sourceLinksMissing':issues,'docxPageCount':8,'docxRenderedWith':'Microsoft Word PDF export and packaged render_docx.py rasterizer','visualQA':'12slide images and8document pages reviewed; Title border removed; slide11spacing repaired.','limitations':['Stitch project link is user-provided; full chat/prompt history not accessible through web tool.','No anonymous Figma/GitHub access check, user test or Flutter implementation claimed.'],'outputs':[{'file':p.name,'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in [pptx,docx]]}
(build/'delivery-check.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2),encoding='utf8')
archive=root/'output/presentation/Power9_Office_Lab2_Bo_Trinh_Bay.zip'
with ZipFile(archive,'w',ZIP_DEFLATED,compresslevel=9) as z:
 for p in sorted(out.rglob('*')):
  if p.is_file():z.write(p,Path('Power9_Office_Lab2')/p.relative_to(out))
with ZipFile(archive) as z:assert z.testzip() is None
print(json.dumps({'slides':12,'documentPages':8,'sourceFiles':len(manifest),'sourceLinksMissing':issues,'zipBytes':archive.stat().st_size,'outputs':[str(pptx),str(docx),str(archive)]},ensure_ascii=False))
