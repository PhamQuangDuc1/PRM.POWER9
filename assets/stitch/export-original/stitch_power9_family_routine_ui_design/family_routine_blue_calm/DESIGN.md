---
name: Family Routine Blue Calm
colors:
  surface: '#f8f9ff'
  surface-dim: '#c5dcfd'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4ff'
  on-surface: '#031c36'
  on-surface-variant: '#424751'
  inverse-surface: '#1b314c'
  inverse-on-surface: '#eaf1ff'
  outline: '#737782'
  outline-variant: '#c2c6d3'
  surface-tint: '#235eac'
  primary: '#004287'
  on-primary: '#ffffff'
  primary-container: '#1e5aa8'
  on-primary-container: '#bed4ff'
  inverse-primary: '#aac7ff'
  secondary: '#575f68'
  on-secondary: '#ffffff'
  secondary-container: '#dbe3ed'
  on-secondary-container: '#5d656e'
  tertiary: '#6e3300'
  on-tertiary: '#ffffff'
  tertiary-container: '#924600'
  on-tertiary-container: '#ffc8a7'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d6e3ff'
  primary-fixed-dim: '#aac7ff'
  on-primary-fixed: '#001b3e'
  on-primary-fixed-variant: '#00458d'
  secondary-fixed: '#dbe3ed'
  secondary-fixed-dim: '#bfc7d1'
  on-secondary-fixed: '#141c23'
  on-secondary-fixed-variant: '#404850'
  tertiary-fixed: '#ffdbc7'
  tertiary-fixed-dim: '#ffb688'
  on-tertiary-fixed: '#311300'
  on-tertiary-fixed-variant: '#733600'
  background: '#f8f9ff'
  on-background: '#031c36'
  surface-variant: '#d3e4ff'
typography:
  display:
    fontFamily: Be Vietnam Pro
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 26px
    fontWeight: '600'
    lineHeight: 34px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Be Vietnam Pro
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Be Vietnam Pro
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: -0.005em
  title-md:
    fontFamily: Be Vietnam Pro
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
  body-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Be Vietnam Pro
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Be Vietnam Pro
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Be Vietnam Pro
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 18px
  label-sm:
    fontFamily: Be Vietnam Pro
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 16px
  margin: 16px
  space-xs: 4px
  space-sm: 8px
  space-md: 12px
  space-lg: 16px
  space-xl: 24px
  space-2xl: 32px
---

## Brand & Style

This design system is tailored for structured, calm, and reassuring family coordination, routines, and daily habit tracking. Built around high accessibility, predictable interaction patterns, and cognitive clarity, the interface reduces anxiety for busy households and family members across all ages.

### Aesthetic Paradigm
- **Soft Minimalist Utility:** Clean visual structures that prioritize content readability over decorative clutter.
- **Monochromatic Accents:** Deep trust-inducing blue acts as the single decorative and functional accent; no superfluous hues, neon tones, or distracting gradients are permitted.
- **Supportive & Grounded:** Spacious card layouts with deliberate touch targets evoke dependability, safety, and operational calm.

## Colors

The palette is strictly calibrated for maximum legibility, calm focus, and accessibility. Blue serves as the sole colored accent across functional, interactive, and selected states.

### Core Swatches
- **Canvas / App Background:** `#F5F8FD` (Subtle tinted mist that avoids harsh screen glare while maintaining crisp contrast against white surfaces)
- **Surface / Card Background:** `#FFFFFF` (Pure white for raised routine cards and actionable panels)
- **Primary Action:** `#1E5AA8` (Deep classic marine blue providing authoritative contrast and clear intent)
- **Selected State Surface:** `#EAF2FC` (Gentle tint for checked routines, active tabs, and highlighted selection states)
- **Primary Text:** `#152C46` (Deep navy-slate, offering high contrast without the stark severity of pure black)
- **Secondary / Supporting Text:** `#4C627A` (Muted slate for timestamps, subheadings, metadata, and helper text)
- **Border / Outline:** `#71839A` (Balanced neutral slate for unfocused inputs and structural dividers)
- **Error / Critical Alert:** `#A7332A` (Grounded crimson for destructive actions, missed routines, and validation errors)

### Rules & Prohibitions
- Absolutely no green, mint, emerald, or teal accents anywhere in the UI. Success states must use `#1E5AA8` with dedicated iconography or neutral confirmation tones.
- No linear or radial gradients; all surfaces and fills are flat and solid.
- Touch states utilize opacity overlays or solid shade changes rather than neon/bright flashes.

## Typography

The typography is built entirely on **Be Vietnam Pro** to ensure pristine multi-language legibility, robust diacritics rendering, and warm geometric construction.

### Type Hierarchy & Usage
- **Display & Headlines (`display`, `headline-lg`, `headline-md`):** Used for routine view titles, time-block summaries, and screen headers. Tighter letter spacing retains cohesion on compact viewports.
- **Titles & Routine Labels (`headline-sm`, `title-md`):** Primary routine task names, family member headers, and card titles. Rendered in semi-bold weight (`600`) to guarantee rapid scanning.
- **Body (`body-lg`, `body-md`, `body-sm`):** Narrative routine instructions, notes, and notifications. Standard regular weight (`400`) with proportional line heights to avoid visual congestion.
- **Labels & Controls (`label-lg`, `label-md`, `label-sm`):** Interactive targets, primary button text (always white on primary actions), input labels, and time badges.

