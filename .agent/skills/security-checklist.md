# Skill: security checklist

**Purpose.** A small, hostile-input-facing public site with an admin panel. Keep it boring and safe.
**When to use.** Any task touching a form, a view, a header, a setting, or a dependency.

## Per-task checklist

**Input**
- [ ] Every POST goes through a Django form/serializer with explicit types, `min_value`/`max_value`,
      `max_length`. No `request.POST[...]` straight into logic.
- [ ] Numeric limits are sane (reject 1e308 before it reaches a formula).
- [ ] No `eval`, `exec`, `pickle`, `yaml.load` (use `yaml.safe_load`), or `subprocess` with user data.
- [ ] Regex from users (regex-tester tool) runs **in the browser only** — never server-side (ReDoS).
- [ ] File uploads: none. If one is ever proposed, it needs an ADR and a threat model.

**Output**
- [ ] Autoescaping on; `|safe` and `mark_safe` require a comment justifying it and a sanitised source.
- [ ] User text is bound with `x-text`, never `x-html` or `innerHTML`.
- [ ] JSON embedded in templates uses `json_script`, not string interpolation.
- [ ] Error pages and messages never leak stack traces, paths or SQL.

**Transport and headers** (`core/middleware.py`)
- [ ] CSP with no `unsafe-eval` (that's why the Alpine CSP build) and no `unsafe-inline` for scripts;
      a per-request nonce for the single JSON-LD block. `default-src 'self'`, `frame-ancestors 'none'`
      except the `/embed/` route.
- [ ] `X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin`,
      `Permissions-Policy` denying camera/mic/geo/payment.
- [ ] Prod: `SECURE_SSL_REDIRECT`, HSTS (start 300 s, raise after verifying), `SESSION_COOKIE_SECURE`,
      `CSRF_COOKIE_SECURE`, `SESSION_COOKIE_HTTPONLY`, `SameSite=Lax`.
- [ ] `ALLOWED_HOSTS` explicit. `DEBUG=False` in prod, enforced by a test.

**Abuse**
- [ ] Rate limit by IP+path on `/run/`, `/leads/`, `/search/` using the Django cache
      (e.g. 30/min, 300/hour). Return 429 with a human message, not a 500.
- [ ] Honeypot field + minimum-time check on the email form. No CAPTCHA (third-party + friction).
- [ ] Admin is at a non-obvious path, staff-only, with strong passwords; consider IP allowlist in P6.

**Secrets and data**
- [ ] Everything from env; `.env.example` documents each key with a dummy value.
- [ ] `SECRET_KEY` never committed; rotate if it ever is (and purge from history).
- [ ] No raw IPs stored. If consent proof needs one, store `sha256(ip + per-install salt)`.
- [ ] Tool inputs are never logged, never persisted, never in a query string (share state goes in
      the URL *hash*, which browsers don't send to the server).

**Dependencies**
- [ ] New package → `.agent/skills/license-audit.md` + a `LICENSES.md` row + an ADR if it's notable.
- [ ] Pin exact versions; review the changelog before bumping Django.

## Quarterly / per-phase
- `pip list --outdated`, read Django security releases, re-run `manage.py check --deploy`,
  restore a backup into a scratch dir and run the test suite against it.

## Output format
In your report: "Security: <the specific controls this task adds or relies on>". If a task adds a
new input surface and you can't name its validation and rate limit, it isn't done.

## Do-nots
- Don't disable CSRF "temporarily". Don't widen CSP to make a library work — change the library.
- Don't write your own crypto, token format or password hashing.
- Don't trust `X-Forwarded-For` without knowing the proxy chain.
- Don't log request bodies.
