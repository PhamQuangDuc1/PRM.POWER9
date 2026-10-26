---
name: Neutral Wireframe
colors:
  surface: '#f9f9f9'
  surface-dim: '#dadada'
  surface-bright: '#f9f9f9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f3'
  surface-container: '#eeeeee'
  surface-container-high: '#e8e8e8'
  surface-container-highest: '#e2e2e2'
  on-surface: '#1a1c1c'
  on-surface-variant: '#444748'
  inverse-surface: '#2f3131'
  inverse-on-surface: '#f1f1f1'
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
  tertiary-container: '#1a1c1c'
  on-tertiary-container: '#838484'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e5e2e1'
  primary-fixed-dim: '#c8c6c5'
  on-primary-fixed: '#1c1b1b'
  on-primary-fixed-variant: '#474746'
  secondary-fixed: '#e3e2e2'
  secondary-fixed-dim: '#c7c6c6'
  on-secondary-fixed: '#1b1c1c'
  on-secondary-fixed-variant: '#464747'
  tertiary-fixed: '#e2e2e2'
  tertiary-fixed-dim: '#c6c6c6'
  on-tertiary-fixed: '#1a1c1c'
  on-tertiary-fixed-variant: '#454747'
  background: '#f9f9f9'
  on-background: '#1a1c1c'
  surface-variant: '#e2e2e2'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.02em
  display-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 30px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 26px
    letterSpacing: -0.01em
  title-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
    letterSpacing: 0em
  title-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0em
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0em
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 18px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter
    fontSize: 10px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.03em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 0.75rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
---

## Brand & Style

This design system establishes a high-fidelity structural foundation built purely for low-fidelity architectural clarity on Android devices (standard base canvas: 360x800 dp). It prioritizes screen hierarchy, ergonomic usability, content grouping, and spatial validation without the distraction of brand colors, rich media, or decorative ornaments.

### Target Audience & Emotional Intent
- **Audience:** Product designers, Android developers, system architects, and stakeholders evaluating information architecture, accessibility, flow logic, and interaction choreography.
- **Tone:** Objective, utilitarian, structured, and blueprint-like. It conveys calm authority, extreme clarity, and tactile mechanical precision.

### Aesthetic Movement
The design movement is **Structural Minimalist Wireframe**:
- **Strict Monochrome Hierarchy:** Built exclusively from pure stark blacks, structural whites, and functional calibrated grays.
- **Physical Boundaries:** Relies on crisp 1px structural strokes and surface tonal changes rather than heavy drop shadows or skeuomorphic styling.
- **Android Touch Architecture:** Strictly enforces a minimum 48x48 dp physical touch target bounding box for all interactive components, adhering rigorously to Android accessibility standards.

## Colors

The system uses a strictly controlled 7-step achromatic neutral scale. Every shade fulfills a deterministic role in establishing structural hierarchy and layout logic:

- `#000000` (Stark Black): Core high-contrast text, primary active states, structural focus boundaries.
- `#171717` (Near Black / Primary): High-priority interactive labels, filled primary buttons, prominent title typography, active vector strokes.
- `#737373` (Mid-tone Gray / Secondary): Secondary supporting text, captions, placeholder copy, inactive icons, auxiliary borders.
- `#D4D4D4` (Structural Gray / Tertiary): Standard 1px component borders, disabled elements, segmented dividers, inactive control strokes.
- `#E5E5E5` (Container Surface): Tonal card fills, chip backgrounds, disabled surfaces, input field fills.
- `#F5F5F5` (Canvas Background): Underlying system application canvas, bottom sheet backgrounds, modal backdrops.
- `#FFFFFF` (Surface Elevated): Elevated card surfaces, floating bar containers, active toggles, input field backgrounds.

Color saturation is forbidden across the system. Semantic status (success, error, warning) must be communicated purely through stroke variations, textual prefixes, or dedicated structural iconography (e.g., alert triangles, circled crosses) paired with `#171717` or `#737373`.

## Typography

The typographic hierarchy relies on **Inter** to ensure maximum legibility at small display scales and uniform vertical metric alignment across standard Android renderers.

- **Legibility Rules:** Ensure strict contrasts; `#171717` or `#000000` text is mandatory on white/light gray surfaces for body copy to preserve WCAG AAA adherence.
- **Scale Restrictions:** Handheld mobile interfaces (360x800 dp) prohibit body fonts under 12px for interactive elements. 10px (`label-sm`) is strictly reserved for non-critical metadata, tags, and badge counters.
- **Styling Discipline:** Never use italics, underlines (unless indicating active hyperlinks), or multi-color weighting. Hierarchy is signaled exclusively through weight changes (400 Regular, 500 Medium, 600 Semi-Bold, 700 Bold) and strict step sizing.

## Layout & Spacing

The layout is built for standard Android portrait viewports (360 dp wide), functioning on an 8-point structural grid with a 4-point micro-grid step:
- **Base Canvas:** 360 dp width x 800 dp height.
- **Screen Margins:** Fixed 16 dp (`margin` = `1rem`) on outer left/right borders.
- **Column Grid:** 4-column fluid layout with 12 dp gutters (`gutter` = `0.75rem`).
- **Vertical Spacing Rhythm:** Strictly increments across 4 dp (`space-xs`), 8 dp (`space-sm`), 12 dp (`space-md`), 16 dp (`space-lg`), and 24 dp (`space-xl`).

