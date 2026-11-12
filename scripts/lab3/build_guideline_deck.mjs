/** 24-slide Lab 3 presentation aligned to Software Project Presentation Guideline v1.0. */
import fs from 'node:fs/promises';
import path from 'node:path';
import {pathToFileURL} from 'node:url';

const root=path.resolve('.');
const modules=process.env.RUNTIME_NODE_MODULES;
const skill=process.env.POWER9_PRESENTATION_SKILL;
if(!modules||!skill) throw new Error('Set RUNTIME_NODE_MODULES and POWER9_PRESENTATION_SKILL');
const {Presentation,PresentationFile}=await import(pathToFileURL(path.join(modules,'@oai/artifact-tool/dist/artifact_tool.mjs')));
const {finalizePresentation}=await import(pathToFileURL(path.join(skill,'container_tools/artifact_tool_utils.mjs')));
const build=path.join(root,'.build/lab3-guideline-deck');
const out=path.join(root,'output/lab3');
await fs.mkdir(build,{recursive:true}); await fs.mkdir(out,{recursive:true});
const deck=Presentation.create({slideSize:{width:1600,height:900}});
const C={paper:'#F4F3EF',white:'#FFFFFF',ink:'#0B2240',blue:'#1E5AA8',muted:'#526174',light:'#DCE7F5',green:'#176B57',rust:'#A33C25',line:'#D6DDE5',pale:'#E7EDF4'};
const FONT='Arial';
const records=[];
const EN={
 'Power9 Office Routine':'Power9 Office Routine',
 'Bối cảnh sử dụng':'Work context and design assumptions','Persona là giả định thiết kế từ Lab 2, chưa có khảo sát định lượng.':'Design personas carried forward from Lab 2; no quantitative user study has been conducted.',
 'Các vấn đề cần kiểm tra với người dùng':'Problem hypotheses to validate','Ba giả thuyết thiết kế; tác động chưa được đo bằng user study.':'Three design hypotheses; impact has not been measured through user research.',
 'Giải pháp và phạm vi MVP':'Solution scope and MVP','Tác nhân và ranh giới hệ thống':'System actors and boundaries','Nhóm tính năng và ba workflow lõi':'Product capabilities and core workflows',
 'Business flow tổng thể':'End-to-end business flow','Lịch và lần thực hiện được lưu thành hai loại dữ liệu riêng.':'Plans and completed activities are stored as separate records.',
 'Vòng đời Schedule và Completion':'Timer session state machine','System architecture':'System architecture','Mã giao diện không gọi Firebase SDK trực tiếp.':'The presentation layer does not call Firebase SDKs directly.',
 'Technology stack':'Technology stack','UI/UX tổng thể':'Product experience and navigation','Ảnh giao diện thật trên Xperia, 03/11/2026.':'Screenshots captured from the app on Xperia, 3 Nov 2026.',
 'Sequence diagram · lưu lịch':'Sequence diagram: save a schedule','Class design · lịch và bản ghi hoàn thành':'Class design: schedules and completions',
 'Database design · mô hình khái niệm':'Database design: conceptual model','Database design · Firestore vật lý':'Database design: Firestore collections',
 'Traceability · feature đến evidence':'Traceability: requirement to evidence','Kế hoạch demo · ba workflow thành một câu chuyện':'Demo plan: three linked workflows',
 'Demo F01 · Khám phá và tạo lịch':'Demo WF-01: discover an activity and create a schedule','Demo F02 · Ghi nhận hoạt động':'Demo WF-02: record a completed activity',
 'Demo F03 · Sửa, hủy và xóa lịch':'Demo WF-03: edit, cancel and delete a schedule','Testing và verification':'Testing and verification',
 'Thành quả đã kiểm chứng':'Verified project outcomes','Giới hạn và bước tiếp theo':'Limitations and next steps','Kết luận':'Conclusion',
 'Nghỉ ngắn có kế hoạch\ntrong ngày làm việc.':'A practical way to plan short breaks\nthroughout the workday.',
 'Ứng dụng Android cho nhân viên văn phòng':'A mobile routine planner for office workers','PRM393  ·  LAB 3  ·  FLUTTER + FIREBASE':'PRM393  ·  LAB 3  ·  FLUTTER + FIREBASE',
 'Khám phá hoạt động  ·  Lên lịch  ·  Ghi nhận tiến độ':'Discover activities  ·  Plan schedules  ·  Track completion',
 'Lịch làm việc':'Changing work schedules','Cuộc họp và thời gian rảnh thay đổi theo ngày.':'Meetings shift, so available time changes from day to day.',
 'Khoảng nghỉ':'Short break windows','Thời gian ngắn khiến việc chọn hoạt động cần nhanh.':'Users need to find an activity that fits a short time window.',
 'Theo dõi cá nhân':'Personal progress','Người dùng cần phân biệt dự định với việc đã làm.':'A planned activity must remain distinct from one that was completed.',
 'Phạm vi giả định: nhân viên văn phòng tự quản lý hoạt động trong ngày.':'Design assumption: office workers manage their own daily activity plans.',
 'Khó lọc hoạt động theo nhu cầu và quỹ thời gian.':'Activity discovery needs useful category and duration filters.',
 'Kế hoạch cần sửa hoặc hủy khi lịch làm việc đổi.':'Plans need safe edit and cancel paths when the workday changes.',
 'Kế hoạch và hoạt động đã thực hiện dễ bị hiểu lẫn.':'A plan and a completed activity must not be counted as the same event.',
 'Chưa có số liệu về tần suất, thời gian xử lý hoặc mức độ ảnh hưởng.':'The project has no measured frequency, task-time or impact baseline.',
 'Cần giải quyết':'User need','Khả năng trong app':'Implemented response','Giới hạn cần nêu':'Evidence boundary',
 'Khám phá':'Discover','Catalog hoạt động đã xuất bản':'Browse published activity catalog','Không có phép đo usability':'No usability study yet',
 'Lên lịch':'Schedule','Một schedule / hoạt động / ngày':'One schedule per activity per day','Nhắc giờ chưa phát notification':'Reminder time is stored; no timed notification is triggered',
 'Ghi nhận':'Record completion','Completion tách khỏi schedule':'Completion is stored separately from a plan','Timer lưu thời lượng thực':'Timer records elapsed seconds',
 'Xem lại':'Review progress','Tiến độ theo ngày, PDF local':'Daily progress and on-device PDF','Storage production chưa bật':'Production Storage upload remains disabled',
 'In-scope: Android, Auth, Firestore và các workflow cá nhân.':'Core scope: Android user journeys, authentication and Firestore-backed personal activity records.',
 'Người dùng Android':'Android user','Firebase':'Firebase services','Web Admin':'Flutter Web Admin',
 'Khám phá · lên lịch\nhoàn thành · xem tiến độ':'Discover activities, plan a day,\nrecord completion and review progress',
 'Auth · Firestore\nFCM · telemetry':'Auth · Firestore\nFCM · Analytics and diagnostics',
 'Quản lý hoạt động\nduyệt và thông báo':'Manage the catalog, review proposals\nand publish announcements',
 'Dữ liệu riêng của người dùng nằm dưới users/{uid}.':'Personal records are scoped to users/{uid}; Admin access uses role checks.',
 'F01':'WF-01','F02':'WF-02','F03':'WF-03','Khám phá và tạo lịch':'Discover and schedule','Ghi nhận hoạt động':'Record activity','Quản lý lịch':'Manage schedules',
 'Tìm hoạt động · xem hướng dẫn · validation · lưu':'Search, review steps, validate the form and save','Check-in hoặc timer · xem tiến độ · hoàn tác':'Check in or run a timer, review progress and undo','Sửa · hủy thao tác · xác nhận xóa · giữ lịch sử':'Edit, cancel without writing, confirm deletion and retain history',
 'Mở rộng: FCM · PDF cục bộ · cấu hình Firebase · inbox.':'Additional capabilities: Gemini suggestions, Admin web, FCM inbox, Remote Config and local PDF export.',
 'Khám phá':'Discover','Chọn hoạt động\n+ ngày':'Choose activity\nand date','Kiểm tra lịch\n+ lưu Schedule':'Validate and\nsave Schedule','Thực hiện\nhoạt động':'Complete the\nactivity','Lưu Completion\n+ xem tiến độ':'Save Completion\nand review progress',
 'NGƯỜI DÙNG':'USER JOURNEY','ỨNG DỤNG + FIREBASE':'APP + FIREBASE','Lỗi mạng / validation\nGiữ draft · retry':'Validation or network error\nKeep the draft and retry',
 'Schedule không đồng nghĩa Completion':'A schedule is not proof of completion',
 'SCHEDULE':'SCHEDULE','COMPLETION':'COMPLETION','Chưa có':'Not scheduled','Đã lên lịch':'Scheduled','Đã cập nhật':'Updated','Đã xóa lịch':'Schedule deleted','Chưa làm':'Not completed','Đã ghi nhận':'Recorded','Đã hoàn tác':'Undone','Xóa Schedule không xóa Completion.':'Deleting a schedule does not delete its completion history.',
 'Android\nFlutter UI':'Android\nFlutter application','Riverpod\nViewModel':'Riverpod\nViewModels','Services\nFirebase SDK':'Service layer\nFirebase SDKs','Firebase\nAuth · Firestore':'Firebase\nAuth · Firestore','Web Admin\nHosting':'Flutter Web Admin\nFirebase Hosting',
 'PDF local':'PDF stays on device','Analytics · FCM · Remote Config · Crashlytics':'Analytics · FCM · Remote Config · Crashlytics · App Check · AI Logic',
 'Quyết định: service layer tách SDK khỏi UI; đánh đổi là thêm lớp mapping và kiểm tra hợp đồng.':'Architecture decision: services isolate Firebase SDKs from UI code; the trade-off is explicit model mapping and service contracts.',
 'Lớp':'Layer','Công nghệ':'Technology','Vai trò trong dự án':'Responsibility','Mobile':'Mobile','Ứng dụng Android và UI':'Android client and screens','State':'State management','Provider, dependency injection và async state':'Providers, dependency injection and async state','Backend dịch vụ':'Backend services','Phiên đăng nhập và dữ liệu cloud':'Authentication and cloud data','Vận hành':'Firebase operations','Thông báo và telemetry':'Push messaging and telemetry','Thiết kế / kiểm thử':'Design and verification','Thiết kế, unit/widget và E2E verification':'Design handoff, Flutter tests and E2E verification',
 'Firebase project: power9-office-se180724 · region asia-southeast1.':'Firebase project: power9-office-se180724 · Firestore region: asia-southeast1.',
 'Hôm nay trên Xperia':'Today screen, Xperia','Khám phá trên Xperia':'Discover screen, Xperia','Timer trên Xperia':'Relax timer, Xperia','Hôm nay':'Today','Thư giãn':'Relax',
 'Người dùng / UI':'User / screen','ScheduleViewModel':'ScheduleViewModel','ScheduleService':'ScheduleService','Firestore':'Cloud Firestore',
 '1  Lưu lịch':'1  Save schedule','2  Kiểm tra draft và session':'2  Validate draft and signed-in session','3  Transaction upsert ID cố định':'3  Upsert stable activityId_dateKey document','4  Server xác nhận':'4  Firestore returns server confirmation','5  Success hoặc error':'5  Service returns success or error','6  Cập nhật state và Home':'6  Update state and refresh Home',
 'Lỗi transaction: giữ draft, hiển thị lỗi và cho thử lại.':'On transaction failure, retain the draft, show the error and offer retry.',
 'ScheduleScreen\nrender + actions':'ScheduleScreen\nrender state and send actions','ScheduleViewModel\ndraft · validation · retry':'ScheduleViewModel\ndraft · validation · retry control','ScheduleService\ncontract':'ScheduleService\ninterface','FirestoreScheduleService\ntransaction + mapping':'FirestoreScheduleService\ntransaction and model mapping','Schedule\nactivityId · dateKey\nminuteOfDay · reminder':'Schedule\nactivityId · dateKey\nminuteOfDay · reminderEnabled',
 'Completion là model riêng; source và durationSeconds chỉ ghi khi hoạt động được xác nhận.':'Completion is a separate model; source and durationSeconds describe the recorded activity.',
 'User\nuid':'User\nuid and role','Activity\nactivityId':'Activity\npublished catalog item','Schedule\nuid + activity + date':'Schedule\nowner + activity + date','Completion\nuid + activity + date':'Completion\nowner + activity + date',
 'Một người dùng có nhiều Schedule và Completion.':'One user owns multiple schedules and completions.','Mỗi Activity có thể xuất hiện trong nhiều ngày.':'An activity may be scheduled on multiple dates.',
 'Collection / path':'Firestore path','Khóa / trường chính':'Key fields','Quy tắc':'Access and integrity rule',
 'activities/{id}':'activities/{activityId}','title · groupId · minutes · published':'title · groupId · purpose · steps · minutes · published','Catalog đã xuất bản; user chỉ đọc':'Users read published items; Admin manages catalog items',
 'users/{uid}/schedules/{id}':'users/{uid}/schedules/{activityId_dateKey}','activityId_dateKey · minuteOfDay · reminderEnabled':'activityId · dateKey · minuteOfDay · reminderEnabled · createdAt','Chủ UID CRUD; giữ createdAt khi sửa':'Owner only; edit keeps document ID and createdAt',
 'users/{uid}/completions/{id}':'users/{uid}/completions/{activityId_dateKey}','source · durationSeconds · dateKey':'source · durationSeconds · dateKey · createdAt','Chủ UID tạo/xóa; không sửa đè completion':'Owner can create/delete; accepted completion is immutable',
 'announcements/{id}':'announcements/{announcementId}','title · body · createdAt':'title · body · server createdAt','Admin tạo; người đăng nhập đọc':'Admin creates; signed-in users read',
 'ID cố định theo hoạt động + ngày giúp retry không nhân đôi occurrence.':'Stable activityId_dateKey keys make retries idempotent and prevent duplicate daily records.',
 'Feature':'Feature','UI':'Screen','ViewModel / Service':'ViewModel / service','Data':'Entity','Evidence':'Verification evidence',
 'F01 tạo lịch':'WF-01 Schedule creation','Khám phá · Chi tiết':'Discover · Activity detail','Schedule':'Schedule','Validation + Firestore':'Missing-time validation · Firestore record',
 'F02 hoàn thành':'WF-02 Completion','Hôm nay · Timer':'Today · Relax timer','Completion':'Completion','Timer/check-in smoke':'Xperia check-in and timer evidence',
 'F03 CRUD':'WF-03 Schedule CRUD','Chi tiết · Tiến độ':'Schedule detail · Progress','Xperia CRUD + server':'Xperia CRUD · Firestore server comparison',
 'F04 báo cáo':'PDF report','Tiến độ · PDF':'Progress · PDF','Report service':'ReportService','Report metadata':'Report metadata','PDF local; Storage off':'Local PDF verified; cloud upload disabled',
 'Truy vết từ Feature đến Screen, Service, Entity và Test':'Trace each feature through screen, service, data entity and test evidence',
 'Tạo lịch':'Create a plan','Thực hiện':'Record activity','Điều chỉnh':'Manage the plan','Tìm hoạt động, validation, lưu':'Discover, validate and save one schedule','Check-in hoặc timer, xem tiến độ':'Check in or time a session, then review progress','Sửa, hủy, xóa, xác nhận lịch sử':'Edit, cancel, confirm deletion and retain history',
 'Dữ liệu: một tài khoản kiểm thử · thiết bị Xperia · video 6:35 dự phòng.':'Preparation: test account, Xperia device, known test data and 6:35 backup video.',
 'ACTOR':'ACTOR','Người dùng':'Android user','Cần chọn một hoạt động nghỉ ngắn.':'Needs a short activity that fits the available break.','TRIGGER':'TRIGGER','Mở Khám phá':'Open Discover','Chọn hoạt động, xem hướng dẫn và ngày.':'Filter by group and duration, inspect the steps and select a date.','KẾT QUẢ':'RESULT','Một Schedule':'One Schedule document','Server xác nhận rồi Home hiển thị lịch.':'The app reports success after Firestore confirms the write.','Ngoại lệ: nhắc bật nhưng thiếu giờ thì báo validation và không lưu.':'Exception: reminder enabled without a time; validation blocks the write and preserves the draft.',
 'CHECK-IN':'CHECK-IN','Không đo thời gian':'No duration is measured','Completion source=checkin; durationSeconds=null.':'source=checkin; durationSeconds=null.','TIMER':'TIMER','Elapsed thực tế':'Measured elapsed time','Kết thúc sớm lưu thời gian đã chạy.':'End early and save the actual elapsed seconds.','UNDO':'UNDO','Schedule vẫn giữ':'The Schedule remains','Hoàn tác chỉ xóa Completion.':'Undo deletes only the Completion document.',
 'Sửa giờ':'Edit the time','Document ID giữ nguyên':'Document ID and createdAt remain stable','Hủy':'Cancel','Không ghi thay đổi':'No write occurs','Xóa lịch':'Delete schedule','Cần xác nhận':'Confirmation required','Lịch sử':'Completion history','Completion vẫn còn':'Completion remains',
 'Bằng chứng: Xperia + Firestore server verification · dữ liệu thử đã được dọn.':'Evidence: Xperia CRUD flow and Firestore server comparison; test records were cleaned up.',
 '49 / 49':'49 / 49','Flutter tests đạt':'Flutter unit and widget tests passed','32 / 33':'32 / 33','ARTEMIS run ID xác minh':'ARTEMIS run IDs verified','189 giây':'189 sec','Pro exploratory':'Pro exploratory session',
 'Hạng mục':'Suite','Kết quả':'Result','Giới hạn':'Scope limit','Flutter':'Flutter mobile','49/49 đạt':'49/49 passed','Unit/widget, không thay E2E':'Unit/widget coverage; not a substitute for E2E','ARTEMIS':'ARTEMIS','32/33 run ID':'32/33 unique run IDs verified','TC10[3] chưa xác minh':'TC10 run 3 remains unverified','Pro':'Pro exploratory','189,02 giây':'189.02 seconds','Chưa đủ tối thiểu 15 phút':'Below the 15-minute requirement','Analyzer':'Static analysis','Sạch':'No analyzer issues','Không đo thay usability':'Does not measure usability',
 'Sản phẩm':'Product','Flutter Android · Auth · Firestore':'Android Flutter app with Firebase Auth and Firestore','UI':'UI','8 ảnh minh họa · responsive 360/412 dp':'8 illustrations · 15 screens checked at 360/412 dp and 1.5× text','Dữ liệu':'Account isolation','Tài khoản A sang B rồi về A, lịch và inbox được đối chiếu':'A → B → A check confirmed schedules, completions and inbox separation','Dịch vụ':'Firebase services','FCM ba trạng thái · Remote Config đổi hành vi':'FCM tested in foreground/background/terminated · two Remote Config values changed behavior','Bộ nộp':'Deliverables','APK · video 6:35 · báo cáo · deck':'APK · 6:35 demo video · report · presentation',
 'TC10[3] ARTEMIS thiếu':'ARTEMIS TC10 run 3 unverified','E2E chưa đủ 33/33 run ID':'Verification is 32/33 unique run IDs','Hoàn tất lượt thiếu khi có ngân sách':'Complete the remaining run under an approved tool budget','Pro 189 giây':'Pro session: 189 seconds','Chưa đạt 15 phút exploratory':'Does not meet the 15-minute exploratory requirement','Lập phiên và tiêu chí trước khi chạy':'Define a valid exploration plan before the next run','Storage production off':'Production Storage upload disabled','PDF không upload cloud':'Local PDF does not demonstrate cloud upload','Trao đổi phương án với giảng viên':'Agree on an acceptable alternative with the instructor','TalkBack một phần':'TalkBack coverage is partial','Chưa bao phủ mọi màn/dialog':'Not every screen and dialog has been checked','Kiểm tra toàn bộ luồng trợ năng':'Complete a screen-by-screen accessibility review','Usability chưa đo':'Usability not measured','Persona là giả định':'Personas remain design assumptions','Thực hiện study và ghi mẫu / task':'Run a usability study and report sample and tasks',
 'Không đánh dấu toàn bộ dự án đạt 100%.':'The project is not reported as 100% complete.',
 '01':'01','02':'02','03':'03','Ứng dụng đã chạy':'A working Android product','Android · Flutter · Firebase':'Android · Flutter · Firebase','Ba workflow có bằng chứng':'Three workflows have device evidence','Tạo lịch · hoàn thành · sửa/xóa':'Create schedule · record completion · edit/delete','Kết quả và giới hạn rõ ràng':'Results and gaps are explicit','49 Flutter tests · ARTEMIS 32/33':'49 Flutter tests · 32/33 ARTEMIS run IDs','GitHub  ·  PhamQuangDuc1/PRM.POWER9':'GitHub  ·  github.com/PhamQuangDuc1/PRM.POWER9',
 'BỐI CẢNH 01':'PERSONA 01','BỐI CẢNH 02':'PERSONA 02','BỐI CẢNH 03':'PERSONA 03',
};
function tr(v){
 if(typeof v!=='string') return v;
 if(EN[v]) return EN[v];
 return v.replace(/^BỐI CẢNH 0([1-3])$/,'PERSONA 0$1');
}
function box(s,x,y,w,h,fill=C.white,stroke=C.line,geometry='rect',name=''){
 return s.shapes.add({geometry,name,position:{left:x,top:y,width:w,height:h},fill,line:{style:'solid',fill:stroke,width:stroke===C.line?1:1.5}});
}
function txt(s,value,x,y,w,h,size=28,bold=false,color=C.ink,opts={}){
 value=tr(value);
 const sh=s.shapes.add({geometry:'textbox',name:opts.name||value.replace(/\n/g,' ').slice(0,80),position:{left:x,top:y,width:w,height:h},fill:'none',line:{fill:'none',width:0}});
 sh.text=value; sh.text.style={typeface:FONT,fontSize:size,bold,color,alignment:opts.align||'left',verticalAlignment:opts.valign||'middle',autoFit:'none',insets:opts.insets??0}; return sh;
}
function base(title,{dark=false,sub='',sources=[],notes=''}={}){
 const n=deck.slides.items.length+1, s=deck.slides.add(); s.background.fill=dark?C.ink:C.paper;
 const fg=dark?C.white:C.ink, secondary=dark?C.light:C.muted;
 title=tr(title);sub=tr(sub);notes=tr(notes);
 txt(s,title,78,55,1440,80,50,true,fg);
 if(sub) txt(s,sub,82,144,1430,58,25,false,secondary);
 txt(s,'POWER9  /  LAB 3',82,848,800,24,17,true,secondary);
 txt(s,String(n).padStart(2,'0'),1475,833,60,38,24,true,secondary,{align:'right'});
 s.speakerNotes.text=`${notes}\n\nProject sources: ${sources.join('; ')}`;
 records.push({slide:n,title,sources,notes}); return s;
}
async function img(s,file,x,y,w,h,alt,fit='contain'){
 const b=await fs.readFile(path.join(root,file));
 return s.images.add({blob:b.buffer.slice(b.byteOffset,b.byteOffset+b.byteLength),contentType:file.toLowerCase().endsWith('.jpg')?'image/jpeg':'image/png',fit,position:{left:x,top:y,width:w,height:h},alt});
}
function label(s,kicker,title,body,x,y,w,{dark=false}={}){
 txt(s,kicker,x,y,w,40,24,true,dark?C.light:C.blue);
 txt(s,title,x,y+48,w,58,34,true,dark?C.white:C.ink);
 txt(s,body,x,y+112,w,70,25,false,dark?C.light:C.muted);
}
function node(s,value,x,y,w,h,{fill=C.white,color=C.ink,stroke=C.blue,size=25}={}){
 value=tr(value);
 const q=box(s,x,y,w,h,fill,stroke,'rect',value);
 q.text=value;q.text.style={typeface:FONT,fontSize:size,bold:true,color,alignment:'center',verticalAlignment:'middle',autoFit:'shrinkText',insets:12};return q;
}
function link(s,a,b,{from='right',to='left',color=C.blue}={}){
 s.shapes.connect(a,b,{kind:'straight',fromSide:from,toSide:to,line:{style:'solid',fill:color,width:2.5},tail:{type:'arrow',width:'med',length:'med'}});
}
function table(s,values,x,y,w,h,widths,size=23){
 values=values.map(row=>row.map(tr));
 const t=s.tables.add({rows:values.length,columns:values[0].length,left:x,top:y,width:w,height:h,columnWidths:widths,values});
 t.borders.assign({fill:C.line,width:0.8,style:'solid'});
 for(let r=0;r<values.length;r++) for(let c=0;c<values[0].length;c++){
  const cell=t.getCell(r,c);cell.fill=r===0?C.ink:C.white;
  cell.text.style={typeface:FONT,fontSize:size,bold:r===0,color:r===0?C.white:C.ink,insets:12,verticalAlignment:'middle'};
 }
 return t;
}

