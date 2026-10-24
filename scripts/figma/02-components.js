await figma.setCurrentPageAsync(figma.root.children.find(p=>p.id==='1:5'));
await Promise.all(['Regular','Medium','SemiBold','Bold'].map(style=>figma.loadFontAsync({family:'Be Vietnam Pro',style})));
if(figma.currentPage.children.some(n=>n.name==='P9/Button'))return {alreadyExists:true};
const vs=await figma.variables.getLocalVariablesAsync();const styles=await figma.getLocalTextStylesAsync();
const V=k=>vs.find(v=>v.name===('color/'+k.replaceAll('.','/'))||v.name===k);
const paint=k=>figma.variables.setBoundVariableForPaint({type:'SOLID',color:{r:0,g:0,b:0}},'color',V(k));
const fill=(n,k)=>n.fills=[paint(k)];const stroke=(n,k)=>n.strokes=[paint(k)];
const bind=(n,p,k)=>n.setBoundVariable(p,V(k));
const all=[];let y=120;const sets={};
async function text(p,name,str,sty='Body',color='text.primary',width=296){const n=figma.createText();p.appendChild(n);n.name=name;n.fontName={family:'Be Vietnam Pro',style:'Regular'};n.characters=str;await n.setTextStyleIdAsync(styles.find(s=>s.name==='P9/'+sty).id);n.textAutoResize='HEIGHT';n.resize(width,n.height);fill(n,color);return n;}
function layout(p,name,d='VERTICAL',w=328){const n=figma.createAutoLayout(d);p.appendChild(n);n.name=name;n.resize(w,40);n.primaryAxisSizingMode='AUTO';n.counterAxisSizingMode='FIXED';n.fills=[];bind(n,'itemSpacing','space/8');return n;}
function component(name,w=328){const n=figma.createComponent();figma.currentPage.appendChild(n);n.name=name;n.layoutMode='VERTICAL';n.resize(w,52);n.primaryAxisSizingMode='AUTO';n.counterAxisSizingMode='FIXED';fill(n,'surface');return n;}
function pad(n,v=16){for(const p of ['paddingTop','paddingBottom','paddingLeft','paddingRight'])bind(n,p,'space/'+v);}
function radius(n,k){for(const p of ['topLeftRadius','topRightRadius','bottomLeftRadius','bottomRightRadius'])bind(n,p,'radius/'+k);}
async function group(name,components,props={}){
 const cs=figma.combineAsVariants(components,figma.currentPage);cs.name=name;cs.x=200;cs.y=y;
 for(let i=0;i<components.length;i++){components[i].x=24+(i%4)*376;components[i].y=64+Math.floor(i/4)*(Math.max(...components.map(c=>c.height))+24);}
 cs.resizeWithoutConstraints(Math.max(...components.map(c=>c.x+c.width))+24,Math.max(...components.map(c=>c.y+c.height))+24);
 cs.description='Power9 · '+name+' · Auto Layout, token và trạng thái dùng chung.';
 for(const [prop,{role,value}] of Object.entries(props)){const key=cs.addComponentProperty(prop,'TEXT',value);for(const c of components){const t=c.findOne(n=>n.type==='TEXT'&&n.name===role);if(t)t.componentPropertyReferences={...t.componentPropertyReferences,characters:key};}}
 sets[name]=cs;y+=cs.height+100;all.push(cs);return cs;
}
const buttons=[];
for(const kind of ['Primary','Secondary'])for(const state of ['Default','Pressed','Disabled','Loading']){
 const c=component('kind='+kind+', state='+state);c.layoutMode='HORIZONTAL';c.primaryAxisSizingMode='FIXED';c.counterAxisSizingMode='FIXED';c.primaryAxisAlignItems='CENTER';c.counterAxisAlignItems='CENTER';c.resize(328,52);radius(c,'button');bind(c,'paddingLeft','space/16');bind(c,'paddingRight','space/16');bind(c,'itemSpacing','space/8');
 fill(c,kind==='Primary'&&state!=='Disabled'?'action.primary':'surface.selected');
 if(state==='Pressed')c.opacity=.88;
 await text(c,'Label',state==='Loading'?'Đang lưu…':'Hoàn thành','Label',kind==='Primary'&&state!=='Disabled'?'action.onPrimary':'action.primary',280);
 const t=c.findOne(n=>n.type==='TEXT');t.textAlignHorizontal='CENTER';
 buttons.push(c);
}
await group('P9/Button',buttons,{'Nhãn':{role:'Label',value:'Hoàn thành'}});
const fields=[];
for(const state of ['Default','Focused','Filled','Error','Disabled']){
 const c=component('state='+state);pad(c);radius(c,'input');bind(c,'itemSpacing','space/4');stroke(c,state==='Error'?'feedback.error':state==='Focused'?'action.primary':'border.control');c.strokeWeight=state==='Focused'?2:1;
 await text(c,'Label','Giờ nhắc','Label');await text(c,'Value',state==='Filled'?'20:30':'Chọn giờ nhắc','Body',state==='Filled'?'text.primary':'text.secondary');
 if(state==='Error')await text(c,'Helper','Vui lòng chọn giờ nhắc','Label','feedback.error');if(state==='Disabled')c.opacity=.55;fields.push(c);
}
await group('P9/TextField',fields,{'Nhãn':{role:'Label',value:'Giờ nhắc'},'Giá trị':{role:'Value',value:'20:30'}});
const cards=[];
for(const state of ['Default','Pressed']){const c=component('state='+state);pad(c);radius(c,'card');bind(c,'itemSpacing','space/8');fill(c,state==='Pressed'?'surface.selected':'surface');
 await text(c,'Title','Thở chậm','Heading');await text(c,'Meta','5 phút · Nhắc lúc 20:30','Label','action.primary');await text(c,'Body','Một khoảng nghỉ nhẹ cho hôm nay.','Body','text.secondary');await text(c,'Action','Xem chi tiết →','Label','action.primary');cards.push(c);}
