# PROJECT PLAN — The House Of Sahas

**Status:** Phase 0 complete except P0-05 to P0-08. Stack **LOCKED** (see `ARCHITECTURE.md`). Phase 1 task list approved-pending.
**Last updated:** 2026-10-10
**Rules:** `MASTER_PROMPT.md` Section 4 (non-negotiables), Section 14 (phases), Section 17 (Definition of Done).

---

## How to read this file

- Task IDs are `P<phase>-<nn>`, e.g. `P1-03`.
- A task fits one focused session and touches roughly 1 to 3 files.
- No task starts until the founder says **"go"** on its plan.
- No task finishes until every item in the Definition of Done passes.
- Statuses: `Not started` · `Planned` · `In progress` · `Blocked` · `Done`.

---

## Phase 0 answers — CONFIRMED 2026-10-10

| Q | Answer | Consequence for the build |
|---|---|---|
| **Q1 Catalogue** | 10–20 products at launch. Sizes + colours as variants. Made-to-measure **out** at launch. | A tight, deliberate edit. Shop and collection layouts must be editorial (large cards, generous air) so the catalogue never looks thin. Homepage may need 3 collection panels instead of 4 if Footwear or Accessories carries only 2–3 pieces. Seeding is a small, hand-curated dataset. |
| **Q1b Womenswear** | Menswear only at launch. | One fit/size logic, one editorial register. Architecture stays gender-neutral so womenswear can be added later without rework. |
| **Q2 Market** | India only. INR. **English + Hindi.** GST invoicing required. | Single currency, single tax regime — but i18n is now a Phase 1 foundation task, not an afterthought. **Hindi needs Devanagari fonts**; Cormorant Garamond, Inter and Jost have no Devanagari coverage (see `ARCHITECTURE.md` §3). Hindi copy needs native-quality review. |
| **Q3 Payments** | Razorpay + **capped COD** (below a value cap, phone confirmation). | One payment adapter. COD reconciliation and RTO handling are Phase 2 requirements. Cap value blocked on price points and margin data. |
| **Q4 Shipping** | Shiprocket. Free shipping on all prepaid orders. 15-day returns/exchanges. 30 days complimentary alterations. | One shipping adapter. Free shipping and alterations are margin decisions — see Risk R1. Proposal on the table: alterations limited to suits and tailored pieces. |
| **Q5 Skills** | Non-technical founder. TypeScript everywhere. The AI co-founder owns deployment configuration. | Max two commands to run anything. Every deliverable ships with copy-paste run and test commands. Backups and deploys must be near-automatic. The Phase 6 PDF guide is a launch deliverable, not a nice-to-have. |
| **Q6 Budget** | ₹0–₹2,000/month. Domain not yet owned. | One small VPS for Medusa + Postgres + Redis (+ Umami). Storefront on a free-tier host. **Meilisearch deferred**; Postgres full-text search first. Payload CMS deferred to Phase 6. Spend thresholds tracked in `LICENSES.md`. |
| **Q7 Assets** | No logo, no photography, no lookbook. | Licensed placeholders (Unsplash/Pexels) with each image's terms recorded. A typographic wordmark in Cormorant Garamond is proposed in Phase 4 at zero cost. **Photoshoot brief is a launch blocker for the hero** — a cinematic hero on stock imagery cannot hold authority. |
| **Q8 Team** | Founder only at launch. | One owner account. Manager, support and inventory roles are **defined in code but unassigned**, so adding staff later needs no refactor. Least privilege from day one. |
| **Q9 Launch** | No fixed date. Quality first. **No checkpoints.** | Milestone-free, date-free. Accepted by the co-founder. Residual risk recorded as R2: Phase 5 polish can expand indefinitely. I will still warn when any phase exceeds its estimate — that is Rule 16, not a checkpoint. |

## Phase status board

| Phase | Focus | Output | Status |
|---|---|---|---|
| 0 | Discovery and decisions | Confirmed answers, locked stack | **In progress** (P0-05 to P0-08 remain) |
| 1 | Foundation | Repo, tooling, Medusa running, DB, env, linting, CI, `LICENSES.md` | Planned — awaiting "go" |
| 2 | Commerce core (functionality only) | Products, cart, checkout, payments, orders, emails, plain pages | Not started |
| 3 | Admin panel | Roles, custom widgets, content blocks, reports | Not started |
| 4 | Design system and styling pass | Tokens, components, all pages styled | Not started |
| 5 | Homepage and motion pass | Sections, parallax, morphing navbar, transitions, performance tuning | Not started |
| 6 | Content and CMS | Editable pages, journal, SEO, PDF guide | Not started |
| 7 | Mobile admin app | Auth, orders, products, inventory, analytics, push | Not started |
| 8 | Growth features | Offers, membership, outfit builder, booking | Not started |
| 9 | QA and launch | Tests, accessibility, Lighthouse, security review, deployment, monitoring | Not started |