// 01 — Overview: Android product and web administration surface.
let s=base('Power9 Office Routine',{sources:['README.md','docs/ui-refresh-2026-11-03.md','web/README.md'],notes:'Overview: Power9 Office Routine is a Flutter Android app with a Flutter Web Admin portal. Mobile users discover workplace activities, schedule them, record completion and review daily progress. Admins manage the catalog, review user proposals, publish approved activities and send announcements. The screenshot is a genuine Xperia capture dated 3 November 2026. The project has not measured health outcomes or user adoption.'});
txt(s,'Plan short activities.\nKeep the day flexible.',84,205,850,155,55,true,C.ink);
txt(s,'A mobile routine planner with a web Admin console',88,390,820,54,31,false,C.muted);
txt(s,'PRM393  ·  LAB 3  ·  FLUTTER + FIREBASE',88,484,820,48,23,true,C.blue);
await img(s,'evidence/ui-refresh/2026-11-03/today.png',1050,194,380,600,'Power9 Today screen captured on Xperia, 3 Nov 2026');
txt(s,'Discover  ·  Schedule  ·  Complete  ·  Review progress',88,650,865,70,26,true,C.blue);

// 02 — Context, clearly identified as design assumptions.
s=base('Three design personas',{sub:'All three personas have equal priority. They are design inputs, not research participants.',sources:['ux/persona.md','ux/user-flow.md'],notes:'The project brief defines Huy, Mai and Linh as equal-priority personas. The ages and routines are design assumptions. No interviews, usability sessions or timing studies have validated them.'});
const contexts=[['P01 · HUY, 28','Software developer with long meetings. Needs movement, posture checks and quick schedule changes.'],['P02 · MAI, 24','New marketer with shifting campaign work. Needs simple lunch, stress-relief and voluntary social activities.'],['P03 · LINH, 39','Administrative team lead balancing meetings and family. Needs personal boundaries and flexible recovery plans.']];
contexts.forEach((v,i)=>label(s,`PERSONA 0${i+1}`,v[0],v[1],90+i*495,270,420));
txt(s,'All personas can use all nine habit groups; the app does not require a 9/9 daily target.',91,690,1370,64,28,true,C.ink);

