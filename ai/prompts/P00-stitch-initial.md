# P00 Initial UI prompt

Status: DRAFT READY TO RUN. This file proves preparation only. No Stitch run/output is claimed. Copy only the text inside the block. If you change it before submitting, save the exact submitted text as a new prompt version.

```text
Design one cohesive Android mobile habit-tracking app named “Power9 Family Routine”. Create high-fidelity, editable mobile UI layouts, not a website, marketing board or code tutorial. Use Vietnamese UI copy with correct diacritics. Base viewport 360×800 logical pixels, with layouts that can expand to width 412.

PRIMARY PERSONA (hypothetical, not research): Linh, 36, an administrative employee and parent of a young child. Her Android sessions are short and interrupted. Tonight she has only five minutes and wants to find and add an appropriate habit. Target: find and add in under 60 seconds from Home. This is a design target, not a proven result.

SUPPORTING HYPOTHETICAL PERSONAS: Minh, 20, student: direct check-in within three actions; Huy, 28, office worker: reschedule in under 30 seconds; Hùng, 61, retired teacher: readable labels, large tap targets, confident completion without instruction. Address these within the same app. Do not create four apps or a persona selector.

VISUAL SYSTEM: calm, warm, practical and spacious. Background #F7F8F4; white surfaces #FFFFFF; main text #173B32; secondary text #52665E; primary action #245C46 with white text; selected background #E8F2EC; control outlines #6C8075; error #A7332A on white. No gradients. Roboto or another Vietnamese-capable sans serif. Body 16/24, labels no smaller than 14/20, headings 20/28 and 24/32. Spacing 4/8/12/16/24/32, screen padding 16, cards radius 16, buttons radius 12 and height 52, inputs radius 8. Touch targets at least 48×48. Use modest elevation, no ornamental charts or large decorative images. One dominant primary action per screen. Never communicate completion, errors or selection by color alone.

CREATE EIGHT DISTINCT SCREENS, with these exact IDs in canvas/frame names (do not show technical IDs in the app UI):
S01 “Hôm nay”: greeting, short today summary, two or three scheduled habit cards. Each card shows plain-language name, duration (“5 phút”), reminder time if present and an explicit “Hoàn thành” action. Include clear entries to “Khám phá thói quen” and “Lịch sử và tiến độ”. Avoid a dense dashboard.
S02 “Ăn uống”: a simple eating-related habit such as “Ăn chậm, chú ý cảm giác no”, concise instructions and a clear record-completion action. Avoid clinical claims, calorie goals and a recipe product.
S03 “Thư giãn”: a five-minute breathing/rest session, clear duration, timer and labeled “Bắt đầu”, with distinct paused/active examples if needed. Include a deliberate finish action and an exit-confirmation dialog for an active session.
S04 “Kết nối”: short real-world activities with loved ones, such as “Gọi hỏi thăm người thân · 5 phút”, clear selection and completion. No realtime chat, public social feed or fake live users.
S05 “Khám phá thói quen”: visible time chips “Tất cả”, “5 phút”, “10 phút”, a labeled search input, three readable activity cards with duration. Selected chip has a check icon as well as color. Include an example matching a five-minute filter.
S06 “Chi tiết thói quen”: title, explicit duration, short purpose and two or three steps. New-habit context has primary “Thêm vào hôm nay”. Existing-habit context has “Đổi lịch”. These are variants of S06, not extra screens.
S07 “Lịch thói quen”: short create/edit form showing chosen habit and duration, day, an optional reminder toggle with explicit label, and time when reminder is on. Primary “Lưu lịch”, secondary cancel/Back. If reminder is on and time missing, show inline validation. Preserve values when save fails. A populated editing example shows the current time and proposed new time.
S08 “Lịch sử và tiến độ”: dated completed activities, simple readable weekly count, no complex charts. Completion is an icon plus text. If an entry is removed, confirm first with “Giữ lại” and “Xóa bản ghi”.

NAVIGATION: four top-level tabs with icons AND labels: “Hôm nay”, “Ăn uống”, “Thư giãn”, “Kết nối”. Use the same order and selected-state pattern on S01–S04. Nested screens S05–S08 have clear Back navigation, preserving context. Do not add onboarding, login, notifications or profile screens just to reach eight.

FLOW F01: S01 → S05 filter for five minutes → S06 → S07 save → S01 showing the newly added habit and obvious confirmation.
FLOW F02: S01 → S03 complete a short rest → S08 view recorded completion → S01. Alternative category paths use S02 or S04 and then S08. Allow direct Home check-in with explicit “Hoàn tác” feedback.
FLOW F03: S01 → S06 existing habit → S07 change reminder time → S01 showing the new time. Cancel retains the old time. Save errors retain entered values and provide “Thử lại”.

ALSO SHOW relevant state variants next to their parent screens, clearly identified on the canvas: S05 no results with “Xóa bộ lọc”; S07 saving, save failure with plain-language explanation and “Thử lại”, and inline time validation; S01 saved/completed confirmation with icon and label; S08 empty with one action to discover a habit; active-session exit confirmation and destructive history confirmation dialogs. Dialogs/state variants do not count as distinct screens.

Keep example data consistent: Linh is adding “Thở chậm · 5 phút” today with an optional evening reminder. Supporting Home cards can include “Đi bộ nhẹ · 10 phút” and “Gọi hỏi thăm người thân · 5 phút”. Do not imply real user data or measured UX outcomes.

Make the main add-habit flow visually complete. If the tool cannot produce all eight screens in one run, prioritize S01, S05, S06, S07 with the same style; report remaining screen IDs rather than replacing them with unrelated screens.
```