await group('P9/Card',cards,{'Tiêu đề':{role:'Title',value:'Thở chậm'},'Thông tin':{role:'Meta',value:'5 phút · Nhắc lúc 20:30'},'Mô tả':{role:'Body',value:'Một khoảng nghỉ nhẹ cho hôm nay.'},'Hành động':{role:'Action',value:'Xem chi tiết →'}});
const navs=[];const labels=['Hôm nay','Ăn uống','Thư giãn','Kết nối'];const symbols=['⌂','○','◌','♡'];
for(let selected=0;selected<4;selected++){const c=component('selected='+selected,360);c.layoutMode='HORIZONTAL';c.primaryAxisSizingMode='FIXED';c.counterAxisSizingMode='FIXED';c.resize(360,76);c.paddingLeft=c.paddingRight=8;c.paddingTop=c.paddingBottom=8;c.itemSpacing=0;
 for(let i=0;i<4;i++){const target=layout(c,'Nav/'+i,'VERTICAL',86);target.primaryAxisAlignItems='CENTER';target.counterAxisAlignItems='CENTER';target.primaryAxisSizingMode='FIXED';target.resize(86,60);target.cornerRadius=12;fill(target,i===selected?'surface.selected':'surface');const a=await text(target,'Icon',symbols[i],'Heading',i===selected?'action.primary':'text.secondary',78);a.textAlignHorizontal='CENTER';const t=await text(target,'Label',labels[i],'Label',i===selected?'action.primary':'text.secondary',78);t.textAlignHorizontal='CENTER';}
 navs.push(c);}
await group('P9/Navigation',navs);
const bars=[];
for(const variant of ['Default','WithActions']){const c=component('variant='+variant,360);c.layoutMode='HORIZONTAL';c.primaryAxisSizingMode='FIXED';c.counterAxisSizingMode='FIXED';c.resize(360,64);c.paddingLeft=c.paddingRight=16;c.itemSpacing=8;c.counterAxisAlignItems='CENTER';
 const back=layout(c,'Back','HORIZONTAL',48);back.resize(48,48);back.primaryAxisSizingMode='FIXED';back.primaryAxisAlignItems='CENTER';back.counterAxisAlignItems='CENTER';await text(back,'BackGlyph','‹','Heading','action.primary',32);
 await text(c,'Title','Hôm nay','Heading','text.primary',208);
 const action=layout(c,'HeaderAction','HORIZONTAL',48);action.resize(48,48);action.primaryAxisSizingMode='FIXED';action.counterAxisAlignItems='CENTER';await text(action,'More','⋯','Heading','action.primary',32);action.visible=variant==='WithActions';bars.push(c);}
