---
name: Power9 Structural Wireframe
colors:
  surface: '#faf9f9'
  surface-dim: '#dadada'
  surface-bright: '#faf9f9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f4f3f3'
  surface-container: '#eeeeee'
  surface-container-high: '#e8e8e8'
  surface-container-highest: '#e3e2e2'
  on-surface: '#1a1c1c'
  on-surface-variant: '#444748'
  inverse-surface: '#2f3131'
  inverse-on-surface: '#f1f0f0'
  outline: '#747878'
  outline-variant: '#c4c7c7'
  surface-tint: '#5f5e5e'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#1c1b1b'
  on-primary-container: '#858383'
  inverse-primary: '#c8c6c5'
  secondary: '#5e5e5e'
  on-secondary: '#ffffff'
  secondary-container: '#e3e2e2'
  on-secondary-container: '#646464'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#1d1b1a'
  on-tertiary-container: '#868381'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e5e2e1'
  primary-fixed-dim: '#c8c6c5'
  on-primary-fixed: '#1c1b1b'
  on-primary-fixed-variant: '#474646'
  secondary-fixed: '#e3e2e2'
  secondary-fixed-dim: '#c7c6c6'
  on-secondary-fixed: '#1b1c1c'
  on-secondary-fixed-variant: '#464747'
  tertiary-fixed: '#e6e1df'
  tertiary-fixed-dim: '#cac6c3'
  on-tertiary-fixed: '#1d1b1a'
  on-tertiary-fixed-variant: '#484645'
  background: '#faf9f9'
  on-background: '#1a1c1c'
  surface-variant: '#e3e2e2'
typography:
  headline-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Be Vietnam Pro
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Be Vietnam Pro
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 26px
  headline-sm:
    fontFamily: Be Vietnam Pro
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Be Vietnam Pro
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
  body-sm:
    fontFamily: Be Vietnam Pro
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.02em
  label-md:
    fontFamily: Be Vietnam Pro
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  label-sm:
    fontFamily: Be Vietnam Pro
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.04em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-sm: 0.75rem
  margin: 1rem
  margin-sm: 0.75rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system establishes an intentional low-fidelity, structural wireframing environment specifically tailored for rapid UX validation and layout prototyping on Android mobile devices. 

The aesthetic is purely functional, schematic, and deliberately stripped of brand ornamentation, decorative visuals, or chromatic distractions. By operating strictly within a disciplined monochromatic spectrum, the interface directs user and stakeholder focus entirely toward information architecture, hierarchy, user flows, and ergonomic touch targets. 

Visual principles:
- **Schematic Box-Model Architecture:** Surfaces, modules, and components prioritize clear containment lines, high-contrast outlines, and deliberate visual rhythm over soft atmospheric illusions.
- **Utilitarian Minimalism:** No shadows, no organic blur effects, no decorative illustrations or brand colors. Graphical placeholders rely exclusively on bounding boxes with neutral diagonal strikes or minimalist geometric icons.
- **Ergonomic Tactility:** Designed explicitly for mobile touch ergonomics, ensuring every interactive element strictly adheres to standard Android tap targets (minimum 48×48dp).

## Colors

The palette operates under a strict monochromatic rulebook to reinforce wireframe neutrality:

- **Primary (`#111111`):** Applied to primary actions, active toggle states, primary titles, and crucial focal elements that require unmistakable visual weight.
- **Secondary (`#767676`):** Used for non-primary control outlines, secondary descriptions, passive icons, and supporting structural metadata.
- **Neutral (`#CCCCCC`):** Dictates structural divider rules, container borders, and disabled element boundaries.
- **Canvas & Surface Tones:**
  - Base Background: Pure White (`#FFFFFF`) to mimic standard sketchboards and stark paper wireframes.
  - Card & Container Fill: `#F4F4F4` for subtle elevation containment and contrasting nested zones.
  - Interactive Inactive Fill / Secondary Surfaces: `#E5E5E5`.
  - Dark Neutral / Tertiary Text: `#4A4A4A` for secondary headings and body copy to ensure legible accessibility without competing with `#111111` key elements.

## Typography

The typography uses **Be Vietnam Pro** across all roles to maintain a clean, contemporary, and systematically legible presentation on mobile displays.

Rules:
- Standard body text strictly adheres to `16px/24px` for effortless legibility across all handheld viewing distances.
- Screen headings are constrained between `20px` and `24px` to avoid editorial bloat and prevent oversized hero text that distorts mobile layouts during flow validation.
- All functional labels enforce a minimum threshold of `14px` (`label-lg`, `label-md`) for controls and forms; the `12px` token (`label-sm`) is strictly reserved for non-critical metadata or schematic timestamps.
- Text uses only three weights: Regular (400) for body and descriptive text, Medium (500) for form inputs and sub-labels, and SemiBold/Bold (600/700) for actionable buttons and titles.

## Layout & Spacing

The layout system is built around a standard 4-column fluid mobile grid with an 8pt base grid for spacing and alignment:

