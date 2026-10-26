await figma.setCurrentPageAsync(await figma.getNodeByIdAsync('10:13'));
const ids=[];
await Promise.all(['Regular','Medium','SemiBold','Bold'].map(style=>figma.loadFontAsync({family:'Be Vietnam Pro',style})));
const bar=await figma.getNodeByIdAsync('16:114');
const title=bar.findOne(n=>n.type==='TEXT');title.resize(276,28);title.fontSize=18;ids.push(title.id,bar.id);
if(!bar.children.some(n=>n.name==='Logo Power9')){const logo=figma.createRectangle();bar.appendChild(logo);logo.name='Logo Power9';logo.resize(40,40);logo.cornerRadius=20;logo.fills=[{type:'IMAGE',imageHash:'47373dd4399773f5c568891062bea8e0f197920d',scaleMode:'FIT'}];ids.push(logo.id);}
const font=(await figma.listAvailableFontsAsync()).find(f=>f.fontName.family==='Material Symbols Outlined');
if(font){await figma.loadFontAsync(font.fontName);for(const id of ['16:61','16:74','16:87','16:100']){const nav=await figma.getNodeByIdAsync(id);for(let i=0;i<nav.children.length;i++){const icon=nav.children[i].children[0];icon.fontName=font.fontName;icon.characters=['today','restaurant','spa','groups'][i];ids.push(icon.id);}}}
for(const id of ['16:51','16:54','16:57','16:121','16:126','16:139','16:143','16:147','16:152','16:156']){const c=await figma.getNodeByIdAsync(id);c.primaryAxisSizingMode='AUTO';ids.push(c.id);}
for(const id of ['16:4','16:6','16:8','16:10','16:12','16:14','16:16','16:18','16:20','16:22','16:24','16:26']){const c=await figma.getNodeByIdAsync(id);c.paddingTop=c.paddingBottom=12;ids.push(c.id);}
return {mutatedNodeIds:ids,logoHash:'47373dd4399773f5c568891062bea8e0f197920d',materialFont:font?.fontName,next:'office-ui-helpers.js + office-05-final-ui.js'};