// 03 — Problem, no invented metrics.
s=base('Problem hypotheses to validate',{sub:'The current evidence is design rationale, not user-research findings.',sources:['ux/persona.md','docs/office-direction.md','docs/gap-review.md'],notes:'The pain points below are hypotheses derived from the approved personas. The repository contains no user-study sample, frequency baseline, measured task duration or impact estimate. Validate these claims with office workers before describing them as observed problems.'});
const pain=[['01','Find a suitable action','Users need category and duration filters for short breaks.'],['02','Adapt a plan safely','Meetings change; cancelling an edit must preserve the last saved schedule.'],['03','Separate plan from action','Progress must distinguish scheduled activities from completed records.']];
pain.forEach((v,i)=>{const y=260+i*166;txt(s,v[0],92,y,90,70,45,true,C.blue);txt(s,v[1],205,y,430,58,33,true);txt(s,v[2],650,y,820,80,28,false,C.muted);});
txt(s,'No measured frequency, task-time or outcome baseline is available.',92,773,1380,42,23,true,C.rust);

// 04 — Solution and scope.
s=base('Solution scope and MVP boundaries',{sources:['docs/lab3-status.md','docs/data-model.md','docs/fcm-pdf-storage.md','web/README.md','docs/ai-feature.md'],notes:'The MVP includes the mobile and Admin journeys listed on the slide. Scheduled reminder delivery is not implemented: reminderEnabled is stored only. PDF creation and local save were verified; production Firebase Storage upload remains disabled because the project stays on Spark.'});
table(s,[['Need','Implemented response','Boundary'],['Discover','Published catalog, group and duration filters, Gemini suggestions','AI suggestion is optional; manual discovery remains available'],['Plan','One Schedule per activity per date; stable document key','Reminder time is stored; no local timed alert is sent'],['Record','Check-in, checklist or timer Completion','Check-in has no duration; timer stores elapsed seconds'],['Admin','Catalog CRUD, proposal review and publishing, announcements','Cross-role interactions verified with Firebase Emulator'],['Review','Daily Progress and PDF report','PDF stays local; production Storage upload is off']],92,242,1415,455,[260,625,530],20);
txt(s,'Core platform: Flutter Android + Flutter Web Admin + Firebase services.',95,724,1320,48,25,true,C.blue);

