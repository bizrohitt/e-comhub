# Skill: add a new tool

**Purpose.** Ship one tool end-to-end without touching a single core file.
**When to use.** Any `P3-*` or `P5-*` task. Read this before writing anything.

## Before you start
- Find the tool's row in `docs/TOOLS_CATALOG.md` — slug, S/A, primary keyword, mode. If there's no
  row, add one first; the catalog is the contract.
- `mode` decides everything: `client` = formula in JS, `server` = formula in Python. **`hybrid`
  needs an ADR** — you almost certainly don't want it (ADR-007).

## Checklist

1. **Create the folder** `tools/<category>/<slug_snake_case>/` with `__init__.py`.
2. **Write `tool.py`** — one module-level `TOOL = ToolSpec(...)`. Required: `slug` (kebab-case,
   permanent), `name`, `category`, `short_description` (≤155 chars, doubles as meta description),
   `primary_keyword` (exactly one), 3–6 `faq` entries, 3–6 `related` slugs, `mode`, `updated`.
3. **Write the formula, once:**
   - `client` → `static/js/lib/<topic>.mjs`: pure functions, no DOM, no Alpine, named exports.
     Reuse an existing module if the math already exists (ROAS/CPA share one).
   - `server` → `logic.py`: pure functions, **no Django imports**, docstring with the formula and
     its source, named constants (no magic numbers).
4. **Write the tests with the formula, not after:**
   - `tests/js/<topic>.test.mjs` with `node:test` + `node:assert/strict`
   - or `tools/<category>/<slug>/tests.py` with pytest
   - Mandatory cases: zero, negative, empty/missing, huge (1e12), fractional cents, divide-by-zero,
     and one real-world scenario whose answer you worked out by hand.
5. **Write `template.html`** — a fragment (no `<html>`, no `<head>`). Labelled inputs, sensible
   defaults, result panel with `aria-live="polite"`, and the shared action bar
   (`{% include "partials/tool_actions.html" %}`). For client tools: `x-data="toolName"` referring
   to a component registered in `static/js/tools/<slug>.mjs` — **never an inline object literal**
   (ADR-003).
6. **Write `content.md`** — how it works (3 steps), the formula written out, a worked example with
   real numbers, a "when this is wrong / what people forget" section. This is the part that ranks
   and earns links. Follow `.agent/skills/seo-tool-page.md`.
7. **Reference data?** Put it in `_data/<name>.yaml` with `source_url`, `checked_on`,
   `review_every_days`, and declare it in `ToolSpec.data_sources`. The page must print
   "verified on <date>".
8. **Server mode only:** `forms.py` with strict validation (type, min/max, length) and a `/run/`
   view that returns an HTML fragment. Rate-limited. Never `eval`, never raw SQL, never trust input.
9. **Run the gates:** `scripts/check.sh` — line limit, ruff, pytest, node --test. All green.
10. **Verify the plugin contract:** `python manage.py check_tools` passes, the tool appears on the
    home page, its category hub, search results and `sitemap.xml` — **and your diff touches no file
    outside the tool folder, `static/js/`, and `tests/`.** If it does, the registry is wrong; fix
    the registry in a separate task rather than special-casing the tool.
11. **Update docs:** catalog row → `live`, `SESSION_LOG.md` entry, `TASKS.md` status.

## Output format (your report)
**Done** · **How to test** (exact URL + command) · **Risks** · **Next task** · **One idea**

## Do-nots
- Don't implement the same formula in two languages.
- Don't add a dependency for something 30 lines of standard library can do.
- Don't write the content block last or treat it as filler — it's half the value of the page.
- Don't invent benchmark numbers or fees. Source them, date them, or omit them.
- Don't copy a competitor's wording, FAQ or layout. Write original text from the formula.
- Don't exceed 600 lines in any file, or 5 files of churn in one session.
