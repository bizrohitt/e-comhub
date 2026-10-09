# ARCHITECTURE — e-comhub

Django 5.2 LTS · HTMX 2 · Alpine 3 (CSP build) · no bundler · no SPA.
Read this before touching `core/`, `tools/registry.py` or any model.

---

## 1. Folder map

```
e-comhub/
  manage.py
  pyproject.toml              ruff + pytest config, no packaging
  requirements/base.txt dev.txt prod.txt
  .env.example
  config/
    settings/base.py dev.py prod.py
    urls.py  wsgi.py  asgi.py
  core/                       shared, framework-level, no business logic
    seo.py                    title/description builders, JSON-LD helpers
    middleware.py             security headers + CSP (hand-rolled, ~30 lines)
    templatetags/core_tags.py
    utils/money.py numbers.py text.py
    views.py                  healthz, error handlers
  tools/
    base.py                   ToolSpec, FAQ, Variant, DataSource dataclasses
    registry.py               auto-discovery, validation, lookup, search index
    urls.py  views.py         ONE generic view family for every tool
    management/commands/check_tools.py
    ecommerce/  marketing/  copywriting/  developer/  design/  seo/  analytics/
      <slug>/                 one folder per tool (see §3)
  pages/                      home, category hubs, search, about, legal
  leads/                      email capture, consent, unsubscribe
  analytics/                  first-party aggregate counters
  adminpanel/                 dashboard views + admin customisation
  templates/
    base.html
    tools/tool_page.html      the ONE tool page shell
    partials/                 header, footer, breadcrumbs, faq, related, capture
    pages/                    home, category, search, legal
  static/
    css/base.css              tokens + layout + components (<30 KB)
    js/vendor/                htmx.min.js, alpine-csp.min.js (self-hosted, pinned)
    js/lib/*.mjs              pure formula modules — the client source of truth
    js/tools/<slug>.mjs       Alpine.data() component per tool
    svg/                      inline-able icons (Lucide, MIT)
  tests/
    python/                   pytest: registry, views, SEO, models
    js/*.test.mjs             node --test: every client formula
  scripts/  docs/  .agent/skills/  AGENTS.md
```

**App boundaries (one responsibility each):** `core` = plumbing · `tools` = registry + generic
rendering · `pages` = information architecture · `leads` = email/consent · `analytics` = counting ·
`adminpanel` = founder control surface. A tool folder is **not** a Django app — it has no models,
no migrations, no `apps.py`.

---

## 2. Request flow

### Client-mode tool (the default, ~80% of tools)
```
GET /tools/ecommerce/profit-margin-calculator/
  → tools.views.ToolPageView
  → registry.get("profit-margin-calculator")           in-memory, no query
  → ToolMeta override lookup                           1 cached query (or 0 on cache hit)
  → render tools/tool_page.html
      {% include tool.template %}                      form markup only
      <script type="module" src="/static/js/tools/profit-margin-calculator.mjs">
  → browser: Alpine.data('profitMargin', ...) imports /static/js/lib/margin.mjs
  → every keystroke computes locally. Zero further requests. Page is CDN-cacheable.
```

### Server-mode tool (only when the browser genuinely can't)
```
POST /tools/<cat>/<slug>/run/      (HTMX, CSRF token, rate-limited)
  → tools.views.ToolRunView
  → forms.ToolForm.clean()                             strict validation
  → logic.calculate(**cleaned) -> dict                 pure function, no Django import
  → render tools/<slug>/partials/result.html           HTML fragment, hx-swap into #result
```

### Why the page stays cacheable
The tool page contains no per-user data and no CSRF-bearing form for client tools, so it can be
served with `Cache-Control: public, max-age=300, s-maxage=86400` and purged on admin save.
Cloudflare absorbs the traffic; the origin serves mostly cold crawls.

---

## 3. Tool plugin contract

**The rule:** adding a tool = adding one folder. No core file is edited. Ever.

