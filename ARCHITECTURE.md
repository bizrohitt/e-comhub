# ARCHITECTURE — The House Of Sahas

**Status:** skeleton, Phase 0. Stack is *PROPOSED*, not locked. It locks in task `P0-04` after the discovery answers.
This file is written before any code (Master Prompt Section 12).

---

## 1. Products on one backend

1. **Storefront** — full-stack ecommerce site; homepage is a cinematic landing page.
2. **Admin panel** — store management, extended, role-aware.
3. **Mobile admin app** — run the business from a phone.

All three talk to the same commerce API and share types from `/shared`.

## 2. Monorepo layout (PROPOSED)

```
e-comhub/                      # repo root = the-house-of-sahas/ in Section 12
  MASTER_PROMPT.md  PROJECT_PLAN.md  SESSION_LOG.md
  DESIGN_SYSTEM.md  ARCHITECTURE.md  COPY_BIBLE.md
  OFFERS_PLAYBOOK.md  LICENSES.md  README.md
  skills/            # reusable instruction files (Section 19)
  docs/              # PDF guides (Phase 6)
  backend/           # Medusa: modules, workflows, api, subscribers
  storefront/        # Next.js
    src/features/    # home, shop, product, cart, checkout, account, journal
    src/components/  # ui primitives (Button, Container, Reveal...)
    src/lib/         # api client, helpers, hooks
    src/styles/      # tokens.css, base.css
    content/         # editable page content
  mobile/            # Expo app
  shared/            # types, constants, validators
  integrations/      # payments, shipping, email, messaging
  scripts/           # seed data, tooling
  tests/
```

**Feature folder contract:** every folder under `src/features/<name>/` has `components/`, `hooks/`, `api/`, `types.ts`, `index.ts`. Nothing outside the feature imports from inside it except through `index.ts`. No circular imports. No god files. 600-line cap, 150 to 250 target.

**Homepage sections** live in `storefront/src/features/home/sections/`, one file per section, each independently reorderable from the CMS.

## 3. Technology (PROPOSED — verify license and version at install time)

| Layer | Recommendation | Why | Alternatives considered |
|---|---|---|---|
| Commerce engine | Medusa (MIT) | Headless, modular, built-in admin, extensible workflows, free to self-host | Saleor (BSD-3, heavier); Medusa vs. building custom (rejected: months of work) |
| Storefront | Next.js (MIT) + TypeScript + Tailwind CSS (MIT) | Fast, SEO-friendly, SSR, image optimisation | Astro (great for content, weaker for app-like checkout); Remix |
| Database | PostgreSQL | Reliable, free | — |
| Cache and queues | Redis | Speed, background jobs | — |
| Editable content | Payload CMS (MIT) or MDX/JSON content files | Founder edits pages without code | Content files as the no-database fallback |
| Admin panel | Medusa Admin + custom widgets and routes | Do not rebuild what exists | Separate custom admin (rejected) |
| Mobile app | React Native with Expo (MIT) | One codebase for iOS and Android, shares TS types | Flutter (no type sharing with web) |
| Smooth scroll | Lenis (MIT) | Premium inertia scrolling | — |
| Animation | Motion (MIT) + native CSS scroll-driven animations | Light and flexible | GSAP — excluded: free to use but not an OSI open source license |
| Fonts | Cormorant Garamond + Jost or Inter (SIL OFL), self-hosted | Old money serif plus clean sans | Any non-OFL font — rejected |
| Icons | Lucide (ISC) | Thin, elegant | — |
| Search | Meilisearch (MIT) | Fast typo-tolerant search | Postgres FTS as a Phase 2 fallback to keep infra small |
| Email | React Email (MIT) + an SMTP provider free tier | Branded transactional email | — |
| Analytics | Plausible or Umami, self-hosted | Privacy-friendly, fast | GA4 (privacy + cookie consent burden) |
| Testing | Vitest, Playwright | Free | — |
| Hosting (start) | Free tiers: Vercel/Cloudflare for storefront; small VPS or Railway/Render/Fly for backend | Costs may begin as traffic grows; flag when | — |

**Cost honesty:** the software is free; the operation is not. Domain, hosting at scale, gateway fees per transaction, and email/SMS volume all cost money. Thresholds are tracked in `LICENSES.md`.

## 4. Data flow (to be drawn in P0-08)

Placeholder for the confirmed flow:

```
Browser / Mobile app
   → Storefront (Next.js server components, edge cache)
   → Commerce API (Medusa)
   → PostgreSQL / Redis
   → Integration adapters (payments, shipping, email, messaging, analytics, accounting, feeds)
   → Webhooks back into Medusa workflows
```

To document properly: cart lifecycle, checkout + payment capture + webhook reconciliation, order state machine, returns/refunds, inventory reservations, tax (GST) calculation, content publishing path from CMS to storefront.

## 5. Integration adapters

Every third-party service sits behind an interface in `/integrations/<name>/`, so providers can be swapped without touching core code.

Planned adapters: `payments/`, `shipping/`, `email/`, `messaging/` (SMS/WhatsApp), `analytics/`, `accounting/` (Tally or Zoho export formats), `feeds/` (Google Merchant, social catalog), `reviews/`.

Adapter contract (to be finalised in `skills/skill-integration-adapter.md`): a typed interface, one implementation per provider, provider chosen by env var, no provider SDK imported outside its own folder, failures degrade gracefully, secrets only in env.

## 6. Security baseline (always on)

- Input validation on every boundary.
- Rate limiting on auth, checkout, contact and newsletter endpoints.
- CSRF protection.
- Secure headers (CSP, HSTS, X-Content-Type-Options, Referrer-Policy, Permissions-Policy).
- Hashed passwords; no plaintext anywhere; session rotation.
- Least-privilege roles: owner, manager, support, inventory (final list from Q8).
- No secrets in code; `.env` only, with a committed `.env.example`.
- Webhook signature verification for every payment and shipping callback.

## 7. Environment and config

- `.env` per app (`backend/`, `storefront/`, `mobile/`), each with `.env.example`.
- Shared constants and types in `/shared` — never duplicated per app.
- Feature flags for anything unfinished, so a partial phase never breaks production.

## 8. Open architecture decisions

1. Repo naming: keep `e-comhub` or rename to `the-house-of-sahas`?
2. CMS choice: Payload CMS vs. MDX/JSON content files (depends on Q5 and Q8 — who edits, how often).
3. Search: Meilisearch from Phase 2, or Postgres FTS first and Meilisearch later?
4. Deployment topology: which free tier for the storefront, which host for Postgres + Redis + Medusa.
5. Multi-currency and tax strategy, driven by Q2.
