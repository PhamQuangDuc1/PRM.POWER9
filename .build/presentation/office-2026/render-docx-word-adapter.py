from pathlib import Path
import importlib.util,tempfile,sys,os
root=Path('D:/PRM393/PRM.POWER9').resolve();build=root/'.build/presentation/office-2026';tmp=build/'render-tmp';tmp.mkdir(exist_ok=True)
assert tmp.resolve().is_relative_to(root)
tempfile.tempdir=str(tmp)
native=Path('C:/Users/PC/.cache/codex-runtimes/codex-primary-runtime/dependencies/native/poppler')
bins=list(native.rglob('pdftoppm.exe'))
if bins:os.environ['PATH']=str(bins[0].parent)+os.pathsep+os.environ.get('PATH','')
skill=Path('C:/Users/PC/.codex/plugins/cache/openai-primary-runtime/documents/26.1024.11018/skills/documents/render_docx.py')
spec=importlib.util.spec_from_file_location('packaged_docx_renderer',skill);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
pdf=build/'demo-word.pdf'
assert pdf.exists()
# Use installed Microsoft Word conversion because the bundled runtime has no LibreOffice.
# Keep the packaged render_docx.py rasterizer and page naming unchanged.
m.convert_to_pdf=lambda *args,**kwargs:(str(pdf),'PDF exported with Microsoft Word COM, document opened read-only')
sys.argv=[str(skill),str(root/'output/presentation/Power9_Office_Lab2/Power9_Office_Kich_Ban_Thuyet_Trinh_Va_Demo.docx'),'--output_dir',str(build/'docx-render'),'--dpi','120']
m.main()
