# DESIGN TOKENS

**Status: provisional.** These are *neutral, functional* tokens for Phases 0–6 — enough to be
readable, responsive and accessible, deliberately not branded. The brand pass happens in **Phase 7,
only on the founder's go-ahead**, and should be a change to the `:root` block in
`static/css/base.css` plus (at most) the type scale — **no template or logic changes**.

That is the whole point of tokenising now: a redesign must be a find-and-replace in one file.

---

## 1. Colour (provisional, greyscale + one accent)

| Token | Value | Use |
|---|---|---|
| `--c-bg` | `#ffffff` | Page background |
| `--c-surface` | `#f7f7f8` | Cards, result panels, table stripes |
| `--c-border` | `#d9d9de` | Hairlines, input borders |
| `--c-text` | `#1a1a1d` | Body text |
| `--c-text-muted` | `#5b5b63` | Helper text, captions (4.6:1 on white — passes AA) |
| `--c-accent` | `#1e5bd6` | Links, primary button, focus ring |
| `--c-accent-hover` | `#1748aa` | Hover/active |
| `--c-good` | `#117a46` | Positive results (profit, pass) |
| `--c-warn` | `#8a5a00` | Caution (thin margin, stale data) |
| `--c-bad` | `#b3261e` | Negative results, errors |
| `--c-focus` | `#1e5bd6` | 2px outline, 2px offset, never removed |

**Contrast rule:** body text ≥7:1, secondary text and large text ≥4.5:1, UI borders ≥3:1. Every
pair above is verified; re-verify after any brand change using our own contrast-checker tool.

**Dark mode:** `prefers-color-scheme: dark` overrides the same tokens in one block. Deferred to
Phase 7, but the token names are already dark-mode-ready (semantic, not literal — no `--c-white`).

**Result colour rule:** never communicate a result by colour alone. "Negative margin" shows a
minus sign and the word, not just red text.

---

## 2. Space scale (4px base)

| Token | Value |
|---|---|
| `--s-1` | `4px` |
| `--s-2` | `8px` |
| `--s-3` | `12px` |
| `--s-4` | `16px` |
| `--s-5` | `24px` |
| `--s-6` | `32px` |
| `--s-7` | `48px` |
| `--s-8` | `64px` |

Use tokens only. A hardcoded `margin: 13px` fails code review.

---

## 3. Type

**Stack (system fonts — zero network cost, zero CLS, zero licensing risk):**
```css
--font-sans: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue",
             Arial, "Noto Sans", sans-serif;
--font-mono: ui-monospace, SFMono-Regular, "SF Mono", Menlo, Consolas, monospace;
```
No web fonts before Phase 7. If a brand font is ever added it must be OFL/Apache licensed,
self-hosted, subset, `font-display: swap`, and preloaded — and must not break the CLS budget.

**Scale (fluid, 1.25 ratio):**

| Token | Value | Use |
|---|---|---|
| `--t-xs` | `0.8125rem` | Captions, table footnotes |
| `--t-sm` | `0.9375rem` | Helper text, labels |
| `--t-base` | `1rem` / `1.0625rem` on ≥48em | Body |
| `--t-lg` | `1.25rem` | Lead paragraph, result value |
| `--t-xl` | `1.5rem` | h3 |
| `--t-2xl` | `1.875rem` | h2 |
| `--t-3xl` | `clamp(1.75rem, 4vw, 2.25rem)` | h1 |

`--lh-tight: 1.2` (headings) · `--lh-base: 1.6` (body) · measure capped at `--measure: 68ch`.
Mono tariff: result numbers use `--font-mono` + `font-variant-numeric: tabular-nums` so digits
don't jump while typing.

---

## 4. Radius, border, shadow

| Token | Value | Note |
|---|---|---|
| `--r-sm` | `4px` | Inputs, buttons |
| `--r-md` | `8px` | Cards, result panels |
| `--bw` | `1px` | Standard border width |
| `--shadow-1` | `0 1px 2px rgb(0 0 0 / 0.06)` | The only shadow before Phase 7 |

No gradients, no glows, no decorative animation until Phase 7.

---

## 5. Layout

| Token | Value |
|---|---|
| `--w-content` | `44rem` (prose) |
| `--w-wide` | `68rem` (hubs, tool grids) |
| `--gutter` | `var(--s-4)` mobile, `var(--s-5)` ≥48em |

**Breakpoints** (min-width, `em` so they respect zoom): `--bp-sm: 30em` · `--bp-md: 48em` ·
`--bp-lg: 64em`. Mobile-first: write the small layout, then add breakpoints.

---

## 6. Interaction

- **Touch targets ≥44×44px**, including icon buttons and table row actions.
- **Focus:** `outline: 2px solid var(--c-focus); outline-offset: 2px`. Never `outline: none`.
- **Hit state** on every interactive element; `:active` must be visible on touch.
- **Transitions:** max `120ms ease` on colour only, and wrapped in
  `@media (prefers-reduced-motion: no-preference)`.
- **Inputs:** `font-size: 16px` minimum on mobile (prevents iOS zoom), `inputmode="decimal"` for
  money fields, `enterkeyhint` where it helps.

---

## 7. Component inventory (the only ones that exist before Phase 7)

`.stack` (vertical rhythm) · `.cluster` (inline wrap) · `.grid-tools` (auto-fit cards) ·
`.card` · `.field` (label + input + helper + error) · `.btn` / `.btn-primary` / `.btn-quiet` ·
`.result` (panel with `aria-live`) · `.table` · `.faq` (details/summary) · `.breadcrumbs` ·
`.badge` (S/A, "new", "verified") · `.notice` (info/warn) · `.skip-link` · `.visually-hidden`.

If a page needs a thirteenth component, it probably needs one of these twelve instead.

---

## 8. Phase 7 brief (fill in when the founder says "start design phase")

- [ ] Brand name, logo (inline SVG, ≤2 KB), favicon set
- [ ] Palette replacing the provisional one — re-run contrast checks
- [ ] Type decision: keep system stack (recommended: it's free, instant and zero-CLS) or add one
      OFL display face for headings only
- [ ] Dark mode token block
- [ ] Illustration/empty-state style (SVG only, no stock photos)
- [ ] OG image template generated from tool name (static SVG→PNG at build, not at request time)
- [ ] Re-run the full performance budget after the swap — a redesign that breaks the budget is
      rejected, not negotiated
