await figma.setCurrentPageAsync(await figma.getNodeByIdAsync('10:13'));
await Promise.all(['Regular','Medium','SemiBold','Bold'].map(style=>figma.loadFontAsync({family:'Be Vietnam Pro',style})));
figma.skipInvisibleInstanceChildren=false;
const ids=[],variants={},page=figma.currentPage;
const existing=page.children.find(n=>n.type==='COMPONENT_SET'&&n.name==='P9/DiscoverGroup');
if(existing)return {alreadyExists:true,setId:existing.id,variants:Object.fromEntries(existing.children.map(n=>[n.name,n.id]))};
const variables=Object.fromEntries((await figma.variables.getLocalVariablesAsync()).map(v=>[v.name,v]));
const card=await figma.getNodeByIdAsync('16:51'),button=await figma.getNodeByIdAsync('16:20');
const groups=[
 ['Vận động thường xuyên',[['Duỗi cơ bắp chân tại bàn','3 phút →']]],
 ['Ngồi đúng tư thế',[['Căn chỉnh góc nhìn màn hình','2 phút →']],'Kiểm tra góc làm việc'],
 ['Ăn uống lành mạnh',[['Uống 250ml nước ấm','1 phút →']]],
 ['Ngủ và phục hồi',[['Chợp mắt tái tạo năng lượng','10 phút →']],'Chuẩn bị nghỉ tối'],
 ['Quản lý căng thẳng',[['Thở hộp thư giãn','4 phút →']]],
 ['Không gian làm việc',[['Dọn gọn bàn làm việc','5 phút →']],'Kiểm tra góc làm việc'],
 ['Kết nối đồng nghiệp',[['Rủ đồng nghiệp đi bộ','5 phút →'],['Trò chuyện trong giờ nghỉ','5 phút →']]],
 ['Mục tiêu và ý nghĩa',[['Ghi nhận 3 thành quả trong ngày','3 phút →']]],
 ['Cân bằng công việc–cuộc sống',[['Đóng laptop đúng giờ','2 phút →']]]
];
function record(n){ids.push(n.id);if('children'in n)for(const c of n.children)record(c);}
function color(n,name,hex){const h=hex.replace('#','');n.fills=[figma.variables.setBoundVariableForPaint({type:'SOLID',color:{r:parseInt(h.slice(0,2),16)/255,g:parseInt(h.slice(2,4),16)/255,b:parseInt(h.slice(4,6),16)/255}},'color',variables['color/'+name])];}
function bind(n,key,value){n.setBoundVariable(key,variables[(key==='cornerRadius'?'radius/':'spacing/')+value]);}
function text(p,name,s,w,size=16,style='Medium',secondary=false){const t=figma.createText();p.appendChild(t);t.name=name;t.fontName={family:'Be Vietnam Pro',style};t.fontSize=size;t.lineHeight={unit:'PIXELS',value:size===14?20:24};t.characters=s;t.textAutoResize='HEIGHT';t.resize(w,t.height);color(t,secondary?'on-surface-variant':'on-surface',secondary?'#424751':'#031c36');return t;}
function props(n,values){const v={};for(const[k,value]of Object.entries(values)){const key=Object.keys(n.componentProperties).find(p=>p.split('#')[0]===k);v[key]=value;}n.setProperties(v);}
const list=[];
for(let i=0;i<groups.length;i++){
 const [title,activities,related]=groups[i];const group=String(i+1).padStart(2,'0');
 const closed=figma.createComponent();page.appendChild(closed);closed.name='Group='+group+', State=Collapsed';closed.layoutMode='VERTICAL';closed.resize(328,1);closed.counterAxisSizingMode='FIXED';closed.primaryAxisSizingMode='AUTO';for(const k of ['paddingLeft','paddingRight','paddingTop','paddingBottom'])bind(closed,k,16);bind(closed,'itemSpacing',12);closed.cornerRadius=16;bind(closed,'cornerRadius',16);color(closed,'surface-container-lowest','#ffffff');
 const header=figma.createAutoLayout('HORIZONTAL');closed.appendChild(header);header.name='Header';header.resize(296,48);header.primaryAxisSizingMode='FIXED';header.counterAxisSizingMode='FIXED';header.counterAxisAlignItems='CENTER';header.fills=[];header.itemSpacing=8;
 text(header,'Group title',group+'. '+title,264);const caret=text(header,'Caret','⌄',24);caret.textAlignHorizontal='CENTER';
 const preview=text(closed,'Preview',activities.length===1?activities[0][0]:activities.length+' hoạt động · 5 phút',296,14,'Regular',true);
 for(let j=0;j<activities.length;j++){const a=card.createInstance();closed.appendChild(a);a.name='Activity/'+(j+1);a.resize(296,112);for(const t of a.findAll(n=>n.type==='TEXT'))t.resize(264,t.height);props(a,{Title:activities[j][0],Meta:activities[j][1]});a.visible=false;}
 const footer=button.createInstance();closed.appendChild(footer);footer.name='Related';footer.resize(296,52);props(footer,{Label:related||'Xem thêm'});footer.visible=false;
 const opened=closed.clone();page.appendChild(opened);opened.name='Group='+group+', State=Expanded';opened.findOne(n=>n.name==='Caret').characters='⌃';opened.findOne(n=>n.name==='Preview').visible=false;for(const a of opened.children.filter(n=>n.name.startsWith('Activity/')))a.visible=true;opened.findOne(n=>n.name==='Related').visible=!!related;
 variants[group]={Collapsed:closed.id,Expanded:opened.id};list.push(closed,opened);
}
const set=figma.combineAsVariants(list,page);set.name='P9/DiscoverGroup';set.description='Nhóm Khám phá: bấm Header để mở/thu gọn; bấm Activity để xem chi tiết. Giữ cùng tên layer Activity giữa hai state để bảo toàn navigation overrides trên instance.';set.x=3000;set.y=220;
for(let i=0;i<9;i++){const a=list[i*2],b=list[i*2+1];a.x=24;b.x=392;a.y=b.y=64+i*400;for(const [source,to]of [[a,b],[b,a]])await source.findOne(n=>n.name==='Header').setReactionsAsync([{trigger:{type:'ON_CLICK'},actions:[{type:'NODE',destinationId:to.id,navigation:'CHANGE_TO',transition:{type:'SMART_ANIMATE',duration:.18,easing:{type:'EASE_OUT'}}}]}]);}
set.resize(760,3700);record(set);
await list[0].screenshot({scale:1});await list[1].screenshot({scale:1});
return {createdNodeIds:ids,setId:set.id,variants,groupCount:9,variantCount:18,toggleReactions:18};
