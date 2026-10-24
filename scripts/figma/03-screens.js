await figma.setCurrentPageAsync(figma.root.children.find(p=>p.id==='1:3'));
await Promise.all(['Regular','Medium','SemiBold','Bold'].map(style=>figma.loadFontAsync({family:'Be Vietnam Pro',style})));
const page=figma.currentPage;page.backgrounds=[{type:'SOLID',color:{r:.89,g:.92,b:.96}}];
if(page.children.some(n=>n.name==='S01 · Hôm nay'))return {alreadyExists:true};
const vs=await figma.variables.getLocalVariablesAsync();const vm=new Map(vs.map(v=>[v.id,v]));const styles=await figma.getLocalTextStylesAsync();
const V=k=>vs.find(v=>v.name==='color/'+k.replaceAll('.','/')||v.name===k);
function val(v){let a=Object.values(v.valuesByMode)[0];return a?.type==='VARIABLE_ALIAS'?val(vm.get(a.id)):a;}
function paint(k){const v=V(k),c=val(v);return figma.variables.setBoundVariableForPaint({type:'SOLID',color:{r:c.r,g:c.g,b:c.b}},'color',v);}
const fill=(n,k)=>n.fills=[paint(k)];const bind=(n,p,k)=>n.setBoundVariable(p,V(k));
const ids={button:'34:18',field:'34:35',card:'34:46',nav:'34:99',bar:'34:112',dialog:'34:127',loading:'34:138',empty:'34:154',error:'34:165'};
const sets={};for(const [k,id]of Object.entries(ids))sets[k]=await figma.getNodeByIdAsync(id);
const roots=[],screens={},links={};let slot=0;
function auto(parent,name,d='VERTICAL',w=328){const n=figma.createAutoLayout(d);parent.appendChild(n);n.name=name;n.resize(w,40);n.primaryAxisSizingMode='AUTO';n.counterAxisSizingMode='FIXED';n.fills=[];bind(n,'itemSpacing','space/12');return n;}
async function text(parent,name,str,sty='Body',color='text.primary',w=328){const t=figma.createText();parent.appendChild(t);t.name=name;t.fontName={family:'Be Vietnam Pro',style:'Regular'};t.characters=str;await t.setTextStyleIdAsync(styles.find(s=>s.name==='P9/'+sty).id);t.textAutoResize='HEIGHT';t.resize(w,t.height);fill(t,color);return t;}
function variant(key,name){return sets[key].children.find(n=>n.type==='COMPONENT'&&n.name===name)||sets[key].defaultVariant;}
function instantiate(parent,key,name){const n=variant(key,name).createInstance();parent.appendChild(n);return n;}
function role(n,r){return n.findOne(x=>x.type==='TEXT'&&x.name===r);}
function change(n,r,value){const t=role(n,r);if(t){t.characters=value;t.textAutoResize='HEIGHT';t.resize(n.width-32,t.height);}return t;}
function button(parent,label,kind='Primary',state='Default',name=label,w=328){const n=instantiate(parent,'button','kind='+kind+', state='+state);n.name=name;n.resize(w,52);const t=role(n,'Label');t.characters=label;t.resize(w-32,t.height);return n;}
function card(parent,title,meta,body,action='Xem chi tiết →',name=title){const n=instantiate(parent,'card','state=Default');n.name=name;change(n,'Title',title);change(n,'Meta',meta);change(n,'Body',body);change(n,'Action',action);return n;}
function field(parent,label,value,state='Filled',name=label){const n=instantiate(parent,'field','state='+state);n.name=name;change(n,'Label',label);change(n,'Value',value);return n;}
async function screen(id,title,tab=null){
 const root=auto(page,id+' · '+title,'VERTICAL',360);root.resize(360,800);root.primaryAxisSizingMode='FIXED';root.counterAxisSizingMode='FIXED';root.itemSpacing=0;root.clipsContent=true;root.x=200+(slot%4)*440;root.y=120+Math.floor(slot/4)*920;slot++;fill(root,'background');
 const bar=instantiate(root,'bar','variant=Default');bar.name='AppBar';change(bar,'Title',title);const back=bar.findOne(n=>n.name==='Back');back.visible=tab===null;
 const viewport=auto(root,'Vùng cuộn','VERTICAL',360);viewport.resize(360,tab===null?736:660);viewport.primaryAxisSizingMode='FIXED';viewport.counterAxisSizingMode='FIXED';viewport.itemSpacing=0;viewport.clipsContent=true;viewport.overflowDirection='VERTICAL';
 const content=auto(viewport,'Nội dung','VERTICAL',360);for(const p of ['paddingTop','paddingBottom','paddingLeft','paddingRight'])bind(content,p,'space/16');bind(content,'itemSpacing','space/16');content.clipsContent=false;
 let nav=null;if(tab!==null){nav=instantiate(root,'nav','selected='+tab);nav.name='Bottom navigation';}
 roots.push(root);screens[id]=root;links[id]={back:back.id,nav:nav?.id||null};return {root,content,bar,nav};
}
async function home(id,completed=false,added=false,rescheduled=false){const {content:c}=await screen(id,'Hôm nay',0);
 await text(c,'Greeting','Chào buổi tối, Linh','Body','text.secondary');
 await text(c,'Summary',completed?'Hôm nay đã xong 2/3 thói quen':added?'Thói quen mới đã sẵn sàng':'Hôm nay đã xong 1/3 thói quen','Title','action.primary');
 await text(c,'Hint','Dành 5 phút cho một khoảng nghỉ nhẹ.','Label','text.secondary');
 const row=auto(c,'Phím tắt','HORIZONTAL',328);row.itemSpacing=8;links[id].discover=button(row,'Khám phá','Secondary','Default','Khám phá',160).id;links[id].history=button(row,'Lịch sử','Secondary','Default','Lịch sử',160).id;
 const a=card(c,'Thở chậm','5 phút · '+(rescheduled?'21:00':'20:30'),'Một khoảng nghỉ trong nhịp sống gia đình.','Xem chi tiết →','Habit/ThoCham');links[id].detail=a.id;
 links[id].complete=button(c,completed?'Hoàn tác':'Hoàn thành','Primary','Default','Checkin').id;
 if(completed)await text(c,'CompletedFeedback','✓ Đã hoàn thành Thở chậm','Label','action.primary');
 card(c,'Đi bộ nhẹ','10 phút · Đã hoàn thành','Bạn đã ghi nhận hoạt động hôm nay.','✓ Đã hoàn thành');
 card(c,'Gọi hỏi thăm người thân','5 phút · 19:00','Một cuộc gọi ngắn để kết nối.','Xem ở Kết nối →','Habit/Connect');
 if(added||rescheduled)await text(c,'SavedFeedback',rescheduled?'✓ Đã lưu giờ nhắc mới 21:00':'✓ Đã thêm thói quen vào hôm nay','Label','action.primary');
}
await home('S01');await (async()=>{const {content:c}=await screen('S02','Ăn uống',1);await text(c,'Title','Ăn chậm, chú ý cảm giác no','Title');await text(c,'Duration','5 phút · Thói quen bữa ăn','Label','action.primary');card(c,'Một bữa ăn có chú ý','Bắt đầu từ việc nhỏ','Dành sự chú ý cho món ăn và cảm giác của cơ thể.','Hướng dẫn');
for(const [i,t]of ['Nhai chậm và cảm nhận món ăn.','Đặt đũa xuống giữa các lần ăn.','Dừng lại khi thấy vừa đủ.'].entries())await text(c,'Step/'+i,(i+1)+'. '+t);
links.S02.complete=button(c,'Ghi nhận hoàn thành').id;links.S02.history=button(c,'Xem lịch sử','Secondary').id;})();
await (async()=>{const {content:c}=await screen('S03','Thư giãn',2);await text(c,'Title','Thở chậm','Title');await text(c,'Duration','5 phút · Một khoảng nghỉ cho bạn','Label','action.primary');const timer=auto(c,'Timer','VERTICAL',328);timer.resize(328,184);timer.primaryAxisSizingMode='FIXED';timer.primaryAxisAlignItems='CENTER';timer.counterAxisAlignItems='CENTER';fill(timer,'surface.selected');timer.cornerRadius=16;const t=await text(timer,'Time','05:00','Title','action.primary',296);t.textAlignHorizontal='CENTER';const a=await text(timer,'Status','Sẵn sàng bắt đầu','Label','text.secondary',296);a.textAlignHorizontal='CENTER';
links.S03.start=button(c,'Bắt đầu phiên').id;await text(c,'Guide','1. Ngồi thoải mái.\n2. Hít vào nhẹ nhàng.\n3. Thở ra chậm, không gắng sức.');links.S03.history=button(c,'Xem lịch sử','Secondary').id;})();
await (async()=>{const {content:c}=await screen('S04','Kết nối',3);await text(c,'Title','Kết nối từ việc nhỏ','Title');await text(c,'Intro','Chọn một hoạt động phù hợp với thời gian bạn có.','Body','text.secondary');
const first=card(c,'Gọi hỏi thăm người thân','5 phút','Một cuộc gọi ngắn để lắng nghe.','✓ Đã chọn','Choice/Call');fill(first,'surface.selected');card(c,'Trò chuyện không điện thoại','15 phút','Dành sự chú ý cho người bên cạnh.','Chọn hoạt động','Choice/Talk');card(c,'Đọc sách cùng nhau','10 phút','Chia sẻ một câu chuyện ngắn.','Chọn hoạt động','Choice/Read');
links.S04.complete=button(c,'Ghi nhận hoàn thành').id;links.S04.history=button(c,'Xem lịch sử','Secondary').id;})();
async function discover(id,empty=false){const {content:c}=await screen(id,'Khám phá thói quen');links[id].search=field(c,'Tìm thói quen',empty?'Hoạt động 30 phút':'Tên thói quen…',empty?'Filled':'Default').id;const row=auto(c,'Bộ lọc','HORIZONTAL',328);row.itemSpacing=8;for(const [i,label]of ['Tất cả','≤5 phút','≤10 phút'].entries()){const b=button(row,label,i===1?'Primary':'Secondary','Default','Filter/'+i,104);links[id]['filter'+i]=b.id;}
if(empty){const e=instantiate(c,'empty','context=Discover');e.name='Empty';links[id].reset=e.findOne(n=>n.name==='EmptyAction').id;}else{links[id].result=card(c,'Thở chậm','5 phút','Một khoảng nghỉ ngắn, dễ bắt đầu.','Xem chi tiết →','Result/ThoCham').id;card(c,'Gọi hỏi thăm người thân','5 phút','Giữ kết nối bằng một cuộc gọi.','Xem chi tiết →');card(c,'Uống một cốc nước','3 phút','Dành một phút quan tâm bản thân.','Xem chi tiết →');}}
await discover('S05');
async function detail(id,existing=false){const {content:c}=await screen(id,'Chi tiết thói quen');if(existing)await text(c,'Existing','✓ Đã có trong lịch','Label','action.primary');await text(c,'Title','Thở chậm','Title');await text(c,'Duration','5 phút · Phù hợp tại nhà','Label','action.primary');if(existing)card(c,'Lịch hiện tại','Hôm nay · 20:30','Nhắc giờ được bật.','Đổi khi bạn bận');
await text(c,'PurposeTitle','Mục đích thói quen','Heading');await text(c,'Purpose','Dành một khoảng nghỉ ngắn trong nhịp sinh hoạt gia đình.','Body','text.secondary');
for(const [i,t]of ['Ngồi thoải mái, thả lỏng vai.','Hít vào nhẹ nhàng.','Thở ra chậm, không gắng sức.'].entries())await text(c,'Step/'+i,(i+1)+'. '+t);
links[id].action=button(c,existing?'Đổi lịch':'Thêm vào hôm nay').id;}
await detail('S06');
async function schedule(id,state='valid',edit=false,time='20:30'){const {content:c}=await screen(id,'Lịch thói quen');await text(c,'Habit','Thở chậm · 5 phút','Heading');await text(c,'Mode',edit?'Điều chỉnh lịch đã có':'Thêm hoạt động vào hôm nay','Label','text.secondary');field(c,'Ngày áp dụng','Hôm nay',state==='saving'?'Disabled':'Filled');links[id].toggle=button(c,'Nhắc giờ: Bật','Secondary','Default','Reminder toggle').id;links[id].time=field(c,'Giờ nhắc',state==='validation'?'Chưa chọn giờ':time,state==='validation'?'Error':state==='saving'?'Disabled':'Filled').id;
if(state==='validation'){await text(c,'Help','Chọn giờ nhắc để tiếp tục.','Label','feedback.error');links[id].choose20=button(c,'Chọn 20:30','Secondary').id;}
else if(state==='error'){const e=instantiate(c,'error','context=Form');e.name='SaveError';links[id].retry=e.findOne(n=>n.name==='Retry').id;}
if(state!=='error')links[id].save=button(c,state==='saving'?'Đang lưu…':'Lưu lịch','Primary',state==='saving'?'Loading':'Default','Save').id;
links[id].cancel=button(c,'Hủy, giữ lịch cũ','Secondary','Default','Cancel').id;
if(state==='valid'){const row=auto(c,'Đổi giờ nhanh','HORIZONTAL',328);row.itemSpacing=8;links[id].choose20=button(row,'20:30','Secondary','Default','Time20',160).id;links[id].choose21=button(row,'21:00','Secondary','Default','Time21',160).id;}
}
await schedule('S07');
async function history(id,empty=false){const {content:c}=await screen(id,'Lịch sử và tiến độ');await text(c,'Week','Tổng kết tuần này','Heading');await text(c,'Total',empty?'0 hoạt động hoàn thành':'12 hoạt động hoàn thành','Title','action.primary');await text(c,'Ratio',empty?'Bắt đầu từ một việc nhỏ.':'12/14 lượt dự kiến · 86% kế hoạch','Label','text.secondary');
if(empty){const e=instantiate(c,'empty','context=History');e.name='Empty';links[id].discover=e.findOne(n=>n.name==='EmptyAction').id;}else{for(const [i,t]of ['Đi bộ nhẹ','Thở chậm','Gọi hỏi thăm người thân'].entries()){card(c,t,i===0?'Hôm nay · 17:28':'Hôm qua · 20:35',i===0?'10 phút':'5 phút','✓ Đã hoàn thành','Record/'+i);const b=button(c,'Xóa bản ghi','Secondary','Default','Delete/'+i);links[id]['delete'+i]=b.id;}}}
await history('S08');
await detail('S06-existing',true);
await discover('S05-empty',true);
await schedule('S07-validation','validation');
await schedule('S07-saving','saving');
await schedule('S07-error','error');
await schedule('S07-edit','valid',true);
await schedule('S07-edit21','valid',true,'21:00');
await schedule('S07-saving-edit','saving',true,'21:00');
await history('S08-empty',true);
await home('S01-completed',true);
await home('S01-added',false,true);
await home('S01-rescheduled',false,false,true);
await (async()=>{const {content:c}=await screen('S03-active','Thư giãn',2);await text(c,'Title','Thở chậm','Title');await text(c,'Time','04:32','Title','action.primary');await text(c,'Status','Phiên đang thực hiện','Label','text.secondary');links['S03-active'].pause=button(c,'Tạm dừng','Secondary').id;links['S03-active'].finish=button(c,'Kết thúc và ghi nhận').id;links['S03-active'].exit=button(c,'Thoát phiên','Secondary').id;})();
await (async()=>{const {content:c}=await screen('S03-paused','Thư giãn',2);await text(c,'Title','Phiên đã tạm dừng','Title');await text(c,'Time','04:32','Title','action.primary');links['S03-paused'].resume=button(c,'Tiếp tục phiên').id;links['S03-paused'].finish=button(c,'Kết thúc và ghi nhận','Secondary').id;links['S03-paused'].exit=button(c,'Thoát phiên','Secondary').id;})();
for(const [id,variantName]of [['O01','variant=Confirmation'],['O02','variant=Destructive']]){const root=auto(page,id+' · Hộp thoại','VERTICAL',328);root.x=200+(slot%4)*440;root.y=120+Math.floor(slot/4)*920;slot++;root.itemSpacing=0;root.clipsContent=false;const d=instantiate(root,'dialog',variantName);d.name='Dialog';roots.push(root);screens[id]=root;links[id]={confirm:d.findOne(n=>n.name==='Confirm').id,cancel:d.findOne(n=>n.name==='Cancel').id};}
const original=await figma.getNodeByIdAsync('18:2');if(original)original.name='Nguồn nhập S01 / Stitch I01 — giữ đối chiếu';
return {createdNodeIds:roots.flatMap(n=>[n.id,...n.findAll(()=>true).map(n=>n.id)]),mutatedNodeIds:[page.id,...(original?[original.id]:[])],screens:Object.fromEntries(Object.entries(screens).map(([k,n])=>[k,{id:n.id,width:n.width,height:n.height}])),links,screenCount:roots.length,instanceCount:roots.reduce((a,n)=>a+n.findAllWithCriteria({types:['INSTANCE']}).length,0)};
