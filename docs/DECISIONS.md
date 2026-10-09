# DECISIONS — ADR log

Newest first. Format: **ADR-NNN · date · status** — decision / options considered / reason /
consequence. Keep each entry under 12 lines. A decision here is not re-litigated without a new ADR
that supersedes it.

Status values: `accepted` · `proposed` (awaiting founder) · `superseded by ADR-NNN` · `reversed`.

---

## ADR-013 · 2026-10-09 · proposed
**Default currency is USD with a user-selectable currency; examples use round USD numbers.**
Options: USD-first / INR-first / auto-detect by IP.
Reason: the keywords we're chasing ("profit margin calculator") are global and dominated by US/UK
search volume; IP detection needs a geo database and breaks caching. A selector is 20 lines and
honest.
Consequence: all worked examples and tests use USD; currency is a display concern, never a formula
concern (we never convert, we only label).

## ADR-012 · 2026-10-09 · accepted
**Reference data (platform fees, ad character limits, tax rates) lives in versioned data files with provenance.**
Options: hardcode in logic / DB table / data file with metadata.
Reason: these numbers change and a wrong one is a trust-killing bug. A file diff is reviewable in
Git; `source_url` + `checked_on` makes staleness visible and testable.
Consequence: registry validation fails a tool whose data is past `review_every_days`; pages print
"Fees verified on <date>".

## ADR-011 · 2026-10-09 · accepted
**Analytics are daily aggregates (`UsageDaily`), not per-event rows.**
Options: per-event table / aggregate counters / third-party analytics.
Reason: third-party trackers are banned by the brief; per-event rows bloat SQLite and answer no
question we actually ask ("which tools get used, which searches fail").
Consequence: we can never do cohort/session analysis. Accepted — that's not our business.

## ADR-010 · 2026-10-09 · accepted
**SQLite in production initially; stay ORM-portable to Postgres.**
Options: SQLite / managed free Postgres (Neon, Supabase) / self-hosted Postgres.
Reason: read-mostly site, most tools never touch the DB, backup is a file copy, one less daemon.
Consequence: single-writer limits; if write volume (leads, counters) ever contends, switch to
Postgres via settings. No raw SQL, no SQLite-only features.

## ADR-009 · 2026-10-09 · accepted
**Host on Oracle Cloud Always Free (Arm VM) + Cloudflare free; Hetzner (~€4/mo) as Plan B.**
Options: Render free / Fly.io / Railway / Oracle Always Free / cheap VPS.
Reason: verified 2026-10-09 — Render free services sleep after ~15 min idle and free Postgres
expires after 30 days; Railway and Fly have no standing free tier for new accounts. Cold starts
would wreck crawl speed and LCP, which is the whole strategy.
Consequence: we manage a VM (Caddy + gunicorn + systemd). Mitigated by a committed provision script
and a 20-minute documented rebuild; Oracle can reclaim idle instances, hence Plan B.

## ADR-008 · 2026-10-09 · accepted
**Two test suites: pytest for Python, `node --test` for browser formulas.**
Options: Python-only tests (leaves JS math untested) / add Vitest+jsdom / Node's built-in runner.
Reason: client-side math is the product. Node 22 ships a test runner with zero dependencies, so JS
formulas written as pure ES modules get real unit tests at no cost.
Consequence: client formulas must live in `static/js/lib/*.mjs` with no DOM access.

## ADR-007 · 2026-10-09 · accepted
**One formula, one implementation. `hybrid` mode requires its own ADR.**
Options: mirror formulas in Python and JS / pick one per tool.
Reason: duplicated money math drifts silently and produces two different answers for the same input
— the worst possible bug for a trust-based tool site.
Consequence: `client` tools have no Python formula (their "worked example" is static content);
`server` tools have no JS formula.

## ADR-006 · 2026-10-09 · accepted
**Default Django admin + custom dashboard views; django-unfold deferred to Phase 7.**
Options: default admin / django-unfold now / custom staff UI.
Reason: Phase 2's goal is control, not aesthetics. Zero dependencies now; Unfold (MIT) is a styling
layer we can add later without touching model or view code.
Consequence: the admin looks plain until P7. Accepted.

## ADR-005 · 2026-10-09 · accepted
**No Tailwind until Phase 7. Ship one hand-written `base.css` driven by CSS custom properties.**
Options: Tailwind standalone CLI now / plain CSS now, Tailwind later / plain CSS forever.
Reason: the brief forbids visual polish before the design phase, so a build step + watcher buys
nothing today; tokens-in-CSS-variables makes P7 a swap rather than a rewrite.
Consequence: authors write real CSS class names now. If P7 adopts Tailwind, templates change but no
logic does.

## ADR-004 · 2026-10-09 · accepted
**No Django Ninja / FastAPI / Redis / Celery / django-q2 until a task proves the need.**
Options: add the typed API layer up front / add on demand.
Reason: nothing in Phases 0–5 needs JSON endpoints, async, a broker or a queue. Every dependency is
a license, a CVE feed and an upgrade.
Consequence: when the public embed/API tier lands (P6), Django Ninja gets an ADR of its own.

## ADR-003 · 2026-10-09 · accepted
**Alpine CSP build + `Alpine.data()` components in external ES modules, from tool #1.**
Options: standard Alpine (needs `script-src 'unsafe-eval'`) / Alpine CSP build / vanilla JS.
Reason: `unsafe-eval` weakens XSS defence on pages that accept pasted user text and costs
Best-Practices points. Retrofitting the CSP build across 120 templates later is a week of work;
adopting it now is free.
Consequence: no inline `x-data="{...}"` object literals, no expressions in `x-on`. Slightly more
verbose templates, strictly better security.

## ADR-002 · 2026-10-09 · accepted
**Ruff replaces black + flake8 + isort.**
Options: black+flake8+isort / Ruff.
Reason: one MIT tool, one config, orders of magnitude faster, format + lint in a single pass.
Consequence: `ruff check` and `ruff format --check` gate every task via `scripts/check.sh`.

## ADR-001 · 2026-10-09 · accepted
**Django 5.2 LTS (not 6.0/6.1), Python 3.11+.**
Options: 5.2 LTS (EOL Apr 2028) / 6.0 (EOL Apr 2027) / 6.1 (EOL Dec 2027).
Reason: a solo-founder project should not take two forced framework upgrades in 18 months; 5.2 also
runs on Python 3.11, which the dev box and most free hosts already have (6.x requires 3.12+).
Consequence: we forgo Django 6.0's built-in CSP settings and template partials — replaced by a ~30
line CSP middleware in `core/` and plain `{% include %}`. Re-evaluate at **6.2 LTS, April 2027**.
