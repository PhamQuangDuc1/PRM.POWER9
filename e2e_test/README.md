# ARTEMIS phase 1

Tiền điều kiện được kiểm tra trước khi gửi task: màn hình phải awake và keyguard không khóa. Nếu không, runner dừng để người dùng mở khóa, không tự wake/unlock. Hierarchy thiếu package được thử lại có giới hạn; chỉ các nhãn thuộc Power9 được trả về. Có thể hủy đúng Flutter time picker bị bỏ dở bằng nút Hủy, không chọn thời gian. Chạy hồi quy không dùng điện thoại/model: `python -m pytest e2e_test/test_device_preconditions.py e2e_test/test_trace_observations.py --basetemp=.build/pytest-<unique> -q`. Kết quả 01/11: 8 passed. Việc này gia cố runner, chưa chứng minh nguyên nhân mọi setup error trước đây.

Kết quả phase 1 hiện hành: 7/9 run ID xác minh, gồm 6 pytest passes hợp lệ và một audit terminal ghi chậm (failure gốc giữ nguyên). TC04[2]/[3] task failed, chưa đạt. Tạo lại thống kê bằng `python e2e_test/summarize_phase1.py`; đọc evidence/artemis/phase1/summary.json. Không cộng các lượt trùng hoặc bị audit loại thành pass. Adapter chờ terminal trace commit tối đa 10 giây trước khi kết luận thiếu output; không tạo JSON thay model.

Opt-in pytest suite trên app Firebase thật, không dùng fake backend. Ba ca TC11, TC03, TC04 × ba lượt; TC04 ở đây chỉ kiểm tra validation/native cancel, chưa bao gồm lưu thành công của TC04 đầy đủ trong test-plan.md. Không coi 9 lượt này là đủ yêu cầu >=10 ca ×3 hoặc Pro exploratory.

Yêu cầu: ARTEMIS upstream commit 351ca8422f7b5b54e80a9c1ce03a222e02415b6b checkout tại .build/tools/artemis, environment từ uv.lock upstream; SDK cục bộ packages/artemis-client/src. Daemon bind localhost:8019, credential/config nằm riêng ignored. Không commit key, raw trace, ảnh Profile/debug hoặc dữ liệu tài khoản. Xem docs/artemis-preflight.md.

Đặt POWER9_DEVICE_SERIAL, POWER9_ADB nếu adb không có PATH, POWER9_NODE nếu node không có PATH, ARTEMIS_BASE_URL nếu đổi localhost port. Mở khóa và mở Power9, đăng nhập tài khoản kiểm thử. Không chạm điện thoại trong lúc chạy.

Chạy bằng Python trong .build/tools/artemis/.venv:

```text
python -m pytest e2e_test/test_artemis_phase1.py --run-artemis -v
```

Daemon có launcher e2e_test/start_artemis.py, chạy bằng cùng Python environment ở terminal riêng. Launcher bind 127.0.0.1, dùng config/key ignored và backend UIAutomator2; không cài helper hoặc đổi cấu hình IDE. Không có --run-artemis thì pytest skip, không gọi model. Preflight billing chạy trước từng task, fail closed nếu thay đổi/không xác minh được. Helper billing riêng hiện kiểm tra project đang gắn key; nếu chuyển key sang project khác phải cập nhật kiểm tra tương ứng trước khi chạy. Kiểm tra billing không phải kiểm soát quota tuyệt đối; lỗi provider vẫn phải ghi là lỗi provider.

Assert output JSON quan sát được, không chỉ succeeded, đồng thời đối chiếu UI hierarchy ở cuối từng ca. ADB chỉ chuẩn bị Home và đối chiếu kết quả, không thực hiện các bước của ca thay ARTEMIS. File evidence gồm traceId/trạng thái/thời gian/output công khai và kết quả assertions; raw trace giữ ignored để xem lại. Không xóa/thay dữ liệu cloud để reset. Model timeout thì dừng task, không tự đổi sang model tính phí.

