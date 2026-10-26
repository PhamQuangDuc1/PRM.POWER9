await figma.setCurrentPageAsync(await figma.getNodeByIdAsync('10:13'));
await Promise.all(['Regular','Medium','SemiBold','Bold'].map(style=>figma.loadFontAsync({family:'Be Vietnam Pro',style})));
const ids=[],removed=[],created=[];
function track(n){created.push(n.id);if('children'in n)for(const c of n.children)track(c);}
const paths=[
 '<rect x="4" y="5" width="16" height="16" rx="2"/><path d="M8 3v4m8-4v4M4 10h16m-12 4h4m-4 3h7"/>',
 '<path d="M5 3v7m3-7v7m-6-7v7c0 2 6 2 6 0M5 12v9M17 3c-4 4-4 9 0 9V3Zm0 9v9"/>',
 '<path d="M12 21C3 17 2 10 4 6c6 1 8 6 8 15Zm0 0c9-4 10-11 8-15-6 1-8 6-8 15Zm0-5V3"/>',
 '<circle cx="9" cy="7" r="3"/><circle cx="18" cy="9" r="2"/><path d="M3 21v-4c0-5 12-5 12 0v4M16 14c4-1 6 1 6 4v3"/>'
];
function svg(path,color='#1e5aa8'){return '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><g fill="none" stroke="'+color+'" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">'+path+'</g></svg>';}
for(let selected=0;selected<4;selected++){const n=await figma.getNodeByIdAsync(['16:61','16:74','16:87','16:100'][selected]);for(let i=0;i<n.children.length;i++){const item=n.children[i];if(!item.children.some(n=>n.name==='Icon / Native')){const old=item.children[0];if(old.type==='TEXT'){removed.push(old.id);old.remove();}const v=figma.createNodeFromSvg(svg(paths[i],i===selected?'#1e5aa8':'#424751'));item.insertChild(0,v);v.name='Icon / Native';v.resize(24,24);item.counterAxisAlignItems='CENTER';track(v);ids.push(item.id);}}}
for(const id of ['16:139','16:143','16:147','16:132','16:135']){const c=await figma.getNodeByIdAsync(id);if(!c.children.some(n=>n.name==='State icon')){const v=figma.createNodeFromSvg(svg(id==='16:132'||id==='16:135'?'<path d="M21 12a9 9 0 1 1-6-8.5"/>':'<circle cx="10" cy="10" r="6"/><path d="m15 15 6 6M7 10h6"/>'));c.insertChild(0,v);v.name='State icon';v.resize(32,32);track(v);ids.push(c.id);}}
const sets=figma.currentPage.children.filter(n=>n.type==='COMPONENT_SET');
await (await figma.getNodeByIdAsync('16:113')).screenshot({scale:.8});
return {createdNodeIds:created,mutatedNodeIds:ids,removedNodeIds:removed,sets:sets.map(n=>({id:n.id,name:n.name,variants:n.children.length})),variables:(await figma.variables.getLocalVariablesAsync()).length,textStyles:(await figma.getLocalTextStylesAsync()).length,effectStyles:(await figma.getLocalEffectStylesAsync()).length,appBarLogo:!!(await figma.getNodeByIdAsync('16:114')).findOne(n=>n.name==='Logo Power9')};
