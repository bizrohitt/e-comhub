# Skill: create or extend a Django app

**Purpose.** Keep apps small, single-purpose and boring.
**When to use.** Any task that adds a model, migration, admin registration or app-level view.

## App boundaries (don't blur them)
`core` plumbing (SEO, middleware, utils, flags) · `tools` registry + generic tool rendering ·
`pages` information architecture (home, hubs, search, legal) · `leads` email + consent ·
`analytics` aggregate counting · `adminpanel` founder control surface.
**A tool folder is not an app** — no models, no migrations, no `apps.py`.

## Checklist

1. **Justify the app.** New app only if it owns data or a distinct responsibility. Otherwise extend
   an existing one. Adding an app is a decision → `DECISIONS.md`.
2. **Create it** under the project root, add to `INSTALLED_APPS` in `config/settings/base.py`.
   Delete the files you don't need (`tests.py` stub, `views.py` if empty) — no dead code.
3. **Models**
   - Explicit `verbose_name`/`help_text` on anything the founder will see in admin.
   - Index every field used in a filter or lookup; `unique_together`/`UniqueConstraint` where real.
   - `created_at`/`updated_at` via `auto_now_add`/`auto_now` when the row's history matters.
   - `__str__` returns something human. `Meta.ordering` set deliberately.
   - **Never store** tool inputs, raw IPs, user agents or anything we don't need (privacy stance).
4. **Migrations.** One per task, named: `python manage.py makemigrations <app> -n add_toolmeta`.
   Review the generated file — no surprise table rewrites. Data migrations get a reverse function.
5. **Queries.** `select_related`/`prefetch_related` on anything rendered in a loop. Aggregate in the
   DB (`Count`, `Sum`, `F`), never in Python. Target ≤3 queries per page; assert it in a test.
6. **Views.** Function or class, whichever is shorter. Thin: fetch, delegate to a service function,
   render. Business logic lives in `services.py`, not in the view.
7. **Admin.** Register in the same task. `list_display`, `list_filter`, `search_fields`,
   `readonly_fields` for computed/audit fields. See `.agent/skills/admin-dashboard.md`.
8. **Tests** in `tests/python/test_<app>.py`: one for each model constraint, one per view (200 +
   correct template + query count), one for each permission boundary.
9. **Settings.** Anything environment-specific goes in `dev.py`/`prod.py` and is read from env with
   a safe default. Never commit a secret; update `.env.example` in the same commit.
10. Run `scripts/check.sh`, update `TASKS.md` and `SESSION_LOG.md`.

## Output format
**Done** · **How to test** (`pytest -q tests/python/test_<app>.py`) · **Risks** · **Next** · **Idea**

## Do-nots
- No signals for business logic (only for audit logging). They hide control flow.
- No `null=True` on a `CharField` (use `blank=True` + `""`).
- No fat models with view logic, no fat views with query logic.
- No new third-party app without `.agent/skills/license-audit.md` and an ADR.
- No `migrate` on prod data without a tested backup (`ARCHITECTURE.md` §8).
