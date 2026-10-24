import fs from 'node:fs/promises';
import path from 'node:path';
import { FileBlob, PresentationFile } from 'file:///C:/Users/PC/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs';

const root = path.resolve('.');
const build = path.join(root, '.build', 'presentation');
const out = path.join(root, 'output', 'presentation');
await fs.mkdir(out, { recursive: true });
const deck = await PresentationFile.importPptx(await FileBlob.load(path.join(build, 'template-renderable.pptx')));

function pos(left, top, width, height) { return { left, top, width, height }; }
function hideTemplateText(slide) {
  for (const shape of slide.shapes.items) {
    try { if (String(shape.text ?? '').trim()) shape.text = ''; } catch {}
  }
}
function addText(slide, text, p, style = {}) {
  const shape = slide.shapes.add({ geometry: 'textbox', position: p, fill: 'none', line: { style: 'solid', fill: 'none', width: 0 } });
  shape.text = text;
  shape.text.style = { fontFace: 'Poppins', fontSize: 24, color: '#1F2937', ...style };
  return shape;
}
function addCard(slide, p, heading, body, accent = '#2686C5') {
  slide.shapes.add({ geometry: 'roundRect', position: p, fill: '#FFFFFF', line: { style: 'solid', fill: '#D6E3ED', width: 1 }, borderRadius: 'rounded-xl', shadow: 'shadow-sm' });
  slide.shapes.add({ geometry: 'rect', position: pos(p.left, p.top, 10, p.height), fill: accent, line: { style: 'solid', fill: accent, width: 0 } });
  addText(slide, heading, pos(p.left + 30, p.top + 22, p.width - 56, 42), { fontFace: 'Poppins', fontSize: 27, bold: true, color: '#1E5AA8' });
  addText(slide, body, pos(p.left + 30, p.top + 78, p.width - 56, p.height - 96), { fontFace: 'Noto Sans', fontSize: 20, color: '#334155' });
}
function addImage(slide, source, p, alt) {
  return fs.readFile(path.join(root, source)).then(bytes => slide.images.add({ blob: bytes.buffer.slice(bytes.byteOffset, bytes.byteOffset + bytes.byteLength), contentType: 'image/png', alt, fit: 'contain', position: p, geometry: 'roundRect', borderRadius: 'rounded-lg' }));
}
function heading(slide, index, title, sub) {
  addText(slide, String(index).padStart(2, '0'), pos(110, 68, 80, 36), { fontSize: 16, bold: true, color: '#2686C5' });
  addText(slide, title, pos(110, 104, 1600, 82), { fontSize: 50, bold: true, color: '#1E5AA8' });
  if (sub) addText(slide, sub, pos(112, 196, 1500, 46), { fontFace: 'Noto Sans', fontSize: 21, color: '#536878' });
}

const s = deck.slides.items;
for (const slide of s) {
  hideTemplateText(slide);
  // The original business template has tables/photos in the content region. Keep its corner motif,
  // while providing a clean editable canvas for the Power9 evidence and text.
  slide.shapes.add({ geometry: 'rect', position: pos(72, 245, 1665, 660), fill: '#FFFFFF', line: { style: 'solid', fill: '#FFFFFF', width: 0 } });
}

// 01
heading(s[0], 1, 'Power9 Family Routine', 'Lab 2 · Thiết kế UI/UX có hỗ trợ AI: Google Stitch → Figma');
addText(s[0], 'Ứng dụng hỗ trợ phụ huynh duy trì những thói quen nhỏ giữa nhịp sống gia đình.', pos(150, 275, 860, 92), { fontSize: 30, bold: true, color: '#111827' });
addCard(s[0], pos(150, 420, 420, 210), 'Vấn đề', 'Thời gian bị chia nhỏ; kế hoạch dài khó duy trì; khó chọn hoạt động phù hợp với khoảng rảnh hiện có.');
addCard(s[0], pos(620, 420, 420, 210), 'Hướng giải pháp', 'Gợi ý thói quen 3–10 phút, hiển thị thời lượng rõ và cho phép đánh dấu hoàn thành nhanh.');
addText(s[0], 'Nhóm thực hiện: Phạm Quang Đức · Văn Quang Duy · Nguyễn Tống Khánh Vĩnh · Đặng Đình Long', pos(150, 830, 1500, 34), { fontFace: 'Noto Sans', fontSize: 16, color: '#334155' });
addText(s[0], 'Bằng chứng: repository · Figma · ảnh xuất từ Google Stitch', pos(150, 900, 1300, 30), { fontFace: 'Noto Sans', fontSize: 15, color: '#536878' });

