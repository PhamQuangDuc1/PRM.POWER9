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
