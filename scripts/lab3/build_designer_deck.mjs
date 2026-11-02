/** Editable Lab 3 presentation. Real evidence only; no reconstructed Console. */
import fs from 'node:fs/promises';
import path from 'node:path';
import {pathToFileURL} from 'node:url';

const root=path.resolve('.');
const modules=process.env.RUNTIME_NODE_MODULES || 'C:/Users/PC/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules';
process.env.RUNTIME_NODE_MODULES=modules;
const skill=process.env.POWER9_PRESENTATION_SKILL || 'C:/Users/PC/.codex/plugins/cache/openai-primary-runtime/presentations/26.1026.10807/skills/presentations';
const {Presentation,PresentationFile}=await import(pathToFileURL(path.join(modules,'@oai/artifact-tool/dist/artifact_tool.mjs')));
const {finalizePresentation,applyPresentationChartFont}=await import(pathToFileURL(path.join(skill,'container_tools/artifact_tool_utils.mjs')));
const build=path.join(root,'.build/lab3-design');
const out=path.join(root,'output/lab3');
await fs.mkdir(build,{recursive:true});await fs.mkdir(out,{recursive:true});
const deck=Presentation.create({slideSize:{width:1600,height:900}});
const C={paper:'#F4F3EF',white:'#FFFFFF',ink:'#0B2240',blue:'#1E5AA8',muted:'#526174',light:'#DCE7F5',green:'#176B57',rust:'#A33C25',line:'#D6DDE5'};
const FONT='Arial';
const pr=JSON.parse(await fs.readFile(path.join(root,'evidence/code-review/lab3-pr.json'),'utf8'));
const summary=JSON.parse(await fs.readFile(path.join(root,'evidence/artemis/lab3-summary.json'),'utf8'));
const meta=[];
function text(s,value,x,y,w,h,size=28,bold=false,color=C.ink){
 const sh=s.shapes.add({geometry:'textbox',name:value.replace(/\n/g,' ').slice(0,90),position:{left:x,top:y,width:w,height:h},fill:'none',line:{fill:'none',width:0}});
 sh.text=value;sh.text.style={typeface:FONT,fontSize:size,bold,color,autoFit:'none',insets:0};return sh;
}
function slide(title,{dark=false,sub='',sources=[],notes=''}={}){
 const s=deck.slides.add();const n=deck.slides.items.length;s.background.fill=dark?C.ink:C.paper;
 const fg=dark?C.white:C.ink;
 if(title)text(s,title,80,66,1420,105,62,true,fg);
 if(sub)text(s,sub,84,181,1410,58,26,false,dark?C.light:C.muted);
 text(s,`POWER9 / LAB 3`,82,847,1100,24,17,false,dark?C.light:C.muted);
 text(s,String(n).padStart(2,'0'),1470,837,65,42,26,true,dark?C.light:C.ink);
 s.speakerNotes.text=notes+'\n\nNGUỒN VÀ GIỚI HẠN\n'+sources.map(v=>v.startsWith('http')?v:`https://github.com/PhamQuangDuc1/PRM.POWER9/blob/codex/lab3-review-and-slides/${v}`).join('\n');
 meta.push({slide:n,title,notes,sources});return s;
}
async function image(s,file,x,y,w,h,alt){
 const b=await fs.readFile(path.join(root,file));return s.images.add({blob:b.buffer.slice(b.byteOffset,b.byteOffset+b.byteLength),contentType:file.endsWith('.jpg')?'image/jpeg':'image/png',fit:'contain',position:{left:x,top:y,width:w,height:h},alt});
}
function table(s,values,x,y,w,h,widths,size=25){
 const t=s.tables.add({rows:values.length,columns:values[0].length,left:x,top:y,width:w,height:h,columnWidths:widths,values});
 t.borders.assign({fill:C.line,width:.7,style:'solid'});
 for(let r=0;r<values.length;r++)for(let c=0;c<values[0].length;c++){
  const cell=t.getCell(r,c);cell.fill=r===0?C.ink:C.white;
  cell.text.style={typeface:FONT,fontSize:size,bold:r===0,color:r===0?C.white:C.ink,insets:15};
 }
 return t;
}
function node(s,label,x,y,w,h){
 const n=s.shapes.add({geometry:'rect',name:label,position:{left:x,top:y,width:w,height:h},fill:C.white,line:{fill:C.blue,width:1.4}});
 n.text=label;n.text.style={typeface:FONT,fontSize:30,bold:true,color:C.ink,alignment:'center',verticalAlignment:'middle',insets:15};return n;
}
function arrow(s,a,b){s.shapes.connect(a,b,{kind:'straight',fromSide:'right',toSide:'left',line:{fill:C.blue,width:3},tail:{type:'arrow',width:'med',length:'med'}});}
// 01 — product cover; original brand artwork is never recolored or redrawn.
let s=slide('',{sources:['assets/brand/README.md','evidence/artemis/latest-home-trace-source.json'],notes:'Power9 Office Routine là ứng dụng Android cho các khoảng nghỉ ngắn trong ngày làm việc. Đây là Lab 3 Cloud-Enabled, kế thừa ba flow Lab 2. Ảnh là app thật từ trace ngày 01/11, không phải đề xuất UI mới. Bản trình bày được làm lại ngày 02/11; video được để cuối theo quyết định người dùng.'});
await image(s,'assets/brand/power9-logo-3d.png',73,61,118,105,'Logo P9 gốc do người dùng thiết kế');
text(s,'POWER9',78,213,980,158,132,true,C.blue);
text(s,'Office Routine',85,378,900,90,70,true);
text(s,'Thói quen nhỏ cho\nngày làm việc cân bằng.',88,537,850,142,46);
text(s,'PRM393 · Lab 3 Cloud-Enabled\nFlutter / Firebase / Android',89,729,800,75,26,false,C.muted);
await image(s,'evidence/artemis/latest-home-trace-xperia.jpg',1120,62,330,744,'Power9 Home thật từ trace TC16, 01/11/2026');
// 02 — need, not a wall of feature bullets.
s=slide('Khoảng nghỉ ngắn, lịch làm việc thay đổi',{sub:'Ba persona giả định từ Lab 2; chưa phải kết quả nghiên cứu người dùng.',sources:['ux/persona.md','ux/user-flow.md'],notes:'Huy, Mai và Linh là ba persona giả định ngang nhau. Nhóm chưa tiến hành khảo sát hoặc đo thời gian hoàn thành tác vụ. Một ứng dụng chung, không có bước chọn persona. Các hoạt động là tự nguyện và không phải lời khuyên sức khỏe.'});
const personas=[['Huy, 28','Ngồi lâu khi tập trung','Bắt đầu một hoạt động\ntrong khoảng nghỉ ngắn.'],['Mai, 24','Ăn vội, ít quen đồng nghiệp','Hoạt động dễ bắt đầu,\nkết nối hoàn toàn tự nguyện.'],['Linh, 39','Lịch họp thường thay đổi','Đổi lịch linh hoạt,\ngiữ quyền tự chọn.']];
personas.forEach((v,i)=>{const x=86+i*505;text(s,v[0],x,309,465,75,52,true,C.blue);text(s,v[1],x,423,455,95,33,true);text(s,v[2],x,565,450,125,31,false,C.muted);});
text(s,'Không đặt mục tiêu hoàn thành cả 9 nhóm mỗi ngày.',88,755,1410,52,32,true);
// 03 — three real flow artifacts with large readable captions.
s=slide('Ba luồng cốt lõi',{dark:true,sub:'Chọn lịch · Thực hiện và xem lại · Đổi lịch',sources:['evidence/flows/schedule-validation-xperia.png','evidence/f02/progress-early-end-xperia.png','evidence/flows/home-schedule-xperia.png','docs/test-report.md'],notes:'F01 kiểm tra thiếu giờ khi bật nhắc và chỉ cập nhật Home sau ghi thành công. F02 timer ghi thời gian thật, ví dụ 72 giây trong ảnh ngày 31/10; Undo không xóa schedule. F03 hủy giữ dữ liệu, lưu đổi giờ không tạo lịch thứ hai. Ba ảnh là bằng chứng các mốc trước, không khẳng định đã quay lại ngày 02/11.'});
for(const [i,v] of [['F01','Chọn lịch','evidence/flows/schedule-validation-xperia.png'],['F02','Ghi nhận thực tế','evidence/f02/progress-early-end-xperia.png'],['F03','Sửa, không trùng lịch','evidence/flows/home-schedule-xperia.png']].entries()){
 const x=87+i*505;await image(s,v[2],x+60,265,320,470,`${v[0]} ảnh app thật tại mốc kiểm chứng trước`);text(s,v[0],x,755,100,50,31,true,C.light);text(s,v[1],x+105,755,370,55,29,true,C.white);
}
// 04 — required architecture as native editable diagram.
s=slide('MVVM và luồng dữ liệu',{sub:'Màn hình đọc state; Firebase SDK được bao gói trong services.',sources:['docs/architecture.md','lib/viewmodels/app_providers.dart','lib/services'],notes:'Riverpod kết nối View và ViewModel. Firebase SDK không nằm trong các màn nghiệp vụ. Service xác nhận ghi rồi ViewModel mới đưa success về UI. Stream dữ liệu cập nhật lại các màn; các mũi tên ở đây biểu diễn hướng phụ thuộc, không phải thứ tự đồng bộ của mọi request.'});
const layers=[['View','screens','Render, loading, error'],['ViewModel','viewmodels','Draft, validation, async guard'],['Service','services','Contract và Firebase SDK'],['Firebase','Cloud','Auth, dữ liệu, telemetry']];
const nodes=layers.map((v,i)=>{const x=88+i*379;const n=node(s,v[0],x,325,290,120);text(s,v[1],x,491,325,50,29,true,C.blue);text(s,v[2],x,562,330,105,29,false,C.muted);return n;});
nodes.slice(0,-1).forEach((n,i)=>arrow(s,n,nodes[i+1]));text(s,'Ghi thành công → cập nhật state → giao diện phản ánh dữ liệu đã xác nhận.',88,743,1430,65,31,true);
// 05 — Authentication gets its own service slide.
s=slide('Authentication',{sub:'Google Sign-In và bảo vệ các màn riêng tư',sources:['evidence/bootstrap/login-xperia.png','evidence/flows/auth-cancel-retry-xperia-2026-11-02.json','evidence/flows/auth-privacy-xperia-2026-11-02.json','lib/app.dart'],notes:'Ảnh Login là mốc bootstrap, không dùng ảnh này riêng để chứng minh Google sign-in đã thành công. Ngày 02/11 đã logout về Login, Back/mở lại không lộ Home, hủy native Google picker thấy lỗi và retry mở picker. Lượt đầu kiểm tra Activity quá sớm bị fail, được giữ riêng. Người dùng đăng nhập lại, Home đã được xác nhận. Chưa đủ test chuyển hai tài khoản và login mất mạng.'});
await image(s,'evidence/bootstrap/login-xperia.png',100,255,345,548,'Login Power9, ảnh bootstrap thật');
const auth=[['01','Đăng xuất','Home và route riêng bị loại khỏi phiên.'],['02','Hủy đăng nhập','Hiện lỗi rõ ràng, cho phép thử lại.'],['03','Khôi phục','Người dùng chọn tài khoản, app về Home.']];
auth.forEach((v,i)=>{const y=294+i*160;text(s,v[0],570,y,100,75,52,true,C.blue);text(s,v[1],700,y,790,55,35,true);text(s,v[2],700,y+64,790,88,29,false,C.muted);});
// 06 — Firestore contracts as native table, not a screenshot of code.
s=slide('Cloud Firestore',{sub:'Schedule và completion độc lập; xóa lần thực hiện không xóa lịch.',sources:['firebase/firestore.rules','evidence/flows/firestore-server-verification.json','evidence/flows/completion-deleted.json','firebase/tests/firestore-rules.test.cjs'],notes:'Dữ liệu riêng nằm dưới users/{uid}; catalog chung chỉ đọc các hoạt động published. Logical ID theo hoạt động/ngày bảo vệ một occurrence. Rules deny-by-default, ownership, schema và immutable fields. 18 Rules tests là mốc trước gồm 16 Firestore và 2 Storage emulator, không phải 18 production tests.'});
text(s,'1 hoạt động\n× 1 ngày',88,310,400,210,64,true,C.blue);text(s,'Một lịch.\nMột lần thực hiện.',91,567,360,112,34,false,C.muted);
table(s,[['Contract','Schedule','Completion'],['Ý nghĩa','Đã chọn hoạt động','Đã thực hiện'],['Thời gian','Ngày, giờ tùy chọn','Timer: giây đo thật'],['Check-in','Không tự hoàn thành','durationSeconds = null'],['Khi xóa record','Lịch được giữ','Chỉ record bị xóa']],540,292,970,420,[220,345,405],26);
text(s,'Rules: đúng chủ sở hữu · đúng schema · từ chối tài khoản khác.',548,747,955,65,28,true);
// 07 — real native notification screenshot; no fake Console.
s=slide('Firebase Cloud Messaging',{dark:true,sub:'Console → Xperia → chạm thông báo mở đúng màn',sources:['evidence/fcm/console-three-states-inbox-xperia.png','docs/fcm-pdf-storage.md','evidence/fcm/permission-denied-xperia-2026-11-02.json'],notes:'Firebase Console Test message đã được người dùng gửi và xác minh foreground, background và terminated ngày 01/11. Terminated có process vắng, không phải Force stop. Notification-only công khai mở Home, payload scope hợp lệ có thể mở Progress. Ngày 02/11 local smoke tắt riêng quyền notification Android 11, xác minh lỗi/retry và restore đúng trạng thái cũ. Không thay cho runtime permission Android 13. Ảnh là inbox ngày 01/11.'});
for(const [i,v] of [['Foreground','Native channel và inbox.'],['Background','Chạm thông báo trở lại app.'],['Terminated','Khởi động lạnh, xử lý initial message.']].entries()){
 const y=285+i*153;text(s,v[0],87,y,870,60,43,true,C.white);text(s,v[1],91,y+69,890,65,28,false,C.light);
}
text(s,'Quyền bị tắt: báo lỗi, có retry, đã khôi phục.',90,768,1000,52,29,true,C.light);
await image(s,'evidence/fcm/console-three-states-inbox-xperia.png',1128,258,315,554,'Inbox với thông báo Console tại ba trạng thái, 01/11');
// 08 — seven representative events; all eleven are in notes/source.
s=slide('Google Analytics',{sub:'Sự kiện có trigger và tham số; không log email hoặc raw search query.',sources:['docs/analytics-plan.md','docs/firebase-observability.md','evidence/artemis/phase2','lib/services/telemetry_service.dart'],notes:'Có 11 AppEvent: login, logout, search, view_activity, schedule_created, schedule_updated, activity_completed, completion_undone, config_refreshed, report_generated, export_report. Bảng chọn bảy loại tiêu biểu, không phải danh sách toàn bộ. DebugView đã có một phần event; TC16[1] xác minh view_activity(activity_id=move-walk) bằng native SDK log được lọc build marker và thời điểm task. Hai lượt TC16 chưa đạt. export_report từ Storage production chưa xác minh vì upload tắt. Không dùng log tự in của Dart để thay SDK evidence.'});
text(s,'11',84,312,350,145,128,true,C.blue);text(s,'event trong mã',92,475,360,60,32,true);text(s,'DebugView đã xác nhận\nmột phần. TC16: 1/3.',92,581,365,112,28,false,C.muted);
table(s,[['Event','Trigger','Params tiêu biểu'],['login','Google Sign-In thành công','method'],['search','Từ khóa ổn định sau debounce','query_length, has_query'],['view_activity','Mở chi tiết','activity_id, group_id'],['schedule_created','Lưu lịch mới thành công','activity_id, group_id'],['schedule_updated','Sửa lịch thành công','activity_id, group_id'],['activity_completed','Check-in/checklist/timer','source, duration_seconds'],['completion_undone','Hoàn tác thành công','activity_id']],505,273,1010,493,[300,365,345],23);
// 09 — two verified server error categories.
s=slide('Firebase Crashlytics',{sub:'Có bằng chứng server cho lỗi fatal và non-fatal.',sources:['evidence/firebase-observability/crashlytics-server.json','evidence/firebase-observability/crashlytics-event-metadata.json','docs/firebase-observability.md'],notes:'Reporting API xác nhận một FATAL test crash và một NON_FATAL completion_write/unavailable từ mất mạng thật. Metadata cho thấy user identifier và custom keys; public evidence chỉ xuất boolean, không xuất giá trị định danh. Native test crash có xác nhận và chỉ có trong debug. Không coi việc gọi SDK hoặc log local là dashboard evidence.'});
text(s,'FATAL',86,305,560,95,75,true,C.rust);text(s,'Native test crash có xác nhận,\nchỉ trong bản debug.',650,309,845,112,33);
text(s,'NON-FATAL',86,493,560,95,69,true,C.blue);text(s,'completion_write / unavailable\nGiữ dữ liệu để người dùng thử lại.',650,497,845,116,33);
table(s,[['Metadata được xác minh','Bằng chứng công khai'],['user identifier','Chỉ lưu trạng thái có/không'],['app_name, platform, test_crash','Custom keys; không xuất tài khoản']],90,680,1410,125,[585,825],24);
// 10 — real RC screenshot and native text transformations.
s=slide('Firebase Remote Config',{sub:'Đổi hai hành vi, fetch lại; không rebuild APK.',sources:['evidence/remote-config/demo-xperia.png','evidence/remote-config/published-demo.json','evidence/remote-config/published-defaults.json','docs/firebase-observability.md'],notes:'discover_max_minutes 60→5 giới hạn catalog; connection_checkin_enabled true→false ẩn check-in nhanh ở social. Sau demo đã đưa về 60/true và fetch lại. Ảnh là snapshot 5/false ngày 01/11, không phải cấu hình hiện tại. Fetch lỗi giữ cache/default. report_upload_enabled là cờ bổ sung đang false.'});
await image(s,'evidence/remote-config/demo-xperia.png',93,253,341,558,'Ảnh demo Remote Config 5/false ngày 01/11');
text(s,'discover_max_minutes',550,302,950,57,32,true,C.muted);text(s,'60 → 5 → 60',546,388,960,130,85,true,C.blue);
text(s,'connection_checkin_enabled',550,575,950,57,32,true,C.muted);text(s,'true → false → true',548,660,960,110,61,true);
// 11 — Storage service slide includes actual PDF evidence and an explicit gap.
s=slide('PDF và Cloud Storage',{sub:'Báo cáo ngày đang xem; upload cloud là tiêu chí riêng.',sources:['evidence/pdf/Power9-2026-11-01-xperia.pdf','docs/fcm-pdf-storage.md','lib/services/firebase_report_upload_service.dart','https://firebase.google.com/docs/storage/faqs-storage-changes-announced-sept-2024'],notes:'Ảnh PDF thật ngày 01/11: 0/2, lịch nghỉ tối 21:30; không UID/email. PDF lưu local qua Android Save as PDF đã kiểm chứng. Uploader/Rules có code, progress, timeout, SHA256 path và metadata sau Storage xác nhận. Production upload chưa có; billing tắt và report_upload_enabled=false. Firebase yêu cầu Blaze cho Cloud Storage; không đổi dịch vụ hay bật billing trong công việc này.'});
text(s,'PDF thật đã lưu\ntrên Xperia.',87,300,820,150,56,true,C.blue);
text(s,'Font Việt được nhúng.\nNgày, giờ và duration từ dữ liệu thật.\nRetry giữ cùng bytes và đường dẫn.',91,500,770,154,31);
text(s,'Upload production: chưa đạt.',91,717,830,62,33,true,C.rust);
await image(s,'evidence/pdf/Power9-2026-11-01-xperia.png',1007,253,465,552,'PDF thật Power9 01/11/2026, không định danh');
// 12 — current UX baseline, not an invented future app redesign.
s=slide('Nền tảng UI/UX hiện tại',{dark:true,sub:'Rõ trạng thái, giữ draft khi lỗi và có đường phục hồi.',sources:['handoff/flutter-handoff.md','test/responsive_main_screens_test.dart','evidence/flutter/lab3-accessibility-2026-11-02.txt','evidence/workspace/checklist-offline-xperia.png','evidence/f02/progress-empty-xperia.png'],notes:'Hai widget tests render 14 widget màn ở 360/412dp và text scale 1,5; bổ sung androidTapTargetGuideline/labeledTapTargetGuideline, đều đạt. Các màn ban đầu có phần chồng lấn HomeShell/body; không thổi phồng số màn chức năng. Không thay cho TalkBack, contrast, mọi trạng thái cuộn/dialog hoặc fidelity Figma đầy đủ. Hình checklist lỗi giữ 3/3 và Progress empty là ảnh thật. Người dùng đang cân nhắc đổi toàn bộ UI/UX; deck trình bày baseline đã kiểm chứng, chưa giả định thiết kế mới đã được duyệt.'});
text(s,'360 / 412 dp',87,292,820,92,64,true,C.white);text(s,'Hai chiều rộng được render.',91,394,800,55,28,false,C.light);
text(s,'1,5×',87,493,720,100,78,true,C.light);text(s,'Cỡ chữ lớn; nhãn và vùng chạm Android đạt.',91,613,800,87,29,false,C.light);
text(s,'TalkBack và fidelity Figma cần kiểm tra thêm.',91,750,800,63,26,false,C.light);
await image(s,'evidence/workspace/checklist-offline-xperia.png',950,273,247,485,'Checklist thật giữ lựa chọn khi lỗi');
await image(s,'evidence/f02/progress-empty-xperia.png',1242,273,247,485,'Tiến độ rỗng thật, không seed lịch sử');
// 13 — native editable chart uses current verified unique run IDs only.
s=slide('Kiểm thử ARTEMIS',{sub:'11 ca × 3 run ID; giữ nguyên các failed attempts và audit.',sources:['evidence/artemis/lab3-summary.json','docs/lab3-e2e-results.md','evidence/artemis/pro-exploratory.json'],notes:'30/33 unique run IDs xác minh: 29 valid pytest passes + 1 delayed-terminal audit TC03. Không phải 30 pytest passes. 59 retained attempts, 9 ca đủ 3/3. TC10[3], TC16[2], TC16[3] thiếu. Pro bị quota, 0 UI steps; 926,82 giây chờ không tính khám phá. Không tính local smoke như ARTEMIS. Biểu đồ thể hiện verified repetitions per case, không phải pass rate từng attempt.'});
text(s,`${summary.verifiedUniqueRunIds}/33`,84,299,540,160,112,true,C.blue);text(s,'run ID được xác minh',91,483,500,65,32,true);
text(s,'29 pytest pass hợp lệ\n+ 1 audit terminal ghi chậm',92,586,495,110,28,false,C.muted);
text(s,'Pro: chưa đạt thời lượng hoạt động.',92,747,530,60,26,true,C.rust);
const cats=summary.cases.map(c=>c.case),good=summary.cases.map(c=>c.verifiedRepetitions.length);
const chart=s.charts.add('bar',{position:{left:640,top:275,width:872,height:485},categories:cats,series:[{name:'Đã xác minh',values:good,fill:C.blue},{name:'Chưa xác minh',values:good.map(v=>3-v),fill:'#CED4DE'}],barOptions:{direction:'column',grouping:'stacked',gapWidth:70,overlap:100},hasLegend:true,legend:{position:'bottom',textStyle:{fontSize:21,fill:C.muted}},xAxis:{textStyle:{fontSize:20,fill:C.muted},line:{fill:C.line,width:1}},yAxis:{min:0,max:3,majorUnit:1,textStyle:{fontSize:22,fill:C.muted},majorGridlines:{fill:C.line,width:1}},dataLabels:{showValue:false},chartFill:C.paper,plotAreaFill:C.paper});
applyPresentationChartFont(chart,{fontFamily:FONT});
// 14 — real commits and the actual PR link.
s=slide('AI code review và ba sửa lỗi',{sub:'5 findings thuộc nhiều nhóm; 3 fixes runtime có commit và regression riêng.',sources:['ai/code-review/lab3-review.md',pr.url,'test/notification_payload_regression_test.dart','test/notification_refresh_regression_test.dart','test/profile_signout_regression_test.dart'],notes:`Baseline review 616f83e. R01 defensive robustness, chưa khẳng định sự cố production; R02 async correctness; R03 session recovery. R04/R05 gia cố runner. PR thật ${pr.url}, draft để giữ rõ các tiêu chí còn thiếu và hướng UI chưa chốt. Ba fix commits ac4b35b, 38b52bc, e595956. Local Codex review và disposition được đưa vào PR body; không có human approval hoặc merge được giả định.`});
table(s,[['Fix','Vấn đề','Sau sửa','Commit'],['R01','date_key sai kiểu','Fallback an toàn','ac4b35b'],['R02','Refresh cũ ghi đè inbox','Bỏ kết quả đến muộn','38b52bc'],['R03','Logout lỗi mất messaging','Restore đúng phiên','e595956']],88,294,1424,328,[105,455,595,269],28);
text(s,'43/43 Flutter tests',88,684,720,80,47,true,C.blue);text(s,'Analyzer sạch',915,684,600,80,47,true);
const prText=text(s,`PR #${pr.number} · ${pr.url}`,92,788,1390,39,23,false,C.muted);prText.text.get(`PR #${pr.number} · ${pr.url}`).link={uri:pr.url,isExternal:true};
// 15 — concise closing with honest boundaries and the deferred video decision.
s=slide('Bản bàn giao và bước tiếp theo',{dark:true,sub:'App, mã nguồn và bằng chứng kiểm thử đã có trong repository.',sources:[pr.url,'output/lab3/README.md','output/lab3/DEMO-RUNBOOK.md','docs/lab3-resume-2026-11-02.md'],notes:'Không khẳng định bài đã đạt 100%. App43tests/analyzer, Firebase evidence, PDF và replay đã bàn giao. Còn TC10[3]/TC16[2–3], Pro, production Storage, TalkBack/fidelity và một số Auth error coverage. Video được người dùng chủ động để cuối sau khi hướng UI/UX ổn định. PR ở trạng thái draft, không merge. Sau các bước hoàn thiện, cập nhật số liệu từ evidence thực thay vì sửa slide thành pass.'});
text(s,'Chốt UI/UX',87,296,560,84,58,true,C.white);text(s,'Chọn hướng nâng cấp trước khi quay.',711,310,790,70,33,false,C.light);
text(s,'Bù bằng chứng',87,468,590,84,58,true,C.white);text(s,'ARTEMIS / Pro và Storage còn thiếu.\nKhông thay bằng kết quả mô phỏng.',711,478,795,120,31,false,C.light);
text(s,'Video để cuối',87,673,590,84,58,true,C.white);text(s,'Demo app + Console có thuyết minh\nsau khi giao diện ổn định.',711,681,795,120,31,false,C.light);