// 05 — Actors.
s=base('System actors and authorization boundaries',{sources:['docs/cross-role-flow.md','docs/data-model.md','web/README.md','lib/services'],notes:'Mobile users can create and read their own activity proposals, schedules and completions. Admin users can review proposals and manage catalog items and announcements. Firestore rules check the signed-in UID and Admin role. Firebase is an external platform, not a human actor.'});
const actorA=node(s,'Người dùng Android',95,340,310,110,{size:27});
const actorC=node(s,'Firebase',655,340,285,110,{fill:C.ink,color:C.white,size:27});
const actorB=node(s,'Web Admin',1190,340,300,110,{size:27});
link(s,actorA,actorC);link(s,actorB,actorC,{from:'left',to:'right'});
txt(s,'Khám phá · lên lịch\nhoàn thành · xem tiến độ',85,500,330,100,26,false,C.muted,{align:'center'});
txt(s,'Auth · Firestore\nFCM · telemetry',630,500,330,100,26,false,C.muted,{align:'center'});
txt(s,'Quản lý hoạt động\nduyệt và thông báo',1180,500,330,100,26,false,C.muted,{align:'center'});
txt(s,'Mobile records are scoped under users/{uid}; Admin writes require the Admin role.',130,714,1320,52,27,true,C.blue);

// 06 — Features and workflow selection.
s=base('Product capabilities and priority workflows',{sources:['docs/lab3-demo-guide.md','docs/lab3-status.md','docs/ai-feature.md','web/README.md'],notes:'The main demo uses F01, F02 and F03 because each has Xperia and Firestore evidence. Admin proposal handling is a separate cross-role flow, verified in the Auth and Firestore emulators. Gemini suggestions are optional and do not create a schedule.'});
const features=[['WF-01','Discover and schedule','9 habit groups, search, duration filters, short instructions, missing-time validation'],['WF-02','Complete and review','Check-in, checklist and measured timer; Progress, undo and daily totals'],['WF-03','Maintain a plan','Edit time, cancel without writing, confirm deletion; retain Completion history']];
features.forEach((v,i)=>{const y=252+i*152;txt(s,v[0],96,y,155,64,32,true,C.blue);txt(s,v[1],280,y,420,58,28,true);txt(s,v[2],720,y,780,75,23,false,C.muted);});
txt(s,'Other modules: Admin catalog and proposals · Gemini · FCM inbox · Remote Config · Crashlytics · local PDF.',100,746,1390,52,23,true,C.ink);

// 07 — Business flow, editable swimlane-like diagram.
s=base('End-to-end mobile business flow',{sub:'A Schedule is the plan; a Completion is the recorded activity.',sources:['docs/cross-role-flow.md','docs/data-model.md','docs/lab3-demo-guide.md'],notes:'The diagram shows the personal mobile journey. Firestore confirms writes before the app shows success. A validation or transaction error keeps the user draft available for correction or retry. Schedule and Completion are separate subcollections.'});
const flow1=node(s,'Discover\npublished activity',90,310,205,92),flow2=node(s,'Choose activity\nand date',340,310,235,92),flow3=node(s,'Validate and save\nSchedule',620,310,260,92),flow4=node(s,'Perform the\nactivity',930,310,220,92),flow5=node(s,'Save Completion\nand review Progress',1200,310,300,92);
[flow1,flow2,flow3,flow4].forEach((a,i)=>link(s,a,[flow2,flow3,flow4,flow5][i]));
txt(s,'MOBILE USER',95,240,260,40,22,true,C.blue);txt(s,'APP + FIREBASE',620,240,540,40,22,true,C.blue);
const err=node(s,'Validation or network error\nRetain draft · retry',620,540,300,94,{fill:'#FFF5F1',stroke:C.rust,size:22});
link(s,flow3,err,{from:'bottom',to:'top',color:C.rust});
txt(s,'Saving a plan never creates a Completion.',958,548,500,48,25,true,C.rust);

// 08 — state model.
s=base('Timer session state machine',{sources:['docs/architecture.md','docs/lab3-demo-guide.md','docs/data-model.md'],notes:'SessionViewModel uses Idle, Running, Paused and Finished states. Start begins a monotonic clock, pause excludes paused time, resume continues elapsed time, and end-early saves only measured seconds. Leaving an unrecorded session requires an explicit Stay or Discard choice. A failed write retains elapsed time for retry.'});
txt(s,'SESSIONVIEWMODEL STATES',95,255,560,45,24,true,C.blue);
const q1=node(s,'Idle\nno active session',95,365,210,100),q2=node(s,'Running\nmonotonic elapsed',410,365,250,100),q3=node(s,'Paused\nclock stopped',765,365,230,100),q4=node(s,'Finished\nrecord / retry',545,550,270,100,{stroke:C.green});
link(s,q1,q2);link(s,q2,q3);link(s,q3,q2,{from:'left',to:'bottom'});link(s,q2,q4,{from:'bottom',to:'top',color:C.green});link(s,q3,q4,{from:'bottom',to:'top',color:C.green});
txt(s,'start',320,322,70,35,19,true,C.blue,{align:'center'});txt(s,'pause',680,322,70,35,19,true,C.blue,{align:'center'});txt(s,'resume',690,475,80,35,19,true,C.blue,{align:'center'});txt(s,'finish',440,482,105,35,18,true,C.green,{align:'center'});txt(s,'stop',815,482,90,35,18,true,C.green,{align:'center'});
txt(s,'Guard: one Completion per activity and date. Discard resets without writing; schedule deletion preserves existing Completion.',95,690,1410,52,24,true,C.ink);
txt(s,'Running reaches target; Running or Paused may end early.',95,752,1410,42,22,true,C.rust);

