# Power9 Family Routine design brief

## Document status

This design specification is prepared before the new Stitch run. Direction: one shared app, Linh primary, three supporting hypothetical personas. AI assistance: Codex; StitchDesign guidance supports semantic design-system review. Generated UI and visual accessibility checks are still pending.

## Product and personas

Power9 helps people choose, schedule and record short everyday wellbeing habits. Primary persona P03: Linh, 36, administrative employee and parent, interrupted Android sessions, needs a short suitable activity in a five-minute break. Primary proposed UX criterion: find and add a suitable habit in under 60 seconds from Home.

Supporting personas: P01 Minh needs check-in within three actions; P02 Huy needs rescheduling under 30 seconds; P04 retired teacher Hùng needs explicit labels, readable text and completion under 30 seconds without guidance. All personas are assumed, not surveyed. Criteria are targets, not measured results.

Design one product. No persona-switching dashboard and no four separate apps.

## Scope and canonical screen contract

| ID | Screen | Purpose |
| --- | --- | --- |
| S01 | Hôm nay | Today list, duration, reminder, direct completion, discover/history entry |
| S02 | Ăn uống | Record one simple eating-related habit |
| S03 | Thư giãn | Short session with duration and explicit start/finish controls |
| S04 | Kết nối | Record one real-world activity with loved ones |
| S05 | Khám phá thói quen | Filter by time and discover short activities |
| S06 | Chi tiết thói quen | Duration, instructions, add or edit schedule |
| S07 | Lịch thói quen | Brief create/edit schedule form |
| S08 | Lịch sử và tiến độ | Completed activities, dates and simple weekly summary |

Top-level bottom navigation: Hôm nay / Ăn uống / Thư giãn / Kết nối. S05–S08 are nested, with labeled Back and preserved destination context; do not force four navigation destinations into every nested form. Screen IDs stay the same across prompt, screenshots, critique, Figma, slide and handoff.

The checklist screenshot contained a generic Onboarding/Login/Home/Search/Detail/Create Form/Notification/Profile inventory. That inventory is superseded for this implementation by S01–S08 above; it is not evidence that those generic screens were built. Update the live checklist manually to match. No authentication screens are needed for this prototype scope.

## Visual direction

A calm, practical Vietnamese wellbeing app. Warm off-white background, forest-green primary actions, clean white cards, visible whitespace. Friendly and readable rather than clinical, competitive or gamified. Avoid gradients, decorative charts, tiny uppercase labels and dense dashboard tiles. One visually dominant primary action per screen. All UI copy in Vietnamese; use “thói quen”, “phút”, “Đã hoàn thành”, “Thử lại” consistently.

## Proposed semantic tokens

These are design inputs to bind to Figma Variables/styles later, not claims of existing bindings.

| Color token | Hex | Intended use |
| --- | --- | --- |
| background | #F7F8F4 | Main canvas |
| surface | #FFFFFF | Cards and forms |
| text.primary | #173B32 | Main text |
| text.secondary | #52665E | Supporting text |
| action.primary | #245C46 | Filled primary button, selected text/icons |
| action.onPrimary | #FFFFFF | Text on primary |
| surface.selected | #E8F2EC | Selected chip/navigation background |
| border.control | #6C8075 | Visible input outlines, not body text |
| feedback.error | #A7332A | Error labels and icons on white |

Typography: Roboto or a Vietnamese-capable sans serif. Title 24/32 medium; heading 20/28 medium; body 16/24 regular; label 14/20 medium. Body minimum 14 sp, preferred 16 sp. Avoid fixed-height text containers; allow line wrapping and test longer Vietnamese labels.

Spacing scale: 4, 8, 12, 16, 24, 32 dp. Screen padding 16 dp; content/card gaps 12–16 dp. Corner radius: 8 dp inputs, 12 dp buttons, 16 dp cards. Elevation: level 0 flat; level 1 subtle 0/2/8 rgba(23,59,50,0.08); overlay level 2 0/8/24 rgba(23,59,50,0.16). Keep outline and hierarchy readable without relying on shadow.

