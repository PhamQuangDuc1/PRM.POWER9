"""Build the evidence-based Lab 3 PDFs; figures retain their recorded dates."""
import sys,json,re,html
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'.build/lab3-pdf-deps'))
from reportlab.pdfgen import canvas
from reportlab.platypus import SimpleDocTemplate,Paragraph,Spacer,PageBreak,Table,TableStyle,Image
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib import colors
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib.utils import ImageReader
OUT=ROOT/'output/lab3';OUT.mkdir(parents=True,exist_ok=True)
pdfmetrics.registerFont(TTFont('BeVietnam',str(ROOT/'assets/fonts/BeVietnamPro-Regular.ttf')))
pdfmetrics.registerFont(TTFont('BeVietnamBold',str(ROOT/'assets/fonts/BeVietnamPro-Bold.ttf')))
pdfmetrics.registerFontFamily('BeVietnam',normal='BeVietnam',bold='BeVietnamBold')
BLUE=colors.HexColor('#245EA8');INK=colors.HexColor('#102A43');GRAY=colors.HexColor('#526476')
BODY=ParagraphStyle('Body',fontName='BeVietnam',fontSize=10.4,leading=16,spaceAfter=10,textColor=INK)
TITLE=ParagraphStyle('Title',parent=BODY,fontName='BeVietnamBold',fontSize=23,leading=31,spaceAfter=18,textColor=colors.black)
H2=ParagraphStyle('H2',parent=BODY,fontName='BeVietnamBold',fontSize=13,leading=19,textColor=colors.black,spaceBefore=9)
SMALL=ParagraphStyle('Small',parent=BODY,fontSize=8,leading=12,textColor=GRAY)

def p(text,style=BODY): return Paragraph(text,style)
def stats():
 records=[]
 for folder in ['phase1','phase2']:
  for file in (ROOT/f'evidence/artemis/{folder}').glob('TC*.json'):
   r=json.loads(file.read_text(encoding='utf-8'));records.append(r)
 good={}
 for r in records:
  if r['case'] not in {'TC02','TC03','TC04','TC06','TC07','TC08','TC09','TC10','TC11','TC13'}: continue
  audited=r.get('delayedTerminalAudit',{}).get('verified') is True
  scope=r.get('phase1ScopeAudit',{}).get('verified') is True
  rejected=r.get('retrospectiveNativeAudit',{}).get('verified') is False
  valid=audited or (r.get('assertionsPassed') is True and (not rejected or scope))
  if valid: good[(r['case'],r['repetition'])]=r
 return records,good

def figure(file,caption,height=340):
 path=ROOT/file
 if not path.exists(): return []
 w,h=ImageReader(str(path)).getSize(); width=height*w/h
 return [Spacer(1,5),Image(str(path),width=width,height=height),Spacer(1,5),p(caption,SMALL)]

def table(rows,widths):
 data=[[p(str(cell),SMALL) for cell in row] for row in rows]
 t=Table(data,colWidths=widths,hAlign='LEFT')
 t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),colors.HexColor('#E8EFF8')),('GRID',(0,0),(-1,-1),.5,colors.HexColor('#D9D9D9')),('VALIGN',(0,0),(-1,-1),'MIDDLE'),('LEFTPADDING',(0,0),(-1,-1),8),('RIGHTPADDING',(0,0),(-1,-1),8),('TOPPADDING',(0,0),(-1,-1),8),('BOTTOMPADDING',(0,0),(-1,-1),8)]))
 return t

def footer(c,doc):
 c.setFont('BeVietnam',8);c.setFillColor(GRAY)
 c.drawString(48,27,'Power9 Office Routine  |  PRM393 Lab 3  |  02/11/2026')
 c.drawRightString(547,27,f'{doc.page} / 10')

