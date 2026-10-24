---
name: Power9 Family Routine
colors:
  surface: '#f9faf6'
  surface-dim: '#d9dad7'
  surface-bright: '#f9faf6'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f4f0'
  surface-container: '#edeeea'
  surface-container-high: '#e7e9e5'
  surface-container-highest: '#e2e3df'
  on-surface: '#1a1c1a'
  on-surface-variant: '#404944'
  inverse-surface: '#2e312f'
  inverse-on-surface: '#f0f1ed'
  outline: '#707973'
  outline-variant: '#c0c9c2'
  surface-tint: '#316852'
  primary: '#044430'
  on-primary: '#ffffff'
  primary-container: '#245c46'
  on-primary-container: '#99d2b6'
  inverse-primary: '#99d3b7'
  secondary: '#57615c'
  on-secondary: '#ffffff'
  secondary-container: '#dbe5df'
  on-secondary-container: '#5d6762'
  tertiary: '#78100d'
  on-tertiary: '#ffffff'
  tertiary-container: '#992921'
  on-tertiary-container: '#ffb3a9'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#b5efd2'
  primary-fixed-dim: '#99d3b7'
  on-primary-fixed: '#002115'
  on-primary-fixed-variant: '#16503b'
  secondary-fixed: '#dbe5df'
  secondary-fixed-dim: '#bfc9c3'
  on-secondary-fixed: '#151d1a'
  on-secondary-fixed-variant: '#3f4945'
  tertiary-fixed: '#ffdad5'
  tertiary-fixed-dim: '#ffb4aa'
  on-tertiary-fixed: '#410001'
  on-tertiary-fixed-variant: '#891d17'
  background: '#f9faf6'
  on-background: '#1a1c1a'
  surface-variant: '#e2e3df'
typography:
  headline-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Be Vietnam Pro
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.005em
  body-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0em
  body-md:
    fontFamily: Be Vietnam Pro
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
    letterSpacing: 0em
  label-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Be Vietnam Pro
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.01em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style
The brand personality is grounded, peaceful, and quietly reliable. Built specifically to alleviate chaotic morning and evening transitions for families, the interface feels like an organized wooden kitchen table—spacious, unhurried, and functional. It prioritizes clarity over visual stimulation, eliminating competitive gamification, hyper-saturated celebration loops, and loud badges in favor of calm completion, predictable interactions, and tactile certainty.

The aesthetic blends **Modern Scandinavian Utility** with refined **Android-native pragmatism**. Surfaces are flat, natural, and matte. Visual weight is communicated strictly through structural balance, purposeful white space, and clear type contrast. Decorative illustrations, background patterns, and gradients are omitted entirely. The interface operates as an unobtrusive, empowering tool for parents and children alike.

## Colors
The color system strictly uses matte, opaque shades derived from nature to establish emotional tranquility while maintaining strict WCAG 2.1 AAA accessibility compliance.

- **Primary Action (`#245C46`):** Deep Forest Sage. Used for prominent active actions, primary interactive buttons, and affirmed state badges. Text atop this color is locked to `#FFFFFF`.
- **Background (`#F7F8F4`):** Warm Oatmeal Canvas. Replaces sterile high-glare white with an organic, gentle foundation that reduces eye strain.
- **Surface (`#FFFFFF`):** Crisp pure white. Applied to interactive cards, sheets, and dialog surfaces to establish soft tonal grouping against the oatmeal canvas.
- **Main Text / On-Background (`#173B32`):** Deep Pine Noir. High-contrast typography layer providing effortless legibility in dim or hurried morning light.
- **Secondary Text (`#52665E`):** Muted Fern Slate. For helper text, timestamps, captions, and structural guidance.
- **Selected Background (`#E8F2EC`):** Soft Mint Wash. Indicates active states, completed item fills, and filter selection backgrounds.
- **Control Outlines & Borders (`#6C8075`):** Lichen Grey. Outlines form controls, dividing rules, unselected pill borders, and structural outlines.
- **Error & Destructive (`#A7332A`):** Burnt Terracotta. Strictly paired with explicit alert icons and helper labels.

Color is never used as the sole conveyor of information: checked habits, alerts, and field validations must always pair color changes with an icon, explicit text, and border state shifts. Gradients are strictly forbidden.

## Typography
Typography is set in **Be Vietnam Pro** across all platforms, ensuring immaculate Unicode rendering for Vietnamese and multilingual family environments alongside geometric legibility on small-to-medium Android screens.

- **Scale Rationale:** The system refrains from using large display sizes. Routines must remain dense enough to fit on single screens without scrolling under duress, yet tall enough for swift glanceability.
- **Headlines:** `headline-lg` (24/32, semi-bold) leads primary views (e.g., "Morning Launch Routine"), while `headline-md` (20/28, semi-bold) structures individual routine sections and card groups.
- **Body:** `body-lg` (16/24, regular) delivers readable descriptions and routine item names; `body-md` (16/24, medium) highlights active or highlighted tasks.
- **Labels:** `label-lg` (14/20, semi-bold) powers button labels and time stamps. `label-md` (14/20, regular) governs form helper texts, micro-copy, and child member tags.

## Layout & Spacing
The layout relies on a strict 8-point spatial cadence tailored specifically for Android handheld ergonomics.