```
tools/ecommerce/profit_margin_calculator/
  __init__.py
  tool.py            REQUIRED — module-level `TOOL: ToolSpec`
  template.html      REQUIRED — the form + result markup fragment (no <html>, no <head>)
  content.md         REQUIRED — how it works, formula, worked example (rendered server-side)
  logic.py           server/hybrid modes only — pure functions
  forms.py           server/hybrid modes only
  tests.py           server/hybrid modes only
  _data/*.yaml       optional reference data with provenance
```
Client-mode counterparts live in `static/js/tools/<slug>.mjs` + `static/js/lib/<name>.mjs` +
`tests/js/<name>.test.mjs`.

### `ToolSpec` (defined in `tools/base.py`)

| Field | Type | Notes |
|---|---|---|
| `slug` | str | URL segment, kebab-case, **immutable once published** (changing it = a `Redirect` row) |
| `name` | str | H1 and nav label |
| `category` | str | must match a folder under `tools/` and a `ToolCategory` row |
| `short_description` | str | ≤155 chars, doubles as the default meta description |
| `primary_keyword` | str | exactly one per tool — the SEO contract |
| `keywords` | tuple[str,…] | secondary terms, used for search index only |
| `faq` | tuple[FAQ,…] | 3–6 entries, rendered + emitted as `FAQPage` JSON-LD |
| `related` | tuple[str,…] | slugs; registry validates they exist and back-links symmetrically |
| `mode` | `client` \| `server` \| `hybrid` | `hybrid` requires an ADR |
| `is_advanced` | bool | S/A tag from the catalog |
| `enabled` | bool | code-level kill switch; admin `ToolMeta.enabled` can also disable |
| `template` | str | defaults to `tools/<category>/<slug>/template.html` |
| `variants` | tuple[Variant,…] | extra URLs with their own keyword/H1/content (e.g. Shopify/Etsy) |
| `data_sources` | tuple[DataSource,…] | `name, source_url, checked_on, review_every_days` |
| `updated` | date | shown on the page, feeds sitemap `lastmod` |

`FAQ(q, a)` · `Variant(slug, name, primary_keyword, content, defaults)` ·
`DataSource(name, source_url, checked_on, review_every_days)`.

### Registry behaviour (`tools/registry.py`)
1. On startup, walk `tools/*/*/tool.py`, import, read `TOOL`.
2. **Validate hard, fail loud:** unique slug, category folder exists, description length, ≥3 FAQs,
   `related` slugs resolve, `mode` consistent with the files present, `data_sources` not past review.
3. Build: slug→spec map, category→specs map, URL patterns, search index (slug + name + keywords +
   short_description), sitemap entries.
4. Expose `all()`, `get(slug)`, `by_category(cat)`, `search(q)`, `enabled_only()`.
5. `manage.py check_tools` runs the same validation and exits non-zero — wired into `scripts/check.sh`.

**Anti-regression test (P1-T04):** a test asserts the dummy tool reaches home, its category page,
search results and the sitemap without any core file appearing in that task's diff.

---

## 4. Data model (minimal by design)

| Model | App | Fields (essentials) | Why |
|---|---|---|---|
| `ToolCategory` | tools | slug, name, description, icon, order, enabled | Hub pages + nav |
| `ToolMeta` | tools | slug (unique), title_override, description_override, faq_override (JSON), enabled, featured, order, noindex, updated_at | Admin edits SEO without deploying. **Overrides only** — never the source of a tool's existence |
| `UsageDaily` | analytics | tool_slug, date, count → unique(tool_slug, date) | Aggregate, `F()`-incremented. No per-event rows, no IP, no user agent |
| `SearchMiss` | analytics | query, count, last_seen | Zero-result searches = the roadmap, free |
| `Lead` | leads | email, source_slug, consent_text, consented_at, ip_hash, confirmed_at, unsubscribed_at | Double opt-in + provable consent |
| `Page` | pages | slug, title, body (markdown), status, updated_at | Legal pages + light blog |
| `SiteSetting` | core | key, value (JSON), updated_by | Branding, limits, toggles |
| `FeatureFlag` | core | key, enabled, rollout_note | LLM features, ads, embeds |
| `Redirect` | core | old_path, new_path, permanent | Slug changes never 404 |
| `AuditLog` | adminpanel | actor, model, object_id, action, diff, at | Who changed the SEO |

