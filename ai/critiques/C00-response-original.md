# C00 Full UX review of V00 overview

## Scope and method

Codex reviewed the actual group-supplied screenshot at assets/stitch/V00/V00-overview-user-provided.png using the criteria preserved in C00-review-criteria.md (from ai/prompts/C00-ux-critique.md), the four hypothetical personas and the Lab 2 screen contract. This is the review response itself, not a transcript from another AI service.

Visible: a semantic style board and four mobile screens. From left to right after the board: S05 discovery/search, S01 today list, S07 scheduling, S06 habit detail. IDs are inferred from screen contents because canvas labels say “Generating Screen...” rather than S01–S08. Group screenshot zoom is 37%. Exact copy below is limited to text legible in the supplied image.

Not visible: S02, S03, S04, S08; complete submitted prompt; functional navigation; Figma layers/variables; actual font sp and target dp. The left response indicates those four screens can be generated next. Eight-screen coverage is not yet established.

## Positive observations

- Cards show activity duration, including five-minute examples relevant to Linh.
- Home has visible labeled completion actions, a completed example and an undo affordance.
- Discovery has time chips, a search input and a reset-filter action.
- Schedule visibly offers save and cancel and mentions preserving entered values in an error example.
- Top-level bottom navigation on Home includes icon and text. This is promising for Hùng; actual target sizes still need inspection.

## Findings

| ID | Screen / evidence | User impact and severity | Heuristic / persona | Recommendation | Verification |
| --- | --- | --- | --- | --- | --- |
| UX01 | S01 header reads “Hom Nay”; other app bars read “Chi Tiet Thoi Quen”, while body text includes Vietnamese accents | Medium: inconsistent reading and professional copy, especially for Hùng | Match between system and real world; Consistency and standards; P04 | Use Vietnamese with diacritics for every app bar, button, nav item and field label; choose a Vietnamese-capable font | Close-up images of all four headers and bottom navigation; inspect editable text later |
| UX02 | S05 discovery list and S07 scheduling form use the same generic detail title as S06 | High: users cannot reliably identify current task or distinguish discovery, detail and scheduling | Visibility of system status; Recognition rather than recall; P03/P02/P04 | S05 “Khám phá thói quen”; S07 “Lịch thói quen”; reserve “Chi tiết thói quen” for S06 | Before/after same screens with clear distinct app bars and consistent Back |
| UX03 | S05 shows three activity cards, then a no-results panel in the same populated screen | High: contradictory feedback makes Linh unsure whether the five-minute filter found activities | Consistency and standards; Aesthetic and minimalist design; P03 | Separate S05 populated and S05 empty as different state examples. Empty has an explanation and one reset-filter action | Main populated screen has results without empty message; adjacent empty variant has no results |
| UX04 | S07 shows a selected reminder time, a missing-time warning and a network/save-error panel together | High: unclear whether the problem is input or connection; Huy may repeat changes unnecessarily | Error prevention; Help users recognize, diagnose and recover from errors; P02/P03 | Separate default/edit, missing-time validation, saving and save-error states. Show required-time error only when reminder is on and time is actually missing | Close-ups of state variants; retry preserves input; success updates Home and error does not |
| UX05 | S06 includes an already-added indication near the top, yet still shows a prominent add-to-today action and an edit-related action below | High: new vs existing context is unclear; potential duplicate-add or wrong task | Error prevention; Consistency and standards; P02/P03 | New S06 has one primary add action without already-added badge. Existing S06 shows existing schedule and primary “Đổi lịch”, without an enabled add action | Side-by-side new/existing variants, each with one context-appropriate primary action; prototype confirms the route |
| UX06 | S05 activity-card action combines detail and add in a label resembling “Xem chi tiết & Thêm” | Medium: user cannot predict whether one tap adds immediately or opens details | Match between system and real world; User control and freedom; P03/P04 | Use “Xem chi tiết” for navigation to S06; keep adding as a distinct explicit action on S06/S07 | Tap destination matches label; no silent addition; compare action copy before/after |

Findings UX01–UX06 are supported by the overview; finer text and interactions require close-up output or prototype verification. Severity is a design-review judgment, not measured user-test impact.

## Coverage gap, separate from UX findings

Only four distinct product screens are evidenced. The style board and state examples do not count as additional screens. Generate S02/S03/S04/S08 using the established palette and screen contract; log this as completing initial coverage, not as three UX improvement rounds.

## Proposed three distinct iteration goals

1. **I01 — Language and task recognition:** fix UX01/UX02 and the ambiguous navigation label UX06. Group also requested blue instead of green; include palette migration in the same revision but do not count color alone as a meaningful UX iteration.
2. **I02 — State consistency and recovery:** fix UX03/UX04 with separate default/populated/empty/validation/loading/error examples and unambiguous retry.
3. **I03 — Context-appropriate primary action:** fix UX05 with new/existing habit variants and safe add/edit routes.

These are recommendations until group decisions and actual after-output exist. Re-review each after-version; do not pre-mark I01/I02/I03 done.

## Accessibility and structure needing inspection

- Cannot determine font size in sp or touch target dp from a canvas screenshot at 37%.
- Cannot pass/fail actual contrast from intended token values alone; measure actual text/background colors, including opacity and selected states.
- Cannot prove Auto Layout, token binding, reusable instances or responsive behavior from this screenshot.
- Cannot prove Back, save, undo, retry, overlay or loading transitions function from static images.
- Cannot assert any under-60-second, under-30-second or three-action target has been met.

## Decision status

Group explicitly requested blue. Correct Vietnamese copy and canonical screen names follow the existing specification. Decisions and pending checks are recorded in design/design-decisions.md. No completed iteration or user-test result is inferred from this review.
