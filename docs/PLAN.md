# PLAN — e-comhub

**Thesis:** 129 genuinely free, genuinely fast tools that ecommerce operators already search for by
name. Each tool page is a ranked SEO landing page, a trust-builder and a lead magnet. Traffic
compounds; monetization comes later and stays optional.

**Status:** Phase 0 in progress (Task 0 complete, awaiting founder approval of the stack).
**Last updated:** 2026-10-09

---

## 1. Why this can work

- **Tool-intent keywords convert into links and repeat visits.** People bookmark a calculator they
  trust; nobody bookmarks a blog post.
- **Competitors monetize these with signup walls.** Our wedge is: no signup, no email gate, instant
  result, works offline-ish in the browser. That is a positioning advantage, not just a feature.
- **Marginal cost per tool approaches zero** once the plugin architecture exists. Tool #80 should
  take 90 minutes, not a day. The whole plan is built around protecting that property.
- **Marginal cost per visitor approaches zero** because client-side tools mean a static-cacheable
  HTML page per tool. Cloudflare serves most traffic; our origin barely works.

**The one metric that matters per phase:** time-to-add-a-new-tool (P1–P3), then indexed tool pages
(P4–P5), then organic clicks (P6+).

---

## 2. Final stack recommendation

Mostly as briefed. **Eight changes**, each with the reason in one line. Full ADRs in `DECISIONS.md`.

| Layer | Final choice | Change vs brief? |
|---|---|---|
| Runtime | Python 3.11+ (3.12 preferred) | — |
| Backend | **Django 5.2 LTS** (5.2.18) | ✅ pinned to LTS, not 6.x |
| API | **None yet.** Plain Django views + HTMX partials | ✅ Django Ninja deferred to P6 |
| Frontend | Django templates + **HTMX 2** + **Alpine 3 CSP build** | ✅ CSP build, not standard build |
| JS delivery | Self-hosted ES modules, per-page `<script type="module">`, no bundler | ✅ explicit |
| CSS | One hand-written `base.css` with CSS custom properties | ✅ **Tailwind deferred to P7** |
| DB | SQLite (dev + first prod), Postgres when a host gives it free and durable | ✅ SQLite is prod-viable here |
| Cache | Django LocMem (dev) / file or SQLite cache (prod). No Redis | — |
| Admin | **Default Django admin** + custom dashboard views | ✅ django-unfold deferred to P7 |
| Jobs | None. Management commands + cron | — |
| Static | WhiteNoise + Cloudflare free | — |
| Hosting | **Oracle Cloud Always Free Arm VM** + Caddy, Cloudflare in front | ✅ not Render/Fly/Railway |
| Lint/format | **Ruff** (one tool, replaces black + flake8 + isort) | ✅ added |
| Tests | **pytest + pytest-django** (Python) **+ `node --test`** (browser formulas) | ✅ JS suite added |
| AI tools | Rule/template engines. LLM = feature-flagged, **bring-your-own-key, browser-only** | ✅ sharpened |

### The eight changes, defended

1. **Django 5.2 LTS, not 6.x.** 5.2 is security-supported to **April 2028**; 6.0 dies April 2027 and
   6.1 December 2027. Choosing 6.x signs a solo founder up for two forced upgrades inside 18 months.
   5.2 also runs on Python 3.11, which every free host and this dev box already has (6.x needs 3.12+).
   *Cost:* we lose Django 6.0's built-in CSP and template partials — replaced by a ~30-line CSP
   middleware in `core/` and ordinary `{% include %}`. Revisit at **6.2 LTS (April 2027)**.
2. **No Django Ninja yet.** Nothing in P0–P5 needs typed JSON endpoints. Every dependency is a
   license to audit, a CVE to track and a version to bump. Add it in P6 *only* when we ship the
   public embed/API tier, which is the first real use case.
3. **Alpine CSP build + `Alpine.data()`.** The normal Alpine build evaluates `x-data="{...}"` strings
   at runtime and therefore needs `script-src 'unsafe-eval'`, which caps our Best-Practices score and
   weakens XSS defence on pages that accept user text. The CSP build forbids inline expressions and
   requires components registered in external files. **Doing this from tool #1 costs nothing; retrofitting
   it across 120 tool templates later costs a week.**
