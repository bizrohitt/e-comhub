# SESSION LOG

Newest entry on top. A new session must be able to resume from `AGENTS.md` + `docs/PLAN.md` +
`docs/TASKS.md` + **the top entry here**. Template at the bottom.

---

## 2026-10-09 · P0-T02 · Tooling and dependency baseline · **done**

**Done**
- `pyproject.toml` — ruff (py311 target, 100 cols, rule set `E W F I UP B C4 DJ S T20 SIM RUF`,
  per-file ignores for settings/tests/scripts) + pytest config (`DJANGO_SETTINGS_MODULE=
  config.settings.dev`, `--strict-markers --strict-config`, DeprecationWarning → error).
- `requirements/{base,dev,prod}.txt` — exact pins, each with its license in a trailing comment:
  Django **5.2.18** (LTS, released 2026-10-06), whitenoise 6.12.0, python-dotenv 1.2.4;
  dev adds pytest 9.1.1, pytest-django 4.14.0, ruff 0.16.10; prod adds gunicorn 26.2.0.
- **Verified the pins actually resolve** — clean install into `.venv` on Python 3.11.2, no
  conflicts. Not a paper exercise.
- `.env.example` — every key the settings module will read: core, database path, prod security,
  rate limits, email (needed at P4), bootstrap feature flags.
- `.github/workflows/ci.yml` — runs `scripts/check.sh` on a 3.11/3.12 matrix, pip cache,
  concurrency cancel, read-only token.
- `scripts/check.sh` rewritten: prefers `.venv/bin/*`, adds `ruff format --check` and
  `manage.py check` gates, and now *names* the reason when it skips one.

**Decisions made**
- **ADR-014** — `python-dotenv` + our own ~25-line typed `env()` helper instead of `django-environ`:
  we need file loading and casting, not its `DATABASE_URL`/`CACHE_URL`/`EMAIL_URL` parsers.

**Half-done / not started**
Nothing. Still zero application code — `config/` and `manage.py` arrive in P0-T03.

**Exact next step**
`P0-T03 — Django skeleton and settings split`: `django-admin startproject config .`, then split
settings into `base.py`/`dev.py`/`prod.py` with the typed `env()` helper, wire WhiteNoise, add
`core/views.py::healthz` returning `{"status": "ok"}`, and point `config/urls.py` at it. Then
`python manage.py check --deploy` with prod settings and fix every critical warning.

**Commands to run**
```bash
python3 -m venv .venv && .venv/bin/pip install -r requirements/dev.txt   # if .venv is missing
bash scripts/check.sh      # expect ALL CHECKS PASSED (django/pytest/node gates still skipped)
```

**Known issues / risks**
- Ruff 0.16 formats Python inside Markdown fences — a doc code sample was reformatted on the first
  run. Harmless and arguably good (docs stay consistent with the codebase), but expect it.
- `filterwarnings = ["error::DeprecationWarning"]` is deliberately strict; if a third-party
  deprecation ever blocks CI, add a targeted `ignore::` entry rather than removing the rule.
- CI has never run yet — it will execute for the first time on this push.

**Blocked on:** nothing.

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