records,good=stats()
analytics_good={(r['case'],r['repetition']) for r in records if r['case']=='TC16' and r.get('assertionsPassed') is True}
analytics_count=len(analytics_good)
verified=len(good); failed=sum(not r.get('assertionsPassed',False) for r in records)
progress=f'ARTEMIS hiện có {verified}/30 run ID được xác minh trong 10 ca chính. Analytics TC16 bổ sung đạt {analytics_count}/3 lượt. Có {len(records)} attempts có evidence; lỗi và lần chạy trùng vẫn giữ riêng. Số này không phải tỷ lệ pytest pass của mọi attempts.'
sections=[
('Báo cáo Lab 3 Power9 Office Routine',[
 'Ứng dụng Android hỗ trợ nhân viên văn phòng chọn, lên lịch và tự ghi nhận hoạt động ngắn trong ngày. Bản Flutter kết nối Firebase, kế thừa 10 màn và ba flow từ Lab 2. Tài liệu này trình bày kiến trúc, tích hợp, kết quả kiểm chứng và các giới hạn còn lại; ảnh được giữ ngày chụp để tránh nhầm với lần thử mới.',
 'Mốc sửa lỗi hiện hành: 48/48 Flutter tests đạt, flutter analyze không issue và APK debug arm64 đã build thành công. 18 Rules tests đạt ở mốc FCM/PDF trước đó. FCM Console đã được kiểm chứng ở foreground, background và terminated; PDF thật đã được lưu trên Xperia. Không dùng số test Dart hoặc emulator để thay yêu cầu ARTEMIS.',
 progress,
 'Storage production chưa được xác minh: dự án giữ Spark theo lựa chọn của người dùng, report_upload_enabled=false. Năm findings đã đưa vào draft PR #3, ba fixes runtime có commit riêng ac4b35b / 38b52bc / e595956. Video được để cuối sau khi chốt UI/UX. Exploratory và các mục bằng chứng thiếu phải được bổ sung trước khi tuyên bố hoàn thành toàn bộ đề.'
],None),
('Người dùng và ba flow kế thừa',[
 'Ba persona giả định được giữ ngang nhau: Huy 28 tuổi, Mai 24 tuổi và Linh 39 tuổi. Điểm chung là thời gian nghỉ ngắn và lịch làm việc dễ thay đổi. App không yêu cầu chọn persona, không tạo lịch sử hoàn thành giả và không buộc người dùng hoàn thành cả chín nhóm mỗi ngày.',
 'F01 tìm và thêm: Hôm nay → Khám phá → Chi tiết → Lịch → Hôm nay. Bộ lọc kết hợp từ khóa và thời lượng; khi không có kết quả, người dùng xóa bộ lọc. Form kiểm tra thiếu giờ khi bật nhắc; lỗi lưu giữ draft để thử lại. Thành công chỉ hiển thị sau backend xác nhận.',
 'F02 thực hiện và xem lại: check-in, checklist hoặc timer → Tiến độ → hoàn tác/xóa. Timer dùng thời gian thật, hỗ trợ tạm dừng và background; check-in không được gán thời lượng ước lượng. F03 mở lịch hiện có → đổi giờ → lưu hoặc hủy; hủy không ghi và lưu không tăng số lịch.',
 'Truy vết màn và component nằm trong docs/design-traceability.md và handoff/flutter-handoff.md. Figma Login/Profile, fidelity ở 360/412 dp và TalkBack chưa được kiểm chứng đầy đủ. Nhắc tại giờ chọn và quiet hours hiện chỉ lưu cấu hình; việc nhận FCM không chứng minh nhắc lịch tự động.'
],None),
('Kiến trúc và nguồn dữ liệu',[
 'Luồng gọi theo MVVM: màn hình trong lib/screens đọc state và gửi action tới lib/viewmodels; các services bao gói Firebase SDK. Models tách dữ liệu nghiệp vụ khỏi widget. Riverpod quản lý dependency, session và các provider theo uid/ngày. Auth gate dùng Navigator theo uid để thay tuyến riêng tư khi phiên đổi.',
 'Firestore catalog chứa 10 hoạt động thuộc chín nhóm. Schedules và completions nằm dưới users/{uid}; định danh từ activityId và ngày giúp thao tác thử lại không tạo thêm bản ghi cho cùng hoạt động/ngày. TodayOverview hợp nhất lịch đã chọn với ghi nhận ngoài lịch và tính số hoàn thành/tổng từ dữ liệu thật.',
 'FirebaseAuthService thực hiện Google Sign-In; FirestoreScheduleService và FirestoreCompletionService ghi dữ liệu. FirebaseNotificationService xử lý FCM/native channel; ReportGenerator tách khỏi ReportUploadService. TelemetryService và AppConfigService cho phép kiểm thử lỗi và thay dependency mà không nối fake backend vào app runtime.',
 'App sử dụng Flutter 3.47.3, Dart 3.13.3 và package vn.power9.power9_office_routine. Các dependency đã resolve được pin trong pubspec.lock. Thiết bị kiểm chứng chính là Sony Xperia SOV41, Android 11/API 30. Cấu hình CLI và model credential giữ cục bộ, không đưa vào app hoặc bằng chứng công khai.'
],None),
('Authentication Firestore và Rules',[
 'Google Sign-In đã chạy trên Xperia với tài khoản do người dùng tự chọn. Ngày 02/11 đã thử logout về Login, Back/mở lại không lộ Home, hủy Google picker hiện lỗi và thử lại mở picker. Lượt đầu kiểm tra Activity quá sớm bị fail, giữ riêng; lượt kiểm tra sau chờ resume đã đạt. Không xuất email hoặc ảnh picker. Lỗi mạng và chuyển hai tài khoản vẫn chưa có bằng chứng thiết bị đầy đủ.',
 'Rules theo deny-by-default, kiểm tra ownership, schema, kiểu, đường dẫn và các trường không được sửa. Emulator dùng project demo-power9; alice/bob chỉ là danh tính kiểm thử cục bộ, không phải dữ liệu production. Kết quả gần nhất là 18 tests: 16 Firestore và hai Storage, gồm cross-user/anonymous denial và metadata báo cáo.',
 'Schedule sửa cùng định danh giữ createdAt; completion là bản ghi riêng nên xóa/hoàn tác completion không xóa lịch. Bằng chứng API server đã được lọc UID/token trong evidence/flows. Không mở Rules hoặc xóa toàn bộ dữ liệu để reset test.',
 'Review hiện hành phát hiện logout có thể tắt messaging trước khi signOut thất bại. Sửa R03 khôi phục binding cho đúng uid còn hoạt động, đồng thời vẫn trả lỗi logout ban đầu. Test regression kiểm tra phiên vẫn còn, notifications được restore và state báo lỗi; đây chưa thay test logout trên máy thật.'
],None),
('F01 và F03 lưu lịch có phục hồi',[
 'Trên Xperia, lượt kiểm chứng ngày 31/10 bắt đầu từ không có lịch. Người dùng bật nhắc nhưng chưa chọn giờ thì form báo lỗi, không tạo schedule. Sau khi tắt nhắc và lưu, Home có đúng một lịch đi bộ. Đổi giờ thành 23:01 vẫn giữ một document và createdAt ban đầu; chọn Hủy sau khi sửa không thay updatedAt/time/reminder trên server.',
 'Ngày 02/11 đã bổ sung Xóa lịch hoạt động với xác nhận, lỗi/retry và guard đổi tài khoản. Demo CRUD thật trên Xperia đã đối chiếu Firestore: thêm, xem, đổi thành 10:30 giữ document/createdAt, hủy xóa không thay updatedAt, xóa lịch giữ completion; chỉ hoàn tác dữ liệu do lượt thử tạo. Evidence tại evidence/flows/crud.',
 'ScheduleViewModel giữ ngày, giờ và trạng thái nhắc trong draft. Khi đang saving, thao tác bị chặn để tránh gửi lặp. Service xác nhận ghi rồi ViewModel mới trả success. Nhánh lỗi cho phép retry từ cùng draft. Đây là luồng ghi bất đồng bộ thật, khác với snapshot của prototype Lab 2.',
 'Ảnh bên dưới lấy từ trace TC16 lượt 1 ngày 01/11 trên bản debug mới; lịch đi bộ đã đổi thành 11:00 trong kiểm thử. JSON server tương ứng ở evidence/flows/firestore-server-verification.json. ARTEMIS lưu lịch tương lai và sửa lịch được ghi riêng, không cộng ADB smoke vào số lần ARTEMIS.'
],('evidence/artemis/latest-home-trace-xperia.jpg','Home từ trace TC16 lượt 1 ngày 01/11/2026: hai lịch thật, giờ đi bộ 11:00. Ảnh không được chụp mới sau khi tắt daemon.')),
('F02 thời gian thực và hoàn tác',[
 'Timer đã được kiểm tra trên Xperia: tạm dừng giữ 02:58 qua dialog rời phiên; resume tiếp tục tính sau background. Kết thúc sớm một phiên ghi đúng 72 giây, Progress hiển thị 1 phút 12 giây. Phiên đủ ba phút ghi đúng 180 giây, không cộng thêm thời gian chờ bấm ghi nhận.',
 'Check-in Home tăng done rồi Undo trả số cũ và vẫn giữ schedule. Nhánh Ăn uống ghi source=checkin, durationSeconds=null. Xóa bản ghi có bước xác nhận: Giữ lại không đổi dữ liệu; Xóa chỉ xóa completion. Progress ngày rỗng hiển thị empty thật và CTA khám phá, không seed lịch sử để lấp màn.',
 'Checklist Góc làm việc giữ 3/3 khi mất mạng; online retry đã được đối chiếu chỉ một completion server. Test clock giả trong Dart dùng để kiểm tra thuật toán, không được trình bày như đo thời gian thiết bị. Các evidence của timer/checklist nằm trong evidence/f02 và evidence/workspace.'
],('evidence/f02/progress-early-end-xperia.png','Progress 72 giây sau phiên kết thúc sớm, Xperia ngày 31/10/2026.')),
('FCM và Notification Center',[
 'FCM đã nhận Test message do người dùng gửi từ Firebase Console ở foreground, background và terminated. Notification-only công khai của project mở Home; payload có target=progress hợp lệ mở Progress. Foreground dùng local notification trên native channel; tap khi app nguội dùng getInitialMessage, khi background dùng onMessageOpenedApp.',
 'Inbox lưu riêng theo uid, hash messageId và deduplicate. Chạm thông báo phải đi qua guard timer. Terminated được xác nhận process vắng mặt trước gửi; không dùng Android Force stop để thay điều kiện này. API accepted không được dùng riêng để kết luận delivery, vì đã đối chiếu thông báo hiển thị và route thực tế.',
 'SDK Messaging 17 dùng register/onRegistered và Android installation-id opt-in. Ngày 02/11 đã tắt riêng thông báo Power9 trong Android 11, xác minh lỗi quyền/nút thử lại, rồi khôi phục quyền như cũ và về Home. Đây là smoke cục bộ, không phải ARTEMIS hay bằng chứng runtime permission Android 13. R01 xử lý date_key sai kiểu; R02 ngăn refresh cũ ghi đè inbox mới. Evidence tại evidence/fcm.'
],('evidence/fcm/console-three-states-inbox-xperia.png','Inbox chứa Test message Console ở ba trạng thái, Xperia ngày 01/11/2026.')),
('Analytics Crashlytics và Remote Config',[
 'Analytics có 12 AppEvent với tham số theo danh sách cho phép, không gửi tên, email hoặc từ khóa tự do. DebugView đã có config_refreshed, view_activity và activity_completed ở mốc trước. TC16 xác minh 1/3 lượt view_activity(activity_id=move-walk) bằng log SDK FA-SVC lọc theo mã bản debug ngẫu nhiên và thời điểm task. Không xuất raw log hoặc dùng log Dart tự in làm bằng chứng SDK. Hai lượt model thất bại; chưa đủ ảnh tham số cho cả 11 event.',
 'Crashlytics reporting API đã xác nhận một FATAL test crash và một NON_FATAL completion_write/unavailable từ lỗi mất mạng thật, có user identifier và custom keys. Evidence công khai chỉ giữ boolean cho định danh. Test crash có xác nhận, chỉ ở debug. Lỗi gửi theo operation/code chuẩn hóa để tránh lộ exception message riêng tư.',
 'Remote Config đã thay hai hành vi không rebuild: discover_max_minutes 60→5 và connection_checkin_enabled true→false, rồi trở về defaults. Fetch thất bại giữ cache/default; debug interval 0, release một giờ. report_upload_enabled=false là cờ bổ sung để giữ Spark. JSON template và đối chiếu nằm ở evidence/remote-config và docs/firebase-observability.md.'
],('evidence/remote-config/demo-xperia.png','Giá trị Remote Config 5/false đã kích hoạt, Xperia ngày 01/11/2026.')),
('PDF Storage và giới hạn Spark',[
 'Progress xuất snapshot đúng ngày đang xem. PdfReportGenerator nhúng font Be Vietnam Pro và logo, không tải font lúc tạo. PDF có tổng hợp, lịch/giờ/trạng thái và thời lượng thực; check-in không nhận số phút giả. PrintingReportService mở Android print preview để lưu hoặc share sheet khi người dùng chủ động chọn.',
 'PDF thật ngày 01/11 đã lưu qua Android Save as PDF và pull về kiểm tra: đúng 0/2, lịch nghỉ tối 21:30 và đi bộ chưa chọn giờ, không có UID. File gốc lưu tại evidence/pdf/Power9-2026-11-01-xperia.pdf. Bản fixture 120 dòng dùng kiểm tra layout, không dùng thay dữ liệu cloud.',
 'Uploader có progress, timeout, path reports/{uid}/{SHA256(bytes)}.pdf và metadata Firestore ghi sau Storage xác nhận. Retry giữ bytes/path; logout bỏ kết quả đến muộn. Rules giới hạn owner, PDF MIME, kích thước và metadata. Tuy nhiên chưa có bucket/upload production vì project giữ Spark; emulator và PDF local chưa thay tiêu chí Storage thật.',
 'Cần trao đổi giảng viên về giới hạn này. Tài liệu không tuyên bố đã upload hoặc có URL production. Không bật billing chỉ để làm đẹp báo cáo; cờ upload vẫn false. ARTEMIS PDF/native preview cũng được phân biệt với ca upload Storage đầy đủ.'
],None),
('Kiểm thử review và việc cần đóng',[
 progress,
 'Đã thực thi 11 ca × 3 run ID. Tổng 30/33 run ID được xác minh, gồm một audit TC03 sau lỗi ghi chậm; không phải 30 pytest passes. Chín ca có 3/3 run ID xác minh; TC10 còn 2/3 và TC16 còn 1/3. Một số case chỉ bao phủ một phần test-plan. 59 attempts giữ pass/fail, tỷ lệ và thời gian riêng. Viewer HTML cục bộ có 33 runs và 257 ảnh gốc đã lọc; không xuất raw prompt hoặc UI dump.',
 'Review cục bộ tại ai/code-review/lab3-review.md có năm findings: payload date sai kiểu, inbox refresh lệch thứ tự, logout lỗi mất binding, nhận nhầm Progress là Home và lỗi terminal chưa ghi evidence. Ba findings runtime đã sửa với regression riêng và commit ac4b35b / 38b52bc / e595956. Ngày 02/11 đã tạo draft PR #3 tại github.com/PhamQuangDuc1/PRM.POWER9/pull/3, đưa cả năm findings/dispositions vào PR body. Không khẳng định có human approval hoặc merge.',
 'Pro exploratory chưa đạt: lượt 45 bị quota ngày 500, hủy với 0 bước UI; 926,82 giây chờ không tính là khám phá. Ngày 02/11 người dùng cho phép tổng 50 lượt, nhưng auto-review vẫn chặn resume theo trần cũ; budget thực tế giữ 45/45, không có model task mới. Còn TC10[3], TC16[2–3], Pro, fidelity/TalkBack, Storage production và video Console. Kiểm tra nhãn/kích thước nút 14 màn ở 360/412 dp chữ 1,5× đã đạt; chưa thay TalkBack. Footage 6 phút 02 giây chưa thay video đầy đủ.',
 'Nguồn mã: github.com/PhamQuangDuc1/PRM.POWER9. Thiết kế: figma.com/design/MTv5qJbn065VYJQIXausoq. Chi tiết yêu cầu và trạng thái: docs/lab3-completion-plan.md, docs/test-report.md và docs/CONTINUE.md. Bản này cần tái tạo từ generator sau khi có thêm test results hoặc fix commits.'
],None),
]
story=[]
for index,(title,paragraphs,fig) in enumerate(sections):
 story += [p(f'{index+1:02d}  {title}',TITLE)]
 for text in paragraphs: story.append(p(html.escape(text)))
 if index==0:
  story += [Spacer(1,14),table([['Thành phần','Mốc kiểm chứng'],['Flutter','48 tests đạt; analyze sạch; APK build được'],['Firebase Rules','18 tests đạt ở mốc trước'],['FCM PDF RC Crashlytics','Có bằng chứng thật; giới hạn ghi trong từng mục'],['ARTEMIS',f'{verified}/30 run ID xác minh; chưa đóng toàn bộ yêu cầu'],['Storage và video','Chưa hoàn tất; PR #3 có ba fix commits']], [135,360])]
 if index==2:
  story += [Spacer(1,12), table([['Contract','Trách nhiệm chính'],['ActivityService','Đọc catalog chung; tìm/lọc qua ViewModel'],['ScheduleService','Lưu hoặc cập nhật một lịch theo hoạt động và ngày'],['CompletionService','Record, undo và xóa completion độc lập schedule'],['NotificationService','Binding theo uid, nhận message và route tap'],['ReportGenerator / ReportUploadService','Tạo bytes PDF tách biệt thao tác Storage'],['TelemetryService / AppConfigService','Event, error report và defaults/cache/fetch']], [185,310])]
 if index==3:
  story += [Spacer(1,12), table([['Nhóm kiểm tra Rules','Điều cần bảo vệ'],['Ownership','SDK request chỉ thao tác dữ liệu dưới đúng uid'],['Schema và kiểu','Từ chối field hoặc giá trị không hợp lệ'],['Completion','Nguồn ghi nhận, duration và bất biến sau tạo'],['Report metadata','Đúng path, digest, ngày và kích thước'],['Storage','Owner, PDF MIME, filename và giới hạn dung lượng']], [175,320])]
 if index==8:
  story += [Spacer(1,12), table([['Trạng thái báo cáo','Hành vi và giới hạn'],['Generate','Snapshot đúng ngày; bytes giữ lại để retry/present'],['Preview / Share','Mở Android UI; không tự gửi tới người khác'],['Upload disabled','Không gọi uploader khi report_upload_enabled=false'],['Upload error','Giữ PDF; báo lỗi; cho phép lưu local hoặc retry'],['Upload success','Metadata sau Storage; download URL là bearer link']], [155,340])]
 if fig: story += figure(*fig)
 if index<len(sections)-1: story.append(PageBreak())