// 09 — architecture.
s=base('System architecture and deployment',{sub:'Two Flutter clients share Firebase services; Admin and user permissions remain distinct.',sources:['docs/architecture.md','lib/screens','lib/viewmodels','lib/services','firebase.json','web/README.md','docs/ai-feature.md'],notes:'Android and Flutter Web Admin use Firebase Auth and Firestore. Firestore rules enforce UID ownership and Admin role checks. Gemini requests use Firebase AI Logic and App Check. FCM, Analytics, Crashlytics and Remote Config are integrated. PDF generation is local; production Storage upload remains disabled.'});
const a1=node(s,'Android\nFlutter client',85,325,235,115),a2=node(s,'Riverpod\nViewModels',360,325,235,115),a3=node(s,'Services\nFirebase SDKs',635,325,245,115),a4=node(s,'Firebase\nAuth · Firestore',935,325,270,115,{fill:C.ink,color:C.white}),a5=node(s,'Flutter Web Admin\nFirebase Hosting',935,570,270,105);
[a1,a2,a3].forEach((a,i)=>link(s,a,[a2,a3,a4][i]));
link(s,a5,a4,{from:'top',to:'bottom'});
txt(s,'PDF local',105,555,230,45,23,true,C.muted);txt(s,'Analytics · FCM · Remote Config · Crashlytics',280,475,630,50,24,true,C.blue);
txt(s,'Other integrations: Gemini via Firebase AI Logic · App Check · FCM · Analytics · Crashlytics · Remote Config.',88,710,1420,60,24,true);

// 10 — technology stack table.
s=base('Technology stack and versioned dependencies',{sources:['pubspec.yaml','pubspec.lock','firebase.json','docs/architecture.md','web/pubspec.yaml'],notes:'Versions below come from project manifests available in the repository. Pubspec.lock has changed in the workspace; final dependency resolution should be checked before release. Firebase Hosting deploys the Flutter Web Admin from web/build/hosting.'});
table(s,[['Layer','Technology / version','Project responsibility'],['Mobile + Admin Web','Flutter 3.47.3 · Dart 3.13.3','Shared Flutter codebase; Android app and Flutter Web portal'],['State / DI','Riverpod 3.4.3','Providers, dependency injection and async state'],['Firebase core','Firebase Core 5.1.0 · Auth 7.0.1 · Firestore 7.1.0','Login, document streams and transactions'],['Firebase operations','Messaging 17.0.1 · Analytics 13.0.1 · Crashlytics 6.0.1 · Remote Config 7.0.1','Push, event telemetry, crash reports and remote feature controls'],['AI / PDF / security','Firebase AI Logic 5.1.0 · App Check · pdf 3.13.1 · Storage 14.0.1','Gemini suggestions, attestation, local reports; Storage code is not production upload evidence']],90,245,1420,470,[290,545,585],20);
txt(s,'Firebase project: power9-office-se180724 · Firestore region: asia-southeast1 · billing: Spark.',95,734,1400,45,24,true,C.blue);

// 11 — UI/UX with three distinct current evidence images.
s=base('UI/UX system and screen coverage',{sub:'The product screenshots show the current Vietnamese-language Android UI.',sources:['evidence/ui-refresh/2026-11-03/today.png','evidence/ui-refresh/2026-11-03/discover.png','evidence/ui-refresh/2026-11-03/relax.png','docs/ui-refresh-2026-11-03.md','design/screen-spec.md'],notes:'These are product screenshots, not Figma mockups. The product contains 10 primary screens across Today, Discover, Activity detail, Schedule, Relax, Food, Progress, Notification Center, Profile and Login. Fifteen screens were checked at 360 and 412 dp with 1.5x text scale. Eight product illustrations were integrated. User feedback changed image use, action placement and screen density; it was not a formal usability study.'});
await img(s,'evidence/ui-refresh/2026-11-03/today.png',115,260,330,500,'Today screen on Xperia');
await img(s,'evidence/ui-refresh/2026-11-03/discover.png',635,260,330,500,'Discover screen on Xperia');
await img(s,'evidence/ui-refresh/2026-11-03/relax.png',1155,260,280,500,'Relax timer on Xperia');
txt(s,'TODAY',165,775,230,38,22,true,C.blue,{align:'center'});txt(s,'DISCOVER',690,775,230,38,22,true,C.blue,{align:'center'});txt(s,'RELAX TIMER',1180,775,230,38,22,true,C.blue,{align:'center'});

// 12 — sequence.
s=base('Sequence diagram: create or update a Schedule',{sources:['docs/architecture.md','docs/lab3-demo-guide.md','lib/viewmodels/schedule_view_model.dart','lib/services'],notes:'Component names reflect the repository architecture. The server transaction upserts the stable activityId_dateKey document. Missing reminder time fails validation before any write. Firestore confirmation gates the success state; errors retain the draft.'});
const sx=[120,455,800,1175];const sl=['User / ScheduleScreen','ScheduleViewModel','ScheduleService','Cloud Firestore'];
sl.forEach((v,i)=>{box(s,sx[i],235,240,65,i===3?C.ink:C.white,C.blue);txt(s,v,sx[i]+8,243,224,48,22,true,i===3?C.white:C.ink,{align:'center'});box(s,sx[i]+117,300,2,360,C.blue,C.blue);});
const messages=[
 {a:0,b:1,label:'1  save(scheduleDraft)'},
 {a:1,b:2,label:'2  validate + check session'},
 {a:2,b:3,label:'3  transaction upsert(activityId_dateKey)'},
 {a:3,b:2,label:'4  server-confirmed snapshot'},
 {a:2,b:1,label:'5  success or error'},
 {a:1,b:0,label:'6  update state and Home'},
];
messages.forEach((m,i)=>{
 const y=335+i*57, x1=sx[m.a]+120, x2=sx[m.b]+120;
 const left=Math.min(x1,x2),right=Math.max(x1,x2),reverse=x1>x2;
 const p1=s.shapes.add({geometry:'ellipse',position:{left:x1-3,top:y-3,width:6,height:6},fill:'none',line:{fill:'none',width:0}});
 const p2=s.shapes.add({geometry:'ellipse',position:{left:x2-3,top:y-3,width:6,height:6},fill:'none',line:{fill:'none',width:0}});
 link(s,p1,p2,{from:reverse?'left':'right',to:reverse?'right':'left',color:i===3?C.green:C.blue});
 txt(s,m.label,left+4,y-26,right-left-8,24,18,true,i===3?C.green:C.blue,{align:'center'});
});
txt(s,'Failure path: keep the draft, show an actionable error and allow retry.',180,738,1220,50,25,true,C.rust,{align:'center'});

// 13 — class model, arranged to match the guideline's title / prompt cards /
// left presentation checklist / right responsibility-map composition.
{
 const sources=['docs/architecture.md','lib/models/schedule.dart','lib/viewmodels/schedule_viewmodel.dart','lib/services/schedule_service.dart','lib/services/firestore_schedule_service.dart','lib/screens/schedule_screen.dart'];
 const notes='Class diagram describes the implementation, not a copy of the Firestore schema. ScheduleScreen sends UI actions to ScheduleViewModel; the ViewModel validates the draft and depends on the ScheduleService interface. Riverpod injects FirestoreScheduleService. Reminder-time validation belongs to the ViewModel; FirestoreScheduleService owns deterministic IDs, transactions and snapshot mapping. Saving a Schedule does not create a Completion.';
 s=deck.slides.add(); s.background.fill=C.paper;
 const purple='#713CE6', lavender='#EEE9FA', paleOrange='#F7E8E1', teal='#DDF1EE', orange='#FCE9DF', gray='#78859A';
 txt(s,'Slide 13',78,42,178,76,46,true,purple);
 txt(s,'Class Design — Responsibilities & Relationships',285,42,1257,76,44,true,C.ink);
 txt(s,'A class diagram explains code responsibilities and collaboration; it is not an ERD.',80,113,1440,42,23,false,C.muted);
 const promptCards=[
  {x:82,w:730,k:'QUESTION TO ANSWER',v:'How does the code divide responsibility? Where do validation and persistence rules live?',size:20},
  {x:830,w:185,k:'DURATION',v:'30 s',size:28},
  {x:1025,w:493,k:'MANDATORY EVIDENCE',v:'Class names and relationships must be traceable in source code.',size:20},
 ];
 for(const c of promptCards){
  box(s,c.x,170,c.w,82,lavender,lavender,'roundRect');
  txt(s,c.k,c.x+14,177,c.w-28,22,14,true,purple);
  txt(s,c.v,c.x+14,199,c.w-28,48,c.size,c.k==='DURATION',C.ink);
 }
 txt(s,'CONTENT TO PRESENT',82,267,515,34,19,true,purple);
 const bullets=[
  'Core classes in one important workflow or module.',
  'Key attributes, operations and class dependencies.',
  'Separate UI, ViewModel, service/repository and domain model.',
  'Trace each business rule to its owning class and source.',
 ];
 bullets.forEach((v,i)=>{
  const y=316+i*70;
  box(s,82,y,32,32,'#E2D8F8','#E2D8F8','ellipse');
  txt(s,String(i+1),82,y,32,32,16,true,purple,{align:'center'});
  txt(s,v,128,y-1,475,52,21,false,C.ink);
 });
 box(s,82,624,535,126,paleOrange,paleOrange,'roundRect');
 txt(s,'CAUTION',98,636,495,24,15,true,'#C94C24');
 txt(s,'Do not convert every database collection into a class with trivial getters and setters.',98,660,493,76,21,false,C.ink);

 // Right-side class map panel.
 box(s,650,264,868,516,C.white,C.line,'roundRect');
 txt(s,'CLASS RESPONSIBILITY MAP',679,278,500,30,16,true,gray);
 const classCard=(x,y,w,h,title,body,headerFill,titleColor=C.ink)=>{
  const card=box(s,x,y,w,h,C.white,C.line,'rect',title);
  box(s,x,y,w,40,headerFill,headerFill,'rect');
  txt(s,title,x+8,y+3,w-16,34,18,true,titleColor,{align:'center'});
  txt(s,body,x+12,y+49,w-24,h-56,17,false,C.ink);
  return card;
 };
 const ui=classCard(680,328,220,128,'ScheduleScreen','+ render form\n+ submit / cancel','#DDE7FF',C.blue);
 const vm=classCard(947,328,220,128,'ScheduleViewModel','+ validateDraft()\n+ save(activity)','#DDF1EE','#087C70');
 const contract=classCard(1214,328,270,128,'ScheduleService','+ watchDay()\n+ save() / delete()','#FCE9DF','#C94C24');
 link(s,ui,vm,{color:'#93A4BF'}); link(s,vm,contract,{color:'#93A4BF'});
 const impl=classCard(947,517,270,82,'FirestoreScheduleService','+ transaction upsert() · map snapshots','#EAE2FA',purple);
 const domain=classCard(947,624,270,86,'Schedule (domain)','activityId · dateKey\nminuteOfDay · reminderEnabled','#EAE2FA',purple);
 link(s,contract,impl,{from:'bottom',to:'top',color:'#93A4BF'});
 link(s,impl,domain,{from:'bottom',to:'top',color:'#93A4BF'});
 txt(s,'RULE OWNERSHIP',1240,530,245,25,15,true,purple);
 txt(s,'ViewModel: reminder requires a time.\nService: stable daily ID and server-confirmed write.',1240,558,245,92,17,false,C.muted);
 txt(s,'Saving a Schedule records a plan; Completion is a separate domain record.',679,738,810,28,18,false,C.muted,{italic:true});
 txt(s,'POWER9  /  LAB 3',82,848,800,24,17,true,C.muted);
 txt(s,'13',1475,833,60,38,24,true,C.ink,{align:'right'});
 s.speakerNotes.text=`${notes}\n\nProject sources: ${sources.join('; ')}`;
 records.push({slide:13,title:'Class Design — Responsibilities & Relationships',sources,notes});
}

