await figma.setCurrentPageAsync(await figma.getNodeByIdAsync('7:3'));
await Promise.all(['Regular','Medium','SemiBold','Bold'].map(style=>figma.loadFontAsync({family:'Be Vietnam Pro',style})));
const ids=[];
const vars=Object.fromEntries((await figma.variables.getLocalVariablesAsync()).map(v=>[v.name,v]));
for(const filters of figma.currentPage.findAll(n=>n.type==='FRAME'&&n.name==='Filters'))for(const n of filters.children){const active=n.name==='Filter/Tất cả';n.fills=[figma.variables.setBoundVariableForPaint({type:'SOLID',color:active?{r:30/255,g:90/255,b:168/255}:{r:229/255,g:238/255,b:1}},'color',vars['color/'+(active?'primary-container':'surface-container')])];for(const t of n.findAll(n=>n.type==='TEXT'))t.fills=[figma.variables.setBoundVariableForPaint({type:'SOLID',color:active?{r:1,g:1,b:1}:{r:30/255,g:90/255,b:168/255}},'color',vars['color/'+(active?'surface-container-lowest':'primary-container')])];ids.push(n.id);}
const board=await figma.getNodeByIdAsync('27:3'),qa=await figma.getNodeByIdAsync('28:395');
const wf=await figma.getNodeByIdAsync('9:2'),ds=await figma.getNodeByIdAsync('15:48');
const textOverflow=[];
for(const root of [board,qa])for(const n of root.findAll(n=>n.type==='TEXT'))if(n.width>n.parent.width+1||n.width<1)textOverflow.push({id:n.id,name:n.name,width:n.width,parent:n.parent.width});
const controls=board.findAll(n=>n.type==='INSTANCE'&&n.name.startsWith('Action/'));
await board.screenshot({scale:.55});await ds.screenshot({scale:.6});
return {mutatedNodeIds:ids,pages:figma.root.children.map(p=>({id:p.id,name:p.name})),mainScreens:board.children.map(n=>({id:n.id,name:n.name,width:n.width,height:n.height})),qaScreens:qa.children.map(n=>({id:n.id,name:n.name,width:n.width,height:n.height})),wireframes:{count:wf.children.length,editableText:wf.findAll(n=>n.type==='TEXT').length},designSystem:{variables:(await figma.variables.getLocalVariablesAsync()).length,textStyles:(await figma.getLocalTextStylesAsync()).length,effectStyles:(await figma.getLocalEffectStylesAsync()).length},editableUI:board.findAll(n=>n.type==='TEXT').length,uiInstances:board.findAll(n=>n.type==='INSTANCE').length,textOverflow,shortActions:controls.filter(n=>n.height<48).map(n=>n.id),completeScreenImageFills:board.children.filter(n=>Array.isArray(n.fills)&&n.fills.some(p=>p.type==='IMAGE')).map(n=>n.id)};
