# PROJECT PLAN — The House Of Sahas

**Status:** Phase 0 in progress (discovery). No application code written yet.
**Last updated:** 2026-10-10
**Owner:** Founder + AI co-founder
**Rules:** See `MASTER_PROMPT.md` Section 4 (non-negotiables), Section 14 (phases), Section 17 (Definition of Done).

---

## How to read this file

- Every task gets an ID in the form `P<phase>-<nn>`, e.g. `P1-03`.
- A task must fit one focused session and touch roughly 1 to 3 files.
- A task is not started until the founder says **"go"** on its plan.
- A task is not done until every item in the Definition of Done (Section 17 of `MASTER_PROMPT.md`) passes.
- Statuses: `Not started` · `Planned` · `In progress` · `Blocked` · `Done`.

---

## Phase status board

| Phase | Focus | Output | Status |
|---|---|---|---|
| 0 | Discovery and decisions | Confirmed answers, locked stack | **In progress** |
| 1 | Foundation | Repo, tooling, Medusa running, DB, env, linting, CI, `LICENSES.md` | Not started |
| 2 | Commerce core (functionality only) | Products, cart, checkout, payments, orders, emails, plain pages | Not started |
| 3 | Admin panel | Roles, custom widgets, content blocks, reports | Not started |
| 4 | Design system and styling pass | Tokens, components, all pages styled | Not started |
| 5 | Homepage and motion pass | Sections, parallax, morphing navbar, transitions, performance tuning | Not started |
| 6 | Content and CMS | Editable pages, journal, SEO, PDF guide | Not started |
| 7 | Mobile admin app | Auth, orders, products, inventory, analytics, push | Not started |
| 8 | Growth features | Offers, membership, outfit builder, booking | Not started |
| 9 | QA and launch | Tests, accessibility, Lighthouse, security review, deployment, monitoring | Not started |

**Milestone:** the store can launch after Phase 6. Phases 7 to 9 add the mobile admin app, growth features and hardening.

---

## Phase 0 — Discovery and decisions

| ID | Task | Files | Acceptance criteria | Sessions | Status |
|---|---|---|---|---|---|
| P0-01 | Save master prompt verbatim; create knowledge file skeletons and `skills/` stubs | `MASTER_PROMPT.md`, `PROJECT_PLAN.md`, `SESSION_LOG.md`, `DESIGN_SYSTEM.md`, `ARCHITECTURE.md`, `COPY_BIBLE.md`, `OFFERS_PLAYBOOK.md`, `LICENSES.md`, `skills/*.md` | All nine knowledge files exist; `MASTER_PROMPT.md` matches the founder's text; skills stubs present | 1 | **Done** |
| P0-02 | Ask the Section 5 discovery questions with recommended defaults | — | Questions delivered, numbered, each with a default | 1 | **Done** |
| P0-03 | Receive and summarize founder answers for confirmation | `SESSION_LOG.md` | Answers written back, confirmed by founder | 1 | Blocked (awaiting answers) |
| P0-04 | Lock the technology stack and record licenses | `ARCHITECTURE.md`, `LICENSES.md` | Every layer chosen with version + license verified; alternatives noted | 1 | Not started |
| P0-05 | Fill `DESIGN_SYSTEM.md` (tokens, type scale, spacing, motion rules) | `DESIGN_SYSTEM.md` | Token table confirmed, contrast checked to WCAG AA | 1 | Not started |
| P0-06 | Fill `COPY_BIBLE.md` (voice, banned words, approved copy) | `COPY_BIBLE.md` | Two variants per key line, one recommended | 1 | Not started |
| P0-07 | Fill `OFFERS_PLAYBOOK.md` (launch, welcome, bundle, loyalty, win-back) | `OFFERS_PLAYBOOK.md` | Each offer has psychology, copy, rules, margin check, metric | 1 | Not started |
| P0-08 | Write `ARCHITECTURE.md` folder map and data flow | `ARCHITECTURE.md` | Monorepo layout agreed; integration adapter pattern documented | 1 | Not started |
| P0-09 | Generate Phase 1 task list (IDs, files, acceptance criteria) | `PROJECT_PLAN.md` | Founder approves the list; no code written | 1 | Not started |

---

## Phases 1 to 9 — task lists

Task lists for Phases 1 to 9 are generated one phase at a time, after the previous phase is complete and tested. Phase 1 tasks will be written in P0-09.

Placeholder for future tables:

```
| ID | Task | Files | Data flow | Acceptance criteria | Sessions | Status |
```

---

## Decisions log

| Date | Decision | Reason | Revisit when |
|---|---|---|---|
| 2026-10-10 | Repo root `e-comhub` is used as the monorepo root described in Section 12 | Repo already exists under this name; brand name lives in the product, not the folder | Phase 1, if the founder wants a rename |
| 2026-10-10 | GSAP excluded by default | Free to use but not an OSI open source license (Rule 8/9) | Only on explicit founder approval |

## Open questions

1. Section 5 discovery questions Q1 to Q9 — awaiting answers.
2. Is womenswear planned (Section 2 asks for confirmation)?
3. Repo and package naming: keep `e-comhub` or rename to `the-house-of-sahas`?
4. Rule conflict: Section 5 lists 9 questions, Rule 4.10 caps questions at 8 per batch. Proposed resolution: treat the Section 5 list as a pre-approved single batch (the founder wrote it), otherwise split 5 + 4.

## Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Scope: storefront + admin + mobile app is a multi-month build | Late launch | Launch after Phase 6; defer mobile app to Phase 7 |
| Homepage motion vs. performance budget (Lighthouse 95+, JS < 150 KB gz) | Slow site, lost premium feel | Motion pass last (Phase 5); every effect tested on a mid-range phone; remove what costs speed |
| Weak photography | Site looks cheap regardless of code | Licensed placeholders only until a real shoot; photoshoot brief early |
| Free tiers end as traffic grows | Sudden monthly cost | Track spend thresholds in `LICENSES.md`; flag before they bite |
| Legal: GST, returns, privacy, cookies, image and font licensing | Fines, takedowns | Legal checklist in Phase 9; `LICENSES.md` enforced from Phase 1 |