**Privacy stance:** no `UsageEvent` row per click, no IP stored raw (hash + salt for consent proof
only), no third-party scripts. The GDPR answer for 95% of the site is "we don't collect anything".

---

## 5. Frontend contract

- **One stylesheet** `base.css`: `:root` custom properties (colour, space, radius, type scale) then
  layout then components. Redesign = change the token block.
- **HTMX loads only on pages that use it** (`{% block scripts %}`), never globally.
- **Alpine CSP build**: components are registered in `static/js/tools/<slug>.mjs` as
  `Alpine.data('name', () => ({...}))`. Templates may use `x-data="name"` but **never** an inline
  object literal, and never `x-on` handlers containing expressions beyond a method call.
- **Formulas are ES modules** in `static/js/lib/` with no DOM access, imported by components and by
  `node --test`. This is what makes browser math testable.
- **No JS, no problem:** the form, explanation, formula, worked example, FAQ and related links are
  all server-rendered. JS only adds live calculation.
- **Accessibility baseline:** `<label for>` on every input, results in `aria-live="polite"`, visible
  `:focus-visible`, 44px targets, one `<h1>`, logical heading order.

---

## 6. Security posture

CSRF on every POST · strict form validation (type, range, length) on server tools · rate limit by
IP+path via Django cache on `/run/` and `/leads/` endpoints · CSP without `unsafe-eval` (that's why
the Alpine CSP build) and without `unsafe-inline` for scripts (nonce for the one inline JSON-LD
block) · `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy`, HSTS in prod ·
`SECURE_*` cookie flags · secrets only from env, `.env.example` committed, `.env` never ·
no user-supplied HTML is ever rendered unescaped. Details: `.agent/skills/security-checklist.md`.

---

## 7. Performance budget enforcement

| Check | Where | Gate |
|---|---|---|
| HTML <50 KB, CSS <30 KB, JS <60 KB gz | `scripts/page_weight.py` (P6) | fails CI |
| Query count per page ≤3 | `django-debug-toolbar`-free assertion helper in tests | fails test |
| LCP <1.5 s, CLS <0.05, Lighthouse ≥95 | `scripts/lighthouse.sh` on 5 sampled pages | manual, per phase |
| No layout shift from ad slots | reserved fixed-height containers | review |

Caching layers: per-view cache for tool pages (5 min) + `s-maxage` for Cloudflare + registry held in
memory + `ToolMeta` overrides in Django cache, invalidated on admin save.

---

## 8. Backups and recovery

| What | How | Frequency | Restore drill |
|---|---|---|---|
| Database (SQLite) | `sqlite3 .backup` → gzip → off-box (R2/B2 free tier or a second host) | nightly, 14 daily + 8 weekly | P6: restore into a scratch dir, run `pytest`, diff row counts |
| Code | Git (GitHub) | per commit | clone + `scripts/bootstrap.sh` |
| Secrets | `.env` in a password manager, never in Git | on change | documented in `docs/DEPLOY.md` (P8) |
| Uploaded assets | none by design (no user uploads) | — | — |
| Whole box | `scripts/provision.sh` rebuilds from bare OS in ~20 min | tested at P6 and P8 | timed drill |

**Recovery objective:** RPO 24 h, RTO 1 h. Because the site is 99% stateless, the real asset is Git
plus a small SQLite file.

---

## 9. Conventions

- Python: Ruff defaults, type hints on public functions, docstring with the formula + source on
  every calculation, no magic numbers (named constants in `logic.py`).
- Templates: one `{% block %}` per region, partials under `templates/partials/`, no logic beyond
  loops/conditionals.
- Naming: folders `snake_case`, slugs/URLs `kebab-case`, CSS classes `kebab-case`, JS `camelCase`.
- Tests mirror source paths. Every formula test includes zero, negative, huge, empty and rounding.
- Commits: `P3-T02: profit margin calculator` — task ID first.