- **Screen Canvas:** Mobile screens feature an uncompromising fixed outer margin of `16px` (`margin: 1rem`) along the lateral edges. This preserves touch comfort near device bezels while maximizing actionable layout area.
- **Layout Model:** A fluid 4-column structure governs mobile screens with `16px` gutters (`gutter: 1rem`). On foldables and tablets, layout expands to an 8-column or 12-column system, anchoring habit checklists to a maximum centered container width of `640px` to protect thumb reach and scan velocity.
- **Touch Boundaries:** All clickable items (switches, checkboxes, chips, avatar toggles) have a mandated minimum target box of `48x48px`, regardless of the visual footprint of the asset itself.
- **Vertical Rhythm:** Spacing between consecutive habit rows inside a card is locked to `space-sm` (`8px`) to maintain grouped coherence. Sections and time blocks are separated by `space-lg` (`24px`).

## Elevation & Depth
This design system avoids heavy shadows, 3D skeuomorphism, and translucent blurs in favor of **Tonal Layering and Crisp Low-Contrast Outlines**.

- **Base Layer (Elevation 0):** The primary view surface `#F7F8F4`.
- **Card and Sheet Layer (Elevation 1):** Solid `#FFFFFF` surfaces sitting on `#F7F8F4`. Separation is achieved through precise tonal contrast and a subtle border stroke of `1px solid #6C8075` at 20% alpha (or full `1px solid #6C8075` for unselected interactive controls).
- **Modest Shadow Specification:** When floating elements require physical differentiation (e.g., bottom-affixed task bars or active drag-reordering cards), use a calm, highly diffused ambient shadow:
  - `box-shadow: 0 4px 16px rgba(23, 59, 50, 0.06);`
- **State Elevation:** Depressed/pressed states do not cast deeper shadows; instead, they shift their background fill to `#E8F2EC` and slightly darken their border.

## Shapes
Geometry balance is essential for family accessibility. Rounded corners soften the interface without looking childlike or overly playful.

- **Cards & Modal Containers:** Formed with a firm `16px` border radius (`rounded-lg`), establishing clear, friendly perimeters for habit clusters and family member cards.
- **Buttons & Large Interactive Elements:** Fixed at `12px` border radius. This pairs cleanly with the required `52px` standard button height, avoiding generic pill shapes while keeping edges approachable.
- **Form Fields & Inputs:** Constructed with an `8px` corner radius (`rounded-md`), presenting a structured, reliable appearance for scheduling and time entries.
- **Status Chips & Pills:** Rendered as complete capsules (`9999px` / full pill) to separate quick filters and metadata tags from interactive task cards.

## Components

### Buttons
- **Primary Action Button:** Height `52px`, border radius `12px`, background `#245C46`, text `#FFFFFF` (`label-lg`). Includes minimum horizontal padding of `24px`. Full width on mobile bottom bars.
- **Secondary Button:** Height `52px`, border radius `12px`, background `#FFFFFF`, text `#173B32`, border `1.5px solid #6C8075`.
- **Interactive Feedback:** Pressed states trigger a flat color change to `#173B32` (on primary) or `#E8F2EC` (on secondary).

### Routine Cards
- Base: `#FFFFFF` fill, `16px` radius, padding `16px`, bordered with subtle `1px solid rgba(108, 128, 117, 0.25)`.
- When all tasks within a routine card are completed, the container background transitions to `#E8F2EC` and the border hardens to `1.5px solid #245C46`. A visible checkmark badge labeled "Complete" must appear in the top-right header.

### Task List Items (Habit Rows)
- Height minimum `56px` with an internal `48x48px` tap target for the selection mechanism.
- Content layout: Task icon/avatar left, title (`body-lg`) center, custom status control right.
- Inactive state: White or transparent fill, `#173B32` text.
- Checked/Done state: Background `#E8F2EC`, title text `#52665E` with subtle strikethrough, checkmark icon inside a `#245C46` filled box.

### Checkboxes & Radio Controls
- Target area: `48x48px` bounding container; visual box `22x22px` with a `4px` radius.
- Unchecked: `#FFFFFF` fill with `2px solid #6C8075`.
- Checked: `#245C46` fill, `#FFFFFF` crisp check icon. Never indicate selection by color swatch alone.

### Input Fields & Pickers
- Height `52px`, corner radius `8px`, border `1.5px solid #6C8075`, background `#FFFFFF`, padding `0 16px`. Text is `#173B32` (`body-lg`).
- Focus state: Border changes to `2px solid #245C46`.
- Error state: Border turns to `2px solid #A7332A`, accompanied by a trailing error icon and explicit error text in `#A7332A` (`label-md`) beneath the input.

### Family Member Chips
- Height `36px`, full pill radius (`9999px`), padding `0 14px`.
- Unselected: `#FFFFFF` fill, `1px solid #6C8075`, text `#52665E`.
- Selected: `#E8F2EC` fill, `1.5px solid #245C46`, text `#173B32`, paired with a checkmark prefix icon.

### Time & Step Counter Bar
- Height `40px`, background `#FFFFFF`, border radius `8px`, border `1px solid rgba(108, 128, 117, 0.3)`. Contains progress expressed via clean numerical indicators (e.g., "3 of 5 done") rather than complex or distracting charts.