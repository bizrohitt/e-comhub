# Skill: write a tool page that ranks

**Purpose.** Turn a working tool into a page that earns impressions, clicks and links.
**When to use.** Every tool task, and any page-content task.
**Source of strategy.** `docs/SEO_PLAYBOOK.md` — this is the execution checklist.

## Checklist

1. **One keyword.** Confirm `primary_keyword` in the catalog. If another live tool already targets
   it, you're building a duplicate — stop and resolve it.
2. **Title** ≤60 chars, keyword in the first five words:
   `Profit Margin Calculator — Free, No Signup | e-comhub`. Uniqueness is enforced by a test.
3. **Meta description** 140–155 chars: what it does, input → output, the differentiator.
4. **H1** = the tool name = the primary keyword. Exactly one `<h1>`. No keyword stuffing anywhere.
5. **Promise line** under 15 words, directly under the H1.
6. **Tool above the fold on a 360px screen.** Nothing — no hero, no banner, no notice — pushes it
   down.
7. **Trust line** rendered from `mode`: client tools say "Your numbers stay in your browser";
   server tools say "We don't store what you enter". Only ever the true one.
8. **Content block** (`content.md`), in this order:
   - How it works — exactly 3 steps
   - The formula — written out, variables defined, plus the source if it's a standard model
   - Worked example — real numbers in a small table + one sentence interpreting the result
   - When this is wrong / what people forget — the section nobody else writes
   - Optional: a short "how to improve this number" list, genuinely actionable
9. **FAQ** — 3–6 questions taken from real autocomplete/People-Also-Ask phrasing. Answer in the
   first sentence, then explain. Visible text and `FAQPage` JSON-LD must match exactly.
10. **Structured data** via `core/seo.py`: `SoftwareApplication` (price 0), `FAQPage`,
    `BreadcrumbList`. Never `AggregateRating` or `Review` without real reviews.
11. **Internal links**: breadcrumb to the hub, 3–6 related tools (symmetric), plus 1–2 contextual
    links inside the prose using the target's keyword as anchor text.
12. **Freshness**: `ToolSpec.updated` is real; data-backed tools print "verified on <date>".
13. **Budget**: HTML <50 KB, no render-blocking JS, LCP <1.5 s, CLS <0.05. Check before done.
14. **Validate**: run the page through a structured-data validator and your own
    `serp-snippet-preview` tool for title/description truncation.

## Output format
A tool page in the exact block order above, plus a one-line note in your report on which keyword it
targets and which 3 tools it links to.

## Do-nots
- Don't publish a stub and "improve it later" — a thin page gets crawled, classified and ignored.
- Don't spin variants ("profit margin calculator for X") unless the content genuinely differs:
  different fees, different example, different pitfalls. Otherwise it's one page.
- Don't write 1,500 words of padding to "hit word count". Length is a by-product of usefulness.
- Don't bury the tool under an intro paragraph. The user came to calculate.
- Don't use dates in URLs, don't change slugs, don't create pagination.
- Don't claim "#1", "best", or a user count you can't prove from `UsageDaily`.
