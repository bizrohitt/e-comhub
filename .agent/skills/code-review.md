# Skill: self-review before "done"

**Purpose.** Catch what you'd be embarrassed by tomorrow. Run this *before* you report, every time.
**When to use.** Every task, no exceptions. Budget 10 minutes.

## 1. Re-read the task
- [ ] Every acceptance criterion in `docs/TASKS.md` is literally met (read them again, don't recall them).
- [ ] Scope didn't creep: ≤5 files, ≤~500 new lines. If it did, split the task and log the rest.

## 2. Read your own diff, top to bottom
- [ ] Nothing committed by accident: no `print`, no `console.log`, no `breakpoint()`, no commented-out
      code, no `.env`, no fixture dumps, no editor files.
- [ ] Names say what the thing is. No `data`, `tmp`, `helper2`, `handleStuff`.
- [ ] No magic numbers — named constants with a comment or a source.
- [ ] No duplicated logic; nothing that belongs in `core/` left inside a tool.
- [ ] Public functions have a docstring; formulas cite the formula and its source.
- [ ] Type hints where they clarify (money, units, optionals).

## 3. Correctness
- [ ] Edge cases tested: zero, negative, empty, missing, huge (1e12), fractional cents, divide-by-zero.
- [ ] `NaN` / `Infinity` / `None` can never reach the DOM or a template.
- [ ] Rounding is explicit and consistent (money: half-up, 2 dp) and matches between JS and Python
      where both exist.
- [ ] One worked example verified **by hand**, not by the code.

## 4. Web layer
- [ ] ≤3 queries per page, asserted in a test. No N+1.
- [ ] Page weight inside budget (`.agent/skills/performance-audit.md`).
- [ ] Mobile 360px: no horizontal scroll, tool above the fold, 44px targets.
- [ ] Keyboard only: can reach, operate and read every control and result.
- [ ] Labels on inputs, `aria-live` on results, one `<h1>`, sensible heading order.
- [ ] JS off: the content still answers the question.

## 5. Copy
- [ ] Headline, promise, CTA, helper text, empty state, error state and success state all written.
- [ ] No banned words; every claim is true; trust line matches the tool's actual `mode`.

## 6. Security and privacy
- [ ] Inputs validated server-side where they reach the server; rate limit on new endpoints.
- [ ] No user text rendered unescaped; no secret added; nothing new logged or stored.

## 7. House rules
- [ ] `scripts/check.sh` green (line limit, ruff, pytest, node --test).
- [ ] No file over 600 lines; nothing new over 400 without a plan.
- [ ] New dependency → `LICENSES.md` row (+ ADR if notable).
- [ ] `TASKS.md`, `TOOLS_CATALOG.md`, `DECISIONS.md`, `SESSION_LOG.md` updated.

## 8. The two honest questions
- **If this breaks at 2am, is the cause obvious from the code and the log entry?**
- **Would I defend every line of this to another engineer?** If not, fix it now — "later" is a lie.

## Output format
Report: **Done** · **How to test** · **Risks** (say "none known" only if you looked) ·
**Next task** · **One idea**.

## Do-nots
- Don't mark done with a failing or skipped test. A skipped test is a failing test with a disguise.
- Don't report work you didn't verify by running it.
- Don't fix an unrelated thing you noticed — log it as a task instead.