await fs.writeFile(path.join(out,'designer-slide-notes.json'),JSON.stringify(meta,null,2)+'\n');
const candidate=path.join(build,'candidate-designer.pptx');await(await PresentationFile.exportPptx(deck)).save(candidate);
for(let i=0;i<deck.slides.items.length;i++){
 const png=await deck.export({slide:deck.slides.items[i],format:'png',scale:.8});
 await fs.writeFile(path.join(build,`slide-${String(i+1).padStart(2,'0')}.png`),new Uint8Array(await png.arrayBuffer()));console.log('Rendered slide '+(i+1));
}
const target=path.join(out,'Power9_Lab3_Designer.pptx');
await finalizePresentation({workspaceDir:root,candidatePath:candidate,finalPath:target,explicitTotalSlideCount:15,materializeLiteralChartWorkbooks:true,requiredNativeTableOwnerSlides:[6,8,9,14],requiredNativeChartOwnerSlides:[13],pythonExecutable:process.env.RUNTIME_PYTHON || 'C:/Users/PC/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/python.exe',integrityValidatorPath:path.join(skill,'container_tools/inspect_presentation_package_integrity.py'),layoutValidatorPath:path.join(skill,'container_tools/inspect_presentation_layout_geometry.py'),layoutArgs:['--expected-slide-size-emu','15240000,8572500','--validate-bullet-geometry','--validate-heading-fit',...[6,8,9,14].flatMap(n=>['--require-native-table-slide',String(n)])],fontPolicy:{basis:'design',families:[FONT]},verifyArtifactToolImport:true,receiptPath:path.join(build,'validation-designer.json')});
console.log(JSON.stringify({pptx:target,slides:15,editableTables:[6,8,9,14],editableChart:13,pr:pr.url}));
