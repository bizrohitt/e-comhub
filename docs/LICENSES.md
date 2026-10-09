# LICENSES

Every dependency we ship or build with, its license, and when it was last checked.
**Rule: permissive only** — MIT, BSD-2/3, Apache-2.0, ISC, MPL-2.0, 0BSD, PSF, Unlicense/CC0.
**Never**: GPL, LGPL*, AGPL, SSPL, BUSL, Elastic, "free for non-commercial", "source available".

\* LGPL is viable only for a dynamically-linked, unmodified library kept out of our source tree.
We currently avoid it entirely — see `psycopg` below.

Process for adding anything: `.agent/skills/license-audit.md`. A new dependency without a row here
fails code review.

---

## 1. Runtime — Python (planned pins for P0-T02)

| Package | Version | License | Source | Checked | Ships to user? |
|---|---|---|---|---|---|
| Python | 3.11+ (3.12 preferred) | PSF-2.0 | python.org | 2026-10-09 | no |
| Django | 5.2.x LTS (latest 5.2.18) | BSD-3-Clause | pypi.org/project/Django | 2026-10-09 | no |
| whitenoise | 6.12.0 | MIT | pypi.org/project/whitenoise | 2026-10-09 | no |
| gunicorn | 26.2.0 | MIT | pypi.org/project/gunicorn | 2026-10-09 | no (prod only) |
| python-dotenv *or* django-environ | 1.2.4 / 0.14.0 | BSD-3-Clause / MIT | pypi | 2026-10-09 | no |

**Deliberately not added yet** (each needs an ADR first): `django-ninja` (MIT, 1.7.1) — P6 API tier ·
`django-unfold` (MIT, 0.108.0) — P7 admin styling · `pillow` (MIT-CMU, 12.3.0) — only if we ever do
server-side images · `django-q2` (MIT, 1.11.1) — only if background jobs become unavoidable.

> ⚠️ **`psycopg` 3.x is LGPL-3.0-only.** If we move to PostgreSQL, use the **`psycopg-binary`
> distribution's licensing carefully** or prefer `psycopg2-binary` (LGPL with an OpenSSL exception)
> — either way this needs a written founder decision first, because it conflicts with our
> permissive-only rule. Current plan (ADR-010) is SQLite, which avoids the question entirely.
> SQLite itself is **public domain**.

## 2. Runtime — browser (vendored into `static/js/vendor/`, pinned)

| Package | Version | License | Source | Checked | Size (min+gz, approx) |
|---|---|---|---|---|---|
| htmx | 2.0.11 | 0BSD | registry.npmjs.org/htmx.org | 2026-10-09 | ~14 KB |
| Alpine.js **CSP build** (`@alpinejs/csp`) | 3.17.4 | MIT | registry.npmjs.org/@alpinejs/csp | 2026-10-09 | ~15 KB |

Both are downloaded once, committed under `static/js/vendor/` with a `VERSIONS.txt`, and loaded
only on pages that need them. No CDN at runtime (privacy + no third-party request).

## 3. Dev and tooling (never shipped)

| Package | Version | License | Source | Checked |
|---|---|---|---|---|
| pytest | 9.1.1 | MIT | pypi.org/project/pytest | 2026-10-09 |
| pytest-django | 4.14.0 | BSD-3-Clause | pypi.org/project/pytest-django | 2026-10-09 |
| ruff | 0.16.10 | MIT | pypi.org/project/ruff | 2026-10-09 |
| Node.js (`node --test` only) | 22.x | MIT | nodejs.org | 2026-10-09 |
| Tailwind CSS standalone CLI | 4.3.3 | MIT | registry.npmjs.org/tailwindcss | 2026-10-09 (deferred to P7) |

## 4. Assets

| Asset | License | Source | Checked | Notes |
|---|---|---|---|---|
| System font stack | n/a (OS fonts) | — | 2026-10-09 | No webfont shipped; zero licensing risk |
| Lucide icons | ISC | github.com/lucide-icons/lucide | 2026-10-09 | Copy individual SVGs inline; attribute in this file |
| Heroicons (fallback) | MIT | github.com/tailwindlabs/heroicons | 2026-10-09 | Same approach |
| Illustrations / images | — | our own SVG or CC0 | — | No stock photos, no scraped images |

## 5. Services

| Service | Tier | Terms note | Checked |
|---|---|---|---|
| Cloudflare | Free | CDN/DNS; free plan allows this use | 2026-10-09 |
| Oracle Cloud Always Free | Free (2 Arm OCPU / 12 GB as of Jun 2026) | Card at signup; idle instances may be reclaimed | 2026-10-09 |
| GitHub + Actions | Free (public repo) | CI minutes free for public repos | 2026-10-09 |

## 6. Our own license

**Not yet chosen.** Default intent: the repository stays **private/all-rights-reserved** while it is
a commercial asset. If we later open-source parts (a growth play — see `GROWTH_PLAYBOOK.md` §4),
release only standalone utility modules under MIT, never the full site. Decide before the repo goes
public.

## 7. Third-party content and trademarks

- Platform names (Shopify, Amazon, Etsy, Meta, Google, TikTok) are used **nominatively only** —
  describing what a tool is for. No logos, no brand colours, no implied endorsement; every such page
  carries a "Not affiliated with X" line.
- Fee schedules and ad limits are **facts**, not copyrightable expression, but each is stored with
  `source_url` + `checked_on` and summarised in our own words. Never paste a competitor's table,
  FAQ text, tool copy or CSS.
- No competitor code is read, copied or adapted. Implementations are written from the public formula.

---

**Audit cadence:** review this file at the end of every phase and before every deploy.
Last full audit: **2026-10-09** (Task 0 — planning pins, nothing installed yet).
