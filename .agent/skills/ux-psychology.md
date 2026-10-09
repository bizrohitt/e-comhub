# Skill: ethical persuasion

**Purpose.** Apply behavioural principles that help the user decide, without manipulating them.
**When to use.** Designing any flow with a choice: tool layout, email capture, result presentation.
**Test for every tactic:** *would I be comfortable if the user saw exactly how this works?*
If no, it's a dark pattern. Delete it.

## The principles we use, and the exact implementation

| Principle | Implementation here | The honest constraint |
|---|---|---|
| **Reciprocity** | Full result, no gate, no signup. Ask only after value is delivered | Never gate the primary answer |
| **Loss aversion** | "At 20% off you need 61% more orders for the same profit" | The number must be computed, not rhetorical |
| **Anchoring** | "Tools like this usually sit behind a $29/mo plan" | Only with a verifiable comparison; otherwise omit |
| **Authority** | Formula shown, variables defined, source cited | If we can't cite it, we don't claim it |
| **Social proof** | "Used 4,812 times this month" from `UsageDaily` | Real counts only, hidden below a floor (e.g. 500) |
| **Commitment** | Multi-step wizards with a progress bar, state in the URL | Max 4 steps; back always works |
| **Endowment** | "Your scenario" — copy, download, share, keep | Nothing is stored server-side to create it |
| **Default effect** | Prefilled sensible values + "Load example" | Defaults must be reasonable, never self-serving |
| **Curiosity gap** | Headlines and newsletter subjects | The page must actually answer it, immediately |
| **Peak-end** | Clear next step after every result ("now check your break-even ROAS") | A helpful next step, not an upsell |
| **Cognitive load** | ≤5 visible inputs; advanced options collapsed | Collapse must not hide something required |

## Flow checklist
1. User lands → sees the tool, not a pitch. Time-to-first-input under 3 seconds.
2. Inputs are prefilled → never a blank-page stare.
3. Result updates live → feedback loop, no "submit and wait".
4. Result is *interpreted*, not just printed: "47.5% margin — healthy for physical products".
5. Then, and only then: copy / share / download, a related tool, and an optional email offer.
6. Nothing blocks, nothing pops, nothing resets their work.

## Do-nots (hard bans)
- Fake counters, fake timers, fake "X people viewing", fake stock or seat counts.
- Email-to-unlock-result, exit-intent popups, interstitials, scroll-jacking.
- Pre-ticked consent, hidden unsubscribe, confirm-shaming decline buttons.
- Colour-only signalling of good/bad results (accessibility + honesty).
- Defaults chosen to flatter the result (e.g. omitting fees to show a bigger margin).
- "Negative option" anything. If we'd need to explain it to a regulator, it's out.

## Output format
In your report, name the one principle you applied and the exact element that carries it.
If a task applies none, say so — not every screen needs persuasion.
