// Append before the return in office-06c-final-repair.js when running final repair.
for(const label of ['5','10']){
 const prefix='F01 / ≤'+label+' / ',list=label==='5'?'F01 / Lọc 5 phút':'F01 / Lọc 10 phút';
 const pairs=[['Chi tiết','F01 / Chi tiết'],['Lịch','F01 / Lịch'],['Validation','F01 / Validation'],['Đang lưu','F01 / Đang lưu'],['Lỗi lưu','F01 / Lỗi lưu'],['Thử lại','F01 / Thử lại']];
 for(let i=0;i<pairs.length;i++)await fork(prefix+pairs[i][0],pairs[i][1],160+i*440,11200+(label==='5'?0:920));
 await link(child(list,'Discover detail'),prefix+'Chi tiết');await back(prefix+'Chi tiết',list);await action(prefix+'Chi tiết','Chọn lịch thực hiện',prefix+'Lịch');
 await action(prefix+'Lịch','Lưu lịch',prefix+'Đang lưu');await link(frames[prefix+'Đang lưu'],prefix+'Lỗi lưu',{type:'AFTER_TIMEOUT',timeout:.8});await action(prefix+'Lỗi lưu','Thử lại',prefix+'Thử lại');await link(child(prefix+'Lỗi lưu','Action'),prefix+'Thử lại');await link(frames[prefix+'Thử lại'],'F01 / Đã thêm',{type:'AFTER_TIMEOUT',timeout:.8});
 await link(child(prefix+'Lịch','Field/Giờ nhắc (24h)'),prefix+'Validation');await action(prefix+'Validation','Chọn 12:00 và tiếp tục',prefix+'Lịch');for(const s of ['Lịch','Lỗi lưu','Validation']){await action(prefix+s,'Hủy',prefix+'Chi tiết');await back(prefix+s,prefix+'Chi tiết');}
}
// Native category headers provide access to the complete workspace and sleep screens.
for(const root of ['F01 / Khám phá','F01 / Lọc 5 phút','F01 / Lọc 10 phút']){for(const [index,to]of [[2,'Duyệt / Góc làm việc'],[6,'Duyệt / Góc làm việc'],[4,'Duyệt / Ngủ']]){const group=child(root,'Group/'+index);const title=group.children.find(n=>n.type==='TEXT');if(title)await link(title,to);}}
// Restore exactly the three requested entry points after Figma creates temporary roots.
page.flowStartingPoints=[{nodeId:frames['F01 / Mai / Hôm nay'].id,name:'F01 · Mai · Tìm và thêm hoạt động'},{nodeId:frames['F02 / Huy / Hôm nay'].id,name:'F02 · Huy · Nghỉ, ghi nhận và hoàn tác'},{nodeId:frames['F03 / Linh / Hôm nay'].id,name:'F03 · Linh · Đổi lịch và giờ yên lặng'}];
// Preserve 48px tap targets for activity labels inside the discover cards.
for(const f of Object.values(frames))for(const t of f.findAll(n=>n.type==='TEXT'&&n.name.startsWith('Group item/')&&n.reactions.length)){const row=t.parent;await row.setReactionsAsync(t.reactions);await t.setReactionsAsync([]);ids.push(row.id,t.id);}
// Paint fallback values match the variables, so immediate screenshots are accurate.
for(const root of ['F01 / Khám phá','F01 / Lọc 5 phút','F01 / Lọc 10 phút'])for(const n of frames[root].findAll(n=>n.name.startsWith('Filter/'))){const active=n.name==='Filter/'+(root.endsWith('5 phút')?'≤5 phút':root.endsWith('10 phút')?'≤10 phút':'Tất cả');n.fills=[figma.variables.setBoundVariableForPaint({type:'SOLID',color:active?{r:30/255,g:90/255,b:168/255}:{r:229/255,g:238/255,b:1}},'color',vars['color/'+(active?'primary-container':'surface-container')])];for(const t of n.findAll(n=>n.type==='TEXT'))t.fills=[figma.variables.setBoundVariableForPaint({type:'SOLID',color:active?{r:1,g:1,b:1}:{r:30/255,g:90/255,b:168/255}},'color',vars['color/'+(active?'surface-container-lowest':'primary-container')])];ids.push(n.id);}
