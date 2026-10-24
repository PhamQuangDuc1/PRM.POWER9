const input={"S01":{"id":"35:2","width":360,"height":800},"S02":{"id":"35:48","width":360,"height":800},"S03":{"id":"35:83","width":360,"height":800},"S04":{"id":"35:114","width":360,"height":800},"S05":{"id":"35:156","width":360,"height":800},"S06":{"id":"35:189","width":360,"height":800},"S07":{"id":"35:206","width":360,"height":800},"S08":{"id":"35:233","width":360,"height":800}};
await figma.setCurrentPageAsync(figma.root.children.find(p=>p.id==='1:2'));
await Promise.all(['Regular','Medium','SemiBold','Bold'].map(style=>figma.loadFontAsync({family:'Be Vietnam Pro',style})));
if(figma.currentPage.children.some(n=>n.name==='WF/S01 · Hôm nay'))return {alreadyExists:true};
figma.currentPage.backgrounds=[{type:'SOLID',color:{r:.91,g:.92,b:.94}}];
const vars=await figma.variables.getLocalVariablesAsync();const vm=new Map(vars.map(v=>[v.id,v.name]));
const created=[];const map={};let i=0;
for(const [key,s]of Object.entries(input)){const src=await figma.getNodeByIdAsync(s.id);const n=src.clone();figma.currentPage.appendChild(n);n.name='WF/'+src.name;n.x=200+i%4*440;n.y=160+Math.floor(i/4)*920;i++;
 for(const q of [n,...n.findAll(()=>true)]){
 for(const field of ['fills','strokes'])if(field in q&&Array.isArray(q[field]))q[field]=q[field].map(p=>{if(p.type!=='SOLID')return p;const key=vm.get(p.boundVariables?.color?.id)||'';let g;if(key.includes('action/primary'))g=.18;else if(key.includes('action/onPrimary'))g=1;else if(key.includes('text/primary'))g=.12;else if(key.includes('text/secondary'))g=.32;else if(key.includes('selected'))g=.9;else if(key.includes('background'))g=.96;else if(key.includes('surface'))g=1;else if(key.includes('error'))g=.25;else g=(p.color.r+p.color.g+p.color.b)/3;const {boundVariables,...rest}=p;return {...rest,color:{r:g,g:g,b:g}};});
 if('effects'in q)q.effects=[];
 }
 created.push(n);map[key]={id:n.id,width:n.width,height:n.height};
}
return {createdNodeIds:created.flatMap(n=>[n.id,...n.findAll(()=>true).map(n=>n.id)]),wireframes:map};
