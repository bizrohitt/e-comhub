# ARCHITECTURE — The House Of Sahas

**Status:** stack **LOCKED** 2026-10-10 (task P0-04), based on the confirmed Phase 0 answers in `PROJECT_PLAN.md`.
Data-flow diagrams (cart, checkout, COD reconciliation, order states, returns, tax) are task **P0-08** and still pending.
Written before any code, per Master Prompt Section 12.

---

## 1. Three products, one backend

1. **Storefront** — Next.js. The homepage is a cinematic landing page (Section 8).
2. **Admin panel** — Medusa Admin, extended with custom widgets and routes. Not rebuilt.
3. **Mobile admin app** — Expo. Deferred to Phase 7; shares types from `/shared`.

## 2. Constraints that shaped every decision below

| Constraint | Source | Architectural consequence |
|---|---|---|
| ₹0–₹2,000/month | Q6 | One VPS runs everything server-side. No second search service. No separate CMS container until Phase 6. |
| Non-technical founder | Q5 | Two-command local setup, one-command deploy, automated backups with a *tested restore*, plain-language runbooks in `docs/`. |
| English + Hindi | Q2 | i18n is a Phase 1 foundation, not a retrofit. No hard-coded UI strings, ever. Devanagari fonts required. |
| 10–20 products | Q1 | Data layer stays simple; curation and editorial layout matter more than catalogue scale. Search via Postgres FTS is genuinely sufficient. |
| Founder only at launch | Q8 | Roles defined in code, one owner assigned. Least privilege from day one. |
| Razorpay + capped COD | Q3 | Payment adapter + COD reconciliation workflow. RTO handling is a first-class order state, not an edge case. |
| No photography yet | Q7 | Image pipeline designed for placeholders now and real assets later, with no layout shift when swapped. |

## 3. Locked stack

