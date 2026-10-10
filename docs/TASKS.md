# TASKS — e-comhub

**Board state:** 2 done · 0 doing · 38 todo (of 40 planned through Phase 4)
**Current phase:** 0 — Foundation
**Next task:** `P0-T03`

---

## How to use this board

- **One task per session.** Pick the next `todo` whose dependencies are all `done`.
- Estimates: **S** <150 new lines · **M** 150–350 · **L** 350–500 (never more; split it instead).
- A task is `done` only when every box in `docs/MASTER_PROMPT.md` §12 is ticked and
  `scripts/check.sh` is green.
- Update the status line here *in the same session* you do the work, then write the session log.

Status values: `todo` · `doing` · `review` · `done` · `blocked`

---

## Phase 0 — Foundation

### P0-T01 · Knowledge base, skills, plan, task board · M · **done**
**Depends:** — · **Files:** `AGENTS.md`, `docs/*.md`, `.agent/skills/*.md`, `scripts/*.sh`, `.gitignore`, `README.md`
**Accept:** all 13 knowledge files + 14 skills exist with real content; `check_line_limit.sh` passes; stack proposal + 40 tasks drafted.

### P0-T02 · Tooling and dependency baseline · S · **done**
**Depends:** P0-T01 · **Files:** `pyproject.toml`, `requirements/{base,dev,prod}.txt`, `.env.example`, `.github/workflows/ci.yml`, `scripts/check.sh`
**Accept:** ✅ Django 5.2.18 + whitenoise 6.12.0 + python-dotenv 1.2.4 pinned and installed clean on Python 3.11.2; ruff 0.16.10 lint + format green; `scripts/check.sh` gates line limit → ruff → django check → pytest → `node --test`, skipping what doesn't exist yet; CI matrix 3.11/3.12 on every push; all pins recorded in `LICENSES.md`.

### P0-T03 · Django skeleton and settings split · M · todo
**Depends:** P0-T02 · **Files:** `manage.py`, `config/settings/{base,dev,prod}.py`, `config/urls.py`, `config/wsgi.py`, `core/views.py`
**Accept:** `runserver` boots on SQLite; `/healthz` returns 200 JSON; secrets read from env only; `DEBUG=False` works with WhiteNoise; `manage.py check --deploy` has no critical warnings in prod settings.

### P0-T04 · Base template, CSS tokens, static pipeline · M · todo
**Depends:** P0-T03 · **Files:** `templates/base.html`, `templates/partials/{header,footer}.html`, `static/css/base.css`, `static/js/vendor/*`
**Accept:** semantic responsive shell with skip-link, visible focus, 44px targets; `base.css` <10 KB and starts with a `:root` token block; htmx 2 + alpine-csp pinned and self-hosted (not loaded globally); page weight <50 KB.

### P0-T05 · Test harness and first smoke tests · S · todo
**Depends:** P0-T03 · **Files:** `pytest.ini`-in-`pyproject.toml`, `tests/python/test_smoke.py`, `tests/js/example.test.mjs`, `scripts/check.sh`
**Accept:** `pytest -q` green; `node --test tests/js` green; `scripts/check.sh` runs all four gates and fails loudly on any one.

---

## Phase 1 — Core platform

### P1-T01 · Tool spec dataclasses · S · todo
**Depends:** P0-T05 · **Files:** `tools/base.py`, `tests/python/test_base.py`
**Accept:** frozen dataclasses `ToolSpec`, `FAQ`, `Variant`, `DataSource` exactly as in `ARCHITECTURE.md` §3; `__post_init__` validation with clear error messages; 100% branch coverage on validation.

### P1-T02 · Registry with auto-discovery and validation · M · todo
**Depends:** P1-T01 · **Files:** `tools/registry.py`, `tools/management/commands/check_tools.py`, `tests/python/test_registry.py`
**Accept:** discovers `tools/*/*/tool.py` at startup; duplicate slug, bad category, missing FAQ, dangling `related`, stale `data_sources` each fail with a named error; `manage.py check_tools` exits non-zero on any; discovery adds <50 ms to boot.

### P1-T03 · Generic tool views, URLs and page shell · M · todo
**Depends:** P1-T02 · **Files:** `tools/urls.py`, `tools/views.py`, `templates/tools/tool_page.html`, `tests/python/test_tool_views.py`
**Accept:** `/tools/<category>/<slug>/` renders any registered tool; disabled tools 404; `/run/` endpoint exists for server mode with CSRF; ≤3 queries per page; variant URLs resolve.