// 14 — conceptual database design.
s=base('Database design: conceptual entity model',{sources:['docs/data-model.md','docs/cross-role-flow.md'],notes:'The conceptual model distinguishes the shared published catalog from each user’s private schedule and completion records. Proposal review and announcements connect the mobile product to Admin operations. Publishing creates an Activity from an approved proposal in a transaction.'});
const ent=[node(s,'User\nuid · role',75,270,205,100),node(s,'Activity\npublished catalog',75,500,235,100),node(s,'Schedule\nowner + activity + date',445,270,270,100),node(s,'Completion\nowner + activity + date',445,500,270,100,{stroke:C.green}),node(s,'ActivityProposal\npending / approved / rejected',880,270,300,110),node(s,'Announcement\nAdmin-authored inbox item',1230,500,300,105)];
link(s,ent[0],ent[2]);link(s,ent[0],ent[3],{from:'right',to:'left',color:C.green});link(s,ent[1],ent[2]);link(s,ent[1],ent[3],{from:'right',to:'left',color:C.green});link(s,ent[0],ent[4]);link(s,ent[1],ent[5]);
txt(s,'Approved proposal is published once as an Activity.',880,420,500,45,23,true,C.blue);
txt(s,'Schedules and Completions are separate records with the same daily identity rule.',125,680,1370,55,26,true,C.ink);

// 15 — physical model table.
s=base('Database design: Firestore paths and integrity rules',{sources:['docs/data-model.md','firebase/firestore.rules'],notes:'Firestore uses security rules with default deny, UID ownership, role checks and field validation. Schedule transactions preserve createdAt when editing. Completion creation is create-if-absent and immutable after acceptance. Local PDF metadata may use storagePath=null; this is not cloud upload.'});
table(s,[['Collection / path','Key fields','Access / integrity rule'],['activities/{activityId}','title · groupId · purpose · minutes · steps · published','Users read published items; Admin manages catalog'],['users/{uid}/schedules/{activityId_dateKey}','dateKey · minuteOfDay · reminderEnabled · createdAt · updatedAt','UID owner only; stable ID; createdAt immutable'],['users/{uid}/completions/{activityId_dateKey}','source · durationSeconds · dateKey · createdAt','UID owner only; create-if-absent; no client update'],['activityProposals/{uid~id}','ownerUid · status · reason · reviewerUid · publishedActivityId','User creates own pending proposal; Admin decides once'],['announcements/{id} · users/{uid}/reports/{sha256}','body / title · dateKey · fileName · sha256 · storagePath','Admin creates announcements; owner stores immutable report metadata']],88,245,1430,460,[450,560,420],19);
txt(s,'Timer duration is an integer from 1 to the activity limit; check-in/checklist durationSeconds is null.',95,724,1400,48,23,true,C.blue);

// 16 — traceability.
s=base('Traceability matrix: features to code, data and evidence',{sources:['docs/design-traceability.md','docs/test-report.md','evidence/flows/crud/native-crud-result.json','evidence/f02','docs/ai-feature.md','web/README.md'],notes:'Rows are representative traceability paths, not a complete coverage claim. Automated unit/widget, Firestore rules, emulator workflows and native Xperia smoke tests are separate evidence types.'});
table(s,[['Feature','Screen / actor','Code responsibility','Data contract','Evidence'],['WF-01 schedule','Discover · detail · user','DiscoverViewModel · ScheduleViewModel','Schedule','Missing-time validation · Firestore record'],['WF-02 completion','Today · Relax · user','SessionViewModel · CompletionService','Completion','Timer 72s · check-in / undo'],['WF-03 schedule CRUD','Schedule detail · Progress','ScheduleViewModel · ScheduleService','Schedule','Xperia CRUD · same ID · createdAt'],['Admin proposal','Explore · Review queue','Proposal services · Admin role guard','activityProposals','Approve / reject / publish on Emulator'],['Gemini suggestions','Discover · user','AI Logic client · candidate validation','Published activity IDs','3 real requests · unknown / duplicate IDs rejected']],88,245,1430,455,[235,285,325,255,330],18);
txt(s,'Acceptance coverage links each requirement to a screen, service, data model, security rule and test evidence.',93,722,1380,56,24,true,C.blue);

// 17 — demo plan.
 s=base('Demo plan: three persona-led workflows',{sources:['docs/lab3-demo-guide.md','output/lab3/DEMO-RUNBOOK.md','ux/persona.md'],notes:'The personas define the intended scenario framing; they are not real participants. Demo each workflow with one test account and records created for the demonstration. A 6:35 app and Firebase Console video exists as backup. Reset only the records created during the demo.'});
const demos=[['WF-01 · MAI','Create a plan','Find a short activity, review instructions, save for today'],['WF-02 · HUY','Record completion','Use check-in or timer, then inspect Progress'],['WF-03 · LINH','Adapt a plan','Change time, cancel safely, then confirm deletion']];
demos.forEach((v,i)=>{const x=90+i*500;txt(s,v[0],x,310,420,55,28,true,C.blue);txt(s,v[1],x,390,420,60,34,true);txt(s,v[2],x,475,420,130,25,false,C.muted);});
txt(s,'Setup: authenticated test account · Xperia · known date · prepared data · 6:35 backup recording.',95,718,1380,55,24,true,C.ink);

// 18 — F01.
s=base('Demo WF-01 · Discover and create a Schedule',{sources:['docs/lab3-demo-guide.md','evidence/flows/schedule-validation-xperia.png','evidence/flows/firestore-server-verification.json'],notes:'Native Xperia evidence: Home started with no schedule, Discover opened the published “Midday walk” activity, missing reminder time was rejected, then a valid schedule was saved. Firestore server verification found one activity/date document. A later edit changed minuteOfDay to 1381 while preserving the same document and createdAt.'});
await img(s,'evidence/flows/schedule-validation-xperia.png',95,235,350,520,'Xperia screen showing missing-time validation');
label(s,'ACTOR','Mai · Android user','Needs a short activity that fits her lunch break.',525,252,800);
label(s,'TRIGGER','Open Discover','Filter by group/duration, inspect activity steps, choose a date.',525,420,800);
label(s,'RESULT','One server-confirmed Schedule','Home displays the saved activity after Firestore confirms the write.',525,588,800);
txt(s,'Exception: reminder enabled with no time. Validation keeps the form and creates no record.',525,760,950,48,22,true,C.rust);