// 02
heading(s[1], 2, 'Persona và vấn đề trọng tâm', 'Bốn persona là giả định phục vụ thảo luận thiết kế, chưa phải kết quả khảo sát.');
addCard(s[1], pos(120, 285, 380, 190), 'Linh — persona chính', '36 tuổi · phụ huynh có con nhỏ\nChọn/thực hiện thói quen ngắn giữa các lần bị gián đoạn.\nMục tiêu: thêm thói quen <60 giây.', '#1E5AA8');
addCard(s[1], pos(545, 285, 320, 190), 'Minh', 'Sinh viên\nCheck-in từ Home ≤3 thao tác.');
addCard(s[1], pos(910, 285, 320, 190), 'Huy', 'Nhân viên văn phòng\nĐổi lịch thói quen <30 giây.');
addCard(s[1], pos(1275, 285, 320, 190), 'Chú Hùng', 'Người nghỉ hưu\nTìm và đánh dấu hoạt động <30 giây.');
addText(s[1], 'Problem statement', pos(150, 575, 420, 42), { fontSize: 25, bold: true, color: '#1E5AA8' });
addText(s[1], 'Linh cần một ứng dụng Power9 giúp chọn và theo dõi các thói quen ngắn phù hợp nhịp sinh hoạt gia đình, để duy trì mỗi ngày mà không phải lập kế hoạch phức tạp.', pos(150, 630, 1330, 96), { fontFace: 'Noto Sans', fontSize: 30, color: '#111827' });
addText(s[1], 'Tình huống thiết kế: sau khi đưa con ngủ, Linh có 5 phút và muốn chọn một hoạt động thư giãn có thể hoàn thành ngay.', pos(150, 782, 1350, 44), { fontFace: 'Noto Sans', fontSize: 18, color: '#536878' });

// 03
heading(s[2], 3, 'Kiến trúc thông tin', 'Tám màn hình chính được tổ chức theo bốn khu vực hành động của Power9.');
const ia = [['S01', 'Hôm nay', 'xem và check-in'], ['S02', 'Ăn uống', 'hoạt động dinh dưỡng'], ['S03', 'Thư giãn', 'hướng dẫn ngắn'], ['S04', 'Kết nối', 'hoạt động cùng gia đình'], ['S05', 'Khám phá', 'tìm thói quen'], ['S06', 'Chi tiết', 'đọc và thêm'], ['S07', 'Lịch thói quen', 'đổi lịch / nhắc'], ['S08', 'Lịch sử & tiến độ', 'xem kết quả']];
ia.forEach((x,i)=> addCard(s[2], pos(120+(i%4)*410, 305+Math.floor(i/4)*230, 360, 175), `${x[0]} · ${x[1]}`, x[2], i<4 ? '#1E5AA8' : '#2686C5'));
addText(s[2], 'Điều hướng chính: Hôm nay · Ăn uống · Thư giãn · Kết nối. Khám phá, Chi tiết, Lịch và Lịch sử là các màn hình chức năng.', pos(135, 830, 1500, 42), { fontFace: 'Noto Sans', fontSize: 18, color: '#536878' });