### P1-T04 · Dummy tool + zero-core-change proof · S · todo
**Depends:** P1-T03 · **Files:** `tools/developer/example_calculator/*`, `tests/python/test_plugin_contract.py`
**Accept:** adding only this folder makes the tool appear on home, category page, search and sitemap; a test asserts no file outside the tool folder was needed; **this is the Phase 1 gate**.

### P1-T05 · Home page · M · todo
**Depends:** P1-T04 · **Files:** `pages/views.py`, `pages/urls.py`, `templates/pages/home.html`, `tests/python/test_pages.py`
**Accept:** categories + featured tools + full tool list rendered from the registry; one `<h1>`; promise + 3-step "how it works" + trust line from `COPY_GUIDE.md`; <50 KB; no JS required.

### P1-T06 · Category hub pages · S · todo
**Depends:** P1-T05 · **Files:** `pages/views.py`, `templates/pages/category.html`
**Accept:** `/tools/<category>/` lists its tools with descriptions, intro copy and cross-links to sibling categories; breadcrumbs; unique title/description per category.

### P1-T07 · Search · M · todo
**Depends:** P1-T06 · **Files:** `pages/search.py`, `templates/pages/search.html`, `static/js/tools/search.mjs`
**Accept:** instant client-side filter over a small JSON index (<15 KB) plus a server-rendered `/search/?q=` fallback that works with JS off; zero-result queries recorded (stub until P2 model exists); keyboard accessible.

### P1-T08 · SEO core helpers · M · todo
**Depends:** P1-T03 · **Files:** `core/seo.py`, `core/templatetags/core_tags.py`, `templates/partials/{breadcrumbs,faq}.html`, `tests/python/test_seo.py`
**Accept:** title/description builders enforce length limits; canonical, OG and Twitter tags; JSON-LD for `SoftwareApplication`, `FAQPage`, `BreadcrumbList` emitted with a CSP nonce and validating against schema.org shapes in tests.

### P1-T09 · sitemap, robots, error pages, redirects · S · todo
**Depends:** P1-T08 · **Files:** `config/urls.py`, `core/sitemaps.py`, `templates/{404,500}.html`, `core/middleware.py`
**Accept:** sitemap built from the registry with real `lastmod`, excludes disabled/noindex tools; robots.txt references it; 404/500 are useful pages with search + popular tools; redirect lookup adds 0 queries on a cache hit.

### P1-T10 · Legal pages and cookie stance · S · todo
**Depends:** P1-T05 · **Files:** `templates/pages/legal/{privacy,terms,cookies,disclaimer}.html`, `pages/urls.py`
**Accept:** GDPR/CCPA-aware privacy policy that matches reality (no trackers, no stored tool inputs); per-tool "your data stays in your browser" line rendered only when `mode == client`; no cookie banner needed because no non-essential cookies are set — stated explicitly.

---

## Phase 2 — Admin panel

### P2-T01 · Core models and migrations · M · todo
**Depends:** P1-T09 · **Files:** `tools/models.py`, `core/models.py`, `pages/models.py`, migrations, `tests/python/test_models.py`
**Accept:** `ToolCategory`, `ToolMeta`, `SiteSetting`, `FeatureFlag`, `Redirect`, `Page` per `ARCHITECTURE.md` §4; sensible indexes and `unique` constraints; no model stores tool inputs or raw IPs.

### P2-T02 · Registry↔DB sync and override resolution · M · todo
**Depends:** P2-T01 · **Files:** `tools/management/commands/sync_tools.py`, `tools/services.py`, `tests/python/test_overrides.py`
**Accept:** `sync_tools` creates/updates `ToolMeta`+`ToolCategory` rows idempotently and never deletes data; override resolution is `DB value → spec value`; resolved metadata cached and invalidated on save; tool pages still ≤3 queries.

### P2-T03 · Admin registration and roles · M · todo
**Depends:** P2-T02 · **Files:** `tools/admin.py`, `core/admin.py`, `pages/admin.py`, `adminpanel/apps.py`
**Accept:** list displays with search/filter, bulk enable/disable/feature actions; groups `superadmin`/`editor`/`support` with least-privilege permissions; editors cannot change settings or users.

### P2-T04 · Founder dashboard · M · todo
**Depends:** P2-T03 · **Files:** `adminpanel/views.py`, `adminpanel/urls.py`, `templates/adminpanel/dashboard.html`
**Accept:** one screen showing 30-day usage, top/bottom tools, lead count, zero-result searches, tools whose reference data is stale, and last 10 errors; loads in <300 ms with aggregate queries only.