SimpleDocTemplate(str(OUT/'Power9_Lab3_Report.pdf'),pagesize=(595.28,841.89),leftMargin=48,rightMargin=48,topMargin=45,bottomMargin=45,title='Báo cáo Lab 3 Power9 Office Routine',author='Power9').build(story,onFirstPage=footer,onLaterPages=footer)

# The professionally redesigned deck is authored by build_designer_deck.mjs.
# Keep this historical text-only deck available only on explicit request.
if '--legacy-slides' not in sys.argv:
 print(json.dumps({'report':str(OUT/'Power9_Lab3_Report.pdf'),'slides':'Use build_designer_deck.mjs; legacy deck not overwritten'}))
 raise SystemExit(0)

SLIDES=[
 ('Power9 Office Routine','PRM393 Lab 3 Cloud Enabled',['Ứng dụng Flutter kết nối Firebase trên Sony Xperia SOV41.','Ba flow từ Lab 2: chọn lịch, ghi nhận và đổi lịch.','Cập nhật 02/11/2026; ảnh cũ giữ ngày nguồn.'],None),
 ('Bài toán và phạm vi','Thói quen ngắn cho ngày làm việc',['Ba persona giả định Huy 28, Mai 24, Linh 39.','Chín nhóm hoạt động, 10 màn chức năng và ba flow.','Không ép hoàn thành 9/9; tiến độ lấy dữ liệu thật.'],None),
 ('MVVM và Riverpod','View → ViewModel → Service → Firebase SDK',['screens: hiển thị state và nhận thao tác.','viewmodels: validation, async state và guard phiên.','services: Auth, Firestore, FCM, PDF, telemetry và config.','Models giữ contract dữ liệu độc lập UI.'],None),
 ('Auth và Firestore','Dữ liệu cá nhân dưới users/{uid}',['Xperia 02/11: logout, Back riêng tư, hủy login và retry đã thử.','Navigator theo uid; Rules deny by default.','Schedule/completion tách riêng, định danh theo hoạt động/ngày.','18 emulator tests ở mốc FCM/PDF; không thay production evidence.'],None),
 ('F01 và F03 lưu lịch','Validation giữ draft và sửa không trùng',['Bật nhắc nhưng thiếu giờ: báo lỗi, không tạo lịch.','Lưu/đổi giờ đã đối chiếu server; Hủy giữ dữ liệu.','Ảnh từ trace TC16 ngày 01/11: lịch đi bộ 11:00 và nghỉ tối 21:30.'],'evidence/artemis/latest-home-trace-xperia.jpg'),
 ('F02 timer và hoàn tác','Ghi thời gian thực tế',['Timer pause/resume/background đã thử trên máy.','Kết thúc sớm: 72 giây; đủ phiên: 180 giây.','Undo hoặc xóa completion vẫn giữ lịch.','Ảnh Progress là mốc 31/10.'],'evidence/f02/progress-early-end-xperia.png'),
 ('Checklist và phục hồi lỗi','Giữ lựa chọn khi mất mạng',['Góc làm việc giữ 3/3 khi lưu lỗi.','Khôi phục mạng, thử lại: đúng một completion server.','Không seed dữ liệu hoàn thành để làm đẹp tiến độ.'],'evidence/workspace/checklist-offline-xperia.png'),
 ('FCM ba trạng thái','Firebase Console → Xperia → tap mở Home',['Foreground, background và terminated đã nhận.','Inbox riêng theo uid, deduplicate messageId.','Terminated có xác minh process vắng; không Force stop.','02/11: từ chối quyền Android 11, retry và khôi phục đạt.'],'evidence/fcm/console-three-states-inbox-xperia.png'),
 ('Analytics','Xác minh event và tham số bằng nguồn đúng',['11 event trong mã; DebugView mới xác nhận một phần.','Params whitelist, không raw search/name/email.','TC16[1] đã khớp SDK view_activity và activity_id=move-walk.','Marker ngẫu nhiên của bản debug giúp lọc đúng nguồn log.'],None),
 ('Crashlytics','Hai loại lỗi đã có bằng chứng server',['FATAL: test crash native chỉ trong khu debug, có xác nhận.','NON_FATAL: completion_write/unavailable từ mất mạng thật.','Reporting API xác nhận user identifier và custom keys.','Bằng chứng đã lọc: evidence/firebase-observability.'],None),
 ('Remote Config','Đổi hai hành vi không rebuild',['discover_max_minutes: 60 → 5.','connection_checkin_enabled: true → false.','Đã fetch lại defaults; fetch lỗi giữ cache.','Ảnh là lần demo 01/11, không phải cấu hình hiện tại.'],'evidence/remote-config/demo-xperia.png'),
 ('PDF và giới hạn Storage','Xuất đúng dữ liệu ngày đang xem',['PDF thật đã lưu bằng Android Save as PDF.','Font Việt, giờ lịch và duration thực từ dữ liệu.','Uploader/Rules có mã, progress và retry.','Storage production chưa đạt; Spark, upload=false.'],None),
 ('Kiểm thử ARTEMIS','Kết quả đọc từ trace và assertions',[f'{verified}/30 run ID đang được xác minh trong 10 ca đã chuẩn bị.','Giữ failed attempts và trace IDs; không đếm lại ca trùng.','Native print preview cần trace của Android print spooler.',f'Analytics TC16 đạt {analytics_count}/3; Pro bị chặn quota ngày500.'],None),
 ('Review và sửa lỗi','Năm findings có vị trí mã',['R01 payload date sai kiểu; R02 inbox refresh trả về lệch thứ tự.','R03 logout lỗi khiến messaging bị tắt.','Ba sửa runtime có regression; Flutter 48/48, analyze sạch.','R04/R05 sửa runner. PR và ba fix commits riêng còn phải đóng.'],None),
 ('Bài học và phần cần đóng','Tách lỗi app khỏi lỗi công cụ và provider',['Demo: đăng nhập → F01 → F02 → F03 → PDF.','Console: FCM, DebugView, Crashlytics và Remote Config.','Còn ba lượt lỗi; Pro bị chặn quota; Storage, PR và video Console chưa đóng.','GitHub: PhamQuangDuc1/PRM.POWER9.'],None),
]
c=canvas.Canvas(str(OUT/'Power9_Lab3_Slides.pdf'),pagesize=(1280,720));c.setTitle('Power9 Lab 3 Presentation');c.setAuthor('Power9')
for index,(title,subtitle,bullets,fig) in enumerate(SLIDES):
 c.setFillColor(colors.white);c.rect(0,0,1280,720,fill=1,stroke=0)
 c.setFillColor(BLUE);c.setFont('BeVietnamBold',35);c.drawString(56,651,title)
 c.setFillColor(GRAY);c.setFont('BeVietnam',20);c.drawString(58,604,subtitle)
 width=820 if fig else 1140;y=527
 style=ParagraphStyle('SlideBody',fontName='BeVietnam',fontSize=25,leading=36,textColor=INK)
 for text in bullets:
  par=p(html.escape(text),style);w,h=par.wrap(width,300);par.drawOn(c,60,y-h);y-=h+26
  assert y>70,(index,title,y)
 if fig:
  path=ROOT/fig;w,h=ImageReader(str(path)).getSize();hh=500;ww=hh*w/h
  c.drawImage(str(path),1030-ww/2,85,width=ww,height=hh,preserveAspectRatio=True,mask='auto')
 c.setFont('BeVietnam',11);c.setFillColor(GRAY);c.drawString(58,30,'Power9 Office Routine  |  Lab 3  |  Bằng chứng trong repository');c.drawRightString(1220,30,f'{index+1:02d} / 15')
 c.linkURL('https://github.com/PhamQuangDuc1/PRM.POWER9',(56,18,750,48),relative=0,thickness=0)
 c.showPage()
c.save()
(OUT/'slide-content.json').write_text(json.dumps(SLIDES,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'report':str(OUT/'Power9_Lab3_Report.pdf'),'slides':str(OUT/'Power9_Lab3_Slides.pdf'),'artemisPrimaryVerifiedRunIds':verified}))
