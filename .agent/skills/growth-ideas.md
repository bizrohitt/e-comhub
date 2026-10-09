# Skill: propose and prioritise growth experiments

**Purpose.** Turn "we could try X" into a ranked, testable queue with honest outcomes.
**When to use.** When the founder says **"brainstorm X"**, at every phase boundary, and whenever a
task surfaces an opportunity worth more than the task itself.

## The format for "brainstorm X"
1. **10 ideas.** Specific enough to build. "Improve SEO" is not an idea; "add a symmetric
   related-tools block to all 10 calculators" is.
2. **Score each with ICE** (1–10 each, multiply):
   - **Impact** — if it works, how much does it move the one metric that matters this phase?
   - **Confidence** — what evidence do we have? (Our own data 9–10 · a strong analogue 6–8 ·
     a hunch 1–3.) Be honest; inflated confidence is how roadmaps rot.
   - **Ease** — 10 = under an hour, 5 = a session, 1 = a phase.
3. **Rank, then recommend exactly one** with a one-line reason.
4. For the recommended one, write the **experiment card** below.
5. Append the table to `docs/GROWTH_PLAYBOOK.md` §5 with the date.

## Experiment card
```
Idea:        Shareable result URLs
Hypothesis:  If results restore from the URL, users will forward them, bringing referral visits
             that cost nothing to acquire.
Metric:      sessions with a hash-state URL on entry, per week
Baseline:    0 (feature doesn't exist)
Target:      >2% of tool sessions within 30 days
Cost:        one session (P4-T03)
Kill switch: feature flag `share_links`
Review on:   +14 days, then +30
Outcome:     (fill in: kept / killed / iterated — and the number)
```

## Where ideas should come from (in order of quality)
1. **`SearchMiss`** — people told us what's missing, on our own site. Free, highest confidence.
2. **`UsageDaily`** — which tools people actually return to; what the bottom 10 have in common.
3. **Search Console** — pages with impressions but no clicks (title/description problem) and
   queries we rank 8–20 for (a content gap, not a new page).
4. **Support/report-an-issue messages** — the only direct voice we get.
5. **Competitor gaps** — what they gate, what's stale, what's slow. Never what they *wrote*.
6. **Analogues from other tool sites** — lowest confidence; treat as hypotheses, not facts.

## Standing rules
- **One experiment at a time** per loop (search / share / embed), or you can't attribute anything.
- **14 days minimum** before judging anything SEO-adjacent; 90 for rankings.
- **Write the kill criteria before you ship.** An experiment with no kill criteria is a feature.
- **Record failures in the playbook.** A dead idea documented is cheaper than one re-tried yearly.
- **Nothing that violates `ux-psychology.md`** gets scored, however good the ICE number looks.

## Output format
A markdown table (idea · I · C · E · score · note), the single recommendation in one line, then the
experiment card for it. Nothing else.

## Do-nots
- Don't propose anything needing paid tooling, paid ads or a paid API before revenue exists.
- Don't propose tactics that need daily human effort (manual posting, outreach at volume) — the
  founder is one person and the whole model is compounding, not grinding.
- Don't bundle five changes into one "experiment".
- Don't report a result without the number.
