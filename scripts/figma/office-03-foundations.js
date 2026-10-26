await figma.setCurrentPageAsync(await figma.getNodeByIdAsync('10:12'));
await Promise.all(['Regular','Medium','SemiBold','Bold'].map(style=>figma.loadFontAsync({family:'Be Vietnam Pro',style})));
const page=figma.currentPage;page.name='04 Design System';
const ids=[page.id], variables={},styles={};
if(page.children.some(n=>n.name==='Power9 / Foundations'))return {alreadyExists:true,pageId:page.id};
const rgb=h=>({r:parseInt(h.slice(1,3),16)/255,g:parseInt(h.slice(3,5),16)/255,b:parseInt(h.slice(5,7),16)/255});
// Collection helper follows figma-generate-library/scripts/createVariableCollection.js.
const existing=await figma.variables.getLocalVariableCollectionsAsync();
function collection(name){let c=existing.find(c=>c.name===name);if(!c){c=figma.variables.createVariableCollection(name);c.renameMode(c.modes[0].modeId,'Value');}return c;}
const primitives=collection('P9 Primitives'),semantic=collection('P9 Office');
const old=await figma.variables.getLocalVariablesAsync();
function variable(c,name,type,value,scopes){let v=old.find(v=>v.name===name&&v.variableCollectionId===c.id);if(!v)v=figma.variables.createVariable(name,c,type);v.scopes=scopes;v.setValueForMode(c.modes[0].modeId,value);v.setVariableCodeSyntax('WEB','var(--'+name.replaceAll('/','-')+')');variables[name]=v.id;return v;}
const colors={'surface':'#f8f9ff','surface-container-lowest':'#ffffff','surface-container-low':'#eff4ff','surface-container':'#e5eeff','primary':'#004287','primary-container':'#1e5aa8','on-surface':'#031c36','on-surface-variant':'#424751','outline':'#737782','outline-variant':'#c2c6d3','error':'#ba1a1a','error-container':'#ffdad6'};
for(const [name,hex] of Object.entries(colors)){const p=variable(primitives,'palette/'+name,'COLOR',rgb(hex),[]);variable(semantic,'color/'+name,'COLOR',{type:'VARIABLE_ALIAS',id:p.id},['FRAME_FILL','SHAPE_FILL','TEXT_FILL','STROKE_COLOR']);}
for(const n of [4,8,12,16,24,32,48,52])variable(semantic,'spacing/'+n,'FLOAT',n,['GAP','WIDTH_HEIGHT']);
for(const n of [8,12,16,24,999])variable(semantic,'radius/'+n,'FLOAT',n,['CORNER_RADIUS']);
const textStyles=await figma.getLocalTextStylesAsync();
for(const [name,size,line,weight] of [['Display',24,32,'Bold'],['Headline',20,28,'SemiBold'],['Body',16,24,'Regular'],['Body Medium',16,24,'Medium'],['Label',14,20,'Medium'],['Helper',14,20,'Regular']]){let s=textStyles.find(s=>s.name==='P9/'+name)||figma.createTextStyle();s.name='P9/'+name;s.fontName={family:'Be Vietnam Pro',style:weight};s.fontSize=size;s.lineHeight={unit:'PIXELS',value:line};styles[name]=s.id;}
const effects=await figma.getLocalEffectStylesAsync();let shadow=effects.find(s=>s.name==='P9/Card shadow')||figma.createEffectStyle();shadow.name='P9/Card shadow';shadow.effects=[{type:'DROP_SHADOW',color:{r:3/255,g:28/255,b:54/255,a:.06},offset:{x:0,y:2},radius:8,spread:0,visible:true,blendMode:'NORMAL'}];
function txt(p,s,size=16,weight='Regular',w=1056){const t=figma.createText();p.appendChild(t);ids.push(t.id);t.fontName={family:'Be Vietnam Pro',style:weight};t.fontSize=size;t.lineHeight={unit:'PIXELS',value:size===24?32:24};t.characters=s;t.textAutoResize='HEIGHT';t.resize(w,t.height);t.fills=[{type:'SOLID',color:rgb('#031c36')}];return t;}
const root=figma.createAutoLayout('VERTICAL');page.appendChild(root);ids.push(root.id);root.name='Power9 / Foundations';root.x=160;root.y=120;root.resize(1120,1);root.primaryAxisSizingMode='AUTO';root.paddingTop=root.paddingBottom=root.paddingLeft=root.paddingRight=32;root.itemSpacing=24;root.fills=[{type:'SOLID',color:rgb('#f8f9ff')}];
txt(root,'POWER9 / OFFICE ROUTINE',24,'Bold');txt(root,'Nền tảng giao diện · Nguồn OI02 + OI03 · Light theme');
txt(root,'Màu sắc',20,'SemiBold');
for(const [name,hex] of Object.entries(colors)){const row=figma.createAutoLayout('HORIZONTAL');root.appendChild(row);ids.push(row.id);row.resize(1056,48);row.itemSpacing=16;row.counterAxisAlignItems='CENTER';row.fills=[];const sw=figma.createRectangle();row.appendChild(sw);ids.push(sw.id);sw.resize(64,40);sw.cornerRadius=8;sw.fills=[figma.variables.setBoundVariableForPaint({type:'SOLID',color:rgb(hex)},'color',await figma.variables.getVariableByIdAsync(variables['color/'+name]))];txt(row,name+'   '+hex,16,'Medium',960);}
txt(root,'Be Vietnam Pro',24,'Bold');
for(const [name,id] of Object.entries(styles)){const t=txt(root,name+' — Thói quen nhỏ, ngày làm việc cân bằng');await t.setTextStyleIdAsync(id);}
txt(root,'Khoảng cách: 4 · 8 · 12 · 16 · 24 · 32 | Target ≥48 | CTA 52',16,'Medium');txt(root,'Bo góc: 8 · 12 · 16 · 24 | Mobile 360 × 800 và 412 × 800');
return {createdNodeIds:ids,variables,styles,effectStyle:shadow.id,collections:[primitives.id,semantic.id],pageId:page.id,boardId:root.id};
