from pathlib import Path
from zipfile import ZipFile
from xml.etree import ElementTree as ET
from pypdf import PdfReader

base=Path('D:/PRM393')
out=Path('D:/PRM393/PRM.POWER9/.build/presentation/requirements-current.txt')
parts=[]
for name in ['PRM323 - Lab 2 Thiết kế UI UX có hỗ trợ AI (bản tiếng Việt).pdf','PRM323_Lab2_HuongDan_Slide_Presentation_Demo.docx','PRM323_Lab2_Presentation_Assessment_Guidelines_EN.docx']:
    p=base/name
    parts.append('\nFILE: '+name+'\n')
    if p.suffix=='.pdf':
        for i,page in enumerate(PdfReader(p).pages):parts.append(f'PAGE {i+1}\n'+page.extract_text())
    else:
        with ZipFile(p) as z:
            r=ET.fromstring(z.read('word/document.xml'))
            for para in r.iter('{http://schemas.openxmlformats.org/wordprocessingml/2006/main}p'):
                parts.append(''.join(t.text or '' for t in para.iter('{http://schemas.openxmlformats.org/wordprocessingml/2006/main}t')))
out.write_text('\n'.join(parts),encoding='utf-8')
print(out.read_text(encoding='utf-8'))