Compatibility đã phát hiện khi chạy: Flash trong upstream commit này return trước Outputter; endpoint /api/sessions/{id} cũng không trả output. Lượt TC11 đầu completed nhưng output=None nên test FAILED đúng chủ đích. Adapter yêu cầu model đặt JSON quan sát vào explanation của terminal report_task_status, đọc đúng payload action_taken trong SQLite trace theo session ID và parse JSON nghiêm ngặt. Không chuyển narrative thành dữ liệu hoặc bỏ assertion khi output thiếu. outputSource ghi rõ cơ chế này trong mỗi evidence. Trace cục bộ cần nằm tại .build/artemis-run/traces/data_engine.db; đây là adapter cho checkout pin hiện tại, không phải API ổn định của upstream.

Rà soát sâu phát hiện clipboard paste có thể báo thành công nhưng query không vào ô tìm kiếm. runtime/sitecustomize.py là adapter chỉ bật trong worker được launcher cấu hình; các chuỗi ASCII kiểm thử có giới hạn đi qua AndroidInputIME/ADB thay clipboard. Không thay app, model hoặc upstream checkout. trace_observations.py kiểm tra query và thông báo rỗng thực sự có trong UI trace; kết quả model tự báo không đủ. Một lượt tìm kiếm cũ từng qua assertion JSON đã bị loại khỏi kết quả xác nhận do thiếu bằng chứng UI; record cũ giữ assertionsPassed lịch sử và retrospectiveNativeAudit.verified=false. Không tính lại nó thành pass.

Đính chính TC04: showTimePicker là Flutter Material, không phải picker hệ thống Android. Ca này kiểm tra validation và hủy dialog Flutter, chưa đáp ứng riêng yêu cầu ARTEMIS native-system interaction; native account picker/notification shade/print UI cần ca khác. Các evidence cũ có trường native_picker_seen chỉ là lời model, không chứng minh native Android.

## Bộ test mở rộng ngày 01/11

`test_artemis_phase2.py` bổ sung TC02/06/07/08/09/10/13 ×3. Bắt buộc `--run-artemis --run-lab3-writes` sau khi người dùng xác nhận ảnh/cây giao diện Xperia được gửi tới API Google Gemini và đồng ý các thao tác lịch/check-in/timer/PDF. Người dùng đã xác nhận tối đa 40 lượt cho đợt này; `.build/artemis-run/deadline-budget.json` giữ số đã dùng, không tự reset để vượt hạn mức. File budget và model credential không commit.

- TC02 tạo lịch test đi bộ ở các ngày +11/+12/+13 theo Asia/Saigon; các lịch này là dữ liệu kiểm thử, không phải sử dụng tự nhiên.
- TC08/09 chỉ tạo rồi undo/xóa completion của đúng task, giữ schedule. Không xóa completion có sẵn.
- TC06/07 timer dùng thời gian thực, cleanup sau task; nếu gặp record/phiên có sẵn thì phải dừng.
- TC10 sửa giờ lịch đi bộ hôm nay thành 09:11/09:12/09:13, nhắc tắt; thay đổi này cần ghi trong bàn giao.
- TC13 mở native Android print preview rồi Back, không chọn máy in, lưu file, share hoặc upload. Native print spooler phải xuất hiện trong trace; lời model tự báo không đủ.
- TC16 (`test_artemis_analytics.py`) yêu cầu view_activity(activity_id=move-walk) trong logcat của đúng app process và sau thời điểm bắt đầu task. Không xuất raw FA-SVC dùng chung giữa các app.

Outputter upstream chưa chạy ở Flash path đã pin. Adapter mới chỉ thay schema của terminal tool trong process worker khi goal có POWER9_OBSERVATION_SCHEMA: thêm object observations với kiểu từng field. Model phải tự ghi giá trị quan sát vào object; field chưa quan sát được phép bỏ trống và assertion sẽ fail. Không điền kết quả từ narrative, không thêm thao tác thiết bị thay model, không sửa checkout upstream. Dữ liệu được đọc nguyên từ action_taken.args.observations; explanation JSON cũ vẫn dùng được cho trace lịch sử. Có offline tests kiểm tra schema không sửa tool gốc, không tự phát sinh giá trị và giữ false/0 nguyên nghĩa.

