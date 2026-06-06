# DESIGN_SYSTEM.md — Memory Jar

> **Single source of truth** for the visual design, UX, branding, motion, and component language of the Memory Jar application. Implementation-ready. Any agent (or human) should be able to build a consistent, production-quality UI from this document without making additional design decisions.
>
> **Companion docs:** `AI_CONTEXT.md` (project context) · `SYSTEM_ARCHITECTURE.md` (architecture) · `FEATURE_TRACKER.md` (status). Design lives here; behavior lives there.

---

## Table of Contents
1. [Design Philosophy](#1-design-philosophy)
2. [Branding System](#2-branding-system)
3. [Color System](#3-color-system)
4. [Typography](#4-typography)
5. [Screen-by-Screen Design](#5-screen-by-screen-design)
6. [Motion & Animation](#6-motion--animation)
7. [Component Library](#7-component-library)
8. [UX Principles](#8-ux-principles)
9. [Responsive Design](#9-responsive-design)
10. [Visual Consistency Rules](#10-visual-consistency-rules)
11. [AI Implementation Guidance](#11-ai-implementation-guidance)
12. [Visual References & Inspirations](#12-visual-references--inspirations)
13. [DO NOT DO — Anti-Patterns](#13-do-not-do--anti-patterns)

---

## 1. Design Philosophy

### 1.1 The Product in One Sentence
**Memory Jar is a warm, quiet, glowing place to put down a feeling today and trust it will arrive, intact, in the right moment of someone's future.**

### 1.2 Emotional Targets
A user opening Memory Jar should feel, in order of priority:

| Rank | Emotion | How it shows up in design |
|---|---|---|
| 1 | **Tenderness** | Soft pastels, rounded geometry, slow easings, no harsh contrasts |
| 2 | **Trust** | Predictable interactions, visible confirmations, transparent delivery state |
| 3 | **Nostalgia** | Slight film grain, warm white balance, soft vignette, hand-feel typography for memories |
| 4 | **Calm** | Generous whitespace, minimal chrome, low-motion defaults |
| 5 | **Quiet delight** | Subtle micro-interactions (jar lid lifts, particle drift) that reward attention without demanding it |

### 1.3 Psychological Goals
- **Reduce emotional cost of future promises.** Writing a message to a future self or loved one feels intimidating; design must lower the activation energy (one-tap "send to me in a year" template).
- **Make the future feel reachable.** Time-distance shrinks when the receiver is a real person, a real date, and a real channel. UI must constantly surface *who, when, how*.
- **Turn waiting into anticipation, not anxiety.** A "jar" of unsent memories should feel like a treasure, not a backlog. Show progress with grace.
- **Make deletion feel okay.** Cancelling a future memory should never feel guilty. Confirmation copy is "Put this one back" not "Delete".

### 1.4 The Balance Equation
```
              ┌──────────────────────────────────────────────┐
              │   Nostalgia  ────────────  Modern clarity    │
              │   Warmth     ────────────  Crisp typography  │
              │   Softness   ────────────  Functional speed │
              │   Hand-feel  ────────────  Pixel perfection  │
              │   Wonder     ────────────  Predictability   │
              └──────────────────────────────────────────────┘
```
Lean *left* on emotion (memory creation, jar visuals, empty states). Lean *right* on utility (settings, delivery status, error states). **The two extremes should never be mixed in the same view.**

### 1.5 Core Metaphor — The Jar
The jar is the only non-negotiable visual concept. It must appear (or be implied) on:
- App icon
- Splash
- Empty state ("Your jar is empty")
- Loading state (a single glowing jar, particles inside)
- Onboarding hero

**Visual rules for the jar:**
- Short, rounded silhouette (not a tall cylinder)
- Glass body, soft inner glow
- Lid is a discrete object that *lifts* during success animations
- Particles inside (in non-reduced-motion mode) represent stored memories

---

## 2. Branding System

### 2.1 Brand Identity
- **Name:** Memory Jar
- **Tagline:** *Keep a moment. Send it later.*
- **One-word brand essence:** Tenderness
- **Logo lockup:** A small glass jar icon (rounded, glowing interior) set to the left of a wordmark. The jar is the primary mark; the wordmark is secondary.

### 2.2 Brand Personality
- Warm, but not saccharine
- Patient — never rushes the user
- Quietly confident — no exclamation marks
- A friend who remembers — never a database
- **Voice adjectives:** gentle, honest, present, unhurried

### 2.3 Voice & Tone
| Context | Voice | Example |
|---|---|---|
| Empty states | Inviting | *"Your jar is empty for now. Capture your first moment."* |
| Success | Warm confirmation | *"Sealed and waiting."* |
| Errors | Apologetic, not blaming | *"We couldn't reach them right now. We'll try again in an hour."* |
| Loading | Calm progress | *"Polishing the glass..."* (not "Loading...") |
| Reminders | Personal, not pushy | *"Tomorrow, this lands on Maya's phone."* |
| Settings | Plain, never cute | *"Quiet hours"* (not "Shhh time") |

**Grammar rules:**
- Sentence case in all UI text.
- Contractions always ("we'll", "you're").
- No emoji in product UI. (User-content is the exception — they can use them.)
- Numbers: spell out under ten in prose, digits for dates/times.
- "Jar" capitalized when referring to the product; lowercase in generic copy.

### 2.4 Logo Guidelines
- **Minimum size:** 24px jar on mobile, 32px on web
- **Clear space:** 1× the jar's diameter on all sides
- **Don't:** rotate, outline-only render, place on busy backgrounds, swap the wordmark font
- **Variants:** full lockup, jar-only (favicon, app icon), monochrome (light/dark)
- **App icon (iOS/Android):** full-bleed soft-gradient background, centered jar, no wordmark. See `3.6 Gradients`.

### 2.5 Icon Style
- **Family:** Outlined, 1.75px stroke, rounded line caps and joins
- **Grid:** 24×24 with 2px keyline padding
- **Corners:** 2px radius on internal corners; never sharper
- **Color:** `onSurface` for default, `primary` for selected/active states
- **No filled variants** in the default set; filled only for active state of a toggle
- **Don't:** mix icon families, use 3D icons, use emoji as a substitute

**Icon set baseline:** Material Symbols (Outlined) for the v1 build. Optional swap to Phosphor or Lucide later if brand drifts warmer.

### 2.6 Illustration Style
- **Soft, hand-drawn, low-saturation.** Think watercolor edges, not vector crisp.
- **Subjects:** jars, paper notes, polaroids, hands, soft light rays, leaves, simple stars
- **Palette:** always pulled from `3.1`, never introducing new hues
- **Stroke:** 1.5–2px, slight wobble (use `path` with subtle `catmullRom` curves, not perfect arcs)
- **Empty-state illustrations:** 240×240 max, centered, never full-bleed
- **Onboarding illustrations:** full-bleed top-third only, with a clear content well below

### 2.7 Motion as Brand
Motion is part of the brand, not a finishing touch. Default easings and durations are codified in `6.1` and apply everywhere. Brand-feel motion is **slow, eased, soft-springed** — never linear, never snappy.

---

## 3. Color System

### 3.1 Light Mode Palette

| Token | Hex | Role |
|---|---|---|
| `primary` | `#7C6CFF` | Brand violet. Primary CTAs, jar glow, active states |
| `primaryContainer` | `#E8E3FF` | Soft lilac background of filled chips, selected rows |
| `onPrimary` | `#FFFFFF` | Text/icons on `primary` |
| `onPrimaryContainer` | `#231A4A` | Text on `primaryContainer` |
| `secondary` | `#FF9B7A` | Warm peach. Used sparingly — time-of-day accents |
| `secondaryContainer` | `#FFE2D6` | Soft peach tint backgrounds |
| `onSecondary` | `#3A1A0E` | Text on `secondary` |
| `tertiary` | `#5BC8B4` | Mint. "Sealed" / "Saved" success accents |
| `tertiaryContainer` | `#CFF4EB` | Soft mint background for success toasts |
| `error` | `#E26464` | Warm red (not pure red — keeps the warmth) |
| `errorContainer` | `#FFE0E0` | Soft pink-red background |
| `warning` | `#E8A95B` | Amber, used for retry states |
| `success` | `#5BC8B4` | Alias of `tertiary` (semantic success) |
| `info` | `#7AB8FF` | Soft sky blue, info toasts |
| `background` | `#FBF9F7` | App background — **warm off-white, never pure white** |
| `surface` | `#FFFFFF` | Cards, sheets |
| `surfaceVariant` | `#F2EEEA` | Subtle differentiation, dividers, list separators |
| `surfaceTint` | `#7C6CFF` @ 6% | Elevation tint for cards |
| `outline` | `#D8D2CC` | Borders, hairlines |
| `outlineVariant` | `#EAE5E0` | Subtle dividers |
| `onSurface` | `#1F1B2E` | Default body text |
| `onSurfaceVariant` | `#5C5669` | Secondary text, captions |
| `onBackground` | `#1F1B2E` | Text on `background` |
| `scrim` | `#000000` @ 32% | Modal scrim |
| `inverseSurface` | `#2A2640` | Snackbars, tooltips |
| `inverseOnSurface` | `#F5F0FF` | Text on `inverseSurface` |

### 3.2 Dark Mode Palette

| Token | Hex | Role |
|---|---|---|
| `primary` | `#A89BFF` | Lifted violet for dark |
| `primaryContainer` | `#3B2F7A` | Deeper violet container |
| `onPrimary` | `#1A1240` | |
| `onPrimaryContainer` | `#E8E3FF` | |
| `secondary` | `#FFB59B` | |
| `secondaryContainer` | `#5A2A1B` | |
| `tertiary` | `#7CDCC8` | |
| `tertiaryContainer` | `#0F3B33` | |
| `error` | `#FF8A8A` | |
| `errorContainer` | `#5A1F1F` | |
| `background` | `#15131C` | **Warm near-black, never pure black** |
| `surface` | `#1D1A26` | |
| `surfaceVariant` | `#2A2638` | |
| `outline` | `#3F3A4F` | |
| `outlineVariant` | `#2F2A3D` | |
| `onSurface` | `#EDEAF5` | |
| `onSurfaceVariant` | `#B4ADC4` | |
| `scrim` | `#000000` @ 56% | |

### 3.3 Semantic Tokens (use these in code, not raw hex)
- `surface`, `surfaceContainer`, `surfaceContainerHigh`, `surfaceContainerHighest` — Material 3 elevation surfaces.
- `textPrimary`, `textSecondary`, `textMuted`, `textDisabled` — derived from `onSurface` / `onSurfaceVariant` with opacity stops.
- `accent.glow` (the jar's inner glow) = `primary` at 35% opacity, blurred 24px.
- `accent.spark` (particles) = `primary` mixed with `tertiary` 50/50, animated.

### 3.4 Gradients (brand-defining)

| Gradient | Definition | Used on |
|---|---|---|
| **Aurora** | `linear-gradient(135deg, #7C6CFF 0%, #5BC8B4 50%, #FF9B7A 100%)` | Splash, jar glow, hero illustrations |
| **Soft Dawn** | `linear-gradient(180deg, #FBF9F7 0%, #F2E9FF 100%)` | Home background |
| **Quiet Night** | `linear-gradient(180deg, #15131C 0%, #1F1B33 100%)` | Dark home background |
| **Memory Beam** | `radial-gradient(circle at 50% 0%, #7C6CFF33 0%, transparent 60%)` | App-bar under-lights |

**Rules:**
- Gradients are *atmospheric*. Never use them on text or small UI controls.
- Maximum 2-3 stops. No rainbow.
- Always layered behind a `surface` or a glass effect — never naked on the page.

### 3.5 Accessibility
- **WCAG target:** AA across the board; AAA for body text on `background`.
- **Body text contrast:** `onSurface` on `background` ≥ 7.0:1 (light = 14.8:1, dark = 15.2:1).
- **Primary text on primary:** use `onPrimary` (`#FFFFFF`), not `onPrimaryContainer`.
- **Don't combine `error` with `success` adjacent** — color-blind confusion.
- **Status indicators** must also use shape/icon (`✓`, `!`, `↻`), not color alone.
- **Glass surfaces:** maintain ≥ 4.5:1 text contrast on the *effective* composite. Test against worst-case background.
- **Reduced motion:** `prefers-reduced-motion: reduce` disables particles, jar glow pulse, and any continuous animation. Never disable confirmations of state — those must persist.

### 3.6 Do / Don't

| ✅ Do | ❌ Don't |
|---|---|
| Use `surfaceContainer` for cards | Use pure `#FFFFFF` over gradients |
| Use `outlineVariant` for hairlines | Use 1px black/dark borders |
| Reserve `secondary` for accents | Tint the whole app peach |
| Use `tertiary` for success | Use pure green `#00C853` |
| Test in both modes | Assume light-only |

---

## 4. Typography

### 4.1 Type Families
- **Display & Headings:** **Fraunces** (serif, optical sizes, slight warmth; supports the "memory/letter" feel)
- **Body & UI:** **Inter** (neutral, high legibility, excellent at small sizes)
- **Mono (timestamps, counts):** **JetBrains Mono** (optional, used in the delivery-debug panel only)
- **Hand-feel accent (memory previews only):** **Caveat** or **Reenie Beanie** for short quoted excerpts — never for body, never for actions

If a font fetch fails, the fallback stack is:
- Display: `Georgia, 'Times New Roman', serif`
- Body: `system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif`

### 4.2 Scale (Material 3, tuned for warmth)

| Token | Size / Line | Weight | Letter spacing | Use |
|---|---|---|---|---|
| `displayLarge` | 57 / 64 | 400 | -0.5 | Splash only |
| `displayMedium` | 45 / 52 | 400 | -0.25 | Hero headings (e.g. onboarding) |
| `displaySmall` | 36 / 44 | 500 | 0 | Jar empty state |
| `headlineLarge` | 32 / 40 | 600 | -0.25 | Screen titles |
| `headlineMedium` | 28 / 36 | 600 | 0 | Section headings |
| `headlineSmall` | 24 / 32 | 600 | 0 | Card titles |
| `titleLarge` | 22 / 28 | 600 | 0 | App-bar titles, list headers |
| `titleMedium` | 16 / 24 | 600 | 0.15 | Card titles (compact) |
| `titleSmall` | 14 / 20 | 600 | 0.1 | Section labels, chips |
| `bodyLarge` | 16 / 24 | 400 | 0.5 | Default body |
| `bodyMedium` | 14 / 20 | 400 | 0.25 | Secondary body, list subtitles |
| `bodySmall` | 12 / 16 | 400 | 0.4 | Captions, timestamps |
| `labelLarge` | 14 / 20 | 600 | 0.1 | Button labels |
| `labelMedium` | 12 / 16 | 600 | 0.5 | Tab labels, form labels |
| `labelSmall` | 11 / 16 | 600 | 0.5 | All-caps tiny labels (overlines) |

### 4.3 Hierarchy Rules
- **Max 2 type families per screen.** Default: Fraunces (display) + Inter (everything else). The hand-feel font is *only* allowed inside `Memory` content bodies the user created.
- **Display sizes only on the top-most heading of a screen.** No nested displays.
- **One `headlineLarge` per screen.** Subsequent headings step down.
- **Labels are always `letter-spacing > 0` and `weight ≥ 600`.** Body is always `weight ≤ 500`.
- **Numbers in lists** are `titleMedium` 600, never italic.

### 4.4 Spacing Rules
- Line height ≥ 1.4× font size for body. Headings can drop to 1.2×.
- Paragraph spacing = 1.5× line height.
- Never use `TextField` with less than 16px font on iOS (zoom prevention).
- Long-form memory content uses `bodyLarge` with 1.6 line height.

### 4.5 Readability
- Maximum line length: **64 characters** for prose, **36 characters** for emphasized quotes.
- Minimum tap target: **48×48 dp** (Material guideline; matches our 1-handed-usage rule).
- Never center-align paragraphs >2 lines.
- Avoid `letter-spacing: 0` on body >14px (looks cramped). Always ≥ 0.1.

---

## 5. Screen-by-Screen Design

> Each section specifies: layout, components, user flow, animations, hierarchy, and the three states (empty / loading / error). Common to all screens: top safe-area padding, no status-bar overlay over content unless explicitly designed (see splash).

### 5.1 Splash Screen
- **Layout:** Full-bleed `Aurora` gradient. Centered jar (~40% screen height). Below the jar: wordmark in `displayMedium` Fraunces white at 90% opacity. Tagline in `bodyMedium` Inter white at 70% opacity.
- **Components:** Jar widget (SVG/Flutter `CustomPainter`), wordmark, tagline, version footer (`labelSmall` 60% white, e.g. "v1.0.0").
- **User flow:** Tap-to-skip disabled. Boot sequence only. Auto-routes to Home (authed) or Onboarding/Auth.
- **Animations:**
  - 0–400ms: jar scales from 0.85 → 1.0 with `Curves.easeOutCubic`
  - 400–800ms: wordmark fades in (opacity 0 → 1)
  - 800ms+: tagline fades in
  - On resolve: jar lid lifts 8dp over 300ms, gradient softens, transition to next screen via `shared-element` jar morph
- **Empty/Loading/Error:** N/A; this *is* the loading screen.
- **Accessibility:** Reduced-motion mode skips the lift animation; the fade is kept.

### 5.2 Login Screen
- **Layout:** `Soft Dawn` background. Vertical stack, max-width 480dp, centered.
  - Top: small jar mark (80dp) at 24dp top margin
  - Headline: "Welcome back" (`headlineLarge`)
  - Sub: "Your jar has been waiting." (`bodyLarge onSurfaceVariant`)
  - Form: email, password (with show/hide)
  - Primary button: "Open the jar"
  - Secondary text-button: "New here? Create an account"
- **Components:** `MemoryTextField` (see 7.4), `PrimaryButton`, `TextButton`, link row.
- **User flow:** Email + password → on success, route to Home. On fail, inline `errorContainer` banner above the form with friendly copy.
- **Animations:** Form fields stagger-fade in 80ms apart on first paint. Button has the `primaryButton` press feedback (see 7.1).
- **Visual hierarchy:** Single column; jar → headline → form → CTA → secondary.
- **Empty state:** N/A.
- **Loading state:** Button shows `tertiaryContainer` background, inline spinner replaces label ("Opening...").
- **Error state:** Inline banner, fields highlight `error` border, the *first* invalid field gets keyboard focus.

### 5.3 Registration Screen
- **Layout:** Same shell as Login.
- **Headline:** "Start a jar"
- **Sub:** "Keep moments for yourself, or send them to people you love."
- **Form:** email, password, confirm password, optional name.
- **Microcopy under password field:** "At least 8 characters. No expiry dates." (lowers intimidation)
- **Primary button:** "Seal my first memory"
- **Animations:** Same stagger.
- **Empty / Loading / Error:** Same as Login.
- **Post-success flow:** First-time users are routed to Onboarding (a 3-step carousel), not directly to Home.

### 5.4 Onboarding (3 steps — referenced from Login/Registration)
- **Step 1 — "Keep a moment"** Hero illustration (hands holding a small jar), headline, body.
- **Step 2 — "Pick a date"** Illustration of a calendar with a future date, headline, body.
- **Step 3 — "We'll deliver it"** Illustration of a paper plane / phone, headline, body, "Got it" primary button.
- **Skip** as a top-right text button. Progress dots at the bottom (1/3, 2/3, 3/3).
- **Animations:** Swipe between steps uses `PageView` with `Curves.easeOutCubic`, illustration scales 1.0→0.95 on swipe, next illustration scales 0.95→1.0.

### 5.5 Home Dashboard (Memory Jar)
- **Layout:**
  - Status-bar-friendly top area: `Memory Beam` gradient, fading down.
  - App bar: title "Memory Jar" in `titleLarge` Fraunces, transparent, no shadow.
  - Hero strip: "Your jar" with the jar widget (small, glowing) + counter "12 sealed · 3 opening this month".
  - Filter chips row: "All · Sealed · Opening soon · Delivered". Horizontal scroll.
  - Memory list: vertical `ListView` of `MemoryCard`s, grouped by `opening date` with sticky date headers ("This week", "Next month", "Next year").
  - FAB bottom-right: extended FAB "+ New memory".
- **Components:** `MemoryCard` (floating, glass), `FilterChip`, sticky `SectionHeader`, `ExtendedFAB`.
- **User flow:** Tap card → detail. Long-press card → quick actions (edit date, cancel). Pull-to-refresh.
- **Animations:**
  - Cards stagger in on first paint (60ms each, max 10 then stop).
  - On scroll, cards lift subtly via parallax (1.0 → 1.02 scale at top of viewport).
  - Pull-to-refresh shows a glowing jar filling up.
- **Hierarchy:** Hero strip → filters → list. FAB is persistent but never covers content (16dp margin).
- **Empty state:** Centered large jar (40% width), `displaySmall` "Your jar is empty", `bodyLarge` "Capture a feeling. Set a date. We'll hold it for you.", primary CTA "Capture your first moment".
- **Loading state:** Skeleton cards (rounded rectangles, `surfaceVariant`, subtle shimmer).
- **Error state:** Inline banner at top "We couldn't load your jar. [Try again]". Existing cached list stays visible.

### 5.6 Memory Creation Screen
- **Layout:** Single scrollable form, max-width 600dp, centered on tablets.
  - Top bar: back arrow, "Capture Memory" title (centered), "Save" text button (right).
  - **Section 1 — The message** (`SectionHeader` "What's on your mind?")
    - Large text area (`bodyLarge`, 8 visible lines, expands). Placeholder: "Write something to your future self..."
  - **Section 2 — Type chips** (text / voice / photo / video). Selected chip is `primaryContainer`.
  - **Section 3 — Recipient** (`SectionHeader` "Send to")
    - Choice chips: "Myself" / "Someone else" / "The world (public, future)".
    - Conditional: contact picker (phone, email) for "Someone else".
  - **Section 4 — When** (`SectionHeader` "Open on")
    - Date picker (large, tappable tile with `displaySmall` date, `bodyMedium` "Tap to change").
    - Time picker (secondary tile).
    - Quick presets row: "1 week", "1 month", "6 months", "1 year", "Birthday next year". (Implemented in Phase 3+)
  - **Section 5 — Channel** (`SectionHeader` "How should it arrive?")
    - Channel cards (icon + name + small sub): WhatsApp, Phone call, SMS, Email. Multi-select. Disabled state for channels requiring media (e.g. Phone call disabled until voice note is attached).
  - **Section 6 — Optional: photo, voice note, video.** (Phase 3)
- **Components:** `MemoryTextField`, `SectionHeader`, `ChoiceChip`, `ChannelCard`, `DateTile`, `VoiceRecorder` (5.9), `MediaPicker`.
- **User flow:** Compose → choose recipient → pick date → pick channel → tap Save → confirmation sheet.
- **Animations:**
  - Section headers fade-in as they enter viewport.
  - Channel cards animate `primaryContainer` fill with a soft 200ms ease.
  - On save: jar lid lifts at top of screen, jar "swallows" the form (shared element transition to confirmation).
- **Hierarchy:** Message (most important, largest) → recipient → when → channel → media.
- **Empty state:** N/A (the form is always available).
- **Loading state:** Save button shows spinner + "Sealing...".
- **Error state:** Inline banner above Save; field-level errors on the offending input. Tapping an error scrolls to the field.

### 5.7 Memory Timeline
- **Layout:** Vertical timeline on a centered rail (3dp wide, `outlineVariant`).
  - Months/years as larger sticky headers.
  - Each memory: a glass card on the rail's right (or alternating sides on tablet/web wider than 720dp).
  - Color of the rail segment between two cards = `primary` faded.
- **Components:** `TimelineCard`, `TimelineNode` (small jar at the rail intersection), sticky month headers.
- **User flow:** Horizontal swipe changes granularity (Day / Month / Year). Tap card → detail.
- **Animations:** Cards stagger-fade 80ms apart. Pinch-to-zoom on the rail scales the time-scale smoothly.
- **Hierarchy:** Time (left axis) is primary; memory content is secondary to the timeline.
- **Empty state:** Same as Home empty state but with the timeline visual.
- **Loading state:** Skeleton rail with shimmering nodes.
- **Error state:** Banner at top, cached timeline visible.

### 5.8 Memory Detail Screen
- **Layout:** Top: hero block with the memory's type icon in a glowing circle, the `type` name, and a `displayMedium` Fraunces title. Below: full content (text / audio player / image / video). Below: metadata card (recipient, channels, delivery date). Bottom: action bar — Edit, Send now, Cancel.
- **Components:** `HeroHeader`, `ContentBlock` (switched by type), `MetadataCard`, `ActionBar` (sticky bottom).
- **User flow:** View → play audio → action. "Send now" requires confirmation sheet. "Cancel" requires soft confirmation ("Put this one back?").
- **Animations:** Hero scales in from 0.95 → 1.0. Content fades in 150ms after hero. Audio player slides up from bottom on play.
- **Hierarchy:** Title → content → metadata → actions.
- **Empty state:** N/A.
- **Loading state:** Skeleton hero + content.
- **Error state:** Banner "Couldn't load this memory. [Try again]".

### 5.9 Voice Recording Screen
- **Layout:** Full-bleed `surface` background with a soft radial gradient at the top.
  - Top: "Voice note" title, close (×) button.
  - Center: large circular recording control (96dp) showing a glowing ring around a microphone icon.
  - Below: time counter (mono font, `displaySmall`).
  - Below: waveform (rolling, 60fps, single-line, `primary` on `outlineVariant`).
  - Below: bottom action row: "Cancel" (text) and "Use this" (primary, disabled until ≥1s recorded).
- **Components:** `RecorderButton` (with `primary` glow when active), `Waveform`, `Timer`.
- **User flow:** Tap to start → speak → tap to stop → preview → "Use this" attaches the audio to the in-progress memory. Cancel discards.
- **Animations:**
  - Recording: outer ring pulses (scale 1.0 ↔ 1.05, 1.4s ease-in-out, infinite).
  - Waveform updates in real time with a 30ms smoothing.
  - On stop: ring settles with a soft spring (`Curves.elasticOut` at low amplitude).
  - Reduced-motion: ring stays static; waveform still updates.
- **Hierarchy:** Recorder button is the focal point. Everything else is support.
- **Empty / Loading / Error:**
  - Mic permission denied: full-screen "We need your microphone to capture this. [Open settings]"
  - Recording error: toast "Couldn't save that. [Try again]"

### 5.10 WhatsApp Reminder Interface
> This is the *delivery* view — shown as a preview of how the memory will arrive on WhatsApp.
- **Layout:** A phone-shaped mockup centered on a soft gradient background. Inside the mockup, a WhatsApp-style chat bubble (rounded, mint for outgoing, with the jar mark + "Memory Jar" header). The bubble contains the memory's text or media.
- **Components:** `PhoneFrame`, `ChatBubble` (custom — not WhatsApp-branded; uses our `tertiaryContainer` for the bubble).
- **User flow:** Preview-only. No interaction beyond close.
- **Animations:** Bubble types in letter-by-letter at 30ms/char (skippable tap), then sits. Media (if any) appears with a 200ms fade after the text completes.
- **Hierarchy:** Preview is everything — full attention.
- **Empty / Loading / Error:** Loader skeleton bubble while generating preview.

### 5.11 Call Reminder Interface
- **Layout:** Phone mockup. Incoming-call style screen: top "Memory Jar", big "Listen to your memory" copy, two large circular buttons: decline (gray) and accept (green — `tertiary`). When the user taps accept (in preview), a player bar slides up showing the audio waveform and a play/pause.
- **Components:** `PhoneFrame`, `CallButtons`, `AudioPlayer`.
- **Animations:** Pulsing ring around accept button (1.0 → 1.15, 1.6s ease-in-out infinite). On accept, ring expands into the player area.
- **Hierarchy:** Accept button is the focal point.

### 5.12 Settings Screen
- **Layout:** Grouped `ListView` with `surface` cards separated by 16dp.
  - **Account** group: Profile, Email, Phone
  - **Delivery** group: Default channels, Quiet hours, Retry behavior
  - **Appearance** group: Theme (System / Light / Dark), Reduced motion, Text size
  - **Privacy** group: Data, Export, Delete account
  - **About** group: Version, Open source, Help, Sign out (destructive, last)
- **Components:** `SettingsGroup`, `SettingsTile` (trailing widget: switch, chevron, value).
- **User flow:** Tap → push detail. Switch toggles inline.
- **Animations:** Switches use `Curves.easeOut`. Section headers fade.
- **Empty / Loading / Error:**
  - Loading: skeleton tiles
  - Error: banner with retry
- **Destructive actions** (Delete account, Sign out) require a confirmation dialog with red "Confirm" button. Use the full dialog component (7.6), not a bottom sheet, for gravity.

### 5.13 Profile Screen
- **Layout:** Hero with avatar (96dp, soft `primaryContainer` background, initials in `displaySmall`), name, email/phone. Below: stats card ("3 memories sent this year", "12 still waiting"). Below: list of public/shared memories (Phase 5+).
- **Components:** `Avatar`, `StatsCard`, `List`.
- **User flow:** Tap avatar → change photo (Phase 3). Tap "Edit profile" → form sheet.
- **Animations:** Avatar pulses gently on first paint (1.0 → 1.04 → 1.0) — once only.

### 5.14 Notification Center
- **Layout:** Grouped list, today / this week / earlier. Each item: small jar-node icon (16dp) + sender/recipient + content preview + relative time. Tap → memory detail. Swipe left → "Mute", "Delete".
- **Components:** `NotificationItem`, `SwipeToAction`.
- **User flow:** Tap → detail. Swipe → quick action with snackbar "Undo" 4s.
- **Animations:** New items slide in from top with a 200ms ease. Swipe uses `Curves.easeInOut` with 40% haptic at the action threshold.
- **Empty state:** Centered soft jar, `headlineSmall` "All quiet here", `bodyMedium` "We'll only ping you when a memory opens."
- **Loading / Error:** Skeleton rows / inline banner.

### 5.15 Common States (apply to all screens)

| State | Visual | Behavior |
|---|---|---|
| **Initial loading** | Skeleton matching the screen's content shape, `surfaceVariant` with a left-to-right shimmer at 1.5s period | No CTA visible until first data |
| **Pull to refresh** | Custom: jar fills with `primary` liquid as user pulls | Release at threshold triggers refresh |
| **Empty** | Centered illustration + headline + sub + primary CTA | Always a path forward, never a dead end |
| **Error (recoverable)** | Inline banner at top, `errorContainer` background, dismissible | First field auto-focuses for inline errors |
| **Error (fatal)** | Full-screen error illustration, "Something went sideways. [Try again]" | Retry button at the bottom |
| **Offline** | Persistent banner "You're offline. Memories will be sealed and sent when you're back." | Read-only mode for content; write actions queue |

---

## 6. Motion & Animation

### 6.1 Foundational Tokens
- **Durations:** `instant` 0ms · `fast` 120ms · `normal` 240ms · `slow` 400ms · `deliberate` 600ms · `cinematic` 1000ms
- **Easings:**
  - `standard` = `Curves.easeInOutCubic`
  - `decelerate` = `Curves.easeOutCubic` (entrances)
  - `accelerate` = `Curves.easeInCubic` (exits)
  - `emphasized` = `Curves.easeInOutCubicEmphasized` (Material 3) — for hero/state changes
  - `spring` = `SpringDescription(mass: 1, stiffness: 180, damping: 22)` for tactile elements
- **Reduced motion:** all easings swap to `Curves.linear`, all durations halved, all continuous animations stop. State transitions still play (just faster and less curvy).

### 6.2 Page Transitions
- **Default push (right-to-left on iOS, fade-through on Android via Material):** duration `normal`, easing `standard`.
- **Modal sheet:** slides up from bottom, `slow`, `decelerate`. Backdrop fades in 0 → 32% black over `normal`.
- **Hero transitions:** between memory cards and detail — `slow`, `emphasized`. The card scales to the detail's hero, content fades in.
- **Tab switches:** cross-fade, `fast`. No slide (slides feel like they're "leaving"; cross-fade feels like presence).

### 6.3 Button Interactions
- **Press:** scale 1.0 → 0.97 over 80ms, `accelerate`. Release: scale back via `spring` (mass 1, stiffness 240, damping 18).
- **Haptic:** light impact on press for primary buttons only.
- **Loading state:** label fades out (80ms), spinner fades in (120ms). Reversed on success.
- **Success state:** button bg transitions to `tertiaryContainer`, label to "Sealed ✓", holds 1.2s, then routes.

### 6.4 Card Interactions
- **Resting:** 1.0 scale, `surface` background, 1dp shadow.
- **Hover (web/desktop):** scale 1.02, shadow 4dp, `surfaceContainer` background, 200ms.
- **Press:** scale 0.99, shadow 0dp, 80ms. Release: spring back.
- **Long-press:** slight rotation (±1.5°) with a 1.0→1.04 scale "lift" hint.
- **Dismiss (swipe):** 240ms `accelerate` out + opacity to 0.

### 6.5 Timeline Animations
- **Card entry:** stagger 60ms, fade + slide-from-bottom 12dp, `normal`, `decelerate`.
- **Rail draw:** on first load, the rail "draws" from top to bottom over `cinematic`, then nodes pop in (`spring`).
- **Pinch-to-zoom:** smooth scale, no snapping. Use `Curves.linear` during gesture, `emphasized` on release to nearest snap point.

### 6.6 Notification Animations
- **Toasts:** slide up from bottom 16dp, fade in over `normal`, hold 4s, slide down over `fast`. Swipe to dismiss.
- **In-app banners:** slide down from top, `decelerate`. Auto-dismiss after 6s. Tap to act.
- **Notification icon (jar mark):** subtle wobble (rotation ±5°) at 800ms ease-in-out, infinite, *only* when a new notification arrives. Reduced-motion: single fade.

### 6.7 Voice Recording
- **Ring pulse:** 1.4s ease-in-out, infinite, scale 1.0 ↔ 1.05, opacity 0.6 ↔ 0.0. Reduced-motion: disabled.
- **Waveform:** real-time, no easing — it must feel live.
- **Stop transition:** ring springs to rest, 600ms, low-amplitude elastic.

### 6.8 Micro-interactions
- **Toggle switch:** thumb travels in 200ms `emphasized`, color transitions in 240ms `standard`.
- **Checkbox:** 120ms fill, then 160ms check stroke draw.
- **Chips:** 120ms `standard` for state, slight scale (1.0 → 1.04) on press.
- **Text field focus:** label rises and shrinks (200ms `decelerate`), border thickness 1 → 2dp, color `outline` → `primary`.
- **Empty→first item:** when the user creates their first memory, the empty illustration morphs (400ms `emphasized`) into a single small memory card before the list rebuilds. Pure delight.

### 6.9 Don'ts in Motion
- ❌ Linear easings on anything user-initiated.
- ❌ Bouncy springs on text/structural elements (only on tactile, hand-held affordances).
- ❌ Animations > 600ms unless the action is genuinely cinematic (splash, hero).
- ❌ Animations that block input for > 100ms.
- ❌ Confetti, fireworks, or any "achievement-unlocked" pattern — brand voice forbids it.

---

## 7. Component Library

> All components are stateless where possible. They accept data + callbacks; behavior lives in screens or controllers. Files live under `lib/ui/` (see `11.4`).

### 7.1 Buttons

**PrimaryButton**
- Height: 56dp. Horizontal padding: 24dp. Border radius: 28dp (fully rounded).
- Background: `primary`. Text: `onPrimary`, `labelLarge`.
- States: default, hover (1.02 scale, 4dp shadow), pressed (0.97 scale), loading (spinner replaces label), disabled (38% opacity, no shadow).
- Variants: `filled`, `tonal` (uses `secondaryContainer`), `outlined` (1.5dp `primary` border, transparent bg), `text` (no bg, `primary` text).
- Icon support: leading icon, 18dp, 8dp gap.
- Full-width option via `isFullWidth: true`.

**IconButton**
- 48×48dp tap target. Visual size 40dp. `surface` circle on hover.
- Variants: `standard`, `filled` (for FAB-adjacent actions), `tonal`.

**ExtendedFAB**
- 56dp height, 16dp horizontal padding, fully rounded. Leading icon + label.
- Used for the primary screen action ("New memory"). Hides scroll-down, shows on scroll-up with a 240ms `emphasized` slide+fade.

### 7.2 Cards

**MemoryCard** (the heart of the app)
- Layout: glass surface (`surface` with 8% white overlay in light, 12% in dark) + 1dp border `outlineVariant` + 8dp corner radius + 4dp shadow.
- Padding: 16dp.
- Content: top row (type icon 20dp + relative date `bodySmall` onSurfaceVariant + status dot 8dp), title (`titleMedium`), 2-line content preview (`bodyMedium` clamped), bottom row (recipient chip + channel icons 16dp).
- Hover/focus: subtle 1.02 scale, shadow → 6dp, border → `primary` at 30% opacity.
- States: `sealed` (default), `openingSoon` (subtle pulse on the status dot), `delivered` (status dot `tertiary`), `failed` (status dot `error`, optional `!` icon).

**ChannelCard** (in the creation form)
- 72dp height. Leading icon 24dp. Title `titleSmall`. Subtitle `bodySmall`. Trailing checkbox.
- Selected: `primaryContainer` background, `primary` icon, `onPrimaryContainer` text.
- Disabled: 38% opacity, no interaction.

**StatsCard**
- 88dp height. 16dp padding. Title `titleMedium`, big number `displaySmall`, sub `bodySmall` onSurfaceVariant.

**MetadataCard**
- Standard `surface` card. Key-value rows separated by `outlineVariant` hairlines.

### 7.3 Forms

**MemoryTextField**
- 56dp height, 16dp horizontal padding, 12dp corner radius.
- Border: 1dp `outline` resting, 2dp `primary` focused, 2dp `error` invalid.
- Label: floats on focus with 200ms `decelerate` rise + scale.
- Helper text: `bodySmall` below field.
- Variants: `outlined`, `filled` (`surfaceVariant` bg), `plain` (no border, used in sheets).
- Multiline variant: 8-line default, expands to viewport. `bodyLarge`.

**MemoryChoiceChips** (`ChoiceChip`)
- 32dp height, 12dp horizontal padding, 16dp corner radius.
- Default: 1dp `outline` border, transparent bg, `onSurfaceVariant` text.
- Selected: `primaryContainer` bg, `onPrimaryContainer` text, no border.
- Icon support: 18dp leading.

**DateTile** (in creation form)
- 72dp height, full width, `surfaceVariant` bg, 12dp radius. Title `bodySmall` "Opens on", date `titleMedium` (Fraunces).

**TimeTile**
- Same shape as DateTile, with time in `titleMedium` and AM/PM in `bodySmall`.

### 7.4 Input Fields
- See `MemoryTextField` above.
- Specialized: **PhoneInput** (country code prefix + validation), **EmailInput** (lowercase transform on blur).

### 7.5 Dialogs
- **AlertDialog** (Material 3 default, customized)
  - 24dp padding, 28dp corner radius.
  - Title: `headlineSmall`. Body: `bodyMedium`. Actions: right-aligned `TextButton`s.
- **ConfirmDialog** (destructive)
  - Title uses `error` color, primary action is `error` filled.
  - Copy: "Are you sure?" → "Yes, cancel it" / "No, keep it" (verb + object).

### 7.6 Bottom Sheets
- **ModalBottomSheet**
  - Top corners 28dp. Drag handle 4dp×32dp pill at top, `outlineVariant`.
  - Drag-to-dismiss with 200ms `accelerate`. Snap points via `DraggableScrollableSheet` for the recorder.
  - Max height = 90% of viewport.

### 7.7 Navigation
- **Bottom Navigation Bar** (3 tabs max in v1: Jar, Notifications, Profile)
  - 80dp height. `surfaceContainer` bg, top 1dp hairline `outlineVariant`.
  - Active icon: 24dp, `primary` with a small `tertiary` dot underneath. Inactive: 24dp, `onSurfaceVariant`.
  - Label visible always (no icon-only mode) — brand requires clarity over compactness.
- **App Bar**
  - `LargeAppBar` (Material 3 style) for primary screens: 152dp expanded, 64dp collapsed, `headlineMedium` title.
  - `SmallAppBar` for sub-screens: 64dp, `titleLarge` Fraunces, transparent bg, optional actions.
- **Navigation Rail** (tablet/web, ≥ 600dp width)
  - 80dp width, 16dp top padding, vertical `NavigationBar` items.

### 7.8 Progress Indicators
- **CircularProgress** (small 16dp, default 40dp, large 56dp). `primary` color, 3.5dp stroke.
- **LinearProgress** at the top of cards during async actions. 2dp height, `primaryContainer` track → `primary` fill.
- **Skeleton** (custom)
  - `surfaceVariant` rectangles with 12dp radius.
  - Shimmer: 1.5s linear gradient sweep, 8% white overlay over `surfaceVariant`. Disabled in reduced-motion.
- **JarProgress** (special)
  - Used during "Sealing..." or full memory save. The jar's inner liquid rises with progress.

### 7.9 Audio Components
- **Waveform** (recording): 60fps line, 1.5dp stroke, `primary`. Smoothing 30ms.
- **Waveform** (playback): static, taps are scrubbable, `primary` for played / `outlineVariant` for unplayed.
- **AudioPlayer**
  - 64dp height, 12dp radius, `surfaceContainer` bg.
  - Play/pause (40dp circle), waveform, time labels (`labelSmall` mono).
  - Scrubbing updates waveform in real time.

### 7.10 Toasts / Snackbars
- 56dp height, 12dp radius, `inverseSurface` bg, `inverseOnSurface` text.
- Trailing action button (`labelLarge` `tertiary`).
- Slide up from bottom (16dp margin), auto-dismiss 4s.

---

## 8. UX Principles

### 8.1 The 10 Rules

1. **Simplicity first.** If a feature needs more than 2 taps from the home screen, the design is wrong.
2. **One-handed usage.** Primary actions in the bottom 50% of the screen. Title small (≤ 64dp). FAB always reachable.
3. **Accessibility is the floor, not the ceiling.** Touch targets ≥ 48dp, contrast ≥ AA, semantic labels on every IconButton, focus rings visible.
4. **Fast memory creation.** From tap of "New memory" to a sealed memory in ≤ 30 seconds for text-only, ≤ 60 seconds including voice.
5. **Minimal user friction.** No "are you sure" dialogs unless the action is destructive or irreversible. Auto-save drafts every 5s.
6. **Emotional engagement through restraint.** Surprise sparingly. The jar metaphor is the only recurring brand motif.
7. **Status is always visible.** A user must never wonder "did it send?" — every memory has a clear state in the list and detail views.
8. **No dead ends.** Every error and empty state offers a next action.
9. **Predictable, but soft.** Interactions are consistent across screens. Softness comes from motion and copy, not from ambiguity.
10. **Quiet by default.** No auto-play video, no auto-play audio, no notification sounds by default. Opt-in for the delightful things.

### 8.2 Decision Heuristics
- **Text or visual?** Default to text for state, visual for hierarchy.
- **Modal or inline?** Modal for destructive/irreversible. Inline for everything else.
- **Toast or banner?** Toast for confirmations, banner for errors.
- **Push or sheet?** Push for sub-screens, sheet for in-place tasks (date pick, channel multi-select).
- **Color or shape?** Color *and* shape for status. Never color alone.

### 8.3 Empty State Voice
- Always 3 lines max: situation → emotion → action.
- Always an action, never just a sad face.
- Use the jar illustration, but rotate the copy so returning users don't see the same text twice.

### 8.4 Error State Voice
- Apologize briefly, then act.
- "We couldn't reach them right now. We'll try again in an hour." (good)
- "Error 503: Service Unavailable" (bad)

---

## 9. Responsive Design

### 9.1 Breakpoints
| Token | Width | Device class |
|---|---|---|
| `xs` | 0–599dp | Phone portrait |
| `sm` | 600–839dp | Phone landscape, small tablet portrait |
| `md` | 840–1199dp | Tablet portrait, small tablet landscape |
| `lg` | 1200–1599dp | Tablet landscape, small laptop |
| `xl` | 1600dp+ | Desktop, large monitor |

### 9.2 Phone Portrait (`xs`, default)
- Single column, edge-to-edge with 16dp horizontal page padding.
- Bottom navigation visible.
- Cards stack vertically.
- Modal sheets from bottom.

### 9.3 Phone Landscape / Small Tablet (`sm`)
- Single column, max-width 600dp centered.
- Bottom navigation can swap to a `NavigationRail` on the left.
- Form layouts stay single column.

### 9.4 Tablet Portrait / Small Landscape (`md`)
- Two-column layouts become possible (e.g. list + detail side-by-side).
- `NavigationRail` is mandatory on the left.
- Memory list = 320dp fixed left column, detail fills the rest.
- Forms grow to 480dp max-width and become two-column for short fields (date + time side-by-side).

### 9.5 Tablet Landscape / Laptop (`lg`)
- Three-column shell: `NavigationRail` (80dp) + content.
- Memory jar dashboard becomes a bento grid: hero + recent + stats.
- Typography: 1 step up from phone (headings from `headlineLarge` to `displaySmall`).
- Background uses `Memory Beam` more prominently.

### 9.6 Desktop / Web (`xl`)
- Same as `lg` but with 1200dp content max-width and centered.
- Hover states fully implemented.
- Right rail for context (e.g. delivery audit panel) appears.
- Keyboard shortcuts: `N` new memory, `/` search, `Esc` close sheet, `?` shortcut help.

### 9.7 Foldables
- Honor `MediaQuery.size` and avoid hard-coded split assumptions.
- In unfolded mode, prefer two-pane layouts.
- In folded mode, behave like `xs` or `sm` based on the inner display width.

### 9.8 Density
- Default density is **comfortable** (the values above). Add a `compact` variant in Settings that reduces padding by 4dp and font sizes by 1 step — for users who want more content per screen.

---

## 10. Visual Consistency Rules

### 10.1 Spacing Scale (8dp base)
| Token | Value |
|---|---|
| `space.xxs` | 2dp |
| `space.xs` | 4dp |
| `space.sm` | 8dp |
| `space.md` | 16dp |
| `space.lg` | 24dp |
| `space.xl` | 32dp |
| `space.xxl` | 48dp |
| `space.xxxl` | 64dp |

**Rules:**
- Default page horizontal padding: `space.md` (16dp) on phones, `space.lg` (24dp) on tablets, `space.xl` (32dp) on web.
- Vertical rhythm between sections: `space.lg` (24dp).
- Vertical rhythm between list items: `space.sm` (8dp) inside cards, `space.md` (16dp) between cards.
- Form field gaps: `space.md` (16dp).
- Never use a value not on the scale.

### 10.2 Corner Radius
| Element | Radius |
|---|---|
| Buttons | 28dp (fully rounded) |
| Pills / chips | 16dp |
| Cards | 16dp |
| Bottom sheets | 28dp top corners |
| Dialogs | 28dp |
| Text fields | 12dp |
| Avatars | 50% (circular) |
| Status dots | 50% |
| Jar | 20dp top, 12dp bottom (slight asymmetry for hand-feel) |

### 10.3 Elevation & Shadows
- Use Material 3 surface tinting, not raw shadows, by default.
- Override to explicit shadow only on:
  - FAB (6dp)
  - Modals (12dp)
  - Hovered cards (4dp)
- Shadow color: `#000000` at 8% (light mode) / 24% (dark mode). No colored shadows.

### 10.4 Borders & Dividers
- Hairlines: 1dp `outlineVariant` for dividers, 1.5dp `outline` for input borders resting, 2dp `primary` for focus.
- Never use 1px black/white.
- Dividers always have at least `space.md` of padding on each side.

### 10.5 Grid System
- 4-column on `xs` (margins 16dp, gutters 8dp).
- 8-column on `sm`.
- 12-column on `md`+ with 16dp gutters.
- Content stays in a 12-column max-width container; empty columns absorb leftover width (centering).

### 10.6 Component Spacing
- **Inside a card:** 16dp padding all sides; 8dp between internal rows.
- **Inside a section header:** 8dp top, 16dp bottom, content follows immediately.
- **Between sections:** 24dp.
- **Between major regions (app bar → content → FAB):** 16dp minimum, FAB has 16dp from screen edge.

### 10.7 Iconography Sizes
- 16dp — inline with body text
- 20dp — chip leading
- 24dp — app bar, list items, navigation
- 32dp — feature icons in cards
- 48dp — empty-state / hero

### 10.8 Opacity Stops
For text and overlays: `100%` · `87%` · `60%` · `38%` · `16%`. Never use intermediate values.

---

## 11. AI Implementation Guidance

### 11.1 Flutter Widget Recommendations
- **Use Material 3** (`useMaterial3: true`) — never roll a custom theme for what Material 3 already does.
- **ColorScheme.fromSeed** with the brand seed `#7C6CFF` generates the entire light/dark palette.
- **CustomPainter** for the jar and waveform (cheaper than SVG for animated elements).
- **flutter_svg** for static illustrations.
- **glassmorphism** = `BackdropFilter(filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12))` on a `surface`-tinted container, behind a 1dp `outlineVariant` border. Wrap in a `ClipRRect` for the corner radius.
- **animations** package for the simpler stuff; for branded motion, use `AnimationController` + `Curves.*` directly so you control easing.
- **flutter_animate** is acceptable for one-shot staggers; do not let it become the default for everything.
- **responsive_framework** or a hand-rolled `LayoutBuilder` for breakpoints. Avoid `sizer` (anti-pattern, debug nightmare).
- **flutter_hooks** is fine for `useAnimationController` etc., but not required.

### 11.2 State Management
**Recommended:** `flutter_riverpod` (provider + hooks-friendly, no BuildContext coupling, easy to test).
**Avoid for v1:** `Provider`/`Bloc`/`GetX` (each has a reason, none are wrong, but Riverpod is the smallest learning curve for the team and survives complexity growth).
- **Form state:** `flutter_form_builder` + `form_builder_validators` (Phase 2+).
- **Server state:** `riverpod`'s `AsyncNotifier` + `dio` for HTTP. Drop the existing `http` package for `dio` when adding interceptors.
- **Local persistence:** `shared_preferences` (settings), `drift` (drafts, scheduled memories cache).
- **Media:** `image_picker`, `record` (already declared), `just_audio` (playback), `cached_network_image`.

### 11.3 Reusable Component Architecture
- Every component is a **stateless widget** that accepts an `on*` callback and a typed config.
- Stateful wrappers (e.g. a button that knows it's loading) are the only stateful widgets in the library.
- Components expose a `key` for list usage and never read global state.
- Use `const` constructors everywhere possible.
- Provide a `screenshot_test` for every component in `test/widgets/`.

### 11.4 Folder Structure (UI)
```
lib/
├── main.dart
├── app.dart                          # MaterialApp + router + theme
├── theme/
│   ├── app_theme.dart                # light & dark ThemeData
│   ├── app_colors.dart               # semantic tokens (3.3)
│   ├── app_typography.dart           # TextTheme from §4
│   ├── app_spacing.dart              # spacing tokens (§10.1)
│   ├── app_motion.dart               # duration & easing tokens (§6.1)
│   └── app_assets.dart               # image/svg/font references
├── ui/
│   ├── primitives/                   # atoms: Text, Icon, Spacer
│   ├── components/                   # §7 library
│   │   ├── buttons/
│   │   ├── cards/
│   │   ├── forms/
│   │   ├── audio/
│   │   ├── progress/
│   │   ├── navigation/
│   │   └── feedback/                 # toasts, banners, dialogs
│   ├── patterns/                     # composed patterns: empty state, error state
│   ├── screens/                      # the §5 screens
│   └── effects/                      # jar, aurora, particles, glassmorphism
├── features/                         # feature-first slicing when app grows
│   ├── jar/                          # home, create, detail
│   ├── timeline/
│   ├── notifications/
│   └── settings/
├── data/                             # repositories, DTOs, API client
├── domain/                           # entities, use-cases (when complexity grows)
└── utils/
```

### 11.5 Naming Conventions
- **Files:** `snake_case.dart`. One public widget per file. File name = class name lowercased.
- **Classes:** `PascalCase`. Suffix: `Screen`, `Widget`, `Card`, `Button`, `Tile`, `Sheet`, `Dialog`, `State`, `Controller`, `Notifier`.
- **Private:** `_` prefix for file-private widgets and helpers.
- **Tokens:** `k` prefix for compile-time constants (`kSpaceMd = 16.0`).
- **Colors:** `AppColors.primary` static, never `Colors.purple`.
- **Durations:** `AppMotion.normal` static, never `Duration(milliseconds: 240)` inline.
- **Routes:** `RouteNames.jar`, `RouteNames.createMemory`.

### 11.6 Don'ts in Code
- ❌ Hard-coded hex anywhere outside `app_colors.dart`.
- ❌ `withOpacity` — use `withValues(alpha:)` (Flutter 3.27+).
- ❌ `EdgeInsets.all(20)` — use the spacing scale.
- ❌ Inline `Duration`/`Curve` — use `AppMotion.*`.
- ❌ `setState` for cross-screen state (use Riverpod).
- ❌ `MediaQuery.of(context).size.width` directly in widgets — go through a `Responsive` helper.
- ❌ `Container` when `SizedBox` or `Padding` would do.

### 11.7 Accessibility Implementation
- Every interactive widget has a `Semantics` label.
- IconButtons always have `tooltip` (visible on long-press on mobile, hover on web).
- All text is selectable in long-form views.
- VoiceOver/TalkBack order matches visual order.
- Form errors are read aloud once per session per field.
- `MediaQuery.disableAnimations` is checked before every continuous animation.

### 11.8 Performance Budgets
- 60fps during all transitions; 90fps on capable devices.
- First contentful paint ≤ 1.5s on a mid-range Android (Moto G class).
- Idle CPU < 2% on a list with 100 memories.
- Memory footprint < 150MB on the same device.
- Cold start to interactive: < 2.5s.

---

## 12. Visual References & Inspirations

### 12.1 Inspired By
- **Apple Journal** — restraint, typography, the feeling of writing for yourself.
- **Headspace** — soft pastels, generous whitespace, illustrations with hand-feel, motion that never hurries.
- **Things 3 / Craft** — clarity, subtle surfaces, the joy of a well-aligned list.
- **Are.na** — quiet curation, treating content with respect.
- **Day One** — the closest product analog: memory journaling with delivery.
- **Material 3 expressive** — color, motion, dynamic color (we deviate by locking to a brand seed).
- **iOS 18 "Liquid Glass"** — backdrop blur, refraction, soft tints (we use it sparingly).

### 12.2 How to Adapt (not copy)
| Inspired by | What we take | What we leave behind |
|---|---|---|
| Apple Journal | Type hierarchy, generous padding, single accent color | Rigid grid; we use a slightly looser, warmer grid |
| Headspace | Soft palette, hand-feel illustrations | Cartoonish style; we use more realistic proportions |
| Things 3 | Subtle elevation, list clarity | Dense information; we breathe more |
| Are.na | Quiet, content-first chrome | Editorial flair; we stay neutral |
| Day One | Memory-first IA, timeline view | Photo-led default; we lead with the message text |
| iOS Liquid Glass | Backdrop blur, refractive surfaces | Full-bleed translucency; we use it only on small surfaces |

### 12.3 What we are deliberately **not**
- **Not a "wellness" app.** No meditations, no breathing exercises, no streaks. Memory Jar is about *people and time*, not self-optimization.
- **Not a social network.** No feeds, no likes, no followers. Memories are private unless explicitly shared.
- **Not a notes app.** No folders, no tags, no search (in v1). Memories are organized only by time.
- **Not Material 3 default.** We customize colors, motion, and surfaces; the result should feel like a different product wearing Material as its bones.

### 12.4 Anti-Aesthetic
What we are *against*, in one line each:
- **Skeuomorphic realism.** No leather, no paper textures, no wax seals. The jar is flat/soft, not a still-life.
- **Maximalist gradient meshes.** Aurora is allowed, but never bleeding off every screen.
- **"AI sparkle."** No shimmery gradient text. No "✨" in product copy.
- **Gamification.** No streaks, no badges, no "Day 30!" celebrations. Memories are not points.

---

## 13. DO NOT DO — Anti-Patterns

### 13.1 Design Mistakes
- ❌ **Don't** use pure black (`#000000`) or pure white (`#FFFFFF`) as app backgrounds. Use `background` (`#FBF9F7` / `#15131C`).
- ❌ **Don't** mix `Roboto` with `Fraunces` mid-paragraph — keep the families to their zones (display vs body).
- ❌ **Don't** use more than 2 type families in a single screen.
- ❌ **Don't** apply glassmorphism to text or small controls. Glass is for *containers* (cards, sheets, nav bars).
- ❌ **Don't** use emoji in product UI. Ever.
- ❌ **Don't** put the FAB over content. Keep 16dp margin from screen edges and from the bottom nav.
- ❌ **Don't** stack a card on a card on a card. Max depth: 2.
- ❌ **Don't** use drop shadows on white cards over white. Use surface tinting.
- ❌ **Don't** use the brand violet for body text. It's only for actions and active states.
- ❌ **Don't** reuse the same empty-state copy on every screen. Rotate the message.

### 13.2 UX Mistakes
- ❌ **Don't** auto-play audio or video. Ever.
- ❌ **Don't** send a push notification for a memory that opens in less than 24 hours — surface it in the in-app notification center instead.
- ❌ **Don't** ask for permissions before the user has a reason to need them. Mic permission is requested on the *recorder* screen, not at app launch.
- ❌ **Don't** put a logout button at the top of settings. Bury it.
- ❌ **Don't** use "Cancel" as a destructive confirmation. Use "Yes, cancel it" / "No, keep it" or similar verb-first copy.
- ❌ **Don't** disable a button without explaining why. Tooltip or helper text under the field.
- ❌ **Don't** use a spinner as the only loading state. Pair it with a label.
- ❌ **Don't** make the user wait on a screen after submitting. Optimistic-update, then reconcile.
- ❌ **Don't** use bottom sheets for destructive confirmations. Use a dialog.
- ❌ **Don't** introduce a new icon for a concept you already have an icon for. Consistency wins.

### 13.3 Accessibility Violations
- ❌ Color-only status indicators (must include icon/shape).
- ❌ Tap targets < 48×48dp.
- ❌ Body text contrast < 4.5:1.
- ❌ Unlabeled IconButtons.
- ❌ Text scaling ignored — at 200% text scale, layouts must still work (test!).
- ❌ Continuous motion without `prefers-reduced-motion` respect.
- ❌ Auto-focus traps (a focused field that can't be released).
- ❌ Timeouts on form filling.
- ❌ Non-descriptive link text ("Click here", "Read more").

### 13.4 Overly Complex Interactions
- ❌ Gestures only (always provide a button alternative).
- ❌ Multi-finger gestures for primary actions.
- ❌ Long-press for critical actions.
- ❌ Pull-to-refresh for non-list screens.
- ❌ Swipe-to-dismiss on the *only* copy of user content (must be undoable).
- ❌ Carousels inside cards inside lists.
- ❌ Tooltips that don't disappear.
- ❌ Modals that stack (modal-on-modal is a code smell).
- ❌ "Swipe up for more" on a scrollable list (use a `See all` button).
- ❌ Custom scrollbars that hide the system one on desktop without offering it back.

### 13.5 Engineering Anti-Patterns (UI-related)
- ❌ `Opacity` widget to fade — use `AnimatedOpacity` or `FadeTransition`.
- ❌ Rebuilding the entire list on a single card change. Use `ListView.builder` + stable keys.
- ❌ `Image.asset` for SVGs. Use `flutter_svg`.
- ❌ Inline `Padding(padding: EdgeInsets.all(20))` — use the spacing scale.
- ❌ Magic numbers in `SizedBox(height: 17)`. Use the scale.
- ❌ Strings inline in widgets — centralize in `lib/l10n/` (Flutter ARB).
- ❌ Hard-coded navigation by index. Use named routes.
- ❌ Mixing `Material` and `Cupertino` widgets arbitrarily. Pick a platform idiom (we default to Material 3) and stay consistent.

### 13.6 Brand-Voice Violations
- ❌ "🔥" or any emoji in product copy.
- ❌ Exclamation marks in success states.
- ❌ "Oops!" — too cute. Use "Something went sideways" or similar.
- ❌ "Just" — minimizing user effort ("just tap here") is condescending.
- ❌ "Don't worry" — patronizing. "We'll try again in an hour" is better.
- ❌ Slang or trending phrases. "No cap", "bestie", "vibes" — none.
- ❌ ALL CAPS body text. ALL CAPS only for `labelSmall` overlines.

---

## Appendix A — Quick-Reference Token Cheat Sheet

```dart
// theme/app_colors.dart
class AppColors {
  static const seed = Color(0xFF7C6CFF);
  static const primaryContainer = Color(0xFFE8E3FF);
  static const onSurface = Color(0xFF1F1B2E);
  static const onSurfaceVariant = Color(0xFF5C5669);
  static const surfaceVariant = Color(0xFFF2EEEA);
  static const outline = Color(0xFFD8D2CC);
  static const outlineVariant = Color(0xFFEAE5E0);
  static const error = Color(0xFFE26464);
  static const tertiary = Color(0xFF5BC8B4);
  static const tertiaryContainer = Color(0xFFCFF4EB);
  // ... full set per §3.1 / §3.2
}

// theme/app_spacing.dart
class AppSpacing {
  static const xxs = 2.0;
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
  static const xxxl = 64.0;
}

// theme/app_motion.dart
class AppMotion {
  static const fast = Duration(milliseconds: 120);
  static const normal = Duration(milliseconds: 240);
  static const slow = Duration(milliseconds: 400);
  static const deliberate = Duration(milliseconds: 600);
  static const cinematic = Duration(milliseconds: 1000);

  static const standard = Curves.easeInOutCubic;
  static const decelerate = Curves.easeOutCubic;
  static const accelerate = Curves.easeInCubic;
  static const emphasized = Curves.easeInOutCubicEmphasized;
}
```

## Appendix B — Acceptance Checklist for a New Screen
Before any screen ships, verify:
- [ ] Uses `AppColors.*` / `AppSpacing.*` / `AppMotion.*` — no magic numbers
- [ ] Has a defined empty, loading, and error state
- [ ] Honors dark mode
- [ ] Honors 200% text scale
- [ ] Honors `prefers-reduced-motion`
- [ ] Touch targets ≥ 48dp
- [ ] Contrast ≥ WCAG AA
- [ ] All IconButtons have tooltips
- [ ] Tested on phone portrait, phone landscape, tablet portrait minimum
- [ ] Renders with 0 memories, 1 memory, 100 memories
- [ ] No layout shift between loading and loaded states
- [ ] Copy follows §2.3 voice
- [ ] Listed in this DESIGN_SYSTEM.md (§5)

---

**End of DESIGN_SYSTEM.md.** This document is versioned alongside the app. Any change to colors, type, motion, or component specs must update both the design token and the relevant section here.