// 04
heading(s[3], 4, 'Ba luồng người dùng', 'Mỗi luồng có happy path; luồng đổi lịch có nhánh kiểm tra và phản hồi lỗi.');
const flows = [
  ['F01 · Thêm thói quen', 'S01 Hôm nay → S05 Khám phá → S06 Chi tiết → “Thêm vào hôm nay” → S01'],
  ['F02 · Hoàn thành', 'S01 → chọn “Thở chậm” → “Hoàn thành” → trạng thái đã lưu → S08'],
  ['F03 · Đổi lịch', 'S01/S06 → S07 Lịch → chọn ngày/giờ → lưu → xác nhận; dữ liệu thiếu → thông báo lỗi']
];
flows.forEach((f,i)=>{ const y=300+i*170; addText(s[3], f[0], pos(160,y,420,44), {fontSize:25,bold:true,color:'#1E5AA8'}); addText(s[3], f[1], pos(610,y,930,50), {fontFace:'Noto Sans',fontSize:22,color:'#111827'}); s[3].shapes.add({geometry:'line',position:pos(160,y+78,1380,1),line:{style:'solid',fill:'#A7C9E6',width:2}}); });
addText(s[3], 'Phục hồi: nếu không chọn giờ nhắc hoặc không lưu được lịch, hiển thị thông báo và giữ nguyên dữ liệu đã nhập.', pos(160,850,1400,42), {fontFace:'Noto Sans',fontSize:18,color:'#536878'});

// 05
heading(s[4], 5, 'AI UI Generation', 'Google Stitch được dùng để tạo bản UI đầu; prompt, ảnh đầu ra và thay đổi được lưu trong repository.');
await addImage(s[4], 'assets/stitch/V00/V00-overview-user-provided.png', pos(1040, 260, 540, 610), 'Ảnh kết quả Google Stitch vòng đầu');
addText(s[4], 'Prompt khởi đầu (P00)', pos(130,285,650,40), {fontSize:24,bold:true,color:'#1E5AA8'});
addText(s[4], '“Thiết kế ứng dụng Android Power9 Family Routine cho Linh. Ưu tiên các thói quen 3–10 phút, thao tác nhanh, nhãn rõ ràng và phản hồi lưu thành công.”', pos(130,345,690,120), {fontFace:'Noto Sans',fontSize:23,color:'#111827'});
addCard(s[4], pos(130,530,720,180), 'Ràng buộc đưa vào prompt', 'Giao diện Android; tiếng Việt có dấu; nút lớn; nội dung gần gũi; hiển thị thời lượng trên card; không dùng gradient.');
addText(s[4], 'Bằng chứng đầy đủ: ai/prompts/P00-stitch-initial.md · assets/stitch/V00/', pos(130,790,780,32), {fontFace:'Noto Sans',fontSize:15,color:'#536878'});

// 06
heading(s[5], 6, 'Ba vòng lặp và critique', 'Các thay đổi được đối chiếu với persona Linh, khả năng đọc và rủi ro thao tác.');
const its = [
 ['I01 · Ngôn ngữ', 'Chuẩn hóa toàn bộ nhãn và nội dung sang tiếng Việt có dấu.'],
 ['I02 · Màu và trạng thái', 'Chuyển xanh lá sang xanh biển; bổ sung trạng thái thêm/lưu/lỗi.'],
 ['I03 · Nội dung & hành động', 'Tách trạng thái “mới” và “đã thêm”, làm rõ nút hành động.']
];
its.forEach((x,i)=> addCard(s[5], pos(150+i*510, 300, 450, 190), x[0], x[1], i===1?'#1E5AA8':'#2686C5'));
addText(s[5], '5 phát hiện UX: (1) thời lượng phải thấy ngay; (2) icon cần kèm nhãn; (3) nhắc lịch cần sửa nhanh; (4) lưu phải có phản hồi; (5) trạng thái trống/lỗi cần chỉ đường tiếp theo.', pos(150,590,1450,85), {fontFace:'Noto Sans',fontSize:22,color:'#111827'});
addText(s[5], 'Quyết định: chấp nhận thẻ có thời lượng; chỉnh nhãn/nút; bổ sung trạng thái lỗi. Tài liệu: ai/critiques/C00-response.md', pos(150,770,1450,48), {fontFace:'Noto Sans',fontSize:18,color:'#536878'});

