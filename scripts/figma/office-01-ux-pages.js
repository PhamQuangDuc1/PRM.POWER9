const createdNodeIds=[],mutatedNodeIds=[];
const names=['01 User Flow','02 Wireframe','03 Final UI'];
for(let i=0;i<names.length;i++){
 let p=figma.root.children.find(p=>p.name===names[i]);
 if(!p&&i===0&&figma.root.children[0].name==='Page 1'){p=figma.root.children[0];p.name=names[i];mutatedNodeIds.push(p.id);}
 if(!p){p=figma.createPage();p.name=names[i];createdNodeIds.push(p.id);}
}
const page=figma.root.children.find(p=>p.name===names[0]);await figma.setCurrentPageAsync(page);
await Promise.all(['Regular','Medium','SemiBold','Bold'].map(style=>figma.loadFontAsync({family:'Be Vietnam Pro',style})));
if(page.children.some(n=>n.name==='Power9 Office / UX'))return {alreadyExists:true,pages:figma.root.children.map(p=>({id:p.id,name:p.name}))};
const rgb=h=>({r:parseInt(h.slice(1,3),16)/255,g:parseInt(h.slice(3,5),16)/255,b:parseInt(h.slice(5,7),16)/255});
function box(parent,name,w=1160,mode='VERTICAL',fill='#FFFFFF'){
 const n=figma.createAutoLayout(mode);parent.appendChild(n);createdNodeIds.push(n.id);n.name=name;n.resize(w,50);n.primaryAxisSizingMode='AUTO';n.counterAxisSizingMode='FIXED';n.itemSpacing=16;n.fills=fill?[{type:'SOLID',color:rgb(fill)}]:[];return n;
}
function txt(parent,content,w=1096,size=16,weight='Regular',color='#152C46'){
 const n=figma.createText();parent.appendChild(n);createdNodeIds.push(n.id);n.name=content.slice(0,65);n.fontName={family:'Be Vietnam Pro',style:weight};n.fontSize=size;n.lineHeight={unit:'PIXELS',value:Math.round(size*1.5)};n.characters=content;n.textAutoResize='HEIGHT';n.resize(w,n.height);n.fills=[{type:'SOLID',color:rgb(color)}];return n;
}
function pad(n,v=24){n.paddingTop=n.paddingBottom=n.paddingLeft=n.paddingRight=v;}
const root=box(page,'Power9 Office / UX',1240);root.x=160;root.y=120;pad(root,32);root.itemSpacing=28;
txt(root,'Power9 Office Routine',1176,32,'Bold');
txt(root,'01 / Phạm vi, 3 persona chính và 3 flow',1176,20,'SemiBold');
txt(root,'Nhân viên văn phòng 23–45 tuổi · 10 màn chức năng · 9 nhóm thói quen theo gợi ý của giảng viên. Các persona là giả định; các tiêu chí thời gian chưa phải kết quả kiểm thử.',1176);
const pRow=box(root,'3 persona chính ngang nhau',1176,'HORIZONTAL',null);pRow.itemSpacing=16;
const personas=[['Huy · 28 tuổi','Lập trình viên; ngồi lâu và lịch họp thay đổi.','Move Often · Sit Smart · Healthy Space','Check-in ≤3 thao tác; đổi lịch <30 giây.'],['Mai · 24 tuổi','Nhân viên marketing mới; ăn vội, căng thẳng và ít quen đồng nghiệp.','Eat Well · Manage Stress · Social Bonds','Tìm và thêm hoạt động phù hợp <60 giây.'],['Linh · 39 tuổi','Trưởng nhóm hành chính; họp nhiều, công việc lấn thời gian nghỉ.','Sleep Well · Purpose · Work–Life Balance','Đặt lịch và giờ yên lặng <60 giây.']];
for(const [name,context,groups,target]of personas){const c=box(pRow,name,381,'VERTICAL','#EAF2FC');pad(c,20);txt(c,name,341,20,'SemiBold');txt(c,context,341);txt(c,groups,341,14,'Medium','#1E5AA8');txt(c,'Mục tiêu dự kiến: '+target,341,14);}
txt(root,'Kiến trúc thông tin',1176,24,'SemiBold');
txt(root,'Cấp cao: S01 Hôm nay / S02 Ăn uống / S03 Thư giãn / S04 Kết nối.\nMàn con: S05 Khám phá → S06 Chi tiết → S07 Lịch; S08 Tiến độ từ Home/ghi nhận. S09 Góc làm việc và S10 Ngủ & phục hồi mở qua hoạt động phù hợp. Back giữ đúng nguồn, form Hủy không lưu.',1176);
txt(root,'9 nhóm: Vận động · Tư thế · Ăn uống · Ngủ/phục hồi · Căng thẳng · Không gian · Kết nối · Mục tiêu/ý nghĩa · Cân bằng công việc–cuộc sống. Không ép hoàn thành 9/9 mỗi ngày.',1176);
const flows=[
 {id:'F01',name:'Mai — tìm và thêm',goal:'Start S01 → tìm việc phù hợp → end S01 có hoạt động mới, S08 khớp 1/4.',steps:['S01\nHôm nay','S05\nKhám phá','S06-new\nChi tiết','S07-create\nĐặt lịch','Saving\nĐang lưu','S01-added\n1/4'],alt:'Không kết quả → xóa lọc. Thiếu giờ → lỗi cạnh trường, giữ form. Lưu lỗi → Thử lại → đang lưu. Hủy → S06, không thêm việc. Back S06 giữ nhóm/bộ lọc S05.',mapping:'S01/S05/S06/S07; error, validation, added và S08 theo snapshot.'},
 {id:'F02',name:'Huy — thực hiện và ghi nhận',goal:'Start S01 → nghỉ sau họp → end S08 có đúng 1 bản ghi mới; Home khớp trạng thái.',steps:['S01\nHôm nay','S03\nBắt đầu','Active\nĐang nghỉ','Paused\nTạm dừng','Finished\nKết thúc','S08-updated\nGhi nhận'],alt:'Paused → tiếp tục về Active. Rời phiên → overlay Tiếp tục/Bỏ phiên. Bỏ không ghi nhận. Check-in nhầm → Hoàn tác đồng bộ Home/history. Nhánh khác: S02 ăn uống, S04 kết nối, S09 checklist → ghi nhận.',mapping:'S01/S02/S03/S04/S08/S09; active, paused, finished, overlay và undo.'},
 {id:'F03',name:'Linh — điều chỉnh lịch và giờ yên lặng',goal:'Start S01 tổng kết17:30 → end S01 tổng kết18:00, vẫn1/3 và không tạo bản sao.',steps:['S01\n17:30','S06-existing\nĐổi lịch','S07-edit\n18:00','Saving\nĐang lưu','Success\nĐã lưu','S01-edited\n18:00'],alt:'Hủy giữ17:30. Lỗi giữ18:00 trên form nhưng Home vẫn17:30; retry không ghi trùng. 18:00 thuộc giờ yên lặng → giải thích không phát thông báo, không tự đổi giờ. S10 chuẩn bị nghỉ tối dùng lại form nhắc.',mapping:'S01/S06/S07/S10; existing/edit/error/retry/rescheduled.'}
];
for(const f of flows){
 const block=box(root,f.id+' / '+f.name,1176,'VERTICAL','#F5F8FD');pad(block,24);
 txt(block,f.id+' / '+f.name,1128,22,'SemiBold');txt(block,f.goal,1128);
 const row=box(block,'Sơ đồ '+f.id,1128,'HORIZONTAL',null);row.itemSpacing=8;
 for(let i=0;i<f.steps.length;i++){const step=box(row,f.steps[i],168,'VERTICAL','#EAF2FC');pad(step,12);txt(step,f.steps[i],144,14,'Medium','#1E5AA8');if(i<5)txt(row,'→',16,16,'SemiBold');}
 txt(block,'Nhánh thay thế / phục hồi\n'+f.alt,1128);txt(block,'Ánh xạ: '+f.mapping,1128,14,'Medium');
}
txt(root,'Tình trạng triển khai',1176,22,'SemiBold');
txt(root,'Nguồn: ZIP 10 màn chính OI02 + ZIP 13 state OI03 của người dùng; state đang được chuẩn hóa về cùng dữ liệu và phiên nghỉ3 phút. Flow ở đây là đặc tả đích, chưa là prototype bấm được. Gói Starter hiện chặn tạo page04–06; không thay 6 page bằng section để nhận là đạt đề.',1176,14);
return {createdNodeIds,mutatedNodeIds,pages:figma.root.children.map(p=>({id:p.id,name:p.name})),uxRoot:{id:root.id,width:root.width,height:root.height},flowCount:3,personaCount:3,font:'Be Vietnam Pro',pageLimitBlock:'Starter maximum3 pages; required6 not yet possible'};
