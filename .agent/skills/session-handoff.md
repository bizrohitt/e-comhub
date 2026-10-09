# Skill: end a session cleanly

**Purpose.** Make the next session productive from a cold start, with no memory of this one.
**When to use.** Every session end, and immediately when context feels ~70% used.

## The test
A new agent reads `AGENTS.md` + `docs/PLAN.md` + `docs/TASKS.md` + the **top entry** of
`docs/SESSION_LOG.md` and can continue without asking a single question. If that's not true, the
log entry isn't finished.

## Checklist

1. **Leave the repo green.** `scripts/check.sh` passes. If you can't finish, revert the broken part
   rather than committing it — a red repo costs the next session more than lost work.
2. **No half-written file.** Partial work is fine; *ambiguous* work is not. Mark unfinished spots
   with `# TODO(P3-T06): <exact next action>` so they're greppable.
3. **Update `docs/TASKS.md`** — status, and a one-line note if acceptance criteria changed.
4. **Update `docs/TOOLS_CATALOG.md`** if any tool's status moved.
5. **Add an ADR** to `docs/DECISIONS.md` for any decision that a future session might otherwise
   re-litigate (choice of library, data shape, naming, trade-off accepted).
6. **Prepend the log entry** (newest on top) using the template at the bottom of `SESSION_LOG.md`:
   - **Done** — what actually landed, not what was attempted
   - **Decisions made** — with ADR numbers
   - **Half-done** — the exact file and what's missing
   - **Exact next step** — a literal action: "create `tools/base.py` with the four dataclasses"
   - **Commands to run** — copy-pasteable, in order
   - **Known issues** — bugs, risks, assumptions that might be wrong
   - **Blocked on** — the person or the decision
7. **Commit** with the task ID first: `P1-T02: tool registry with auto-discovery`.
8. **Report to the founder:** Done · How to test · Risks · Next task · One idea.

## Writing the "exact next step"
| Bad | Good |
|---|---|
| "Continue the registry" | "Add `validate()` to `tools/registry.py`: duplicate slug, missing category folder, <3 FAQs, dangling `related`. Then wire it into `check_tools`." |
| "Fix the tests" | "`tests/python/test_registry.py::test_duplicate_slug` fails because discovery caches the first import — clear `_REGISTRY` in a fixture." |

## Do-nots
- Don't start the next task "since there's room". One task per session (AGENTS.md rule 1).
- Don't paste file contents into the log — paths and line ranges only.
- Don't write "see the diff" as the handoff. The next session won't read the diff.
- Don't leave a decision undocumented because it felt obvious at the time. It won't be.