**Launch is possible after Phase 6.** Phase 7 onward adds the mobile admin app, growth features and hardening.

---

## Phase 0 — task list

| ID | Task | Files | Acceptance criteria | Sessions | Status |
|---|---|---|---|---|---|
| P0-01 | Save master prompt verbatim; create knowledge skeletons and `skills/` stubs | 9 knowledge files, 11 skill stubs, `docs/` | All present; master prompt matches founder text; every file under 600 lines | 1 | **Done** |
| P0-02 | Ask Section 5 discovery questions with recommended defaults | — | Nine questions delivered, numbered, each with a default | 1 | **Done** |
| P0-03 | Receive answers, summarize back, confirm | `PROJECT_PLAN.md`, `SESSION_LOG.md` | All nine answers recorded with consequences; confirmed by founder | 2 | **Done** |
| P0-04 | Lock the technology stack | `ARCHITECTURE.md`, `LICENSES.md` | Every layer chosen with license recorded; alternatives and deferrals justified | 1 | **Done** |
| P0-05 | Fill `DESIGN_SYSTEM.md` — tokens, fluid type scale, spacing, component inventory, motion rules | `DESIGN_SYSTEM.md` | Token table confirmed; contrast measured to WCAG AA; Devanagari pairing resolved | 1 | Not started |
| P0-06 | Fill `COPY_BIBLE.md` — voice, banned words, headline formulas, homepage copy in EN + HI | `COPY_BIBLE.md` | Two variants per key line, one recommended; Hindi variants flagged for native review | 2 | Not started |
| P0-07 | Fill `OFFERS_PLAYBOOK.md` — launch, welcome, bundle, loyalty, win-back | `OFFERS_PLAYBOOK.md` | Each offer has psychology, exact copy, rules, margin check, metric. **Blocked on price and cost data** | 1 | Blocked |
| P0-08 | Complete `ARCHITECTURE.md` data flow — cart, checkout, COD reconciliation, order states, returns, tax | `ARCHITECTURE.md` | Each flow documented end to end with failure modes | 1 | Not started |
| P0-09 | Generate the Phase 1 task list | `PROJECT_PLAN.md` | List below, approved by founder | 1 | **Done** |

---

## Phase 1 — Foundation (task list, awaiting your "go")

Goal of the phase: a running, seeded, linted, tested, CI-covered monorepo. **No styling, no homepage, no motion.** Functionality and structure only.

| ID | Task | Files | Acceptance criteria | Sessions |
|---|---|---|---|---|
| **P1-01** | Root workspace scaffolding | `package.json` (npm workspaces), `.gitignore`, `.nvmrc`, `tsconfig.base.json` | `npm install` at root completes with no errors; workspaces resolve | 1 |
| **P1-02** | Shared package foundation | `shared/package.json`, `shared/tsconfig.json`, `shared/src/index.ts`, `shared/src/types/product.ts` | Type-checks; storefront and backend can both import from `@houseofsahas/shared` | 1 |
| **P1-03** | Environment conventions | `backend/.env.example`, `storefront/.env.example`, `docs/ENVIRONMENT.md` | Every variable documented in plain language for a non-technical owner; copying `.env.example` to `.env` is enough to run | 1 |
| **P1-04** | Local infrastructure in two commands | `docker-compose.yml`, `docs/LOCAL_SETUP.md` | Founder runs two commands and Postgres + Redis are up and reachable | 1 |
| **P1-05** | Medusa backend installed and booting | `backend/package.json`, `backend/medusa-config.ts`, `backend/src/api/health/route.ts` | `npm run dev` starts; `/health` returns 200; Medusa admin loads | 2 |
| **P1-06** | Migrations and curated seed data | `scripts/seed/products.json`, `scripts/seed/index.ts`, `backend/src/scripts/README.md` | 10–20 products across 3–4 collections with size/colour variants, INR prices, GST-ready tax fields; visible in admin | 2 |
| **P1-07** | Storefront scaffold | `storefront/package.json`, `storefront/next.config.ts`, `storefront/src/styles/tokens.css`, `storefront/src/app/page.tsx` | `npm run dev` renders a plain page; the six color tokens exist as CSS variables; feature folder contract in place. **No styling work** | 2 |
| **P1-08** | i18n foundation (EN + HI) | `storefront/src/i18n/*`, `messages/en.json`, `messages/hi.json`, Devanagari font files | Language switch renders the same plain page in English and Hindi; no untranslated-key leaks; Devanagari renders correctly | 2 |
| **P1-09** | Lint, format and type-check | `eslint.config.js`, `.prettierrc`, root `npm run check` | One command runs lint + format check + tsc across all workspaces and passes | 1 |
| **P1-10** | Testing baseline | `vitest.config.ts`, `playwright.config.ts`, `tests/smoke.spec.ts` | Unit and one end-to-end smoke test run green locally | 1 |
| **P1-11** | CI workflow | `.github/workflows/ci.yml` | On push and PR: install, lint, typecheck, test. Green run recorded on the branch | 1 |
| **P1-12** | License audit | `LICENSES.md`, `scripts/license-audit.ts` | Every installed dependency, font and placeholder image recorded with version, license and link; no GPL/AGPL; audit script re-runnable | 1 |