`run_exploratory.py --run-artemis` chuẩn bị một task Pro không script. Chỉ được tính đạt thời lượng khi thực tế 900–1800 giây; không thêm sleep để giả 15 phút. Output issue phải rà trace trước khi xuất công khai. Task hoàn tất sớm vẫn không đóng tiêu chí exploratory.

## Firebase CLI preflight có trong repo

Helper `e2e_test/check_model_billing.cjs` dùng Firebase CLI 15.33.0 đã kiểm tra trong môi trường này. Chỉ đọc billingInfo, không bật billing; thiếu field boolean hoặc lỗi xác thực đều fail closed. Dùng Node module resolution trước, fallback `%APPDATA%/npm/node_modules/firebase-tools/lib`; nếu cài nơi khác đặt POWER9_FIREBASE_TOOLS_DIR tới thư mục lib. Không hardcode đường dẫn tên người dùng hoặc credential. POWER9_FIREBASE_PROJECT mặc định power9-office-se180724; project này phải đúng project gắn model key đã xác minh. Khi đổi key/project phải xác minh lại quan hệ đó; một billing check cho project khác không chứng minh model miễn phí. Đây là preflight billing, không phải hạn mức quota tuyệt đối. Credential model/config vẫn do người chạy chuẩn bị riêng ignored.

## TC16 và SDK service dùng chung

Trên bản SDK hiện tại, PID app có log kết nối FA nhưng không có dòng view_activity; FA-SVC xử lý event trong service dùng chung. Không dùng một dòng không có định danh app để kết luận là Power9. Bản debug kiểm thử bổ sung default parameter `p9_e2e_build` ngẫu nhiên qua Firebase SDK, từ dart-define POWER9_E2E_BUILD; không phải UID, email hoặc device ID. Bản thường/release xóa marker. Hai regression tests kiểm tra release/off và từ chối giá trị dạng email/free text.

Để tái hiện, tạo marker tổng hợp mới dạng p9_ + ngày + chuỗi ngẫu nhiên (tối đa40ký tự), lưu `{ "marker": "..." }` vào ignored `.build/artemis-run/analytics-build-marker.json`, build debug với cùng `--dart-define=POWER9_E2E_BUILD=<marker>`, rồi install -r. Bật tạm log.tag.FA và log.tag.FA-SVC thành VERBOSE, debug.firebase.analytics.app thành packagePower9. TC16 ưu tiên log đúng appPID; fallback dùng **--regex marker ngay ở logcat** rồi lọc thời điểm bắt đầu task và event+activity_id. Chỉ SDK lines có markercủa APK này được trả về; không đọc/xuất dữ liệuappkhác hoặc rawlogs. Log do Dart app tự in không được coi là bằng chứngSDK.

Sau kiểm thử khôi phục taglogs về giá trị trước đó và tắt Analyticsdebug bằng .none. Tài liệu chính thức: [Native Android event logging](https://firebase.google.com/docs/analytics/android/events#view_events_in_the_android_studio_debug_log), [DebugView](https://firebase.google.com/docs/analytics/debugview). LogSDK chứng minh SDKđã xử lý event/params, không tự suy ra DebugView/dashboard đã nhận đầy đủmọievent.

Lượt TC10 thử lại dùng tickđồnghồ dễ quan sát: rep2=10:30, rep3=11:00, vẫn yêu cầu Hủygiữgiờcũ rồi saveđúnggiờmới và tổngkhôngtăng. Các lượt cũ09:12/09:13/10:45 thấtbại giữ nguyên và không được đổi thành pass bằng cách đổiexpected.

Người dùng đã nâng giới hạn từ40 lên **45 lượt tổng cộng**, gồm phiên Pro15–20phút; budget phải giữusedhiện tại, chỉ cập nhậtlimit sau xác nhận trực tiếp. Không mở rộng ra profile/debugUI, gửi thông báo hoặc billing.
