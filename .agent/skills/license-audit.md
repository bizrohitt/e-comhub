# Skill: vet and record a dependency

**Purpose.** Every dependency must be free, permissive, commercially usable and worth its weight.
**When to use.** Before adding **any** package, vendored script, font, icon set, data file or image.

## Allowed vs banned
**Allowed:** MIT · BSD-2/3 · Apache-2.0 · ISC · MPL-2.0 · 0BSD · PSF · Unlicense/CC0 · OFL (fonts).
**Banned without written founder approval:** GPL (any) · LGPL · AGPL · SSPL · BUSL · Elastic ·
CC-BY-NC / CC-BY-SA · "free for personal use" · "source available" · anything with a field-of-use
restriction.
**Why LGPL is also out:** it only stays safe under dynamic linking with no modification — a
condition that's easy to break accidentally and hard to prove later.

## Checklist

1. **Do we need it?** Can the standard library, Django, or ~50 lines of our own code do it? Default
   answer is yes. Every dependency is a license, a CVE feed, an upgrade and a supply-chain risk.
2. **Find the license from the source of truth**, not a blog or a badge:
   ```bash
   curl -s https://pypi.org/pypi/<pkg>/json | python3 -c "import sys,json; i=json.load(sys.stdin)['info']; print(i['version'], i.get('license_expression') or i.get('license'), [c for c in i['classifiers'] if 'License' in c])"
   curl -s https://registry.npmjs.org/<pkg> | python3 -c "import sys,json; d=json.load(sys.stdin); v=d['dist-tags']['latest']; print(v, d['versions'][v].get('license'))"
   ```
   Then confirm in the repo's `LICENSE` file — metadata is sometimes wrong or missing.
3. **Check its transitive deps.** A permissive package with a GPL dependency is a GPL problem.
   `pip download --no-deps` then inspect, or read the project's dependency list.
4. **Check health:** last release date, open critical issues, maintainer count, whether it's
   archived. An unmaintained MIT package is still a liability.
5. **Check weight** if it ships to the browser: unpacked size, min+gz size, whether we'd use 5% of it.
6. **Record it** in `docs/LICENSES.md` — package, version, license, source URL, date checked,
   "ships to user?" — in the **same commit** that adds it.
7. **Pin the exact version.** No `>=`, no `^`, no `latest`.
8. **Vendored browser assets:** commit the file under `static/js/vendor/` with its version in
   `VERSIONS.txt` and its license header intact. Never load from a CDN at runtime (privacy + a
   third-party request we don't control).
9. **Notable additions get an ADR** in `docs/DECISIONS.md` — what it replaces, what it costs.

## Special cases already decided
- `psycopg` 3.x is **LGPL-3.0-only** → flagged in `LICENSES.md`; we're on SQLite (ADR-010), so the
  question is deferred. Revisit only with a founder decision.
- Icons: copy individual **Lucide (ISC)** or **Heroicons (MIT)** SVGs inline. Never ship an icon font.
- Fonts: system stack only. A brand font must be OFL, self-hosted and subset.
- Data (fee tables, benchmarks): facts aren't copyrightable, but **the presentation is** — write our
  own summary, record `source_url` + `checked_on`, never paste a competitor's table.

## Output format
One line in your report: `Added <pkg> <version> (<license>) — <why nothing lighter works>.`

## Do-nots
- Don't add a package to save 20 lines. Don't add one "we'll probably need it".
- Don't trust a GitHub badge, an LLM memory, or a README claim over the LICENSE file.
- Don't vendor code without its license header.
- Don't let a dependency land in a commit that doesn't update `LICENSES.md`.
