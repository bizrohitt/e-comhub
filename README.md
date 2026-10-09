# e-comhub

Free online tools for ecommerce brands, marketers and copywriters — calculators, generators and
formatters that competitors charge for. Fast, mobile-first, no signup, most tools run entirely in
your browser.

**Status:** Phase 0 — foundation. No application code yet. Planning and knowledge base are in `docs/`.

## Stack

Django 5.2 LTS (Python 3.11+) · Django templates + HTMX + Alpine (CSP build) · SQLite in dev ·
WhiteNoise + Cloudflare · pytest + `node --test` · Ruff. No bundler, no SPA, no paid services.

## Repo map

| Path | What |
|---|---|
| `AGENTS.md` | Working rules the AI agent reads every session |
| `docs/PLAN.md` | Roadmap, phases, milestones |
| `docs/TASKS.md` | Task board (IDs, deps, acceptance criteria) |
| `docs/ARCHITECTURE.md` | Folder map, data model, tool plugin contract |
| `docs/TOOLS_CATALOG.md` | All 129 planned tools |
| `docs/SESSION_LOG.md` | Handoff notes, newest first |
| `.agent/skills/` | Task playbooks for the agent |
| `scripts/` | `check.sh`, `check_line_limit.sh` |

## Local checks

```bash
scripts/check.sh              # runs every check that applies to the current state of the repo
```

## House rules

No file over 600 lines · permissive licenses only (MIT/BSD/Apache-2.0/ISC/MPL-2.0/0BSD) ·
no third-party trackers · no dark patterns · every page under budget (HTML <50 KB, JS <60 KB gz).