**Phase 1 total: ~16 sessions.** Phase 1 is complete when all twelve tasks are `Done` and CI is green.

**Deferred out of Phase 1 (recorded so nothing is lost):** Meilisearch (Postgres FTS first), Payload CMS (Phase 6), the Expo mobile app (Phase 7), all motion libraries except their installation point (Phase 5), all visual styling (Phase 4).

---

## Decisions log

| Date | Decision | Reason | Revisit when |
|---|---|---|---|
| 2026-10-10 | Repo root `e-comhub` is the monorepo root from Section 12 | Founder will connect a different repo later; all Phase 0 files are portable plain Markdown | When the founder re-points the workspace |
| 2026-10-10 | GSAP excluded | Free to use but not an OSI open source license (Rules 8, 9) | Only on explicit founder approval |
| 2026-10-10 | Meilisearch deferred; Postgres full-text search at launch | ₹2,000/month ceiling; a second service does not fit | When search quality or budget changes |
| 2026-10-10 | Content in typed JSON/MDX files first; Payload CMS added in Phase 6 | No extra infra early, and the section schema stays identical, so Phase 6 is an editing UI over existing data — no rework | Phase 6 |
| 2026-10-10 | Inter for Latin body text + an OFL Devanagari face for Hindi | Cormorant Garamond, Inter and Jost have **no Devanagari coverage**; Hindi would render as boxes | P0-05 |
| 2026-10-10 | Roles defined but unassigned; single owner account | Q8: founder only at launch | When staff are hired |
| 2026-10-10 | No launch date, no checkpoints | Q9: founder's explicit choice | If a phase exceeds its estimate |
| 2026-10-10 | Section 8 motion split into **core** (navbar morph, line reveals, two-layer parallax, image-swap hover) and **measured opt-ins** (custom cursor, grain, curtain, magnetic buttons) | The full list conflicts with the 150 KB gzipped JS budget | Phase 5, measured on a mid-range phone |

## Open questions

1. **Do you have a GSTIN?** Invoice format, HSN codes and e-invoicing obligations all depend on it. Needed before Phase 2 checkout work.
2. **Price points and cost price** for the 10–20 launch products. Blocks P0-07 (offers) and the COD value cap.
3. **Do you own the domain?** If not, which name — this affects env config, CORS and secure headers in P1-03.
4. Hindi copy: I can draft it, but it needs a native-quality review before launch. Who reviews it?
5. Is the alterations promise for all products, or suits and tailored pieces only? (Margin question.)
6. Which repo will you connect, and do you want this branch pushed so the Phase 0 work travels with you?

## Risks

| ID | Risk | Impact | Mitigation |
|---|---|---|---|
| R1 | Free shipping **plus** 30-day complimentary alterations on the same order erodes margin | Silent loss on every order | Needs Q on price/cost data. Proposal: alterations on suits and tailored pieces only; free shipping stays unconditional on prepaid |
| R2 | No date and no checkpoints; Phase 5 motion polish expands indefinitely | Store never earns | Accepted by founder. I will warn whenever a phase exceeds its session estimate |
| R3 | No photography, and the hero depends on it | Site looks cheap regardless of code quality | Photoshoot brief in Phase 4; treat as launch blocker; placeholders licensed and recorded meanwhile |
| R4 | COD on premium menswear → high return-to-origin | Cash tied up, reverse logistics cost | Value cap + phone confirmation; measure RTO rate from the first order |
| R5 | Non-technical owner running a self-hosted backend | Store down with no one able to fix it | Two-command local setup, one-command deploy, automated daily backups with a tested restore, plain-language runbook in `docs/` |
| R6 | Hindi i18n added late | Rework across every string and page | Foundation task P1-08; no hard-coded UI strings from day one |
| R7 | Free tiers end as traffic grows | Sudden monthly cost | Threshold table in `LICENSES.md`; flagged before it bites |
| R8 | Legal: GST, returns, privacy, cookie consent, image and font licensing | Fines, takedowns | `LICENSES.md` enforced from P1-12; legal checklist in Phase 9 |
