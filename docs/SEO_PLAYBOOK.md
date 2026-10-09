# SEO PLAYBOOK

The entire acquisition strategy in one file. One tool = one primary keyword = one URL.

---

## 1. The bet

People search for tools by name — "profit margin calculator", "utm builder", "break even roas".
These queries have **unambiguous intent and no good free answer that loads fast**. Our edge is not
cleverness, it's: instant result, no signup wall, no 2 MB of JavaScript, real formulas shown, and
120 interlinked pages that make the site look like an authority on operator math.

**What we will not do:** spin 500 near-identical pages, invent statistics, fake "trusted by 10,000
stores", buy links, or publish AI slop. One thin-content penalty erases the whole asset.

---

## 2. Keyword model

| Tier | Example | Volume | Our play |
|---|---|---|---|
| **Head tool** | `profit margin calculator` | High, competitive | The main tool page. Win on speed + usefulness + depth below the fold |
| **Qualified tool** | `shopify fee calculator` | Medium, high intent | Variant page with its own data, worked example and FAQ |
| **Long-tail task** | `how to calculate break even roas` | Low, easy | Answered *inside* the tool page's content block, not a separate thin page |
| **Comparison** | `margin vs markup` | Medium | A genuine explainer section on the markup tool + its own page only if it earns one |
| **Cluster hub** | `ecommerce calculators` | Medium | Category page, links to every tool in the cluster |

**Rule:** a new URL must have a different *answer*, not just a different *phrasing*. If two pages
would share 80% of their text, they are one page.

---

## 3. URL and IA

```
/                                    home — all categories, featured tools
/tools/<category>/                   hub — every tool in the cluster + intro + cross-links
/tools/<category>/<slug>/            tool page (the money page)
/tools/<category>/<slug>/<variant>/  only for genuinely different variants
/search/?q=                          internal search (noindex)
/guides/<slug>/                      optional supporting content (phase 8+)
```

Lowercase, hyphenated, no dates, no `/page/2`. **Slugs are permanent** — a change creates a 301
`Redirect` row, never a 404.

---

## 4. Tool page template (the one that ranks)

| Order | Block | Rule |
|---|---|---|
| 1 | Breadcrumbs | `Home › Category › Tool`, with `BreadcrumbList` JSON-LD |
| 2 | H1 | Exact primary keyword, title-case-free, ≤60 chars |
| 3 | One-line promise | The outcome, not the mechanism |
| 4 | **The tool itself** | Above the fold on mobile. No preamble, no cookie wall, no hero image |
| 5 | Trust line | "Free. No signup. Your numbers stay in your browser." — only when literally true |
| 6 | How it works | Exactly 3 steps |
| 7 | The formula | Written out, with variables defined. This is what earns links |
| 8 | Worked example | Real numbers, a short table, a sentence interpreting the result |
| 9 | Pitfalls / when this is wrong | Nobody else writes this. It's the strongest trust signal we have |
| 10 | FAQ | 3–6 Qs from real search suggestions, with `FAQPage` JSON-LD |
| 11 | Related tools | 3–6, symmetric links |
| 12 | Last updated | Real date from `ToolSpec.updated` |

Word count is an output, not a target — usually 500–900 words of *useful* text. If a section would
be padding, delete it.

---

## 5. Title and description formulas

**Title (≤60 chars):** `<Primary Keyword> — Free, No Signup | <Brand>`
- `Profit Margin Calculator — Free, No Signup | e-comhub`
- `Break-Even ROAS Calculator (Free Tool) | e-comhub`

**Meta description (140–155 chars):** what it does + the input → output + the differentiator.
- `Work out margin, markup and break-even price from your cost and fees. Instant, free, no signup — your numbers never leave your browser.`

**Rules:** primary keyword in the first 5 words of the title; never duplicate a title across the
site (a test enforces uniqueness); no ALL CAPS, no emoji, no "best" claims we can't support.

---

## 6. Structured data

| Schema | Where | Notes |
|---|---|---|
| `SoftwareApplication` | every tool page | `applicationCategory: BusinessApplication`, `offers.price: 0`, `priceCurrency: USD` |
| `FAQPage` | every tool page with FAQs | Must match the visible text exactly |
| `BreadcrumbList` | every page below home | 3 levels max |
| `WebSite` + `SearchAction` | home | Enables sitelinks search box |
| `Organization` | home | Name, logo, sameAs — once we have profiles |

**Never** use `AggregateRating` or `Review` markup without real, verifiable reviews. That's a manual
action waiting to happen.

---

## 7. Internal linking

- Every tool links to its **category hub** (breadcrumb) and 3–6 **related tools**, and links are
  **symmetric** — if A links to B, B links to A. Enforced by a test (P4-T05).
- Category hubs link to each other ("marketers also use…").
- Home links to every category and the top 12 tools.
- **Orphan check fails the build:** every tool must be reachable within 3 clicks of home.
- Anchor text is the tool's name or its primary keyword — never "click here".
- Content blocks link naturally: the ROAS page links to the margin page on the word "margin".

---

## 8. Technical SEO checklist (verify each phase)

- [ ] One `<h1>`, logical `h2`/`h3` order, no skipped levels
- [ ] Canonical on every page; variants canonical to themselves, not the base
- [ ] `sitemap.xml` from the registry with real `lastmod`; disabled/noindex tools excluded
- [ ] `robots.txt` allows everything except `/search/`, `/admin/`, `/embed/`
- [ ] 404s are useful (search + popular tools); 301s via the `Redirect` model; zero redirect chains
- [ ] Mobile-first: the tool is usable without zooming or horizontal scroll
- [ ] Core Web Vitals: LCP <1.5 s, CLS <0.05, INP <200 ms — **no JS required to render content**
- [ ] No JS-dependent content: the formula, example and FAQ are in the HTML source
- [ ] `hreflang` only if we ever localise (we don't yet)
- [ ] Pagination: none. Hubs list everything

---

## 9. Measurement

| Metric | Where | Target by end of Phase 8 |
|---|---|---|
| Indexed tool pages | Search Console | 100% of enabled tools |
| Impressions / clicks per tool | Search Console | every tool >0 clicks within 90 days of launch |
| Zero-result internal searches | `SearchMiss` model | reviewed monthly → becomes the roadmap |
| Tool usage | `UsageDaily` | top 10 known; bottom 10 fixed or parked |
| Referring domains | manual / free tier tool | 10 in the first quarter |

**The free feedback loop:** `SearchMiss` tells us what visitors wanted and we didn't have. That is
better keyword research than any paid tool, because it comes from people already on the site.

---

## 10. Launch sequence per tool (do this every time)

1. Publish with complete content (never a stub).
2. Link it from its category hub + 3 related tools (the symmetric test enforces this).
3. It enters `sitemap.xml` automatically via the registry.
4. Submit the URL in Search Console once; don't spam re-indexing.
5. Post one genuinely helpful answer where that question gets asked (Reddit, a forum, a Facebook
   group) — **answer first, link only if it adds something**. One link, no drip campaign.
6. Add it to the next newsletter's "new tools" line.
7. Re-check impressions at 30 days: if it's getting impressions but no clicks, rewrite the title and
   description; if it's getting neither, the page needs more depth or the keyword was wrong.