// 07
heading(s[6], 7, 'Quyết định thiết kế', 'Các quyết định cần bảo vệ được bằng nhu cầu persona và tính dễ dùng.');
const decisions = [['Chấp nhận','Hiển thị “5 phút” trên card để Linh chọn việc vừa khoảng rảnh.'],['Chỉnh sửa','Dùng nhãn + biểu tượng cho thao tác chính, hỗ trợ người dùng ít quen app.'],['Chỉnh sửa','Tách “Thêm vào hôm nay” và “Đổi lịch” để giảm bấm nhầm.'],['Loại bỏ','Không thêm tính năng chat thời gian thực vì không phục vụ mục tiêu Lab 2.']];
decisions.forEach((x,i)=>addCard(s[6],pos(135+(i%2)*800,300+Math.floor(i/2)*230,720,185),x[0],x[1],i===3?'#A73A2A':'#1E5AA8'));
addText(s[6], 'Nguyên tắc kiểm tra: rõ trạng thái · ít lựa chọn mỗi màn · thao tác một tay · phản hồi sau khi lưu.', pos(150,830,1450,42), {fontFace:'Noto Sans',fontSize:19,color:'#536878'});

// 08
heading(s[7], 8, 'Wireframe → Final UI', 'Wireframe xác định cấu trúc và luồng trước khi hoàn thiện nội dung, màu sắc và trạng thái.');
await addImage(s[7], 'assets/wireframe/W01/W01-overview-user-provided.png', pos(160, 300, 620, 510), 'Wireframe Power9');
await addImage(s[7], 'assets/stitch/I03/I03-overview-user-provided.png', pos(1030, 300, 620, 510), 'UI vòng lặp I03');
addText(s[7], 'Wireframe', pos(360,845,240,36), {fontSize:22,bold:true,color:'#1E5AA8'});
addText(s[7], 'Final UI từ Stitch', pos(1190,845,320,36), {fontSize:22,bold:true,color:'#1E5AA8'});

// 09
heading(s[8], 9, 'Design system', 'Token và component được định nghĩa để đồng bộ các màn hình Android.');
const tokens = [['Primary','#1E5AA8'],['Surface','#F5F8FD'],['Text','#152C46'],['Selected','#EAF2FC'],['Error','#A7332A']];
tokens.forEach((x,i)=>{ s[8].shapes.add({geometry:'roundRect',position:pos(130+i*285,300,245,105),fill:x[1],line:{style:'solid',fill:x[1],width:0},borderRadius:'rounded-lg'}); addText(s[8],x[0]+'\n'+x[1],pos(148+i*285,425,230,52),{fontSize:18,bold:true,color:'#1E5AA8'}); });
addCard(s[8],pos(150,570,670,190),'Typography & spacing','Be Vietnam Pro; body tối thiểu 14 dp; nhãn 14 dp; spacing 8/12/16/24 dp; bán kính thẻ 16 dp.');
addCard(s[8],pos(920,570,670,190),'Nhóm component','Button · Text field · Card · Navigation · App bar · Dialog · Loading · Empty · Error.');
addText(s[8],'Trạng thái cần thể hiện: Default / Selected / Disabled / Error / Empty. Ảnh liên kết instance trên Figma sẽ bổ sung sau khi đồng bộ Final UI.',pos(150,835,1450,44),{fontFace:'Noto Sans',fontSize:17,color:'#536878'});

