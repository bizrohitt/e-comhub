# Skill: HTMX + Alpine patterns

**Purpose.** A tiny, approved set of interaction patterns. Anything outside this list needs a reason.
**When to use.** Every template with behaviour.

## Non-negotiables
- **Alpine CSP build** (ADR-003): components are registered in external modules; templates may only
  reference them by name. No inline object literals, no expressions inside `x-on`, no `eval`.
- **HTMX loads only where used** — put the script tag in `{% block scripts %}`, never in `base.html`.
- **Server-rendered first.** Content that matters for SEO (formula, example, FAQ) is in the HTML.
  JS adds live calculation; it never creates the content.
- **Formulas are importable ES modules** in `static/js/lib/` with no DOM access — that's what makes
  them testable by `node --test`.

## Pattern 1 — client calculator (the default)
```html
<!-- template.html -->
<form class="stack" x-data="profitMargin" @submit.prevent>
  <div class="field">
    <label for="cost">Product cost</label>
    <input id="cost" type="number" inputmode="decimal" step="0.01" min="0"
           x-model.number="cost" @input="recalc">
    <p class="help">What you pay your supplier, per unit</p>
  </div>
  <output class="result" aria-live="polite" x-text="summary"></output>
</form>
```
```js
// static/js/tools/profit-margin-calculator.mjs
import { margin } from '../lib/margin.mjs';
document.addEventListener('alpine:init', () => {
  Alpine.data('profitMargin', () => ({
    cost: 17, price: 40, result: null,
    init() { this.recalc(); },
    recalc() { this.result = margin({ cost: this.cost, price: this.price }); },
    get summary() { return this.result ? `${this.result.marginPct}% margin` : 'Enter a cost and price'; },
  }));
});
```
Rules: every input has a label · `inputmode="decimal"` for money · defaults prefilled so the page is
never a blank form · result in `aria-live="polite"` · `NaN`/`Infinity` never reach the DOM (the lib
returns `null` and the component shows the empty-state sentence).

## Pattern 2 — server tool (only when the browser genuinely can't)
```html
<form hx-post="{% url 'tools:run' tool.category tool.slug %}"
      hx-target="#result" hx-swap="innerHTML" hx-indicator="#spin">
  {% csrf_token %}
  ...fields...
  <button class="btn-primary">Calculate my fees</button>
  <span id="spin" class="htmx-indicator">Calculating…</span>
</form>
<div id="result" aria-live="polite"></div>
```
The view validates with a Django form, calls a pure function, and renders a fragment template.
It is rate-limited and returns a friendly error fragment on invalid input (never a 500 page).

## Pattern 3 — progressive enhancement
The `<form>` must have a real `action`/`method` fallback for server tools. For client tools, the
no-JS experience is the full content block plus a note that live calculation needs JavaScript.
Test by disabling JS: the page must still answer the user's question in prose.

## Pattern 4 — copy / share / example (shared, build once)
Lives in `templates/partials/tool_actions.html` + `static/js/lib/{export,state}.mjs`.
Copy uses `navigator.clipboard` with a `document.execCommand` fallback and swaps the label to
"Copied" for 2s. Share encodes state into the **URL hash** (never the query string, so inputs never
reach server logs). Example loads the documented sample values.

## Pattern 5 — multi-step tool
One Alpine component, a `step` integer, `<progress>` for the bar, state in the hash so a refresh or
a shared link resumes. Each step is a `<fieldset>` with a legend. Never more than 4 steps.

## Do-nots
- No `x-data="{ open: false }"` inline objects (CSP build forbids it, and it hides logic).
- No `hx-get` polling, no websockets, no `hx-boost` on the whole site.
- No jQuery, no lodash, no moment, no charting library (hand-rolled inline SVG if a chart is needed).
- No fetch to a third-party origin from the browser, ever.
- No layout shift: reserve space for results before they render.
- No `innerHTML` with user text — bind with `x-text`.
