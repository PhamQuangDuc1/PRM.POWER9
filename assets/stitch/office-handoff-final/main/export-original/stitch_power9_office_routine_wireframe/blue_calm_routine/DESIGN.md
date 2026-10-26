---
name: Blue Calm Routine
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
  tertiary: '#841914'
  on-tertiary: '#ffffff'
  tertiary-container: '#a53229'
  on-tertiary-container: '#ffc6be'
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
  tertiary-fixed: '#ffdad5'
  tertiary-fixed-dim: '#ffb4aa'
  on-tertiary-fixed: '#410001'
  on-tertiary-fixed-variant: '#891d17'
  background: '#f8f9ff'
  on-background: '#031c36'
  surface-variant: '#d3e4ff'
typography:
  display:
    fontFamily: Be Vietnam Pro, Roboto, sans-serif
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline:
    fontFamily: Be Vietnam Pro, Roboto, sans-serif
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.005em
  body:
    fontFamily: Be Vietnam Pro, Roboto, sans-serif
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0em
  body-medium:
    fontFamily: Be Vietnam Pro, Roboto, sans-serif
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
    letterSpacing: 0em
  label:
    fontFamily: Be Vietnam Pro, Roboto, sans-serif
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.01em
  helper:
    fontFamily: Be Vietnam Pro, Roboto, sans-serif
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
  gutter-desktop: 1.5rem
  margin: 1rem
  margin-tablet: 1.5rem
  margin-desktop: 2.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style
The design system targets busy modern households and focused workplace routines, establishing an atmosphere of gentle discipline, predictability, and emotional calm. It eliminates visual clutter to reduce cognitive load during routine planning and daily task execution.

The aesthetic blends **Modern Corporate Clarity** with a **Supportive Humanist Touch**. Interfaces rely on generous negative space, gentle ocean-tinted backgrounds, precise structured alignments, and soft rounded contours that feel approachable rather than sterile.

## Colors
The palette uses calm, maritime-inspired blues balanced by functional neutrals for sustained visual comfort:

- **Canvas / App Background (`#F5F8FD`):** Base layer for all views; cools the screen and mitigates ocular strain.
- **Surface / Card (`#FFFFFF`):** High-clarity container fill, lifting content cleanly off the canvas.
- **Primary Action (`#1E5AA8`):** Deep oceanic blue used exclusively for primary calls-to-action, key routine highlights, and dominant focus states.
- **On-Primary (`#FFFFFF`):** Pure white text/icons ensuring WCAG AAA accessibility against the primary action token.
- **Selected State Surface (`#EAF2FC`):** Soft, low-saturation blue tint applied to active navigation items, selected routine list rows, and highlighted schedule blocks.
- **Primary Text (`#152C46`):** Deep navy neutral for titles, critical data, and high-emphasis body text.
- **Secondary / Supporting Text (`#4C627A`):** Muted slate blue for subheadings, descriptive helper copy, and routine time stamps.
- **Border / Outline (`#71839A`):** Structural boundary color with calculated opacity stops for subtle form fields and card delimiters.
- **Error (`#A7332A`):** Controlled crimson for validation feedback, overdue routines, and urgent system alerts.

## Typography
Typography is set in **Be Vietnam Pro** (with fallback to **Roboto**). The system strictly enforces a minimum readable size of 14px/20px to protect readability for all ages across mobile and desktop interfaces:

- **Display (24px / 32px, Bold):** Top-level views, screen titles, and primary dashboard summaries.
- **Headline (20px / 28px, Semi-Bold):** Card section headers, routine category headers, and modal titles.
- **Body (16px / 24px, Regular & Medium):** Routine instructions, task narratives, description lists, and dialog text.
- **Label / Nav / Helper (14px / 20px, Regular & Medium):** Form field labels, validation messages, metadata timestamps, tab bars, and navigation chips. Never drop below 14px.

## Layout & Spacing
A fluid 8pt/4pt rhythm governs layout composition across devices:

- **Mobile (< 768px):** 4-column layout with 16px (`1rem`) outer margins and gutters. Single-column stacked cards for chronological routines.
- **Tablet (768px - 1024px):** 8-column layout with 24px (`1.5rem`) margins and gutters. Side-by-side arrangement for schedule lists and preview panes.
- **Desktop (> 1024px):** 12-column layout with 40px (`2.5rem`) outer margins and 24px (`1.5rem`) gutters. Fixed primary routine navigation sidebar (280px) coupled with a fluid multi-column content area.

## Elevation & Depth
Depth is constructed through subtle tonal layering rather than aggressive drop shadows:

- **Base Layer:** Canvas background (`#F5F8FD`) provides overall ambient tone.
- **Surface Elevation (Cards & Containers):** Pure white (`#FFFFFF`) with a delicate 1px boundary (`#71839A` at 20% opacity) and an ambient, low-contrast shadow: `0 2px 8px rgba(21, 44, 70, 0.04)`.
- **Selected Elevation:** Surfaces switch to `#EAF2FC` with a stroke of `#1E5AA8` at 30% opacity, eliminating heavy drop shadows in favor of tinted contrast.
- **Overlays & Modals:** Elevated surfaces feature `0 12px 32px rgba(21, 44, 70, 0.08)` bordered by `#71839A` at 25% opacity.

## Shapes
Component rounding scales proportionally based on object area and interaction purpose:

- **Inputs & Dropdowns:** 8px (`0.5rem`) corner radius ensures crisp alignment with label baselines.
- **Buttons, Badges & Chips:** 12px (`0.75rem`) corner radius for tactile, friendly touch points.
- **Cards, Panels & Modals:** 16px (`1rem`) corner radius to contain complex routine information within smooth visual boundaries.

## Components

### Buttons
- **Primary Button:** Background `#1E5AA8`, Text `#FFFFFF`, Border-radius `12px`, Height `44px` (touch targets min `44px`), Padding `0 20px`. Hover: darken primary to `#174886`.
- **Secondary / Ghost Button:** Background transparent or `#FFFFFF`, Text `#1E5AA8`, Border `1.5px solid #1E5AA8`, Border-radius `12px`, Height `44px`. Hover: Background `#EAF2FC`.

### Input Fields
- **Container:** Background `#FFFFFF`, Height `48px`, Border `1px solid #71839A` (at 40% resting opacity), Border-radius `8px`, Padding `0 16px`.
- **States:** Focus sets border to `2px solid #1E5AA8` with zero outer glow. Error sets border to `1.5px solid #A7332A`.
- **Typography:** Value text `#152C46` (`16px/24px`), Helper/Error text (`14px/20px`).

### Cards & Panels
- **Container:** Background `#FFFFFF`, Border-radius `16px`, Padding `20px` (or `24px` on desktop), Border `1px solid rgba(113, 131, 154, 0.20)`.
- **Selected Routine Card:** Background `#EAF2FC`, Border `1.5px solid #1E5AA8`.

### Chips & Filters
- **Default State:** Background `#FFFFFF`, Border `1px solid #71839A` (30% opacity), Text `#4C627A` (`14px/20px`), Border-radius `12px`, Padding `6px 14px`.
- **Selected State:** Background `#EAF2FC`, Border `1px solid #1E5AA8`, Text `#1E5AA8` (Font-weight `500`).

### Checkboxes & Radio Buttons
- **Box / Circle:** 20px × 20px, Border `2px solid #71839A`, Radius `6px` (Checkbox) or full circular (Radio).
- **Checked State:** Background `#1E5AA8`, Border-color `#1E5AA8`, Icon `#FFFFFF`.

### Routine Lists
- Row items include an interactive minimum height of `56px`, separated by hairline dividers (`rgba(113, 131, 154, 0.15)`), supporting completed check states with strikethrough text in `#4C627A`.