### P2-T05 · Live SEO editing · S · todo
**Depends:** P2-T04 · **Files:** `tools/admin.py`, `tools/services.py`, `templates/adminpanel/preview.html`
**Accept:** editing title/description/FAQ in admin changes the live page within 60 s without deploy; character counters and SERP preview in the form; invalid lengths blocked at validation.

### P2-T06 · Audit log, feature flags, site settings · M · todo
**Depends:** P2-T05 · **Files:** `adminpanel/models.py`, `adminpanel/signals.py`, `core/flags.py`, `tests/python/test_flags.py`
**Accept:** every admin create/update/delete writes an `AuditLog` row with a field-level diff; `flag("name")` helper is cached and used by at least one template; `SiteSetting` drives site name, contact email and rate limits.

---

## Phase 3 — First 10 tools

### P3-T01 · Calculation kernel and shared tool UI · M · todo
**Depends:** P2-T02 · **Files:** `core/utils/money.py`, `static/js/lib/{money,format}.mjs`, `templates/partials/tool_{form,result,actions}.html`, `tests/js/money.test.mjs`
**Accept:** half-up currency rounding, safe division (no `NaN`/`Infinity` ever reaches the DOM), percent helpers, locale-aware number formatting; shared "Copy result / Load example / Reset / Share" action bar; identical rounding behaviour proven in both Python and JS tests.

### P3-T02 · Profit margin calculator · S · todo
**Depends:** P3-T01 · **Files:** `tools/ecommerce/profit_margin_calculator/*`, `static/js/{lib/margin.mjs,tools/profit-margin-calculator.mjs}`, `tests/js/margin.test.mjs`
**Accept:** margin, markup, profit and break-even price from cost/price/fees/shipping; zero, negative, huge and empty inputs handled; formula + worked example on page; FAQ schema valid; <50 KB.

### P3-T03 · Break-even ROAS calculator · S · todo
**Depends:** P3-T02 · **Files:** `tools/ecommerce/break_even_roas_calculator/*`, `static/js/lib/roas.mjs`, `tests/js/roas.test.mjs`
**Accept:** break-even ROAS from margin %, with profit-target ROAS and a sensitivity row; explains why break-even ROAS = 1 / margin; edge cases tested.

### P3-T04 · Break-even CPA calculator · S · todo
**Depends:** P3-T03 · **Files:** `tools/ecommerce/break_even_cpa_calculator/*`, reuses `static/js/lib/roas.mjs`
**Accept:** max allowable CPA from AOV, margin and target profit; cross-links to ROAS tool; **no formula duplicated** — imports the shared module.

