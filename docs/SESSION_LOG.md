# SESSION LOG

Newest entry on top. A new session must be able to resume from `AGENTS.md` + `docs/PLAN.md` +
`docs/TASKS.md` + **the top entry here**. Template at the bottom.

---

## 2026-10-09 · P0-T01 · Knowledge base, skills, plan, task board · **done**

**Done**
- Created the full knowledge base: `AGENTS.md`, `README.md`, and `docs/` — `MASTER_PROMPT.md`
  (saved verbatim), `PLAN.md`, `TASKS.md`, `ARCHITECTURE.md`, `DECISIONS.md`, `TOOLS_CATALOG.md`,
  `SEO_PLAYBOOK.md`, `GROWTH_PLAYBOOK.md`, `COPY_GUIDE.md`, `DESIGN_TOKENS.md`, `LICENSES.md`,
  this log.
- Created 14 skill files in `.agent/skills/`, each a usable checklist (not a placeholder).
- Created `scripts/check_line_limit.sh` (hard 600 / soft 400, git-aware, excludes vendor +
  migrations + minified) and `scripts/check.sh` (line limit → ruff → pytest → `node --test`,
  skipping gates that don't exist yet). Both pass.
- Catalogued **129 tools** across 7 categories with slug, S/A, primary keyword, mode and phase.
- Drafted **40 tasks** (Phases 0–4) with dependencies and acceptance criteria.
- Verified every stack fact against live sources (PyPI, npm registry, hosting comparisons,
  Django release roadmap) rather than memory — see `LICENSES.md` for versions and dates.

**Decisions made** (13 ADRs in `DECISIONS.md`, ADR-001…013) — the eight that change the brief:
Django **5.2 LTS** not 6.x · no Django Ninja/Redis/queues yet · Alpine **CSP build** from day one ·
**no Tailwind until Phase 7** · SQLite in prod initially · **Oracle Always Free** over Render
(Render free web sleeps at ~15 min idle and its free Postgres expires after 30 days) · default
Django admin for Phase 2 · Ruff + a **`node --test` suite for browser formulas** (because
client-side money math must be unit-tested).

**Half-done / not started**
Nothing is half-done. No application code exists yet — that is intentional per the brief
("Do Task 0 only… Stop and wait for my approval").

**Exact next step**
`P0-T02 — Tooling and dependency baseline`: create `pyproject.toml` (ruff + pytest config),
`requirements/{base,dev,prod}.txt` pinned to Django 5.2.x, `.env.example`, and a GitHub Actions
workflow that runs `scripts/check.sh`. Then `P0-T03` (Django skeleton + settings split + `/healthz`).

**Commands to run**
```bash
bash scripts/check_line_limit.sh     # expect OK
bash scripts/check.sh                # expect ALL CHECKS PASSED (ruff/pytest/node gates skipped)
```

**Known issues / risks**
- Dev box has **Python 3.11.2**; Django 6.x would need 3.12+. Another reason 5.2 LTS is the pick.
- Three questions are open for the founder (`PLAN.md` §8): public brand name, audience bias
  (SMB sellers vs 7-figure DTC), and default currency. Defaults assumed: keep `e-comhub` for now,
  SMB-first, USD with a selector.
- `psycopg` 3.x is LGPL — flagged in `LICENSES.md`. Irrelevant while we're on SQLite, but it must
  be a conscious decision if we ever move to Postgres.

**Blocked on:** founder approval of the stack (the 8 changes) before P0-T02 starts.

---

## Template for the next entry

```
## YYYY-MM-DD · <TASK-ID> · <title> · <done|partial|blocked>

**Done**            bullets of what actually landed
**Decisions made**  with ADR numbers if any
**Half-done**       exact file + what's missing
**Exact next step** the literal next action, not a vague direction
**Commands to run** copy-pasteable
**Known issues**    bugs, risks, stale assumptions
**Blocked on**      person or decision, if anything
```
