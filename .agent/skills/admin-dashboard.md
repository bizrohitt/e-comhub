# Skill: admin and dashboard work

**Purpose.** Give the founder full control of the site without a deploy — and without a second app.
**When to use.** Any `P2-*` task, plus later additions to the control surface.

## Principles
- **Default Django admin** + a few custom views (ADR-006). No admin theme before Phase 7.
- **The registry owns existence; the DB owns presentation.** `ToolMeta` can rename, re-describe,
  re-FAQ, feature, reorder, `noindex` or disable a tool. It can never create one.
- **Every control must be reversible** and visible in `AuditLog`.
- **Speed matters here too:** the dashboard is aggregate queries only, under 300 ms.

## Checklist

1. **Register the model** with `list_display` (4–6 useful columns), `list_filter`, `search_fields`,
   `date_hierarchy` where it helps, and `readonly_fields` for computed/audit fields.
2. **Bulk actions** for the things the founder will actually do in bulk: enable, disable, feature,
   unfeature, mark data re-verified.
3. **Validation in the form, not the save:** title ≤60 chars, description 140–155, FAQ JSON shape.
   Show live character counters and a SERP preview (P2-T05).
4. **Cache invalidation on save.** Any `ToolMeta`/`SiteSetting`/`FeatureFlag` write clears the
   relevant cache keys and (later) purges the CDN path. A stale admin edit is a bug report.
5. **Permissions:** groups `superadmin` (everything), `editor` (tools, pages, SEO — no settings, no
   users, no flags), `support` (leads read + unsubscribe only). Test each boundary.
6. **Audit log** via `post_save`/`post_delete` signals storing actor, model, pk, action and a
   field-level diff. This is the one acceptable use of signals.
7. **Dashboard widgets** (`adminpanel/views.py`), each one query:
   - 30-day usage total + sparkline (inline SVG, no chart library)
   - Top 10 and bottom 10 tools by usage
   - Leads: new, confirmed, unsubscribed
   - Zero-result searches (the roadmap)
   - **Stale reference data** — tools past `review_every_days`
   - Last 10 server errors
8. **Feature flags**: `flag("name")` helper, cached, defaulting to **off**. Every risky or
   monetization feature ships behind one.
9. **Site settings**: site name, contact email, rate limits, ad slots on/off, LLM features on/off.
   Typed JSON with validation — not a free-text blob.

## Output format
Screenshot-free description of what the founder can now do, in their words:
"You can now disable a tool and change its title; the live page updates within a minute."

## Do-nots
- Don't put business logic in `admin.py` — call a service function.
- Don't let the admin create tools, categories that don't exist in code, or arbitrary HTML.
- Don't expose raw JSON editing of anything a form can validate.
- Don't add an analytics widget that needs a per-event table (ADR-011).
- Don't ship a custom staff UI when three admin fields would do.