### P3-T05 · Pricing and markup calculator · S · todo
**Depends:** P3-T04 · **Files:** `tools/ecommerce/markup_calculator/*`, reuses `static/js/lib/margin.mjs`
**Accept:** price from cost + target margin or markup, with a margin↔markup conversion table; clearly explains the difference (the #1 confusion in this keyword cluster).

### P3-T06 · Discount and coupon impact calculator · M · todo
**Depends:** P3-T05 · **Files:** `tools/ecommerce/discount_impact_calculator/*`, `static/js/lib/discount.mjs`, `tests/js/discount.test.mjs`
**Accept:** shows new margin, profit per order and the extra unit volume needed to break even on the discount; loss-aversion framing handled truthfully.

### P3-T07 · Average order value calculator · S · todo
**Depends:** P3-T06 · **Files:** `tools/ecommerce/aov_calculator/*`, `static/js/lib/store_metrics.mjs`
**Accept:** AOV from revenue/orders plus "what AOV would you need for target revenue" reverse mode; division-by-zero guarded.

### P3-T08 · Conversion rate calculator · S · todo
**Depends:** P3-T07 · **Files:** `tools/ecommerce/conversion_rate_calculator/*`, reuses `static/js/lib/store_metrics.mjs`
**Accept:** CR from sessions/orders, revenue-per-session, and the traffic needed for a revenue goal; benchmark note sourced and dated, not invented.

### P3-T09 · Customer lifetime value calculator · M · todo
**Depends:** P3-T08 · **Files:** `tools/ecommerce/customer_lifetime_value_calculator/*`, `static/js/lib/clv.mjs`, `tests/js/clv.test.mjs`
**Accept:** simple (AOV × frequency × lifespan × margin) and retention-based (margin × r/(1+d−r)) models side by side, each labelled with its assumptions; LTV:CAC ratio output.

### P3-T10 · Platform fee calculator (+ variants) · L · todo
**Depends:** P3-T09 · **Files:** `tools/ecommerce/platform_fee_calculator/{tool,logic,forms,tests}.py`, `_data/fees/*.yaml`
**Accept:** Shopify / Amazon FBA / Etsy variants from one engine with per-variant copy and URLs; every fee row carries `source_url` + `checked_on`; page prints "Fees verified on <date>"; "not affiliated with X" disclaimer; stale data fails `check_tools`.

### P3-T11 · UTM builder · S · todo
**Depends:** P3-T10 · **Files:** `tools/marketing/utm_builder/*`, `static/js/lib/utm.mjs`, `tests/js/utm.test.mjs`
**Accept:** correct encoding of spaces/unicode/existing query strings, lowercase normalisation toggle, preset templates, copy + QR-free share link, bulk mode for 10 URLs; never mangles an existing fragment.

### P3-T12 · Phase 3 QA and velocity check · S · todo
**Depends:** P3-T11 · **Files:** `docs/TOOLS_CATALOG.md`, `docs/SESSION_LOG.md`, `scripts/page_weight.py`
**Accept:** all 10 tools pass budgets and schema validation; catalog statuses accurate; **measured time-to-add for one extra trivial tool is <90 minutes** — if not, fix the architecture before Phase 5.

---

## Phase 4 — Growth layer

### P4-T01 · Email capture with double opt-in · M · todo
**Depends:** P3-T12 · **Files:** `leads/{models,forms,views,urls}.py`, `templates/partials/capture.html`, `tests/python/test_leads.py`
**Accept:** unchecked consent box with the exact consent text stored on the row; confirmation email required before "confirmed"; honeypot + rate limit; capture appears only *after* a result exists (reciprocity, never a gate).

### P4-T02 · Result export and save · M · todo
**Depends:** P4-T01 · **Files:** `static/js/lib/export.mjs`, `templates/partials/tool_actions.html`, `static/css/print.css`
**Accept:** copy-as-text, download CSV, and a clean print/PDF stylesheet — all client-side, no server round-trip, no dependency; works for any tool via the shared result contract.

### P4-T03 · Shareable result links · S · todo
**Depends:** P4-T02 · **Files:** `static/js/lib/state.mjs`, `tests/js/state.test.mjs`
**Accept:** inputs encode into the URL hash (never the query string, so nothing reaches our logs), restore exactly on load, survive a round-trip, and reject malformed state safely; "Copy link" in the action bar.

### P4-T04 · First-party usage analytics · M · todo
**Depends:** P4-T03 · **Files:** `analytics/{models,services,views}.py`, `adminpanel/views.py`, `tests/python/test_analytics.py`
**Accept:** `UsageDaily` and `SearchMiss` increment through a cache buffer flushed by a management command; no IP, no UA, no cookie; dashboard widgets wired; counting adds <5 ms to a request.

### P4-T05 · Related tools and internal linking · M · todo
**Depends:** P4-T04 · **Files:** `tools/services.py`, `templates/partials/related.html`, `tests/python/test_linking.py`
**Accept:** related tools resolved from spec + category + shared keywords, always symmetric, 3–6 per page; every tool reachable within 3 clicks of home; orphan-page test fails the build.

### P4-T06 · Embeddable widget · M · todo
**Depends:** P4-T05 · **Files:** `tools/views.py`, `templates/tools/embed.html`, `templates/pages/embed_builder.html`
**Accept:** `/tools/<cat>/<slug>/embed/` renders a minimal frame-safe page with a required visible backlink; snippet generator page; `X-Frame-Options` relaxed for this route only; no cookies set.

### P4-T07 · Consent lifecycle: unsubscribe, export, deletion · S · todo
**Depends:** P4-T06 · **Files:** `leads/views.py`, `templates/leads/*.html`, `docs/PLAN.md`
**Accept:** one-click signed unsubscribe link with no login, data export and deletion on request, retention policy enforced by a management command, privacy policy updated to match the implementation.

---

## Backlog beyond Phase 4 (expand into cards when Phase 4 closes)

- **Phase 5** — four batches of 10: marketing/offers, copywriting, developer, SEO+design. Each batch
  ends with a catalog update and a budget check.
- **Phase 6** — page-weight script in CI, Lighthouse runs, caching + Cloudflare rules, rate limits,
  CSP tightening, backup/restore drill, Django Ninja API + "pro" limits if justified.
- **Phase 7** — design phase (tokens, brand, polish) — **only on the founder's word**.
- **Phase 8** — provision script, deploy, monitoring, Search Console, directories, Product Hunt,
  first content pieces, quarterly fee-data review task.
