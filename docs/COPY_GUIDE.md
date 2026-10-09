# COPY GUIDE

Every word on the screen is product. This file is the spec for those words.

---

## 1. Who we write for

A store owner with 40 open tabs, on a phone, between tasks. They are numerate but busy, sceptical of
marketing language, and they have been burned by "free" tools that wanted an email. They want the
number and they want to trust it.

**Write like a sharp colleague explaining something at a desk — not like a SaaS landing page.**

---

## 2. Voice

| We are | We are not |
|---|---|
| Plain, direct, specific | Clever, punny, breathless |
| Useful before persuasive | Hype-first |
| Honest about limits | Over-claiming |
| Confident | Boastful |
| Warm, lightly human | Jokey or emoji-heavy |

**Reading level:** grade 7–8. Short sentences. One idea per line. Active voice. Second person
("your margin"), never "users". Contractions are fine.

**Banned words and phrases:** revolutionary, game-changer, seamless, leverage (as a verb), unlock,
supercharge, "in today's fast-paced world", "we're excited to announce", AI-powered (unless it
literally is), "best-in-class", any superlative we can't prove.

**Numbers:** always concrete. Not "save money" → "see the 11% margin you're actually making".

---

## 3. Headline formulas (pick one, don't invent a sixth)

1. **Outcome + speed** — "Know your real margin in 10 seconds"
2. **Stop X, start Y** — "Stop guessing your break-even ROAS"
3. **Number + benefit** — "3 inputs. Your true profit per order."
4. **The correction** — "Margin and markup are not the same number"
5. **Plain tool name** — "Profit Margin Calculator" *(the default for H1s — the keyword IS the promise)*

**H1 rule:** on tool pages, the H1 is the tool's name (matching the primary keyword). The clever
headline, if any, goes in the one-line promise beneath it.

---

## 4. Page copy blocks

### Tool page skeleton
```
H1:        Profit Margin Calculator
Promise:   Enter your cost and price. See margin, markup and the profit in every order.
Trust:     Free. No signup. Your numbers stay in your browser.
[TOOL]
How it works:  1. Enter your product cost  2. Add fees and shipping  3. Read your margin
Formula:   Margin % = (Price − Total cost) ÷ Price × 100
Example:   A $40 product costing $17 with $4 fees → 47.5% margin, $19 profit.
Pitfalls:  Most stores forget payment fees and returns. Both come out of this number.
FAQ:       3–6 real questions
Related:   3–6 tools
```

**Promise line rules:** under 15 words, states the input and the output, no adjectives.
**Trust line rule:** only render the "stays in your browser" clause when `mode == client`. If a tool
posts to the server, the line changes to "Free. No signup. We don't store what you enter." — and
that must be true.

---

## 5. CTAs

**Rule:** the button says the result, in the user's words.

| Context | Use | Never |
|---|---|---|
| Calculator | `Calculate my margin` | `Submit` |
| Generator | `Generate 10 headlines` | `Go` |
| Copy action | `Copy result` → `Copied` | `Copy to clipboard (success!)` |
| Email capture | `Send me the spreadsheet` | `Subscribe` |
| Newsletter | `Get new tools by email` | `Join our community` |
| Example data | `Load example` | `Try demo` |
| Reset | `Clear` | `Reset form` |

Secondary actions are plain links, not buttons. One primary action per screen. Live-calculating
tools often need **no submit button at all** — the result updates as they type, which is the whole
point of client-side math.

---

## 6. Microcopy

| Element | Pattern | Example |
|---|---|---|
| Field label | Noun, no colon, no "please" | `Product cost` |
| Helper text | What to include, one line | `What you pay your supplier, per unit` |
| Placeholder | A realistic value, never the label | `17.00` |
| Validation | What to do, not what's wrong | `Enter a number above 0` |
| Empty result | Tell them the next step | `Enter a cost and price to see your margin` |
| Loading (server tools) | Honest | `Calculating…` |
| Error | Human + recovery | `That didn't work. Check the numbers and try again.` |
| Zero state on search | Offer a path | `No tool for "x" yet. Tell us what you need →` |
| Consent | Explicit, unticked | `Email me new tools about once a month. Unsubscribe any time.` |
| Success | Confirm + next step | `Check your inbox to confirm. Nothing until you do.` |

**Units and currency:** the symbol sits in the label or an input prefix (`$ Product cost`), never
inside the placeholder. Percentages always carry `%`. Results round to 2 decimals for money and
1 for percentages, and say so when rounding matters.

---

## 7. Accessibility is copy too

- Every input has a real `<label for>`. Placeholders are never labels.
- Link text makes sense alone: "break-even ROAS calculator", not "read more".
- Results announce politely via `aria-live="polite"` — one concise sentence, not the whole table.
- Icon-only buttons carry `aria-label` ("Copy result").
- Error text is tied to its field with `aria-describedby`.

---

## 8. Legal and honesty rules

- Never say "free forever" unless we commit to it. Say "free, no signup" — true today and tomorrow.
- Never imply a platform endorses us. Use "Fee calculator for Shopify sellers" + "Not affiliated
  with Shopify." Never use their logo or brand colours.
- Financial/tax outputs carry: "This is an estimate, not tax advice."
- Any external number gets a source and a date, or it doesn't get published.
- Usage counts are rendered only from real data, and only above a floor (e.g. 500 uses), so the
  number is never embarrassing *or* fake.

---

## 9. Email copy

**Subject:** 4–7 words, specific, no clickbait. "The margin math most stores get wrong."
**Body:** one tip (3 short paragraphs), one new-tool line, one link. Plain text feel, no pixel.
**Sign-off:** a human name. **Footer:** one-line unsubscribe, no dark pattern.

---

## 10. Pre-publish checklist

- [ ] H1 is the primary keyword, exactly one `<h1>`
- [ ] Promise line under 15 words, input → output
- [ ] Trust line is literally true for this tool's mode
- [ ] Every CTA names its outcome
- [ ] No banned words
- [ ] Every number has a source or is computed on the page
- [ ] Grade 7–8 reading level, no sentence over 25 words
- [ ] Labels, helper text, validation and empty state all written (no browser defaults)
- [ ] FAQ answers the question in the first sentence, then explains