4. **No Tailwind until Phase 7.** The brief says "functionality first, no polish". Tailwind adds a
   binary, a watcher and a build step to produce styling we have explicitly agreed not to do yet.
   One ~6 KB `base.css` driven by CSS variables gives us responsive, accessible, readable pages now,
   and at P7 the design phase is a token swap (or a clean Tailwind introduction) with zero logic change.
5. **SQLite in production (at first).** This is a read-mostly site where most tools never touch the
   DB. SQLite in WAL mode on one VM handles this traffic class easily, backs up with a file copy, and
   removes an entire moving part. We stay ORM-pure so Postgres is a settings change the day writes
   justify it.
6. **Oracle Cloud Always Free, not Render free.** Verified 2026-10-09: Render's free web services
   **sleep after ~15 minutes idle** and its free Postgres **expires 30 days after creation**;
   Railway and Fly no longer have standing free tiers for new accounts. A sleeping origin means
   Googlebot and the first real visitor of the hour eat a cold start — fatal for a site whose entire
   strategy is speed and crawl coverage. Oracle Always Free (2 Arm OCPU / 12 GB as of June 2026, card
   required at signup) is always-on. *Risk:* idle instances can be reclaimed and signup can be
   finicky — so **Plan B** is a ~€4/month Hetzner box, and the deploy must be a 20-minute rebuild
   from a documented script either way.
7. **Default admin first.** The Phase 2 deliverable is *control* (toggle a tool, edit its SEO, see
   usage), not a pretty dashboard. Default admin + three custom views ships that in one phase with
   zero dependencies. django-unfold is MIT and can be added in P7 as pure styling.
8. **Ruff + a JS test suite.** Ruff replaces three tools with one. `node --test` is built into Node
   22 (zero dependencies) and lets us unit-test the browser formulas — without it, "compute in the
   browser" would mean "the formulas are untested", which is unacceptable for money math.

### Two things I will not pretend about

- **"100% free" and LLMs are incompatible.** Every "AI" tool in the catalog is a deterministic
  template/rule engine — which, for headline and description generators, is often *better* (instant,
  private, no hallucinated product claims). If we ever want true LLM output, the honest options are:
  user pastes their own API key (stored in their browser only), or a self-hosted small model on a
  paid box. Both are feature-flagged and off by default.
- **Platform fee calculators go stale.** Shopify/Amazon/Etsy change fees without warning. Every fee
  table carries `source_url` + `checked_on`, renders "fees verified on X", and has a quarterly review
  task. A wrong fee number is a trust-destroying bug, not a cosmetic one.

---

## 3. Phase roadmap

Each phase ends with: a demo, a green `scripts/check.sh`, and a `SESSION_LOG.md` entry.

| # | Phase | Outcome | Exit criteria | Tasks |
|---|---|---|---|---|
| 0 | Foundation | Repo, docs, skills, Django skeleton, base template, checks | `scripts/check.sh` green; `/healthz` returns 200 | P0-T01…05 |
| 1 | Core platform | Tool registry + generic tool page + IA + SEO plumbing | A new tool folder appears on home, category, search, sitemap with **zero core edits** | P1-T01…10 |
| 2 | Admin panel | Founder controls the site without deploying | Disable a tool and rewrite its title/FAQ from admin; change is live in <60 s | P2-T01…06 |
| 3 | First 10 tools | The ecommerce money calculators | 10 tools live, each with tests, FAQ schema, worked example; **<90 min to add tool #11** | P3-T01…12 |
| 4 | Growth layer | Capture, share, export, measure | Consented lead flow works end-to-end; share links restore state; usage counters aggregate | P4-T01…07 |
| 5 | Tool batches 2–5 | Marketing, copy, developer, SEO (10 per batch) | 60+ tools live, catalog statuses accurate | P5-* |
| 6 | Hardening | Speed, security, backups, API/embeds | Lighthouse mobile 95+ on 5 sampled pages; security checklist green; restore test passes | P6-* |
| 7 | Design | Brand + polish, **only on founder's word** | Tokens swapped, zero logic diff, budgets still met | P7-* |
| 8 | Launch & scale | Live, indexed, promoted | Sitemap submitted, 100% of tool pages indexable, first 10 backlinks | P8-* |

**Working sequence note:** Phases 1–3 are deliberately ordered so the *architecture is proven by a
dummy tool before the first real tool is written*. If adding the dummy tool in P1-T04 requires
touching core code, the registry is wrong and P1 is not done.