// 10
heading(s[9], 10, 'Accessibility và responsive', 'Các tiêu chí được dùng để kiểm tra thiết kế trước khi bàn giao.');
addCard(s[9],pos(160,300,430,210),'Kích thước','Khung cơ sở Android 360 × 800 dp\nVùng chạm tối thiểu 48 × 48 dp\nNút chính cao 52 dp');
addCard(s[9],pos(745,300,430,210),'Khả năng đọc','Chữ nội dung ≥14 dp\nTương phản văn bản thường ≥4.5:1\nNhãn không chỉ dựa vào màu');
addCard(s[9],pos(1330,300,430,210),'Trạng thái','Thông báo lưu thành công rõ ràng\nXác nhận trước hành động xóa\nCó lỗi và trạng thái trống');
addText(s[9], 'Cần bổ sung trước khi nộp: ảnh kiểm tra 360 dp và 412 dp từ Figma, cùng ảnh đối chiếu vùng chạm và contrast cho các màn chính.', pos(160,650,1540,80), {fontFace:'Noto Sans',fontSize:24,bold:true,color:'#1E5AA8'});
addText(s[9], 'Các thông số trên là tiêu chí thiết kế; kiểm chứng trực quan trong Figma vẫn đang chờ bổ sung.', pos(160,780,1400,36), {fontFace:'Noto Sans',fontSize:18,color:'#536878'});

// 11
heading(s[10], 11, 'Live prototype', 'Kịch bản demo đã xác định; cần nối liên kết trong Figma trước khi trình bày.');
addCard(s[10],pos(150,300,430,240),'Demo 1','Mở Hôm nay → Khám phá → xem Chi tiết → thêm “Thở chậm” vào hôm nay.');
addCard(s[10],pos(745,300,430,240),'Demo 2','Từ Hôm nay đánh dấu hoàn thành → xem phản hồi → mở Lịch sử & tiến độ.');
addCard(s[10],pos(1340,300,430,240),'Demo 3','Mở Lịch thói quen → đổi ngày/giờ → lưu; thử thiếu dữ liệu để xem lỗi.');
addText(s[10], 'Vị trí bổ sung: ảnh hoặc video prototype đã nối trong Figma', pos(350,700,1220,65), {fontSize:29,bold:true,color:'#1E5AA8'});
addText(s[10], 'Trạng thái hiện tại: màn hình nguồn đã có; liên kết prototype và kiểm tra không dead-end cần hoàn tất.', pos(350,785,1220,44), {fontFace:'Noto Sans',fontSize:19,color:'#536878'});

// 12
heading(s[11], 12, 'Handoff và tổng kết', 'Tài liệu bàn giao được tổ chức theo từng màn hình và mapping sang Flutter.');
addCard(s[11],pos(180,315,650,270),'Handoff hiện có','8 màn hình × 6 trường: mục tiêu, entry, component, state, interaction, navigation.\n2 bảng mapping Token → Flutter và Component → Widget.');
addCard(s[11],pos(1060,315,650,270),'Cần bổ sung trước nộp','Đồng bộ 8 Final UI nguồn gốc vào Figma; liên kết 3 flow; kiểm tra 412 dp; chụp ảnh bằng chứng theo checklist.');
addText(s[11], 'Tài liệu: handoff/flutter-handoff.md · design/design-decisions.md · ux/user-flow.md', pos(250,705,1420,40), {fontFace:'Noto Sans',fontSize:20,color:'#1E5AA8'});
addText(s[11], 'Cảm ơn thầy/cô và các bạn', pos(520,835,930,60), {fontSize:34,bold:true,color:'#1E5AA8'});

const candidate = path.join(build, 'Power9_Lab2_Presentation_draft.pptx');
const final = path.join(out, 'Power9_Lab2_Presentation_v2.pptx');
const blob = await PresentationFile.exportPptx(deck);
await blob.save(candidate);
await fs.copyFile(candidate, final);
for (let i=0;i<s.length;i++) {
  const png = await deck.export({slide:s[i],format:'png',scale:2/3});
  const b = new Uint8Array(await png.arrayBuffer());
  await fs.writeFile(path.join(build,'final-'+String(i+1).padStart(2,'0')+'.png'),b);
}
console.log(final);
