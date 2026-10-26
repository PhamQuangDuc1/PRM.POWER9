from pathlib import Path
import json,shutil,hashlib,sys,re
from zipfile import ZipFile
from xml.etree import ElementTree as ET
root=Path('D:/PRM393/PRM.POWER9');build=root/'.build/presentation/office-2026';out=root/'output/presentation/Power9_Office_Lab2';sources=out/'sources'
sources.mkdir(parents=True,exist_ok=True)
files=['ux/persona.md','ux/user-flow.md','design/DESIGN.md','design/screen-spec.md','design/design-decisions.md','ai/ai-design-log.md','ai/prompts/OFFICE-UI01-from-final-wireframe.md','ai/prompts/OFFICE-OI01-font-root-fix.md','ai/prompts/OFFICE-OI02-content-density.md','ai/prompts/OFFICE-OI03-task-recovery.md','ai/critiques/OFFICE-3-MAIN-CRITIQUES.md','ai/critiques/OFFICE-OI02-after-review.md','ai/critiques/OFFICE-OI03-expanded-review.md','docs/FIGMA-FINAL-AUDIT.md','docs/SLIDE-3-VONG-PHAN-BIEN.md','assets/figma/office-checkpoint.json','assets/figma/office-behavior-audit.json','assets/figma/office-accordion-audit.json','assets/figma/office-six-page-audit.json','assets/figma/office-library-audit.json','output/office-ui-font-check/font-verification.json']
manifest=[]
def cp(src,dest,label=None):
 dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dest)
 manifest.append({'file':str(dest.relative_to(out)).replace('\\','/'),'source':label or str(src.relative_to(root)),'sha256':hashlib.sha256(dest.read_bytes()).hexdigest()})
for f in files:cp(root/f,sources/f)
for f in Path('D:/PRM393').glob('PRM323_Lab2_*.docx'):cp(f,sources/'guidelines'/f.name,f.name)
for f in ['S07-before.png','S07-after-local-fix.png']:cp(root/'output/office-ui-font-check'/f,sources/'evidence'/f)
cp(root/'assets/stitch/office-ui/OI01-after/overview-02.png',sources/'evidence/DENSITY-BEFORE.png')
cp(root/'assets/stitch/office-ui/OI02-after/overview-02.png',sources/'evidence/DENSITY-AFTER.png')
cp(root/'assets/stitch/office-ui/UI01/overview-01.png',sources/'evidence/STITCH-INITIAL.png')
cp(root/'assets/stitch/office-handoff-final/main/export-original/stitch_power9_office_routine_wireframe/office_oi02_s07_l_ch_th_i_quen/screen.png',sources/'evidence/SCHEDULE-STITCH-AFTER.png')
cp(root/'output/office-wireframe-audit/S07-360.png',sources/'evidence/WIREFRAME-S07.png')
for f in (build/'evidence').glob('*.png'):cp(f,sources/'evidence'/f.name,'Figma screenshot or saved MCP export; see evidence-provenance.json')
nodes={'S01':'27:5','S02':'27:46','S06':'27:186','S08':'27:234','FORM':'27:205','ERROR':'30:170','LEAVE-OVERLAY':'30:925','DELETE-OVERLAY':'39:2322','ACCORDION':'62:25','DESIGN-SYSTEM':'15:48','UI-OVERVIEW':'27:3','NAVIGATION':'16:113','RESPONSIVE-412':'28:396'}
prov=[]
for name,node in nodes.items():prov.append({'image':name+'.png','origin':'Figma MCP screenshot','nodeId':node,'url':'https://www.figma.com/design/MTv5qJbn065VYJQIXausoq?node-id='+node.replace(':','-'),'note':'UI-OVERVIEW and RESPONSIVE-412 were captured during earlier verified UI phase; subsequent Discover accordion/native-nav updates are shown separately.' if name in ['UI-OVERVIEW','RESPONSIVE-412'] else 'Native Figma artifact; not a generated mockup.'})
(sources/'evidence-provenance.json').write_text(json.dumps(prov,ensure_ascii=False,indent=2),encoding='utf8')
(sources/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf8')
(sources/'README.md').write_text('''# Nguồn cho bộ trình bày Power9 Office

Các slide có nguồn ngay ở chân trang. Nguồn Figma và tài liệu chính thức mở bằng URL; nguồn cục bộ mở tương đối trong thư mục sources của gói này. Giữ PPTX và sources cạnh nhau khi giải nén.

Ảnh Figma lấy từ node thật; xem evidence-provenance.json. Ảnh Stitch và render kiểm chứng font được ghi nhãn riêng. UI-OVERVIEW là mốc hoàn thiện 10 UI trước khi bổ sung interactive accordion; ACCORDION.png là ảnh cập nhật cuối. Không trình bày ảnh minh họa là sản phẩm thật.

Prompt UI01 là nguyên văn bản lưu trong dự án, chưa có log chat gốc để đối chiếu 100% bản thực gửi. Speaker notes giữ toàn văn, slide trích chính xác phần liên quan. Các con số kiểm tra là kiểm tra cấu trúc/dữ liệu, chưa phải user test.

Nguồn ngoài: Nielsen Norman Group https://www.nngroup.com/articles/ten-usability-heuristics/ ; W3C https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html ; Android Accessibility https://support.google.com/accessibility/android/answer/7101858?hl=en ; Flutter https://docs.flutter.dev/cookbook/design/themes . Truy cập26/10/2026.
''',encoding='utf8')
print(str(out))