const barSet=await group('P9/AppBar',bars,{'Tiêu đề':{role:'Title',value:'Hôm nay'}});
const dialogs=[];
for(const variant of ['Confirmation','Destructive']){const c=component('variant='+variant);pad(c,24);radius(c,'card');bind(c,'itemSpacing','space/16');await text(c,'Title',variant==='Destructive'?'Xóa bản ghi này?':'Thoát phiên thư giãn?','Heading','text.primary',280);await text(c,'Body',variant==='Destructive'?'Bản ghi sẽ bị xóa khỏi lịch sử. Bạn có thể giữ lại để tiếp tục xem.':'Phiên chưa hoàn thành sẽ không được ghi vào lịch sử.','Body','text.secondary',280);
 for(const [role,label,kind]of [['Confirm',variant==='Destructive'?'Xóa bản ghi':'Xác nhận thoát','Primary'],['Cancel',variant==='Destructive'?'Giữ lại':'Tiếp tục phiên','Secondary']]){const b=buttons.find(b=>b.name==='kind='+kind+', state=Default').createInstance();c.appendChild(b);b.name=role;b.resize(280,52);const t=b.findOne(n=>n.type==='TEXT'&&n.name==='Label');t.characters=label;t.resize(248,t.height);if(role==='Confirm'&&variant==='Destructive')fill(b,'feedback.error');}
 dialogs.push(c);}
await group('P9/Dialog',dialogs);
const loadings=[];for(const variant of ['Screen','List']){const c=component('variant='+variant);pad(c);radius(c,'card');bind(c,'itemSpacing','space/16');await text(c,'Title','Đang tải hoạt động…','Heading');for(let j=0;j<(variant==='List'?3:1);j++){const skeleton=figma.createRectangle();c.appendChild(skeleton);skeleton.resize(296,48);skeleton.cornerRadius=8;fill(skeleton,'surface.selected');}await text(c,'Body','Vui lòng chờ trong giây lát.','Label','text.secondary');loadings.push(c);}await group('P9/Loading',loadings);
const empties=[];for(const context of ['Discover','History','Today']){const c=component('context='+context);pad(c);radius(c,'card');bind(c,'itemSpacing','space/16');await text(c,'Title',context==='Discover'?'Chưa có hoạt động phù hợp':context==='History'?'Chưa có hoạt động nào được ghi nhận':'Hôm nay chưa có thói quen','Heading');await text(c,'Body',context==='Discover'?'Thử bỏ bộ lọc để xem thêm hoạt động.':'Bắt đầu từ một hoạt động ngắn phù hợp với bạn.','Body','text.secondary');const b=buttons[0].createInstance();c.appendChild(b);b.name='EmptyAction';b.resize(296,52);const t=b.findOne(n=>n.type==='TEXT');t.characters=context==='Discover'?'Xóa bộ lọc':'Khám phá thói quen';t.resize(264,t.height);empties.push(c);}await group('P9/Empty',empties);
const errors=[];for(const context of ['Screen','Form']){const c=component('context='+context);pad(c);radius(c,'card');bind(c,'itemSpacing','space/16');stroke(c,'feedback.error');await text(c,'Title',context==='Form'?'Chưa lưu được lịch':'Chưa tải được hoạt động','Heading','feedback.error');await text(c,'Body',context==='Form'?'Kết nối đang gián đoạn. Dữ liệu bạn nhập vẫn được giữ nguyên.':'Kiểm tra kết nối và thử lại.','Body','text.secondary');const b=buttons[0].createInstance();c.appendChild(b);b.name='Retry';b.resize(296,52);const t=b.findOne(n=>n.type==='TEXT');t.characters='Thử lại';t.resize(264,t.height);errors.push(c);}await group('P9/Error',errors);
return {createdNodeIds:all.flatMap(n=>[n.id,...n.findAll(()=>true).map(n=>n.id)]),sets:Object.fromEntries(Object.entries(sets).map(([k,v])=>[k,{id:v.id,variants:v.children.map(c=>({id:c.id,name:c.name,width:c.width,height:c.height}))}])),setCount:all.length};
