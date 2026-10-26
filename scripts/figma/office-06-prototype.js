// Prepend: const OFFICE_UI_RESULT = <JSON returned by office-05-final-ui.js>;
// Run only after inspecting the Final UI screenshots and repairing any visual issues.
if(typeof OFFICE_UI_RESULT==='undefined')throw new Error('Missing verified Office UI result. Supply actual returned IDs, never guessed IDs.');
await figma.setCurrentPageAsync(await figma.getNodeByIdAsync('10:14'));
figma.currentPage.name='06 Prototype';
if(figma.currentPage.children.some(n=>n.name==='F01 / Mai / Hôm nay'))return {alreadyExists:true};
await Promise.all(['Regular','Medium','SemiBold','Bold'].map(style=>figma.loadFontAsync({family:'Be Vietnam Pro',style})));
const source={...OFFICE_UI_RESULT.screens,...OFFICE_UI_RESULT.states},ids=[],clones={},connections=[];
const page=figma.currentPage;
function collect(n){ids.push(n.id);if('children'in n)for(const c of n.children)collect(c);}
async function clone(key,sourceKey,x,y){const original=await figma.getNodeByIdAsync(source[sourceKey]);if(!original)throw new Error('Source missing: '+sourceKey);const n=original.clone();page.appendChild(n);n.name=key;n.x=x;n.y=y;collect(n);clones[key]=n;return n;}
const configurations=[
 ['F01 / Mai / Hôm nay','S01',160,160],['F01 / Khám phá','S05',600,160],['F01 / Chi tiết','S06',1040,160],['F01 / Lịch','S07',1480,160],['F01 / Đang lưu','S07-saving',1920,160],['F01 / Lỗi lưu','S07-error',2360,160],['F01 / Thử lại','S07-saving',2800,160],['F01 / Đã thêm','S01-added',3240,160],['F01 / Validation','S07-validation',1480,1080],['F01 / Không kết quả','S05-empty',600,1080],
 ['F02 / Huy / Hôm nay','S01',160,2080],['F02 / Thư giãn','S03',600,2080],['F02 / Đang nghỉ','S03-active',1040,2080],['F02 / Tạm dừng','S03-paused',1480,2080],['F02 / Hoàn tất','S03-finished',1920,2080],['F02 / Tiến độ','S08-session',2360,2080],['F02 / Home sau phiên','S01-session',2800,2080],['F02 / Checkin','S01-done',160,3000],['F02 / Checkin progress','S08-done',600,3000],
 ['F03 / Linh / Hôm nay','S01',160,4080],['F03 / Đã thêm từ trước','S06-existing',600,4080],['F03 / Đổi lịch','S07-edit',1040,4080],['F03 / Đang lưu','S07-edit-saving',1480,4080],['F03 / Lỗi lưu','S07-edit-error',1920,4080],['F03 / Thử lại','S07-edit-saving',2360,4080],['F03 / Đã đổi lịch','S01-rescheduled',2800,4080],['F03 / Validation','S07-edit-validation',1040,5000]
];
for(const args of configurations)await clone(...args);
function find(root,name){const n=clones[root].findOne(n=>n.name===name);if(!n)throw new Error(root+' missing interactive layer '+name);return n;}
async function link(node,dest,trigger={type:'ON_CLICK'},navigation='NAVIGATE'){const destination=clones[dest];if(!destination)throw new Error('Missing destination '+dest);for(let p=node;p&&p.type!=='PAGE';p=p.parent)if(p.id===destination.id)return;await node.setReactionsAsync([{trigger,actions:[{type:'NODE',destinationId:destination.id,navigation,transition:{type:'DISSOLVE',easing:{type:'EASE_OUT'},duration:.18},resetScrollPosition:false}]}]);connections.push({from:node.id,to:destination.id,trigger:trigger.type,navigation});}
async function go(root,label,to){await link(find(root,'Action/'+label),to);}
async function back(root,to){const node=clones[root].findOne(n=>n.name==='Back');if(node)await link(node,to);}
await go('F01 / Mai / Hôm nay','Khám phá','F01 / Khám phá');
await link(find('F01 / Khám phá','Discover detail'),'F01 / Chi tiết');
await link(find('F01 / Khám phá','Field/Tìm thói quen'),'F01 / Không kết quả');
await go('F01 / Không kết quả','Xóa bộ lọc','F01 / Khám phá');
await go('F01 / Chi tiết','Chọn lịch thực hiện','F01 / Lịch');
await go('F01 / Lịch','Lưu lịch','F01 / Đang lưu');
await link(clones['F01 / Đang lưu'],'F01 / Lỗi lưu',{type:'AFTER_TIMEOUT',timeout:.8});
await go('F01 / Lỗi lưu','Thử lại','F01 / Thử lại');
await link(find('F01 / Lỗi lưu','Action'),'F01 / Thử lại');
await link(clones['F01 / Thử lại'],'F01 / Đã thêm',{type:'AFTER_TIMEOUT',timeout:.8});
await link(find('F01 / Lịch','Field/Giờ nhắc (24h)'),'F01 / Validation');
await go('F01 / Validation','Chọn 12:00 và tiếp tục','F01 / Lịch');
for(const state of ['F01 / Lịch','F01 / Validation','F01 / Lỗi lưu']){await go(state,'Hủy','F01 / Chi tiết');await back(state,'F01 / Chi tiết');}
await back('F01 / Chi tiết','F01 / Khám phá');await back('F01 / Khám phá','F01 / Mai / Hôm nay');await back('F01 / Không kết quả','F01 / Khám phá');
const navMind=clones['F02 / Huy / Hôm nay'].findOne(n=>n.name==='Nav/2');await link(navMind,'F02 / Thư giãn');
await go('F02 / Thư giãn','Bắt đầu','F02 / Đang nghỉ');await go('F02 / Đang nghỉ','Tạm dừng','F02 / Tạm dừng');await go('F02 / Tạm dừng','Tiếp tục','F02 / Đang nghỉ');await go('F02 / Tạm dừng','Kết thúc','F02 / Hoàn tất');
await link(clones['F02 / Đang nghỉ'],'F02 / Hoàn tất',{type:'AFTER_TIMEOUT',timeout:135});
await go('F02 / Hoàn tất','Ghi nhận hoạt động','F02 / Tiến độ');await go('F02 / Hoàn tất','Về Hôm nay','F02 / Huy / Hôm nay');await back('F02 / Tiến độ','F02 / Home sau phiên');
await go('F02 / Home sau phiên','Tiến độ','F02 / Tiến độ');
await link(find('F02 / Huy / Hôm nay','Checkin'),'F02 / Checkin');await go('F02 / Checkin','Hoàn tác','F02 / Huy / Hôm nay');await go('F02 / Checkin','Tiến độ','F02 / Checkin progress');await go('F02 / Checkin progress','Hoàn tác','F02 / Huy / Hôm nay');await back('F02 / Checkin progress','F02 / Checkin');
for(const [key,origin]of [['F02 / Dialog active','F02 / Đang nghỉ'],['F02 / Dialog paused','F02 / Tạm dừng']]){const overlaySource=await figma.getNodeByIdAsync(OFFICE_UI_RESULT.dialog);const dialog=overlaySource.clone();page.appendChild(dialog);dialog.name=key;dialog.x=3240;dialog.y=key.endsWith('active')?2080:2500;collect(dialog);clones[key]=dialog;dialog.layoutMode='NONE';dialog.resize(360,800);dialog.fills=[{type:'SOLID',color:{r:3/255,g:28/255,b:54/255},opacity:.4}];const panel=dialog.children[0];panel.x=16;panel.y=(800-panel.height)/2;const trigger=find(origin,'Action/Rời phiên nghỉ');await link(trigger,key,{type:'ON_CLICK'},'OVERLAY');const stay=dialog.findOne(n=>n.name==='Action/Tiếp tục');await stay.setReactionsAsync([{trigger:{type:'ON_CLICK'},actions:[{type:'CLOSE'}]}]);connections.push({from:stay.id,to:clones[origin].id,navigation:'CLOSE'});const leave=dialog.findOne(n=>n.name==='Action/Rời phiên nghỉ');await link(leave,'F02 / Huy / Hôm nay');}
await link(find('F03 / Linh / Hôm nay','Reschedule'),'F03 / Đã thêm từ trước');await go('F03 / Đã thêm từ trước','Đổi lịch','F03 / Đổi lịch');await go('F03 / Đổi lịch','Lưu lịch','F03 / Đang lưu');await link(clones['F03 / Đang lưu'],'F03 / Lỗi lưu',{type:'AFTER_TIMEOUT',timeout:.8});await go('F03 / Lỗi lưu','Thử lại','F03 / Thử lại');await link(find('F03 / Lỗi lưu','Action'),'F03 / Thử lại');await link(clones['F03 / Thử lại'],'F03 / Đã đổi lịch',{type:'AFTER_TIMEOUT',timeout:.8});
await link(find('F03 / Đổi lịch','Field/Giờ nhắc (24h)'),'F03 / Validation');await go('F03 / Validation','Chọn 18:00 và tiếp tục','F03 / Đổi lịch');
for(const state of ['F03 / Đổi lịch','F03 / Validation','F03 / Lỗi lưu']){await go(state,'Hủy','F03 / Đã thêm từ trước');await back(state,'F03 / Đã thêm từ trước');}await back('F03 / Đã thêm từ trước','F03 / Linh / Hôm nay');
page.flowStartingPoints=[{nodeId:clones['F01 / Mai / Hôm nay'].id,name:'F01 · Mai · Tìm và thêm hoạt động'},{nodeId:clones['F02 / Huy / Hôm nay'].id,name:'F02 · Huy · Nghỉ, ghi nhận và hoàn tác'},{nodeId:clones['F03 / Linh / Hôm nay'].id,name:'F03 · Linh · Đổi lịch và giờ yên lặng'}];
return {createdNodeIds:ids,frames:Object.fromEntries(Object.entries(clones).map(([k,n])=>[k,n.id])),connections,startingPoints:page.flowStartingPoints,pendingChecks:['Interactive playback in Figma viewer'],note:'Timer states are representative snapshots, not a live one-second countdown. New session increases denominator from3 to4.'};
