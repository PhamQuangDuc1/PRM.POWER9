const page=figma.root.children.find(p=>p.id==='1:4');
await figma.setCurrentPageAsync(page);
for(const [i,p] of figma.root.children.entries())p.name=['01 User Flow','02 Wireframe','03 Final UI','04 Design System','05 Components','06 Prototype'][i]||p.name;
await Promise.all(['Regular','Medium','SemiBold','Bold'].map(style=>figma.loadFontAsync({family:'Be Vietnam Pro',style})));
const existing=figma.currentPage.children.find(n=>n.name==='Power9 / Nền tảng');
if(existing)return {alreadyExists:true,id:existing.id};
const collections=await figma.variables.getLocalVariableCollectionsAsync();
const collection=collections.find(c=>c.name==='Power9 / Light')||figma.variables.createVariableCollection('Power9 / Light');
const oldVars=await figma.variables.getLocalVariablesAsync();
const getVar=(name,type)=>oldVars.find(v=>v.name===name)||figma.variables.createVariable(name,collection,type);
collection.renameMode(collection.modes[0].modeId,'Light');
const mode=collection.modes[0].modeId;
const vars={};
const rgb=h=>({r:parseInt(h.slice(1,3),16)/255,g:parseInt(h.slice(3,5),16)/255,b:parseInt(h.slice(5,7),16)/255});
const palette={background:'#F5F8FD',surface:'#FFFFFF','text.primary':'#152C46','text.secondary':'#4C627A','action.primary':'#1E5AA8','action.onPrimary':'#FFFFFF','surface.selected':'#EAF2FC','border.control':'#71839A','feedback.error':'#A7332A'};
for(const [name,hex] of Object.entries(palette)){
 const p=getVar('primitive/'+name.replaceAll('.','/'),'COLOR');p.scopes=['ALL_FILLS','STROKE_COLOR'];p.setValueForMode(mode,{...rgb(hex),a:1});
 const v=getVar('color/'+name.replaceAll('.','/'),'COLOR');v.scopes=name.startsWith('text.')?['TEXT_FILL']:['ALL_FILLS','STROKE_COLOR'];v.setValueForMode(mode,{type:'VARIABLE_ALIAS',id:p.id});vars[name]=v;
}
for(const n of [4,8,12,16,24,32]){const v=getVar('space/'+n,'FLOAT');v.scopes=['GAP'];v.setValueForMode(mode,n);vars['space/'+n]=v;}
for(const [name,n] of Object.entries({input:8,button:12,card:16})){const v=getVar('radius/'+name,'FLOAT');v.scopes=['CORNER_RADIUS'];v.setValueForMode(mode,n);vars['radius/'+name]=v;}
for(const [name,n] of Object.entries({target:48,button:52})){const v=getVar('size/'+name,'FLOAT');v.scopes=['WIDTH_HEIGHT'];v.setValueForMode(mode,n);vars['size/'+name]=v;}
const textStyles={};
for(const [name,size,line,style] of [['Title',24,32,'SemiBold'],['Heading',20,28,'SemiBold'],['Body',16,24,'Regular'],['Label',14,20,'Medium']]){
 const s=figma.createTextStyle();s.name='P9/'+name;s.fontName={family:'Be Vietnam Pro',style};s.fontSize=size;s.lineHeight={unit:'PIXELS',value:line};textStyles[name]=s;
}
const effects={};
for(const [name,y,blur,alpha] of [['Card',2,8,.08],['Overlay',8,24,.16]]){const s=figma.createEffectStyle();s.name='P9/'+name;s.effects=[{type:'DROP_SHADOW',color:{...rgb('#152C46'),a:alpha},offset:{x:0,y},radius:blur,spread:0,visible:true,blendMode:'NORMAL'}];effects[name]=s;}
const fill=(node,key)=>node.fills=[figma.variables.setBoundVariableForPaint({type:'SOLID',color:rgb(palette[key])},'color',vars[key])];
const root=figma.createAutoLayout('VERTICAL');page.appendChild(root);root.name='Power9 / Nền tảng';root.x=200;root.y=120;root.resize(960,100);root.primaryAxisSizingMode='AUTO';root.counterAxisSizingMode='FIXED';root.itemSpacing=24;root.paddingTop=root.paddingBottom=root.paddingLeft=root.paddingRight=32;fill(root,'background');
async function txt(parent,str,style='Body',color='text.primary',w=896){const t=figma.createText();parent.appendChild(t);t.fontName=textStyles[style].fontName;t.characters=str;await t.setTextStyleIdAsync(textStyles[style].id);t.textAutoResize='HEIGHT';t.resize(w,t.height);fill(t,color);return t;}
await txt(root,'Power9 — Hệ thống thiết kế','Title');
await txt(root,'Giao diện sáng · Tiếng Việt · Android 360 × 800','Body','text.secondary');
await txt(root,'01 / Màu theo vai trò','Heading');
const entries=Object.entries(palette);
for(let r=0;r<3;r++){const row=figma.createAutoLayout('HORIZONTAL');root.appendChild(row);row.fills=[];row.itemSpacing=16;row.primaryAxisSizingMode='AUTO';row.counterAxisSizingMode='AUTO';
 for(const [name,hex] of entries.slice(r*3,r*3+3)){const box=figma.createAutoLayout('VERTICAL');row.appendChild(box);box.resize(288,120);box.primaryAxisSizingMode='AUTO';box.counterAxisSizingMode='FIXED';box.paddingTop=box.paddingBottom=box.paddingLeft=box.paddingRight=16;box.itemSpacing=8;box.cornerRadius=16;fill(box,'surface');
 const sw=figma.createRectangle();box.appendChild(sw);sw.resize(256,32);sw.cornerRadius=8;fill(sw,name);await txt(box,name,'Label','text.primary',256);await txt(box,hex,'Label','text.secondary',256);}}
await txt(root,'02 / Kiểu chữ','Heading');
for(const [name,sample]of [['Title','Tiêu đề · 24 / 32'],['Heading','Tên màn và nhóm nội dung · 20 / 28'],['Body','Thở chậm 5 phút, bắt đầu từ việc nhỏ. · 16 / 24'],['Label','Hoàn thành · Thử lại · Quay lại · 14 / 20']])await txt(root,sample,name);
await txt(root,'03 / Khoảng cách, bo góc và độ nổi','Heading');
await txt(root,'Khoảng cách 4 · 8 · 12 · 16 · 24 · 32 dp\nBo góc: ô nhập 8 · nút 12 · thẻ 16 dp\nVùng chạm ≥ 48 × 48 dp · Nút chính cao 52 dp','Body');
await txt(root,'Màu chữ chính / trắng: 14.18:1 · Chữ phụ / trắng: 6.30:1\nChữ trắng / nút xanh: 6.81:1 · Chữ lỗi / trắng: 6.67:1','Label','text.secondary');
return {createdNodeIds:[root.id,...root.findAll(()=>true).map(n=>n.id)],mutatedNodeIds:figma.root.children.map(p=>p.id),collectionId:collection.id,variables:Object.fromEntries(Object.entries(vars).map(([k,v])=>[k,v.id])),textStyles:Object.fromEntries(Object.entries(textStyles).map(([k,v])=>[k,v.id])),effects:Object.fromEntries(Object.entries(effects).map(([k,v])=>[k,v.id])),bounds:{width:root.width,height:root.height}};
