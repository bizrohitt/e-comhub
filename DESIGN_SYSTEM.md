# DESIGN SYSTEM — The House Of Sahas

**Status:** skeleton, Phase 0. Everything below marked *PROPOSED* is pending founder confirmation.
Implementation lands in Phase 4 as `storefront/src/styles/tokens.css` plus the Tailwind config. Until then this file is the single source of truth for visual decisions.

**Rule:** never hard-code a color, font size or spacing value outside the tokens (Master Prompt Sections 4.1 and 7).

---

## 1. Color code (PROPOSED)

| Token | Hex | Use |
|---|---|---|
| `--ivory` | `#F6F1E7` | Main background |
| `--parchment` | `#EAE2D3` | Alternate sections, cards |
| `--bottle-green` | `#1F3A2E` | Primary brand color, dark sections, buttons |
| `--ink` | `#141414` | Body text, deep backgrounds |
| `--camel` | `#A98655` | Accent, lines, hover, small details (use sparingly) |
| `--stone` | `#8C8576` | Secondary text, captions |

**Proportion rule:** ~70% ivory/parchment, ~20% green/ink, ~10% camel.

**Derived tokens to define in Phase 4** (no new hues without approval):

- `--surface-raised`, `--surface-sunken`
- `--border-hairline` (1px, camel at low opacity or stone)
- `--on-bottle-green` (text on dark), `--on-camel`
- `--state-success`, `--state-warning`, `--state-danger` — muted, desaturated to match the palette; never neon
- `--overlay-scrim`, `--grain-opacity`

### Contrast check (to be measured, WCAG AA minimum)

| Pair | Target | Status |
|---|---|---|
| `--ink` on `--ivory` | ≥ 4.5:1 (body) | To verify in Phase 4 |
| `--stone` on `--ivory` | ≥ 4.5:1 (captions) | To verify — `#8C8576` on `#F6F1E7` is likely near the AA line; may need a darker `--stone-strong` for small text |
| `--ivory` on `--bottle-green` | ≥ 4.5:1 | To verify |
| `--camel` on `--ivory` | ≥ 3:1 (large text / UI borders only) | To verify — camel is an accent, never body text |

## 2. Typography (PROPOSED)

- **Headings:** Cormorant Garamond, light to regular weight, generous letter-spacing on small caps labels.
- **Body:** Jost or Inter, 16 to 18px, line-height 1.7.
- **Scale:** fluid with `clamp()`; 8px spacing grid; very generous whitespace.
- Self-hosted, SIL OFL. Only the hero heading font and weight are preloaded (Section 8 budget).

Fluid scale to define in Phase 4: `--text-xs` … `--text-display`, each a `clamp()` with min/preferred/max, plus matching `--leading-*` and `--tracking-*` (small caps labels get the widest tracking).

## 3. Shape, lines and depth

- Thin 1px lines.
- Square or barely rounded corners: 0 to 2px.
- No heavy shadows. No gradients except subtle overlays on photography.
- Elevation is communicated by whitespace and hairlines, not by drop shadows.

## 4. Principles

- **Minimal yet premium:** fewer elements, bigger images, more air. Every element must justify itself.
- **Authority signals:** founding story, craft details, fabric origins, press or client mentions (only true ones), clear policies.
- **Clarity:** a first-time visitor understands what we sell, who it is for, and how to buy within five seconds.
- **Mobile first:** design for a phone, then enhance.
- **Accessibility:** keyboard navigation, visible focus states, alt text, `prefers-reduced-motion` respected (disable parallax and morphing when set).

## 5. Component inventory (to be built in Phase 4)

Primitives: `Container`, `Button` (primary / secondary / ghost / magnetic), `Text`, `Heading`, `Eyebrow` (small caps label), `Hairline`, `Reveal`, `Link`, `ImageFrame`, `Card`, `Input`, `Select`, `Checkbox`, `Badge`, `Price`, `Toast`, `Modal`, `Drawer`, `Accordion`, `Table`, `Pagination`, `Skeleton`, `EmptyState`.

Commerce: `ProductCard`, `ProductGrid`, `VariantSelector`, `SizeSelector`, `CartDrawer`, `CartItemRow`, `OrderSummary`, `AddressForm`, `FilterPanel`, `SortSelect`, `SearchField`, `Breadcrumb`, `QuantityStepper`.

Layout: `Navbar` (morphing, sticky), `MobileMenuOverlay`, `Footer`, `SectionShell`, `PageTransitionCurtain`, `GrainOverlay`, `CustomCursor`.

Each primitive: typed props, token-based styling only, under 600 lines, keyboard accessible, reduced-motion aware.

## 6. Motion rules (to be detailed in Phase 5)

- Transform and opacity only; GPU friendly. No animating layout properties.
- Never cause layout shift (CLS < 0.05).
- Easing, durations and named curves: TBD in Phase 5, recorded in `skills/skill-motion.md`.
- `prefers-reduced-motion: reduce` disables parallax, morphing, pinned scroll stories, curtain transitions and magnetic buttons; content stays fully reachable and readable.
- Every effect must be tested on a mid-range phone. If it costs speed, it is removed — speed is part of premium.

## 7. Photography and imagery direction

- AVIF/WebP with responsive `srcset`; poster image for any video; video under 3 MB.
- Licensed placeholders (Unsplash / Pexels, commercial use permitted, terms checked per image) until a real shoot. Every placeholder recorded in `LICENSES.md`.
- A photoshoot brief is a Phase 4/5 deliverable.

## 8. Open design decisions

1. Body font: Jost or Inter? (Recommendation to follow in P0-05.)
2. Does the founder want to adjust any of the six hex values?
3. Womenswear, if planned, may need a second editorial tone — confirm scope.
