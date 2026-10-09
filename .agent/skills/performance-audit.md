# Skill: performance audit

**Purpose.** Keep every page inside the budget. Speed is the product's main competitive advantage.
**When to use.** Before marking any page-rendering task done, and as a full pass each phase.

## The budget (per page, gzipped)
| Metric | Limit |
|---|---|
| HTML | <50 KB |
| CSS | <30 KB (currently one file, target <10 KB) |
| JS | <60 KB total (htmx ~14 + alpine-csp ~15 + our code) |
| Requests | <12 |
| DB queries | ≤3 |
| LCP | <1.5 s on mobile |
| CLS | <0.05 |
| INP | <200 ms |
| Lighthouse (mobile) | ≥95 in all four categories |

## Checklist

1. **Measure the bytes**
   ```bash
   curl -s -H 'Accept-Encoding: gzip' -o /tmp/p.gz -w '%{size_download}\n' <url>
   ```
   Repeat for the CSS and each JS file. Compare to the table. (`scripts/page_weight.py` automates
   this from P6.)
2. **Count the queries.** Wrap the view in `assertNumQueries` in a test. Any N+1 is a blocker, not
   a nit. Registry lookups must be in-memory; `ToolMeta` overrides must be cached.
3. **Check what's loaded.** HTMX only on pages that use it. Alpine only on pages with a component.
   Each tool's module loads only on its own page. No global bundle.
4. **Check render blocking.** One small stylesheet in `<head>`; all JS is `type="module"` (deferred
   by default). No synchronous third-party anything — we have no third parties.
5. **Check layout stability.** Fixed heights reserved for result panels, images, and (later) ad
   slots. System fonts = no FOUT. Test by throttling to Slow 4G and watching for jumps.
6. **Check the cache.** Tool pages: `Cache-Control: public, max-age=300, s-maxage=86400`, purged on
   admin save. Static assets: hashed filenames + 1-year immutable via WhiteNoise.
7. **Run Lighthouse** (`scripts/lighthouse.sh`, mobile preset) on 5 sampled pages: home, a category
   hub, a client tool, a server tool, search. Record the four scores in the session log.
8. **Fix in this order:** remove bytes → defer bytes → cache bytes → optimise code. Deleting
   something always beats optimising it.

## Common regressions to look for
- A tool importing a shared module that pulls in half the library (`import { x } from './lib'` on a
  barrel file) — import the specific module.
- An admin or debug template leaking into a public base template.
- A content block with a 300 KB inline SVG or base64 image.
- `prefetch_related` missing on the category hub's tool list.
- A new partial added to `base.html` that only one page needs.

## Output format
A 6-row table in your report: HTML / CSS / JS / requests / queries / Lighthouse — measured value vs
limit, and PASS/FAIL. Never claim a number you didn't measure.

## Do-nots
- Don't add a build step, a bundler or a minifier to "fix" performance. Write less code.
- Don't lazy-load the tool itself — it's the LCP element.
- Don't ship a polyfill for a browser we don't support (baseline: last 2 versions + iOS Safari 15).
- Don't optimise before measuring, and don't mark done without re-measuring.