Targets: at least 48×48 dp; primary button height 52 dp. Screen baseline 360×800 logical dp, test at 412 dp. Scroll content inside a stable shell; bottom controls must not cover it. Accommodate keyboard and text expansion.

## Preflight color calculations

Computed from proposed hex values with the WCAG relative-luminance formula in this session; rounded to two decimals. This only validates these color pairs, not rendered Stitch/Figma screens.

| Foreground / background | Ratio |
| --- | --- |
| #173B32 / #FFFFFF | 12.29:1 |
| #52665E / #FFFFFF | 6.14:1 |
| #FFFFFF / #245C46 | 7.79:1 |
| #245C46 / #E8F2EC | 6.81:1 |
| #A7332A / #FFFFFF | 6.67:1 |
| #52665E / #F7F8F4 | 5.76:1 |

Control border #6C8075 on white: 4.22:1; do not use this as normal-size body text. Verify actual output colors/opacity and states again before marking accessibility pass.

## Content and interaction rules

- Activity cards show duration in text: “Thở chậm · 5 phút”; show reminder time when scheduled.
- Home check-in uses an explicit “Hoàn thành” action; show check icon + “Đã hoàn thành” and “Hoàn tác”.
- S05 time filters: “Tất cả”, “5 phút”, “10 phút”; display selection beyond color, e.g. check icon.
- S06 has one primary CTA appropriate to context: “Thêm vào hôm nay” for new habit, “Đổi lịch” for existing habit.
- S07: selected day, optional reminder with clear on/off label, time required only when reminder is enabled. Display error next to missing time and preserve values after failed save. Avoid a multi-step wizard.
- Save feedback must be obvious and persist in the destination content, not only a disappearing toast.
- S03 is a short wellbeing break, with “Bắt đầu”, “Tạm dừng”, “Tiếp tục”, “Kết thúc”; timer behavior in prototype is illustrative, not evidence of implemented runtime.
- S04 supports offline real-world connection, not a full realtime chat product. Data is illustrative; do not fabricate live friends or clinical claims.
- S08 shows dated completion entries and a clear weekly summary. Destructive removal requires confirmation; cancellation preserves data.
- Back from forms returns to the previous context; cancellation never silently saves changes.

## States and Figma work still required

## Semantic interaction guidance

StitchDesign guidance is adapted to this Android wellbeing app: density 4/10, predictable layout variance 2/10, restrained motion 2/10. The primary persona's interrupted sessions and the supporting older persona take priority over decorative asymmetry or perpetual animation. This is a mobile task interface, so no marketing hero section is needed.

- Forest Green (#245C46) is the single decorative accent; error red is reserved for semantic feedback and always paired with a label/icon.
- Labels sit above inputs; helper/error text sits below. Selected controls have a visible indicator beyond color. Focused fields use a clear outline.
- Button pressed state uses a subtle fill/opacity change; loading prevents repeated submission and preserves the button label context.
- Use a short 120–200 ms transition for feedback when appropriate; no perpetual pulses, floating cards, typewriter text or cascade delays. Reduced-motion behavior is immediate or a simple fade. No animation may delay check-in or hide confirmation.
- Loading placeholders match the content geometry; error and empty patterns explain the next available action in Vietnamese.
- No overlapping content, neon/glow, gratuitous three-column cards, decorative percentages or generic AI marketing copy. Use real task labels and clearly illustrative activity data.

These are specifications for generation and later Figma states, not proof that interaction or reduced motion has been implemented.

Stitch should illustrate relevant default/populated, loading, empty, error and success states. State frames and dialogs do not count toward the eight screen minimum.

Later rebuild components with Auto Layout and required variants: Button, Text field, Card, Navigation, App bar, Dialog, Loading, Empty, Error. Bind the semantic tokens and use instances. Imported layers do not by themselves prove a design system.

No Flutter code, backend, login, meal recipes, social feed, medical advice, dark theme or tablet screen designs in this scope.
