# Skill: write the words

**Purpose.** Produce copy that gets the user to their answer and earns the right to ask for an email.
**When to use.** Any task that puts text on a screen — tool pages, forms, errors, emails, admin.
**Reference.** `docs/COPY_GUIDE.md` is the full spec; this is the working loop.

## The loop

1. **Name the reader's job.** One sentence: "A seller wants to know if $40 is enough to be
   profitable." Write to that, not to a persona document.
2. **Write the promise first.** Under 15 words, input → output, no adjectives. If you can't write
   it, the tool's scope is unclear — fix the tool, not the sentence.
3. **Pick a headline formula** (COPY_GUIDE §3). On tool pages the H1 is just the tool name; the
   crafted line goes underneath.
4. **Write the CTA as the result.** `Calculate my margin`, `Generate 10 headlines`,
   `Send me the spreadsheet`. Never `Submit`, `Go`, `Subscribe`.
5. **Write every state before you write the happy path:** empty, loading, invalid, zero result,
   error, success. Missing states are the most common review failure.
6. **Cut 30%.** First draft → delete every adverb, every "simply", every "just", every sentence
   that restates the previous one. Then read it aloud; anything you stumble on gets rewritten.
7. **Check honesty.** Every claim must be true *today*: "no signup" (true), "free forever" (don't
   say it), "trusted by thousands" (not until `UsageDaily` says so).
8. **Check reading level.** Grade 7–8, no sentence over 25 words, one idea per line.

## Snippets that work here

| Need | Use |
|---|---|
| Trust line (client tool) | `Free. No signup. Your numbers stay in your browser.` |
| Trust line (server tool) | `Free. No signup. We don't store what you enter.` |
| Email ask, after a result | `Want this as a spreadsheet? We'll email it and nothing else.` |
| Newsletter | `New tools by email, about once a month. Unsubscribe in one click.` |
| Empty result | `Enter a cost and a price to see your margin.` |
| Validation | `Enter a number above 0.` |
| Error | `That didn't work. Check the numbers and try again.` |
| Zero search results | `No tool for "{q}" yet. Tell us what you need →` |
| Disclaimer | `Estimate only — not tax or financial advice.` |
| Platform page | `Not affiliated with Shopify. Fees verified on 12 Sep 2026.` |

## Output format
Deliver copy as the final strings in the template/content file, never as a list of options in chat.
In your report, quote only the H1 and the promise line.

## Do-nots
- No banned words: revolutionary, seamless, supercharge, unlock, game-changer, "in today's…".
- No exclamation marks outside a genuine success confirmation (and at most one).
- No emoji in product UI. (Newsletter subject lines: still no.)
- No confirm-shaming ("No thanks, I like losing money"), no pre-ticked consent, no fake urgency.
- No placeholder-as-label. No "Lorem". No copy written after the code "to be polished later".