## Layout & Spacing

Layouts follow an intentional mobile-first grid structure optimized for one-handed operation and effortless vertical scanning.

### Spatial Scale
The system adheres to a strict 4-based metric scale:
- `space-xs` (`4px`): Micro padding, gaps between icon and text pairs.
- `space-sm` (`8px`): Compact list item spacing, internal badge padding, button icon gaps.
- `space-md` (`12px`): Standard internal card padding for dense views, input field horizontal inset.
- `space-lg` (`16px`): Standard canvas margins, spacing between adjacent routine cards.
- `space-xl` (`24px`): Section separators, spacing before secondary modules.
- `space-2xl` (`32px`): Major block divisions, top/bottom canvas padding.

### Grid & Ergonomics
- **Outer Canvas Margins:** `16px` fixed on mobile devices; `24px` on tablet viewports.
- **Column Gutter:** `16px` for multi-column grids on larger screens.
- **Touch Target Integrity:** Every interactive zone maintains an absolute bounding box minimum of **48x48px**, even if the visual container appears smaller.

## Elevation & Depth

Visual hierarchy is primarily achieved through **tonal differentiation and soft boundaries** rather than aggressive multi-tiered drop shadows.

### Surface Tiers
- **Tier 0 (Canvas):** `#F5F8FD` background base.
- **Tier 1 (Resting Card / Container):** `#FFFFFF` surfaces sitting on `#F5F8FD`. Cards use a soft, ambient, low-contrast shadow: `0px 2px 8px rgba(21, 44, 70, 0.04)`.
- **Tier 2 (Active / Selected Card):** Filled with `#EAF2FC` with a `1px` subtle interior stroke of `#1E5AA8`.
- **Tier 3 (Modals / Floating Bottom Sheets):** `#FFFFFF` with `0px 8px 24px rgba(21, 44, 70, 0.10)`.

### Border Depth
- Rather than heavy outlines, structural components rely on soft neutral dividers (`#71839A` at `20%` to `40%` opacity) to keep the aesthetic lightweight and calm.

## Shapes

The shape system employs deliberate, role-specific radiuses that reinforce accessibility and friendly utility:

### Radius Specifications
- **Cards & Major Containers:** `16px` (`rounded-lg`). Creates a soft, welcoming envelope for household routines and notifications.
- **Action Buttons:** `12px` fixed radius with a standardized `52px` height, providing distinct tactile affordance.
- **Inputs & Dropdowns:** `8px` fixed radius (`rounded-md`), balancing structure and gentle corners.
- **Badges & Selection Chips:** `8px` or fully circular pill forms depending on context.
- **Touch Areas:** All clickable surfaces adhere strictly to a minimum hit-box dimension of `48px x 48px`.

## Components

### Buttons
- **Primary Button:** Fixed height `52px`, radius `12px`. Background `#1E5AA8`, label color `#FFFFFF` (`label-lg`, weight `600`). Minimum width `100%` on mobile primary flows.
- **Secondary / Soft Button:** Height `52px`, radius `12px`. Background `#EAF2FC`, label color `#1E5AA8`.
- **Ghost / Tertiary Button:** Height `48px`, transparent background, text color `#1E5AA8` or `#4C627A`.

### Cards & Routine Modules
- **Routine Item Card:** Radius `16px`, background `#FFFFFF`. Padding `16px`. Title in `#152C46`, subtitle/time in `#4C627A`.
- **Completed / Selected Routine Card:** Background changes to `#EAF2FC`, left accent indicator or check icon in `#1E5AA8`. Text transitions to `#152C46` with optional muted strike-through for completed sub-tasks.

### Inputs & Form Controls
- **Text Inputs:** Height `52px`, radius `8px`. White background `#FFFFFF`, outline `1px solid #71839A`. Placeholder in `#4C627A` (50% opacity).
- **Focused State:** Outline increases to `2px solid #1E5AA8`.
- **Error State:** Outline shifts to `1.5px solid #A7332A`, with helper text below in `#A7332A` (`body-sm`).

### Selection Controls
- **Checkboxes:** `24x24px` box with `6px` radius inside a `48x48px` touch target. Unchecked: `2px solid #71839A`. Checked: filled `#1E5AA8` with a white checkmark.
- **Radio Buttons:** `24x24px` circular shape inside a `48x48px` touch target. Unchecked: `2px solid #71839A`. Checked: outer ring `#1E5AA8` with a centered `12px` solid `#1E5AA8` dot.

### Chips & Filters
- **Unselected Chip:** Background `#FFFFFF`, border `1px solid #71839A`, text `#4C627A`. Height `36px`, radius `8px`.
- **Selected Chip:** Background `#EAF2FC`, border `1px solid #1E5AA8`, text `#1E5AA8` (`label-md`).

### Progress & Time Indicators
- **Routine Progress Bar:** Track background `#EAF2FC`, fill `#1E5AA8`, height `8px`, radius `4px`.
- **Time Badges:** Background `#EAF2FC`, text `#1E5AA8`, radius `6px`, padding `4px 8px`, typography `label-sm`.