### Touch Targets & Ergonomic Constraints
- Interactive elements must maintain an invisible or visible minimum boundary of 48x48 dp. Even if a visual indicator (such as an icon or checkbox) is 20x20 dp, its touch padding must expand to at least 48x48 dp.
- Action items, bottom navigation bars, and confirmation bars should anchor within the thumb-reach zone (lower 35% of the screen height).

## Elevation & Depth

This system avoids decorative drop shadows, skeuomorphism, and multi-color glow effects. Depth and hierarchy are achieved entirely through **Tonal Layering** and **Crisp Structural Strokes**:

1. **Elevation Tier 0 (Canvas Base):** Background canvas rendered in `#F5F5F5`.
2. **Elevation Tier 1 (Surface Containers):** Neutral content panels, base cards, and list groupings rendered in `#FFFFFF` with a crisp `1px solid #D4D4D4` border.
3. **Elevation Tier 2 (Floating & Fixed chrome):** Top app bars, bottom navigation sheets, and persistent footers rendered in `#FFFFFF`, distinguished by a terminating `1px solid #D4D4D4` edge border (e.g., border-top or border-bottom).
4. **Elevation Tier 3 (Modals & Overlays):** Dialog windows, context pickers, and alerts use `#FFFFFF` fill with a `1.5px solid #171717` border to assert absolute focus. Backdrops utilize a flat `#000000` overlay with 40% fixed opacity (no blur filter).

## Shapes

The geometric identity balances clean industrial utility with mobile ergonomics:
- **Base Border Radius:** 8 dp (`roundedness: 2`) across inputs, buttons, checkboxes, dialogs, and segmented items.
- **Large Surface Radius:** 16 dp (`rounded-lg`) applied to cards, bottom sheets, and elevated modal panels.
- **Extra-Large Surface Radius:** 24 dp (`rounded-xl`) reserved for top sheet headers or nested parent container frames.
- **Edge Consistency:** All structural outlines must maintain an exact 1px width (`#D4D4D4` for passive structural borders, `#171717` for active, selected, or focused borders).

## Components

### Buttons
- **Primary:** `#171717` solid fill, `#FFFFFF` text (`label-lg`), height 48 dp, corner radius 8 dp. Hover/pressed state shifts to `#000000`.
- **Secondary / Outlined:** `#FFFFFF` fill, 1px solid `#171717` border, `#171717` text (`label-lg`), height 48 dp.
- **Subtle / Ghost:** Transparent fill, no border, `#171717` text (`label-lg`), minimum touch target padded to 48x48 dp.
- **Disabled State:** `#E5E5E5` fill, `#737373` text, no visible border.

### Input Fields
- **Container:** Height 52 dp, `#FFFFFF` background, 1px solid `#D4D4D4` border, radius 8 dp, horizontal padding 12 dp.
- **Typography:** Value text `#171717` (`body-md`), placeholder text `#737373` (`body-md`).
- **Focus State:** 1.5px solid `#171717` border.
- **Helper / Error State:** Descriptive micro-copy set in `label-sm` positioned 4 dp below the field in `#737373` or `#171717` with leading icon indicator.

### Checkboxes & Radio Buttons
- **Checkbox:** 20x20 dp box with 4 dp border radius, 1.5px solid `#737373` border in neutral state, padded to 48x48 dp interactive touch target. Checked state: `#171717` fill with `#FFFFFF` 1.5px checkmark icon.
- **Radio Button:** 20x20 dp circle with 1.5px solid `#737373` border. Selected state: 1.5px solid `#171717` outer ring enclosing a 10x10 dp solid `#171717` inner circle. Padded to a 48x48 dp touch target.

### Cards & List Items
- **Card Surface:** `#FFFFFF` background, 1px solid `#D4D4D4` border, radius 16 dp, 16 dp internal padding.
- **List Item:** Height 56 dp to 72 dp depending on single/two-line hierarchy. Separated by a 1px solid `#E5E5E5` bottom hairline divider inset by 16 dp.

### Chips & Tags
- **Filter Chip:** Height 36 dp, minimum touch zone 48 dp. Unselected: `#FFFFFF` fill, 1px solid `#D4D4D4` border, `#737373` label (`label-md`). Selected: `#171717` fill, `#FFFFFF` label (`label-md`).
- **Metadata Tag:** Height 24 dp, `#E5E5E5` fill, `#171717` label (`label-sm`), 4 dp corner radius.

### Iconography & Placeholder Assets
- **Line Icons:** 24x24 dp bounding box, stroke-based with 1.5px uniform stroke thickness, rounded caps and joins, rendered in `#171717` (active) or `#737373` (inactive).
- **Image / Media Placeholders:** `#E5E5E5` container with 1px solid `#D4D4D4` border, crossed by two 1px diagonal corner-to-corner guide lines (`#D4D4D4`) and centered standard image vector glyph.