---

## 4. Milestones (sequence, not calendar — 1 "session" ≈ 1 task)

| Milestone | Definition of hit |
|---|---|
| **M1 — Skeleton walks** | `runserver` serves a styled-enough base page, `/healthz` 200, checks green |
| **M2 — Plugin proven** | Dummy tool auto-registers everywhere; `manage.py check_tools` validates specs |
| **M3 — Founder in control** | Admin toggles + SEO overrides live |
| **M4 — First money tool** | Profit margin calculator passes tests, renders <50 KB, FAQ schema valid |
| **M5 — Ten tools** | Catalog shows 10 `live`; internal linking hub per category |
| **M6 — Growth loop closed** | Share link + copy result + consented email capture + usage counts |
| **M7 — Sixty tools** | Four category hubs are genuinely useful destinations |
| **M8 — Hardened** | Budgets, headers, rate limits, backups, restore drill |
| **M9 — Public** | Deployed, indexed, submitted to directories |

---

## 5. Architecture decisions locked for P0–P3

1. **One tool = one folder** under `tools/<category>/<slug>/` exporting `TOOL: ToolSpec`.
2. **One formula, one place.** `mode="client"` → formula in `static/js/lib/<name>.mjs` tested by
   `node --test`. `mode="server"` → formula in `logic.py` tested by pytest. **`hybrid` requires an
   ADR** explaining why duplication is acceptable (usually: it isn't).
3. **No Django imports in formula code.** Pure functions in, plain data out.
4. **The registry is the single source of truth** for URLs, nav, sitemap, search index and admin rows.
   DB `ToolMeta` rows only *override* presentation (title, description, FAQ, enabled, featured, order).
5. **Analytics are aggregates, not events.** `UsageDaily(tool, date, count)` incremented with `F()`
   through a cache buffer. A row per click would bloat the DB and buy nothing.
6. **Progressive enhancement.** A client tool without JS still renders its form, explanation, formula,
   worked example and FAQ — the SEO content never depends on JS.
7. **Reference data has provenance.** `_data/*.yaml` (or JSON) with `source_url`, `checked_on`,
   `review_every_days`; the page prints the verified date.

---

## 6. Risks and mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Google treats 120 tool pages as thin/templated spam | Medium | High | Unique worked examples, real formulas, original FAQs, no auto-spun variants; ship variants only where the content genuinely differs |
| Formula bug in money math destroys trust | Medium | High | Unit tests with edge cases on every formula; cite the formula on the page; "report an issue" link on every tool |
| Platform fee data goes stale | High | Medium | Provenance metadata + visible verified date + quarterly review task |
| Free host reclaims the VM | Medium | High | Rebuild script + nightly off-box backup; Plan B paid box costs ~€4 |
| Scope creep: 120 tools, zero shipped | High | High | Phase gates; a tool is only "live" when its catalog row says so; batches of 10 |
| Agent context exhaustion mid-task | High | Medium | One task per session, 5-file cap, mandatory session log |
| Trademark/brand misuse on platform tools | Low | Medium | Nominative use only ("fee calculator for Shopify"), no logos, explicit "not affiliated" line |
| Adding a tool starts requiring core edits | Medium | High | `manage.py check_tools` in CI; P1-T04 dummy-tool test asserts zero core diff |

---

## 7. What we are deliberately NOT building

Accounts/login, a bundler/SPA, Redis, Celery, Docker-in-dev, a design system, a blog CMS beyond a
simple `Page` model, multi-currency FX fetching (static rates + user input instead), server-side
image processing (browser WASM only), and anything that stores a user's business data.

---

## 8. Open questions for the founder (max 3)

1. **Brand name + domain** — "e-comhub" is the repo name. Keep it, or is a different public name
   coming? Needed before P1-T05 (home page copy) and P8 (deployment).
2. **Audience bias** — if I must choose, do we optimise for **Shopify dropshippers/SMB sellers**
   (volume, low intent) or **established 7-figure DTC brands** (fewer, better links, agency reach)?
   Default assumption: SMB sellers first, because the search volume is where the compounding is.
3. **Geography of the money examples** — default currency and tax framing: USD/global, or INR/GST
   first? Default assumption: USD default with a currency selector, since the keywords are global.

*(Per the brief, I've stated defaults and will proceed on them if you don't answer.)*
