// Prepend const ACCORDION_LIBRARY=<actual library result>, TARGET_PAGE_ID, PROTOTYPE_MODE.
await figma.setCurrentPageAsync(await figma.getNodeByIdAsync(TARGET_PAGE_ID));
await Promise.all(['Regular','Medium','SemiBold','Bold'].map(style=>figma.loadFontAsync({family:'Be Vietnam Pro',style})));
figma.skipInvisibleInstanceChildren=false;
const page=figma.currentPage,ids=[],removed=[],checks=[],replacements=[];
const listIds=PROTOTYPE_MODE?['30:43','31:519','31:570']:['27:135','28:526'];
function nav(node){if(!node||!('reactions'in node))return null;for(const r of node.reactions)for(const a of r.actions||[])if(a.type==='NODE'&&a.navigation==='NAVIGATE')return a.destinationId;return null;}
async function navigate(node,dest){if(!dest)return;await node.setReactionsAsync([{trigger:{type:'ON_CLICK'},actions:[{type:'NODE',destinationId:dest,navigation:'NAVIGATE',transition:null,resetScrollPosition:false,resetInteractiveComponents:false}]}]);}
function record(n){ids.push(n.id);if('children'in n)for(const c of n.children)record(c);}
function fit(n){if('children'in n)for(const c of n.children)fit(c);if(n.type==='FRAME'&&n.layoutMode==='VERTICAL'&&n.primaryAxisSizingMode==='AUTO'){const cs=n.children.filter(n=>n.visible);n.resize(n.width,n.paddingTop+n.paddingBottom+cs.reduce((s,n)=>s+n.height,0)+n.itemSpacing*Math.max(0,cs.length-1));n.primaryAxisSizingMode='AUTO';}}
for(const listId of listIds){const list=await figma.getNodeByIdAsync(listId),body=list.findOne(n=>n.name==='Content');
 for(let i=1;i<=9;i++){
  const old=body.children.find(n=>n.name==='Group/'+i);if(!old)throw new Error('Missing Group/'+i+' in '+list.name);
  if(old.type==='INSTANCE'){checks.push({list:list.id,group:i,alreadyApplied:true});continue;}
  const group=String(i).padStart(2,'0'),initial=i===7?'Expanded':'Collapsed';
  const activityDest=i===7?[nav(old.findOne(n=>n.name==='Discover detail')),nav(old.findOne(n=>n.name==='Discover detail 2'))]:[nav(old)||nav(old.findOne(n=>n.name==='Group item/'+i))];
  const relatedDest=nav(old.children.find(n=>n.type==='TEXT'));
  const c=(await figma.getNodeByIdAsync(ACCORDION_LIBRARY.variants[group][initial])).createInstance();body.insertChild(body.children.indexOf(old),c);c.name=old.name;c.resize(old.width,c.height);c.layoutSizingHorizontal='FILL';c.visible=old.visible;
  for(let j=0;j<activityDest.length;j++)await navigate(c.findOne(n=>n.name==='Activity/'+(j+1)),activityDest[j]);
  await navigate(c.findOne(n=>n.name==='Related'),relatedDest);
  // State changes must keep overridden activity destinations on the live instance.
  c.setProperties({State:'Expanded'});
  const current=activityDest.map((_,j)=>nav(c.findOne(n=>n.name==='Activity/'+(j+1))));
  const kept=activityDest.every((d,j)=>!d||current[j]===d);
  const open=c.findOne(n=>n.name==='Header').reactions.some(r=>(r.actions||[]).some(a=>a.navigation==='CHANGE_TO'&&a.destinationId===ACCORDION_LIBRARY.variants[group].Collapsed));
  if(!kept||!open)throw new Error('Accordion state lost navigation in '+list.name+' group'+i);
  c.setProperties({State:'Collapsed'});
  const close=c.findOne(n=>n.name==='Header').reactions.some(r=>(r.actions||[]).some(a=>a.navigation==='CHANGE_TO'&&a.destinationId===ACCORDION_LIBRARY.variants[group].Expanded));
  if(!close)throw new Error('Missing expand reaction in group'+i);
  c.setProperties({State:initial});
  removed.push(old.id,...old.findAll(()=>true).map(n=>n.id));old.remove();record(c);replacements.push({list:list.id,group:i,instance:c.id,initial,visible:c.visible,destinations:activityDest,related:relatedDest});checks.push({list:list.id,group:i,expand:close,collapse:open,navigationPreserved:kept});
 }
 fit(body);
}
if(PROTOTYPE_MODE)page.flowStartingPoints=[{nodeId:'30:2',name:'F01 · Mai · Tìm và thêm hoạt động'},{nodeId:'30:324',name:'F02 · Huy · Nghỉ, ghi nhận và hoàn tác'},{nodeId:'30:638',name:'F03 · Linh · Đổi lịch và giờ yên lặng'}];
const first=await figma.getNodeByIdAsync(listIds[0]);const group1=first.findOne(n=>n.name==='Group/1');group1.setProperties({State:'Expanded'});fit(first.findOne(n=>n.name==='Content'));await first.screenshot({scale:.85});group1.setProperties({State:'Collapsed'});fit(first.findOne(n=>n.name==='Content'));
return {createdNodeIds:ids,removedNodeIds:removed,replacements,checks,passed:checks.every(c=>c.alreadyApplied||c.expand&&c.collapse&&c.navigationPreserved),startingPoints:PROTOTYPE_MODE?page.flowStartingPoints:undefined};
