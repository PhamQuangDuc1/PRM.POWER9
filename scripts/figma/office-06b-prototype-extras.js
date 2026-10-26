// Insert immediately before page.flowStartingPoints in office-06-prototype.js.
for(const args of [
 ['Duyệt / Ăn uống','S02',160,6080],['Duyệt / Kết nối','S04',600,6080],['Duyệt / Góc làm việc','S09',1040,6080],['Duyệt / Ngủ','S10',1480,6080],['Duyệt / Tiến độ','S08',1920,6080],
 ['F01 / Tiến độ sau thêm','S08',3240,1080],['F03 / Tiến độ sau đổi','S08',2800,5000],['Duyệt / Lịch nghỉ tối','S07',1480,7000],['Duyệt / Đã đặt giờ nghỉ','S10',1920,7000],['Duyệt / Đã kiểm tra','S09',1040,7000],['Duyệt / Sau bữa trưa','S08-session',160,7000]
])await clone(...args);
function replace(root,from,to){for(const t of clones[root].findAll(n=>n.type==='TEXT'&&n.characters.includes(from))){t.characters=t.characters.replaceAll(from,to);}}
function fitContent(root){const c=clones[root].findOne(n=>n.name==='Content');function fit(n){if('children'in n)for(const c of n.children)fit(c);if(n.type==='FRAME'&&n.layoutMode==='VERTICAL'&&n.primaryAxisSizingMode==='AUTO'){n.resize(n.width,n.paddingTop+n.paddingBottom+n.children.reduce((v,c)=>v+c.height,0)+n.itemSpacing*Math.max(0,n.children.length-1));n.primaryAxisSizingMode='AUTO';}}fit(c);}
replace('F01 / Tiến độ sau thêm','1/3','1/4');replace('F01 / Tiến độ sau thêm','33%','25%');replace('F01 / Tiến độ sau thêm','Còn 2','Còn 3');
const added=clones['F01 / Đã thêm'].findOne(n=>n.name==='Card/Rủ đồng nghiệp đi bộ').clone();const addedBody=clones['F01 / Tiến độ sau thêm'].findOne(n=>n.name==='Content');addedBody.insertChild(addedBody.children.length-1,added);collect(added);const barAdded=clones['F01 / Tiến độ sau thêm'].findOne(n=>n.name==='Progress track').children[0];barAdded.resize(74,10);fitContent('F01 / Tiến độ sau thêm');
replace('F03 / Tiến độ sau đổi','17:30','18:00');
replace('Duyệt / Sau bữa trưa','Nghỉ sau cuộc họp','Ăn trưa có chú ý');replace('Duyệt / Sau bữa trưa','3 phút · Quản lý căng thẳng','Ăn uống lành mạnh');
replace('Duyệt / Lịch nghỉ tối','Rủ đồng nghiệp đi bộ','Chuẩn bị nghỉ tối');replace('Duyệt / Lịch nghỉ tối','5 phút · Thực hiện 1 lần','Ngủ và phục hồi · Thực hiện 1 lần');replace('Duyệt / Lịch nghỉ tối','12:00','21:30');
replace('Duyệt / Đã đặt giờ nghỉ','Chọn giờ nhắc','Đã đặt giờ nhắc 21:30');replace('Duyệt / Đã kiểm tra','Đã kiểm tra','Đã ghi nhận kiểm tra');
for(const root of ['F01 / Mai / Hôm nay','F02 / Huy / Hôm nay','F03 / Linh / Hôm nay']){await go(root,'Khám phá','F01 / Khám phá');await go(root,'Tiến độ','Duyệt / Tiến độ');}
await go('F01 / Đã thêm','Tiến độ','F01 / Tiến độ sau thêm');await back('F01 / Tiến độ sau thêm','F01 / Đã thêm');await go('F03 / Đã đổi lịch','Tiến độ','F03 / Tiến độ sau đổi');await back('F03 / Tiến độ sau đổi','F03 / Đã đổi lịch');
await back('Duyệt / Tiến độ','F01 / Mai / Hôm nay');
for(const root of ['F01 / Mai / Hôm nay','F02 / Huy / Hôm nay','F03 / Linh / Hôm nay','Duyệt / Ăn uống','Duyệt / Kết nối','F02 / Thư giãn']){
 const dests=['F01 / Mai / Hôm nay','Duyệt / Ăn uống','F02 / Thư giãn','Duyệt / Kết nối'];
 for(let i=0;i<4;i++){const item=clones[root].findOne(n=>n.name==='Nav/'+i);if(item)await link(item,dests[i]);}
}
await link(find('F01 / Khám phá','Filter/≤5 phút'),'F01 / Khám phá');
await link(find('F01 / Khám phá','Filter/Tất cả'),'F01 / Khám phá');await link(find('F01 / Khám phá','Filter/≤10 phút'),'F01 / Khám phá');
for(const i of [2,6])await link(find('F01 / Khám phá','Group item/'+i),'Duyệt / Góc làm việc');
await link(find('F01 / Khám phá','Group item/4'),'Duyệt / Ngủ');await link(find('F01 / Khám phá','Group item/3'),'Duyệt / Ăn uống');await link(find('F01 / Khám phá','Group item/5'),'F02 / Thư giãn');await link(find('F01 / Khám phá','Group item/9'),'F03 / Đã thêm từ trước');
await link(find('Duyệt / Kết nối','Discover detail'),'F01 / Chi tiết');await link(find('Duyệt / Kết nối','Discover detail 2'),'F01 / Chi tiết');await link(find('F01 / Khám phá','Discover detail 2'),'F01 / Chi tiết');
await back('Duyệt / Góc làm việc','F01 / Khám phá');await back('Duyệt / Ngủ','F01 / Khám phá');await go('Duyệt / Góc làm việc','Đã kiểm tra','Duyệt / Đã kiểm tra');await back('Duyệt / Đã kiểm tra','F01 / Khám phá');
await go('Duyệt / Ngủ','Chọn giờ nhắc','Duyệt / Lịch nghỉ tối');await go('Duyệt / Lịch nghỉ tối','Lưu lịch','Duyệt / Đã đặt giờ nghỉ');await go('Duyệt / Lịch nghỉ tối','Hủy','Duyệt / Ngủ');await back('Duyệt / Lịch nghỉ tối','Duyệt / Ngủ');await back('Duyệt / Đã đặt giờ nghỉ','F01 / Khám phá');
await go('Duyệt / Ăn uống','Đã thực hiện','Duyệt / Sau bữa trưa');await go('Duyệt / Ăn uống','Xem tiến độ','Duyệt / Tiến độ');await back('Duyệt / Sau bữa trưa','Duyệt / Ăn uống');
// Context notes sit on the canvas, outside product screens.
for(const [x,y,title,body]of [[160,40,'F01 · Mai · Tìm và thêm','Lưu → lỗi giữ dữ liệu → thử lại → Home 1/4.'],[160,1960,'F02 · Huy · Nghỉ và ghi nhận','Active/paused giữ snapshot02:15; overlay Ở lại đóng về đúng nguồn.'],[160,3960,'F03 · Linh · Đổi lịch','17:30 →18:00; không phát thông báo trong giờ yên lặng.']]){const t=figma.createText();page.appendChild(t);t.fontName={family:'Be Vietnam Pro',style:'SemiBold'};t.fontSize=20;t.characters=title+'\n'+body;t.textAutoResize='HEIGHT';t.resize(1800,t.height);t.x=x;t.y=y;ids.push(t.id);}
const interactionAudit=[];for(const [name,root]of Object.entries(clones)){const reactions=root.findAll(n=>'reactions'in n&&n.reactions.length>0);const broken=[];for(const n of reactions)for(const r of n.reactions)for(const a of r.actions||[]){if(a.type==='NODE'&&a.destinationId&&!await figma.getNodeByIdAsync(a.destinationId))broken.push(n.id);}interactionAudit.push({name,id:root.id,reactions:reactions.length+(root.reactions?.length||0),broken});}
await clones['F01 / Lỗi lưu'].screenshot({scale:.8});await clones['F02 / Dialog active'].screenshot({scale:.8});
