const ids=[];
await Promise.all(['Regular','Medium','SemiBold','Bold'].map(style=>figma.loadFontAsync({family:'Be Vietnam Pro',style})));
const vars=Object.fromEntries((await figma.variables.getLocalVariablesAsync()).map(v=>[v.name,v]));
const styles=Object.fromEntries((await figma.getLocalTextStylesAsync()).map(s=>[s.name,s]));
const rgb=h=>({r:parseInt(h.slice(1,3),16)/255,g:parseInt(h.slice(3,5),16)/255,b:parseInt(h.slice(5,7),16)/255});
function fill(n,key='surface-container-lowest',stroke=false){const p=figma.variables.setBoundVariableForPaint({type:'SOLID',color:{r:1,g:1,b:1}},'color',vars['color/'+key]);if(stroke)n.strokes=[p];else n.fills=[p];}
function bind(n,key,value){const v=vars[(key==='cornerRadius'?'radius/':'spacing/')+value];if(v)n.setBoundVariable(key,v);else n[key]=value;}
function pad(n,v=16){for(const k of ['paddingTop','paddingBottom','paddingLeft','paddingRight'])bind(n,k,v);}
function frame(parent,name,w=328,mode='VERTICAL',bg=null){const n=figma.createAutoLayout(mode);parent.appendChild(n);ids.push(n.id);n.name=name;n.resize(w,1);n.primaryAxisSizingMode='AUTO';n.counterAxisSizingMode='FIXED';bind(n,'itemSpacing',12);n.fills=[];if(bg)fill(n,bg);return n;}
function text(parent,s,w=296,style='Body',color='on-surface'){const t=figma.createText();parent.appendChild(t);ids.push(t.id);t.name=s.slice(0,70);const ts=styles['P9/'+style];t.fontName=ts.fontName;t.fontSize=ts.fontSize;t.lineHeight=ts.lineHeight;t.textStyleId=ts.id;t.characters=s;t.textAutoResize='HEIGHT';t.resize(w,Math.max(1,t.height));fill(t,color);return t;}
function round(n,r=16){n.cornerRadius=r;bind(n,'cornerRadius',r);}
function fixed(n,w,h){n.resize(w,h);n.primaryAxisSizingMode='FIXED';n.counterAxisSizingMode='FIXED';}
function fit(n){if('children'in n)for(const c of n.children)fit(c);if((n.type==='FRAME'||n.type==='COMPONENT'||n.type==='COMPONENT_SET')&&n.layoutMode!=='NONE'&&n.primaryAxisSizingMode==='AUTO'){const cs=n.children.filter(c=>c.visible&&c.layoutPositioning!=='ABSOLUTE');const v=n.layoutMode==='VERTICAL';const main=cs.reduce((s,c)=>s+(v?c.height:c.width),0)+n.itemSpacing*Math.max(0,cs.length-1);if(v)n.resize(n.width,Math.max(1,n.paddingTop+n.paddingBottom+main));else n.resize(Math.max(1,n.paddingLeft+n.paddingRight+main),n.height);n.primaryAxisSizingMode='AUTO';}}
function collect(n){ids.push(n.id);if('children'in n)for(const c of n.children)collect(c);}
