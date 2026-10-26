await figma.setCurrentPageAsync(await figma.getNodeByIdAsync('7:3'));
await Promise.all(['Regular','Medium','SemiBold','Bold'].map(style=>figma.loadFontAsync({family:'Be Vietnam Pro',style})));
const ids=[],created=[];
const main=await figma.getNodeByIdAsync('27:3');
for(const n of figma.currentPage.findAll(n=>n.type==='FRAME'&&n.name==='Filters')){n.resize(n.width,48);n.primaryAxisSizingMode='FIXED';ids.push(n.id);}
// Keep related boxes responsive through Auto Layout and explicit wrapping widths.
function reflow(n,w){
 if(n.type==='TEXT'){n.textAutoResize='HEIGHT';n.resize(w,n.height);return;}
 if(!('children'in n)||!('resize'in n))return;
 const h=n.height;n.resize(w,h);
 if(n.name==='AppBar'){
  const title=n.findOne(c=>c.type==='TEXT'&&c.name!=='←');if(title)title.resize(w-(n.findOne(c=>c.name==='Back')?92:84),title.height);
  return;
 }
 if(n.name==='Bottom navigation'){const itemW=(w-8)/4;for(const item of n.children){item.resize(itemW,64);for(const t of item.children)if(t.type==='TEXT')t.resize(itemW-8,t.height);}return;}
 if(n.name==='Filters'){const itemW=(w-16)/3;for(const item of n.children){item.resize(itemW,48);for(const t of item.children)if(t.type==='TEXT')t.resize(itemW,t.height);}return;}
 if(n.name==='Progress track'){const bar=n.children[0];const ratio=bar.width/(n.width===w?w:n.width);bar.resize(Math.round(w*.33),10);return;}
 if(n.name.startsWith('Action/')||n.name==='Saving'){for(const t of n.children)if(t.type==='TEXT')t.resize(w-32,t.height);return;}
 const pw=w-(n.paddingLeft||0)-(n.paddingRight||0);
 for(const c of n.children){if(c.name==='Back'||c.name==='Logo Power9')continue;reflow(c,pw);}
 if(n.layoutMode==='VERTICAL'&&n.primaryAxisSizingMode==='AUTO'){n.resize(w,Math.max(1,(n.paddingTop||0)+(n.paddingBottom||0)+n.children.reduce((sum,c)=>sum+c.height,0)+(n.itemSpacing||0)*Math.max(0,n.children.length-1)));n.primaryAxisSizingMode='AUTO';}
}
let board=figma.currentPage.children.find(n=>n.name==='QA / 412px');
if(!board){board=figma.createFrame();figma.currentPage.appendChild(board);created.push(board.id);board.name='QA / 412px';board.x=4200;board.y=120;board.resize(2480,1900);board.fills=[{type:'SOLID',color:{r:.94,g:.96,b:1}}];board.clipsContent=false;for(let i=0;i<main.children.length;i++){const original=main.children[i];const c=original.clone();board.appendChild(c);c.name=original.name+' / 412';c.x=40+(i%5)*488;c.y=64+Math.floor(i/5)*900;reflow(c,412);c.resize(412,800);created.push(c.id,...c.findAll(()=>true).map(n=>n.id));}}
const overflow=board.findAll(n=>n.type==='TEXT'&&n.width>n.parent.width+1).map(n=>({id:n.id,name:n.name}));
await (await figma.getNodeByIdAsync('27:135')).screenshot({scale:.8});
await board.children[0].screenshot({scale:.8});
return {createdNodeIds:created,mutatedNodeIds:ids,qaBoard:board.id,responsiveFrames:board.children.map(n=>({id:n.id,name:n.name,width:n.width,height:n.height})),horizontalTextOverflow:overflow};
