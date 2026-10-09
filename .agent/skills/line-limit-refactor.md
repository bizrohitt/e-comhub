# Skill: split an oversized file

**Purpose.** Keep every file under 600 lines (target 150–300) without breaking behaviour.
**When to use.** `check_line_limit.sh` warns at 400 or fails at 600 — or you can feel a file sprawling.

## Rule of thumb
A file is too big *before* it hits the limit if you can't describe it in one sentence without "and".

## Checklist

1. **Stop adding.** Split first, then continue the feature. Never "finish this one thing" at 580 lines.
2. **Make sure tests cover the file** before you move anything. If they don't, write the
   characterisation tests first — that's the whole safety net.
3. **Find the seam** — group by responsibility, not by line count:
   | File type | Typical seams |
   |---|---|
   | `views.py` | per feature area → `views/<area>.py` with a package `__init__.py` |
   | `models.py` | per aggregate → `models/<entity>.py`; keep `Meta` and managers with their model |
   | `logic.py` | per calculation family → `logic/<topic>.py`; pure functions move cleanly |
   | `admin.py` | per model → `admin/<model>.py` |
   | template | extract blocks into `partials/` and `{% include %}` |
   | CSS | tokens / layout / components → separate files, or `@layer` sections |
   | `.mjs` | one module per formula family; components stay separate from formulas |
   | doc | split by audience or phase, and link from the parent |
4. **Move, don't rewrite.** One commit that only relocates code (tests must pass unchanged), then a
   second commit for any behaviour change. Never mix the two — it makes review impossible.
5. **Preserve the public import path.** Turn the module into a package and re-export in
   `__init__.py` so callers don't change:
   ```python
   # tools/ecommerce/x/logic/__init__.py
   from .margin import margin, markup          # noqa: F401
   from .fees import platform_fees             # noqa: F401
   ```
6. **Re-run everything:** `scripts/check.sh`. Diff the rendered HTML of an affected page before and
   after if you split a template.
7. **Update** any `docs/ARCHITECTURE.md` path references and note the split in `SESSION_LOG.md`.

## When splitting is the wrong answer
- The file is long because of **duplication** → extract a shared helper into `core/` instead.
- The file is long because of **dead code** → delete it.
- The file is long because of **one giant data literal** → move it to `_data/*.yaml`.
- The file is long because the **module does three jobs** → that's a design fix, not a file split.

## Output format
"Split `X` (N lines) into `A` (n1), `B` (n2), `C` (n3). No behaviour change; tests unchanged and green."

## Do-nots
- Don't split mid-task and leave half the imports broken for the next session.
- Don't create `utils2.py`, `helpers.py`, `misc.py` — name files after what they own.
- Don't create a 12-file package for a 400-line module. Two or three files is usually right.
- Don't bypass the limit by making lines longer. Ruff's line length still applies.