- **Grid & Margins:**
  - Mobile default margins are fixed at `1rem` (16dp), providing a stable outer boundary against phone bezels.
  - Column gutters sit at `1rem` (16dp), reducing to `0.75rem` (12dp) on compact screens (<360dp width).
- **Component Spacing Scale:**
  - `space-xs` (4dp): Tight inline icon-to-label pairing.
  - `space-sm` (8dp): Internal form field padding, stacked label-to-input gap, and compact item padding.
  - `space-md` (16dp): Standard card internal padding, vertical stacking between related list items.
  - `space-lg` (24dp): Separation between major structural blocks, card decks, and form fieldsets.
  - `space-xl` (32dp): Major section division and bottom-sheet separation.
- **Ergonomics & Touch Targets:**
  - Every interactive touchpoint must preserve an invisible or visible bounding box of at least `48×48dp`.
  - When stacking interactive items vertically, preserve a minimum gap of `space-sm` (8dp) to eliminate mis-taps during user testing.

## Elevation & Depth

This design system deliberately excludes drop shadows, ambient blur radius, and multi-tier lighting models. Depth is established purely through structural layering and border contrasts:

- **Tonal Layering:**
  - Base canvas is `#FFFFFF`.
  - Level 1 Containers (Cards, list panels): Filled with `#F4F4F4` or `#FFFFFF` bounded by a 1px solid `#CCCCCC` border.
  - Level 2 Nested Containers (inner stat boxes, inner routine blocks): Filled with `#E5E5E5` or bounded by a 1px dashed/solid `#CCCCCC` rule.
- **Low-Contrast Structural Borders:**
  - Surface differentiation relies on crisp, 1px or 1.5px solid strokes (`#CCCCCC` for passive areas, `#767676` for active inputs, `#111111` for focused states).
- **Modals & Overlays:**
  - Sheet dialogs, bottom sheets, and full-screen confirmation takeovers use a solid `#FFFFFF` surface with a distinct 2px solid `#111111` outline, cast over a 40% solid neutral scrim (`#111111` at 0.4 opacity) without Gaussian blur.

## Shapes

The shape philosophy reflects a clean, architectural, and structural boxy wireframe visual.

- **Base Radius (0.25rem / 4px):** Applied to standard interactive controls, input fields, checkboxes, toggle switches, and nested cards. This slight softening prevents visual harshness while sustaining an intentional schematic wireframe look.
- **Container Radius (`rounded-lg`, 0.5rem / 8px):** Reserved for primary mobile cards, modular routine panels, bottom sheets, and modal frames.
- **Pills / Full Rounding:** Prohibited, except for round action status indicators (e.g., standard circular radio buttons or completion check circles). Standard chips and primary action buttons maintain crisp, boxy profiles.

## Components

### Buttons
- **Primary Action Button:** Full-width or inline button, solid `#111111` background, `#FFFFFF` text (`label-lg`), height 48dp, corner radius 4px.
- **Secondary / Outline Button:** `#FFFFFF` background, 1.5px border `#111111`, `#111111` text, height 48dp.
- **Ghost / Neutral Button:** Transparent background, `#4A4A4A` text, min height 48dp with 48x48dp interactive touch target.

### Cards & Routine Modules
- **Wireframe Routine Card:** Background `#F4F4F4` or `#FFFFFF`, 1px solid `#CCCCCC` outline, 8px corner radius, internal padding `16px`.
- **Card States:** Selected or active state swaps border to 2px solid `#111111`.
- **Media / Image Placeholder:** Neutral `#E5E5E5` rectangular box featuring 1px `#CCCCCC` diagonal cross-lines from corner to corner and a centered 24px schematic icon.

### Form Inputs & Text Fields
- **Text Input:** Height 48dp, background `#FFFFFF`, 1px solid `#767676` border, corner radius 4px, padding 12px 16px. Placeholder text in `#767676`. Active/focused input switches border to 2px solid `#111111`.
- **Input Labels:** `label-md` (`14px`), font weight 600, `#111111`, positioned directly above the field with a 6px gap.

### Selection Controls (Checkboxes & Radios)
- **Checkbox:** 20×20dp box with 48×48dp hit zone. Unchecked: 1.5px solid `#767676` border, `#FFFFFF` fill. Checked: solid `#111111` fill with a white 1.5px schematic checkmark.
- **Radio Button:** 20×20dp circle with 48×48dp hit zone. Unselected: 1.5px solid `#767676`. Selected: 1.5px solid `#111111` outer ring with an inner 10dp solid `#111111` concentric dot.

### Chips & Filter Tags
- **Filter Chip:** Height 36dp (with 48dp touch target envelope), 1px solid `#CCCCCC`, background `#F4F4F4`, text `#4A4A4A` (`label-md`). Selected chip: background `#111111`, text `#FFFFFF`, border `#111111`.

### Lists & Activity Trackers
- **Routine List Item:** Minimum height 56dp, padding 12px 16px, separated by a 1px solid `#E5E5E5` divider. Contains a leading 48×48dp touch target (checkbox or drag handle), central title (`body-md`) and subtitle (`body-sm`), and trailing action slot.