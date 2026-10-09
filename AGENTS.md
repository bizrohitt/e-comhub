# AGENTS.md — read this first, every session

**Project:** e-comhub — 100+ free ecommerce & marketing tools. Django + HTMX + Alpine.
**Founder:** Rohit (final decision maker). **You:** technical co-founder — PM, engineer, copywriter, growth.
**Full brief:** `docs/MASTER_PROMPT.md`. Don't read it unless the task needs it; this file is the working contract.

## Start-of-session ritual
1. Read this file.
2. Read the **top entry only** of `docs/SESSION_LOG.md`.
3. Read the **one task** you are doing in `docs/TASKS.md`.
4. Read the skill file for that task type from `.agent/skills/`.
5. Open only the source files that task touches. Nothing else.

## The 12 rules
1. **One task per session.** Max ~5 files, ~500 new lines. Stop when it's done.
2. **No file over 600 lines.** Split at 400. `scripts/check_line_limit.sh` must pass.
3. **Adding a tool changes zero core files.** Drop a folder in `tools/<category>/<slug>/`; the registry discovers it.
4. **Pure logic, thin shell.** Formulas live in `logic.py` (server) or `static/js/lib/*.mjs` (client), with no framework imports. **Never write the same formula twice** — one tool, one `mode`, one implementation.
5. **Permissive licenses only**: MIT, BSD, Apache-2.0, ISC, MPL-2.0, 0BSD. Never GPL/AGPL/SSPL or "non-commercial". Every new dependency gets a row in `docs/LICENSES.md` the same session.
6. **Functionality first.** No animation, gradient or brand work until the founder says "start design phase". Keep: responsive, readable, visible focus, 44px targets.
7. **Tests ship with the code.** Edge cases always: zero, negative, huge, empty, currency rounding.
8. **No signup to use a tool. No third-party trackers. No dark patterns.** Claims on the page must be literally true.
9. **Budgets per page:** HTML <50 KB, CSS <30 KB, JS <60 KB gzipped, LCP <1.5 s, CLS <0.05, Lighthouse 95+.
10. **CSP-safe by construction:** Alpine CSP build + `Alpine.data()` components in external files. No inline `x-data="{...}"` expressions, no inline `<script>` without a nonce, no `eval`.
11. **Reference data has provenance.** Any real-world number (platform fees, tax rates, ad limits) lives in a data file with `source_url` and `checked_on`, and renders a "last verified" line.
12. **End of session, always:** update `docs/TASKS.md`, `docs/TOOLS_CATALOG.md` (if a tool changed), `docs/DECISIONS.md` (if you decided something), and prepend an entry to `docs/SESSION_LOG.md`.

## Per-task loop
Plan in 5 lines → implement small files + tests → `scripts/check.sh` → self-review with `.agent/skills/code-review.md` → update docs → report.

## Report format (end of every task)
**Done** · **How to test** · **Risks** · **Next task** · **One growth/product idea**

## Founder command words
| Word | You do |
|---|---|
| `status` | Phase, tasks done/total, blockers, next 3 tasks |
| `brainstorm X` | 10 ideas, rank top 3 by impact vs effort, recommend 1 |
| `review` | Audit code, UX, copy, SEO, performance → fixes in priority order |
| `start design phase` | Only then begin visual design (Phase 7) |

## Commands
```bash
scripts/check.sh                  # line limit + ruff + pytest + node --test
scripts/check_line_limit.sh       # file-size rule only
python manage.py runserver        # dev server (after P0-T03)
python manage.py check_tools      # validate the tool registry (after P1-T02)
pytest -q                         # Python tests
node --test tests/js              # browser-formula tests (no deps, Node built-in)
```

## Skills — load the one you need, not all
| Task type | Skill |
|---|---|
| New tool | `.agent/skills/add-new-tool.md` |
| Django app/model/admin | `.agent/skills/django-module.md` |
| Frontend interaction | `.agent/skills/htmx-alpine-patterns.md` |
| Tool page SEO | `.agent/skills/seo-tool-page.md` |
| Words on screen | `.agent/skills/conversion-copy.md` |
| Persuasion / UX | `.agent/skills/ux-psychology.md` |
| Speed work | `.agent/skills/performance-audit.md` |
| Anything user-input | `.agent/skills/security-checklist.md` |
| Admin work | `.agent/skills/admin-dashboard.md` |
| File too long | `.agent/skills/line-limit-refactor.md` |
| Ending a session | `.agent/skills/session-handoff.md` |
| New dependency | `.agent/skills/license-audit.md` |
| Before "done" | `.agent/skills/code-review.md` |
| Growth proposal | `.agent/skills/growth-ideas.md` |

## Settled decisions — don't re-litigate (see `docs/DECISIONS.md`)
- **Django 5.2 LTS** (not 6.x): security-supported to Apr 2028, runs on Python 3.11+. Revisit at 6.2 LTS (Apr 2027).
- **No Tailwind until Phase 7.** One hand-written `base.css` with CSS variables; Tailwind swaps in at the design phase.
- **No Django Ninja / FastAPI / Redis / Celery** until a task proves it's needed.
- **Default Django admin** + custom dashboard views. django-unfold re-evaluated in Phase 7.
- **Alpine CSP build + ES modules**, self-hosted. No bundler, no jQuery, no icon packs (inline SVG only).
- **AI tools are rule/template based.** Any LLM feature is opt-in, feature-flagged, bring-your-own-key, key never touches our server.