| Layer | Locked choice | License | Why | Alternative rejected / deferred |
|---|---|---|---|---|
| Commerce engine | **Medusa v2** | MIT | Headless, modular, built-in admin, extensible workflows, free to self-host | Saleor (BSD-3, heavier for a solo founder); custom build (months of work) |
| Storefront | **Next.js 15 + TypeScript 5** | MIT | SSR/SSG for SEO, image optimisation, app router, one language across the monorepo | Astro (weaker for app-like checkout); Remix (smaller ecosystem for commerce) |
| Styling | **Tailwind CSS v4** | MIT | Token-driven, no hard-coded colors possible if configured correctly, tiny CSS output | CSS Modules (no token enforcement) |
| Database | **PostgreSQL 16** | PostgreSQL License | Reliable, free, and gives us full-text search so we can skip Meilisearch | — |
| Cache and queues | **Redis 7** | BSD-3 | Cart/session speed, Medusa background jobs | — |
| Editable content | **Typed JSON/MDX content files at launch → Payload CMS in Phase 6** | MIT (Payload) | No extra infra early. The section schema is identical either way, so Phase 6 adds an editing UI over existing data with no rework | Payload from day one (a second container the budget and the founder don't need yet) |
| Admin panel | **Medusa Admin + custom widgets/routes** | MIT | Do not rebuild what exists | Separate custom admin |
| Mobile app | **Expo / React Native** | MIT | One codebase for iOS and Android, shares TypeScript types with web | Flutter (no type sharing) |
| Search | **Postgres full-text search** at launch; Meilisearch deferred | MIT (Meilisearch) | With 10–20 products, Postgres FTS is sufficient and costs nothing extra | Meilisearch now (another service outside the budget) |
| Smooth scroll | **Lenis** | MIT | Premium inertia scrolling | GSAP — **excluded**, not an OSI open source license |
| Animation | **Motion** (formerly Framer Motion) + native CSS scroll-driven animations | MIT | Light and flexible, layout animations for the morphing navbar | GSAP — excluded |
| Icons | **Lucide** | ISC | Thin, elegant | — |
| Email | **React Email** + an SMTP free tier (provider chosen in Phase 2) | MIT | Branded transactional templates as code | Provider choice deferred: Brevo ~300/day free vs Resend ~100/day free; both cost money at volume |
| Analytics | **Umami**, self-hosted on the same VPS | MIT | Lighter than Plausible on a shared box, privacy-friendly, no cookie-consent burden | Plausible (heavier); GA4 (privacy + consent cost) |
| i18n | **next-intl** | MIT | Typed message catalogs, route-aware locale, works with the app router | Hand-rolled context (leaks strings, unmaintainable in two languages) |
| Testing | **Vitest + Playwright** | MIT | Free, fast, covers unit and the main purchase path | — |
| Storefront hosting | **Cloudflare Pages or Vercel free tier** | — | Generous free tier, global CDN, AVIF/WebP transforms | Chosen in P1-03 once the domain is known |
| Backend hosting | **One small VPS** (Hetzner-class, ~₹400–₹800/month) | — | Runs Medusa + Postgres + Redis + Umami inside budget | Railway/Render free tiers **sleep** — unacceptable for a store taking orders |

**Versions are verified at install time** (P1-12), not assumed here.

### Fonts — a real problem the Phase 0 answers created

| Role | Locked | License | Note |
|---|---|---|---|
| Headings (Latin) | **Cormorant Garamond** | SIL OFL 1.1 | The old-money serif. Preload the hero weight only. |
| Body (Latin) | **Inter** | SIL OFL 1.1 | Chosen over Jost for wider weights, better small-size legibility and metric stability |
| Headings (Devanagari) | **Tiro Devanagari Hindi** (proposed, confirm in P0-05) | SIL OFL 1.1 | Serif register that matches Cormorant's heritage feel |
| Body (Devanagari) | **Mukta** or **Noto Sans Devanagari** (proposed, confirm in P0-05) | SIL OFL 1.1 | Pairs with Inter's proportions |

**Why this matters:** Cormorant Garamond, Inter and Jost have **no Devanagari coverage**. Without an explicit Devanagari pairing, the Hindi locale renders as empty boxes or browser fallback fonts that destroy the brand. This is a P0-05 decision and a P1-08 implementation requirement.

## 4. Monorepo layout

```
e-comhub/                      # repo root = the-house-of-sahas/ in Section 12
  MASTER_PROMPT.md  PROJECT_PLAN.md  SESSION_LOG.md
  DESIGN_SYSTEM.md  ARCHITECTURE.md  COPY_BIBLE.md
  OFFERS_PLAYBOOK.md  LICENSES.md  README.md
  skills/            # reusable instruction sheets (Section 19)
  docs/              # runbooks + the Phase 6 PDF guide
  backend/           # Medusa: modules, workflows, api, subscribers, scripts
  storefront/        # Next.js
    src/features/    # home, shop, product, cart, checkout, account, journal
    src/components/  # ui primitives (Button, Container, Reveal...)
    src/i18n/        # locale routing, message loading
    src/lib/         # api client, helpers, hooks
    src/styles/      # tokens.css, base.css
    content/         # typed JSON/MDX page + section content
    messages/        # en.json, hi.json
  mobile/            # Expo app (Phase 7)
  shared/            # types, constants, validators
  integrations/      # payments/ shipping/ email/ messaging/ analytics/ accounting/ feeds/
  scripts/           # seed data, license audit, tooling
  tests/
```

**Feature folder contract.** Every `src/features/<name>/` contains `components/`, `hooks/`, `api/`, `types.ts`, `index.ts`. Nothing outside a feature imports from inside it except through `index.ts`. No circular imports. No god files. 600-line cap, 150–250 target.

**Homepage sections** live in `storefront/src/features/home/sections/` — one file per section, each under 600 lines, each driven by the same section schema the Phase 6 CMS will edit.

## 5. Content schema (the bridge between Phase 1 and Phase 6)

Pages are arrays of typed section blocks: `hero`, `text`, `imageGrid`, `productRow`, `testimonial`, `faq`, `cta`, plus the homepage-specific sections from Section 8. One TypeScript schema in `/shared`, one JSON/MDX file per page in `storefront/content/`. Payload CMS is introduced in Phase 6 as an editor over **that same schema**, which is why adding a page must take under five minutes and no code (Section 13).

## 6. Integration adapters

Every third-party service sits behind an interface in `/integrations/<name>/`. No provider SDK is imported anywhere else. The provider is selected by env var, failures degrade gracefully, and secrets live only in env.

| Adapter | Phase 1–6 | Later |
|---|---|---|
| `payments/` | **Razorpay** + a COD pseudo-provider (creates the order, marks payment pending, triggers phone confirmation) | Stripe/PayPal when international |
| `shipping/` | **Shiprocket** (rate fetch, label, AWB, tracking webhook) | DHL if international shipping is added |
| `email/` | SMTP provider free tier + React Email templates | Volume upgrade path |
| `messaging/` | Stub interface only | WhatsApp order updates (Phase 8) |
| `analytics/` | Umami | — |
| `accounting/` | Stub interface only | Tally / Zoho export formats |
| `feeds/` | Stub interface only | Google Merchant, social catalogs |
| `reviews/` | Not built | Phase 8; only verified reviews, per Section 10 |

Contract details are written in `skills/skill-integration-adapter.md` during Phase 1.

## 7. Security baseline (always on)

- Input validation at every boundary; shared validators from `/shared`.
- Rate limiting on auth, checkout, contact, newsletter and COD-confirmation endpoints.
- CSRF protection on all state-changing storefront routes.
- Secure headers: CSP, HSTS, `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy`, `X-Frame-Options`.
- Hashed passwords, session rotation, no plaintext secrets anywhere.
- **Webhook signature verification for every Razorpay and Shiprocket callback** — non-negotiable with COD in the mix.
- Roles: `owner`, `manager`, `support`, `inventory` defined; only `owner` assigned at launch.
- `.env` only, with a committed `.env.example` per app.
- Daily automated database backups **with a tested restore procedure documented in `docs/`** — a backup nobody has restored is not a backup.

## 8. Performance budget (enforced from Phase 5)

Lighthouse 95+ mobile · LCP < 2.0s · CLS < 0.05 · initial JS < 150 KB gzipped · AVIF/WebP with responsive `srcset` · video < 3 MB with a poster · lazy-load below the fold · preload only the hero font and hero image.

**Motion is split, because the full Section 8 list does not fit 150 KB:**

- **Core (build in Phase 5):** morphing sticky navbar, line-by-line headline reveals, two-layer hero parallax, image-swap hover on product cards.
- **Measured opt-ins (build only if a mid-range phone test keeps us inside budget):** custom cursor, grain overlay, page-transition curtain, magnetic buttons.

Rule: if an effect costs speed, it is removed. Speed is part of premium.

## 9. Open architecture items

1. Data-flow diagrams — **P0-08** (cart lifecycle, checkout, payment capture, COD reconciliation and RTO, order state machine, returns/refunds, inventory reservation, GST calculation).
2. Storefront host choice — P1-03, once the domain is known.
3. SMTP provider choice — Phase 2.
4. Devanagari face confirmation — P0-05.
5. GSTIN status and invoice format — needed before Phase 2 checkout work.
6. Domain ownership and name — affects env, CORS, headers, sitemap.