// 19 — F02.
s=base('Demo WF-02 · Record completion and review Progress',{dark:true,sources:['docs/lab3-demo-guide.md','evidence/f02/progress-early-end-xperia.png','docs/data-model.md','evidence/flows/completion-early.json'],notes:'Xperia timer end-early test saved 72 seconds, shown as 1 minute 12 seconds in Progress. Check-in uses source=checkin and durationSeconds=null. Undo removes only Completion; the Schedule remains. A separate full timer run saved 180 seconds.'});
await img(s,'evidence/f02/progress-early-end-xperia.png',116,238,330,510,'Progress screen showing a 72-second timer session');
label(s,'CHECK-IN','No time is inferred','source=checkin; durationSeconds=null.',525,250,880,{dark:true});
label(s,'TIMER','Measured with Stopwatch','The end-early example saved 72 seconds, not the catalog target.',525,420,880,{dark:true});
label(s,'UNDO','Schedule stays in place','Undo deletes only the Completion record.',525,590,880,{dark:true});

// 20 — F03.
s=base('Demo WF-03 · Edit, cancel and delete a Schedule',{sources:['docs/lab3-demo-guide.md','evidence/flows/crud/native-crud-result.json','evidence/flows/firestore-server-verification.json'],notes:'Native Xperia CRUD evidence covers create, read, update and delete. Editing the time updated the same Firestore document and preserved createdAt. Cancel left server values unchanged. Deleting the schedule retained the completion history.'});
const steps=[['Edit time','Same document ID; createdAt preserved'],['Cancel','No write; saved value unchanged'],['Delete plan','Confirmation required'],['Review history','Completion remains']];
steps.forEach((v,i)=>{const x=90+i*370;txt(s,String(i+1).padStart(2,'0'),x,330,90,70,48,true,C.blue);txt(s,v[0],x,430,320,54,30,true);txt(s,v[1],x,505,330,85,24,false,C.muted);});
txt(s,'Evidence: native Xperia CRUD · server metadata comparison · test records cleaned up.',95,720,1410,52,24,true,C.green);

// 21 — test report.
s=base('Verification results by test level',{sources:['docs/test-report.md','docs/lab3-e2e-results.md','docs/lab3-status.md','evidence/artemis/lab3-summary.json','docs/firebase-observability.md'],notes:'Do not combine different test levels into a single pass rate. Flutter 49/49 refers to the Lab 3 unit/widget suite. ARTEMIS has 32/33 unique run IDs verified, including one delayed-terminal audit; TC10 run 3 remains unresolved. Pro exploratory lasted 189.02 seconds and did not meet the 15-minute requirement.'});
txt(s,'49 / 49',96,285,420,112,84,true,C.blue);txt(s,'Lab 3 Flutter unit/widget suite',100,409,430,48,25,true);
txt(s,'32 / 33',595,285,420,112,84,true,C.green);txt(s,'ARTEMIS unique run IDs',598,409,440,48,26,true);
txt(s,'189 sec',1090,285,380,112,78,true,C.rust);txt(s,'Pro exploration',1095,409,380,48,28,true);
table(s,[['Scope','Result','Interpretation'],['Lab 3 Flutter','49/49 passed','Unit/widget; not E2E'],['ARTEMIS','32/33 verified','TC10 run 3 unresolved; 63 attempts retained'],['Pro','189.02 seconds','Below the 15-minute requirement'],['Analyzer','No issues','Static analysis; not usability evidence']],95,525,1410,245,[290,390,730],19);

// 22 — measurable achievements.
s=base('Verified outcomes across the product',{sources:['docs/lab3-status.md','docs/ui-refresh-2026-11-03.md','docs/fcm-pdf-storage.md','docs/test-report.md','docs/ai-feature.md','output/lab3/README.md'],notes:'Mobile and Admin verification are separate suites. Admin CRUD, proposal review, publishing and inbox were verified with Firebase Emulator; the hosted Admin login opened, while three production cross-role rounds have not been measured. Gemini returned valid recommendations at 3, 5 and 10-minute limits. FCM Console test messages were received in foreground, background and terminated app states.'});
const wins=[['Mobile product','Flutter Android · Google Auth · Firestore schedules and completions'],['Interface','8 illustrations · 15 screens checked at 360/412 dp with 1.5× text'],['Account privacy','A to B and back to A verified; schedules, completions and inbox stayed isolated'],['Firebase services','FCM three states · two Remote Config behavior changes · Crashlytics records'],['Gemini','Three real suggestion requests returned eligible activities for 3, 5 and 10 minutes'],['Admin Web','Catalog, dashboard, proposal review/publish and announcements tested on Emulator'],['Submission','APK · 6:35 demo video · report · editable presentation']];
wins.forEach((v,i)=>{const y=210+i*82;txt(s,v[0],100,y,280,53,26,true,C.blue);txt(s,v[1],405,y,1040,57,24,false,C.ink);});

// 23 — limitations and next steps.
s=base('Limitations, impact and next steps',{sources:['docs/lab3-status.md','docs/lab3-e2e-results.md','docs/fcm-pdf-storage.md','docs/lab3-accessibility-check.md','docs/gap-review.md','evidence/code-review/lab3-pr.json'],notes:'The latest status is based on evidence through 4 November 2026. ARTEMIS TC10 run 3 remains unresolved; Pro remains below the required exploratory duration. Storage production was intentionally left off to keep Firebase Spark and avoid billing. Three manual TalkBack flow groups were confirmed, but the Google account picker and all possible states were not covered. PR #4 is open and unmerged.'});
table(s,[['Open limitation','Impact','Next step'],['ARTEMIS TC10 run 3','32/33 unique run IDs verified','Complete only with approved budget and evidence plan'],['Pro: 189.02 seconds','Does not meet 15-minute exploration','Plan a valid exploration before spending another run'],['Storage upload disabled','PDF is on-device, not cloud-stored','Agree on an acceptable assignment alternative'],['TalkBack scope','Three manual flow groups passed; Google picker and all states untested','Complete remaining accessibility cases'],['No usability study','Personas and benefit statements are unvalidated','Recruit office workers; record tasks, sample and completion times'],['Hosted Admin integration','Emulator flows passed; production cross-role timing unmeasured','Run three real-account cross-role rounds']],90,235,1415,470,[400,470,545],18);
txt(s,'Report verified progress; do not claim full project completion.',95,728,1370,48,25,true,C.rust);

// 24 — conclusion.
s=base('Conclusion',{dark:true,sources:['README.md','output/lab3/README.md','docs/lab3-status.md'],notes:'Close with the verified product scope and the known gaps. The repository is public, but GitHub PR #4 remains open and unmerged as of the latest project notes. Keep this slide visible for questions.'});
txt(s,'01',92,268,100,70,46,true,C.light);txt(s,'A working mobile and web product',235,268,620,70,35,true,C.white);txt(s,'Flutter clients backed by Firebase',900,276,570,58,25,false,C.light);
txt(s,'02',92,415,100,70,46,true,C.light);txt(s,'Three device-verified workflows',235,415,620,70,35,true,C.white);txt(s,'Create schedule · record completion · edit/delete',880,423,620,58,24,false,C.light);
txt(s,'03',92,562,100,70,46,true,C.light);txt(s,'Evidence and limitations are explicit',235,562,650,70,33,true,C.white);txt(s,'49 Flutter tests · 32/33 ARTEMIS IDs',930,570,570,58,24,false,C.light);
txt(s,'Repository: github.com/PhamQuangDuc1/PRM.POWER9',94,737,1250,55,25,true,C.light);

// 25 — Appendix A1: role-to-role transaction.
s=base('Appendix A1 · Cross-role proposal and publishing flow',{sources:['docs/cross-role-flow.md','docs/data-model.md','web/README.md','docs/test-report.md'],notes:'The mobile proposal, Admin decision, publication transaction and Android catalog refresh were verified in Firebase Emulator. The Admin Hosting login is deployed; three production cross-role rounds with real-role accounts have not been measured.'});
const cr1=node(s,'Android user\ncreates proposal',75,305,235,100),cr2=node(s,'Firestore\npending',375,305,215,100),cr3=node(s,'Web Admin\nreview queue',660,305,230,100),cr4=node(s,'Approve or reject\nwith reason',960,305,245,100),cr5=node(s,'Publish transaction\ncreates Activity',1270,305,245,100);
link(s,cr1,cr2);link(s,cr2,cr3);link(s,cr3,cr4);link(s,cr4,cr5);
txt(s,'On rejection, preserve the original proposal and show the review reason in “My proposals.”',115,495,1360,54,25,true,C.rust);
txt(s,'After publication, Android discovers the new item through published=true. Admin announcements appear in the mobile inbox.',115,575,1360,75,24,true,C.ink);
txt(s,'Rules: owner UID creates pending proposals · Admin decides once · publication uses a Firestore transaction.',115,690,1360,58,24,true,C.blue);

// 26 — Appendix A2: constrained Gemini recommendation path.
s=base('Appendix A2 · Gemini activity suggestions',{sources:['docs/ai-feature.md','pubspec.yaml','evidence/assignment'],notes:'Firebase AI Logic sends at most 30 eligible activity candidates, each containing only an activity ID, group ID and duration. Search text, names, email and personal records are excluded. App Check is required. The app validates returned IDs, removes unknown/duplicate values and renders at most three suggestions. Three Emulator requests produced eligible results for 3, 5 and 10-minute limits; all returned the same three items.'});
const ai1=node(s,'User selects\ngroup + duration',90,300,240,100),ai2=node(s,'Filter published\nFirestore catalog',390,300,250,100),ai3=node(s,'Gemini Developer API\nFirebase AI Logic',705,300,290,100,{fill:C.ink,color:C.white}),ai4=node(s,'Validate IDs\nmax 3 suggestions',1060,300,235,100),ai5=node(s,'Open detail\nuser chooses next step',1360,300,180,100);
link(s,ai1,ai2);link(s,ai2,ai3);link(s,ai3,ai4);link(s,ai4,ai5);
txt(s,'Privacy boundary',95,485,260,45,25,true,C.blue);txt(s,'Prompt contains candidate IDs, groups and duration only. It excludes search query and personal data.',360,485,1120,55,24,false,C.ink);
txt(s,'Safety boundary',95,575,260,45,25,true,C.green);txt(s,'Reject unknown IDs, deduplicate results, cap at three and preserve manual search/filter when AI fails.',360,575,1120,65,24,false,C.ink);
txt(s,'Evidence: 3-, 5- and 10-minute real API requests returned eligible recommendations; selecting one opens Activity detail and does not create a schedule.',95,700,1410,80,23,true,C.rust);

// 27 — Appendix A3: service evidence and limits.
s=base('Appendix A3 · Firebase services: evidence and scope',{sources:['docs/firebase-observability.md','docs/fcm-pdf-storage.md','docs/lab3-status.md','docs/ai-feature.md','docs/test-report.md'],notes:'Each row reports a separate service state. SDK logs are not substituted for server-side evidence. Do not represent the old DebugView capture during the demo recording as a server receipt; a later server screenshot verified view_activity for move-walk.'});
table(s,[['Service','Verified evidence','Limit / presentation note'],['Auth + Firestore','Google sign-in, offline retry/logout/back, account A/B isolation; UID/schema rules. Separate Admin suite: 22 Rules + 53 Flutter tests.','Admin cross-role runtime timing has not been measured in production'],['FCM','Console test message received foreground/background/terminated; tap opened app','Permission-denied recovery is a separate Android-version scope'],['Analytics','11/12 event types had SDK evidence; server DebugView later received view_activity(move-walk)','During the 6:35 recording Debug Device=0; do not claim that recording proved event receipt'],['Crashlytics','Reporting API showed a fatal debug test crash and non-fatal network failure','Historical records; no new crash was generated for the final video'],['Remote Config','discover_max_minutes and connection_checkin_enabled changed behavior without rebuild','Values were returned to defaults after verification'],['App Check + Gemini','Debug token enabled three eligible AI requests; remote flag hid Gemini while manual discovery remained','Do not include debug token in presentation or logs'],['Storage','Rules/uploader code and Emulator tests exist; PDF metadata can reference local bytes','Production upload disabled; Spark plan retained']],88,228,1430,520,[280,610,540],17);

// 28 — Appendix A4: ARTEMIS coverage by case.
s=base('Appendix A4 · ARTEMIS case coverage',{sources:['evidence/artemis/lab3-summary.json','docs/lab3-e2e-results.md'],notes:'Verified repetition counts are unique run IDs, not pytest attempt pass rates. The published summary has 32/33 unique run IDs verified: 31 with valid pytest evidence plus one audit-only delayed-terminal observation. All 63 attempts, including failures, remain retained. TC10 run 3 is the only unresolved run ID.'});
const art=JSON.parse(await fs.readFile(path.join(root,'evidence/artemis/lab3-summary.json'),'utf8'));
const artRows=[['Case','Verified run IDs','Attempts retained'],...art.cases.map(c=>[c.case,`${c.verifiedRepetitions.length}/3`,String(c.attempts)])];
table(s,artRows,300,215,1000,485,[300,350,350],19);
txt(s,'32/33 unique run IDs verified  ·  31 pytest-verified  ·  1 audit-only  ·  63 attempts retained',95,735,1410,48,23,true,C.blue);
txt(s,'Run 3 of TC10 remains unresolved; no status has been converted from failed to passed.',95,785,1410,38,20,true,C.rust);

// 29 — Appendix A5: data invariants and security contracts.
s=base('Appendix A5 · Firestore invariants and security contracts',{sources:['docs/data-model.md','firebase/firestore.rules','firebase/tests','docs/test-report.md'],notes:'Security rules default to deny, validate owner UID and enforce allowed schema transitions. Schedule can be edited and deleted by its owner. Completion is created once and cannot be overwritten by a client. Timer and check-in have distinct duration semantics.'});
table(s,[['Invariant','Implementation','Why it matters'],['Stable daily identity','activityId_yyyy-MM-dd document ID in each user subcollection','Retry and multi-device writes do not create duplicate daily records'],['Owner isolation','users/{uid}/schedules and /completions; rule checks request.auth.uid','Account A data does not appear in account B'],['Server-confirmed save','Transaction must succeed before UI reports success','Offline/cache-pending writes are not described as saved'],['Immutable completion','Create-if-absent; client may delete but cannot update accepted record','Retry cannot overwrite measured duration'],['Duration contract','Check-in/checklist: null; timer: integer 1..activity.minutes×60','Do not infer time from catalog duration'],['Deletion semantics','Schedule delete does not cascade to Completion','History remains available after plan removal']],90,245,1410,450,[350,590,470],18);
txt(s,'Firestore Rules suites and Flutter widget tests are reported separately; neither substitutes for the outstanding ARTEMIS run.',95,724,1400,54,22,true,C.rust);

// 30 — Appendix A6: reproducible presentation handoff.
s=base('Appendix A6 · Demo setup, recovery and handoff',{sources:['docs/lab3-demo-guide.md','output/lab3/DEMO-RUNBOOK.md','docs/demo-android-emulator-2026-11-04.md','evidence/code-review/lab3-pr.json','output/lab3/README.md'],notes:'For live demo, use a test account and test data, verify the current date and app session, and prepare the 6:35 backup video. Restore network, permissions and configuration afterward. Delete only records created in the demo and return to the original account/Home. The AVD script is documented but has not been rehearsed.'});
const handoff=[
 ['Live Admin Hosting','https://power9-office-se180724.web.app/','Hosted login is available; full three-round production cross-role timing remains unmeasured.'],
 ['GitHub repository','github.com/PhamQuangDuc1/PRM.POWER9','PR #4 is open and unmerged; do not describe it as merged.'],
 ['Demo recording','Power9_Lab3_Demo_Final.mp4 · 6 min 35 sec','App + Firebase Console footage; Vietnamese narration and captions.'],
 ['Android package','Power9-Lab3-debug-arm64.apk','Debug APK used for the latest Xperia UI verification.'],
 ['Environment recovery','Remove only demo-created data; restore account, network, debug flags and accessibility settings','Do not send FCM or create Crashlytics records during the core data workflows.'],
];
handoff.forEach((v,i)=>{const y=220+i*108;txt(s,v[0],95,y,300,44,23,true,C.blue);txt(s,v[1],410,y,520,56,22,true,C.ink);txt(s,v[2],950,y,550,70,19,false,C.muted);});
txt(s,'Source of record: repository docs, filtered evidence files and the project’s latest status notes.',95,782,1380,34,20,true,C.green);

const candidate=path.join(build,'candidate-guideline.pptx');
await (await PresentationFile.exportPptx(deck)).save(candidate);
for(let i=0;i<deck.slides.items.length;i++){
 const png=await deck.export({slide:deck.slides.items[i],format:'png',scale:.75});
 await fs.writeFile(path.join(build,`slide-${String(i+1).padStart(2,'0')}.png`),new Uint8Array(await png.arrayBuffer()));
}
await fs.writeFile(path.join(build,'slide-notes.json'),JSON.stringify(records,null,2)+'\n');
const target=path.join(out,'Power9_Lab3_English_Detailed_30_Slides.pptx');
await finalizePresentation({workspaceDir:root,candidatePath:candidate,finalPath:target,explicitTotalSlideCount:30,requiredNativeTableOwnerSlides:[4,10,15,16,21,23,27,28,29],requiredNativeChartOwnerSlides:[],pythonExecutable:process.env.RUNTIME_PYTHON,integrityValidatorPath:path.join(skill,'container_tools/inspect_presentation_package_integrity.py'),layoutValidatorPath:path.join(skill,'container_tools/inspect_presentation_layout_geometry.py'),layoutArgs:['--expected-slide-size-emu','15240000,8572500','--validate-heading-fit',...[4,10,15,16,21,23,27,28,29].flatMap(n=>['--require-native-table-slide',String(n)])],fontPolicy:{basis:'design',families:[FONT]},verifyArtifactToolImport:true,receiptPath:path.join(build,'validation-english-v2.json')});
console.log(JSON.stringify({pptx:target,slides:deck.slides.items.length,tables:[4,10,15,16,21,23,27,28,29]}));
