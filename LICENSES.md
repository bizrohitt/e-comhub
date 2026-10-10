# LICENSES — The House Of Sahas

**Status:** stack locked at P0-04 (2026-10-10). Rows below carry planned entries; **exact versions are filled in P1-12** when packages are installed, and re-verified at every upgrade.

**Policy (Master Prompt Rules 8 and 9):**

- Every dependency must be free to use.
- Preferred licenses: MIT, Apache-2.0, BSD, ISC, SIL OFL (fonts).
- Licenses must permit modification and commercial use.
- **Avoid GPL and AGPL** in distributed code unless the founder approves after the obligations are explained.
- Flag anything source-available but not truly open source.
- Flag anything that costs money at scale (hosting limits, gateway fees, SMS/email volume).
- Never copy proprietary themes, images or fonts.

**Excluded by default:** GSAP — free to use, but its license is not an OSI open source license. Requires explicit founder approval.

---

## 1. Code dependencies

Locked at P0-04. **Versions are recorded at install time in P1-12**, not assumed now. Every row must be re-verified at each upgrade.

| Name | Version | License | OSI approved | Permits modification + commercial use | Link | Used in | Notes |
|---|---|---|---|---|---|---|---|
| Medusa | _verify in P1-05_ | MIT | Yes | Yes | medusajs.com | `backend/` | Commerce engine |
| Next.js | _verify in P1-07_ | MIT | Yes | Yes | nextjs.org | `storefront/` | |
| TypeScript | _verify in P1-01_ | Apache-2.0 | Yes | Yes | typescriptlang.org | all | |
| Tailwind CSS | _verify in P1-07_ | MIT | Yes | Yes | tailwindcss.com | `storefront/` | Token-only styling |
| PostgreSQL | 16 | PostgreSQL License | Yes | Yes | postgresql.org | infra | Permissive, BSD-like |
| Redis | 7.x | BSD-3 (7.x) | Yes | Yes | redis.io | infra | **Check the version installed:** Redis 8 moved to RSALv2/SSPL, which is *not* OSI open source. Pin to a 7.x release |
| next-intl | _verify in P1-08_ | MIT | Yes | Yes | next-intl.dev | `storefront/` | EN + HI |
| Lenis | _verify in P5_ | MIT | Yes | Yes | github.com/darkroomengineering/lenis | `storefront/` | Smooth scroll |
| Motion | _verify in P5_ | MIT | Yes | Yes | motion.dev | `storefront/` | Formerly Framer Motion |
| Lucide | _verify in P1-07_ | ISC | Yes | Yes | lucide.dev | `storefront/` | Icons |
| React Email | _verify in P2_ | MIT | Yes | Yes | react.email | `backend/`, `storefront/` | Templates |
| Umami | _verify in P2_ | MIT | Yes | Yes | umami.is | infra | Self-hosted analytics |
| Payload CMS | _verify in P6_ | MIT | Yes | Yes | payloadcms.com | `backend/` | Deferred to Phase 6 |
| Meilisearch | — | MIT | Yes | Yes | meilisearch.com | — | **Deferred.** Postgres FTS at launch |
| Expo / React Native | _verify in P7_ | MIT | Yes | Yes | expo.dev | `mobile/` | Phase 7 |
| Vitest | _verify in P1-10_ | MIT | Yes | Yes | vitest.dev | all | |
| Playwright | _verify in P1-10_ | Apache-2.0 | Yes | Yes | playwright.dev | `tests/` | |
| **GSAP** | — | Custom, **not OSI** | **No** | Free to use, but not open source | gsap.com | — | **EXCLUDED** by Rules 8 and 9. Requires explicit founder approval |

**Audit requirement (P1-12):** a re-runnable `scripts/license-audit.ts` that lists every installed package with its license and fails the build on GPL, AGPL, SSPL or any non-OSI license.

## 2. Fonts

| Name | Version / cut | License | Link | Self-hosted | Notes |
|---|---|---|---|---|---|
| Cormorant Garamond | _verify in P0-05_ | SIL OFL 1.1 | fonts.google.com | Yes | Latin headings. Preload the hero weight only |
| Inter | _verify in P1-08_ | SIL OFL 1.1 | rsms.me/inter | Yes | Latin body. Chosen over Jost for legibility at small sizes |
| Tiro Devanagari Hindi | _proposed, confirm in P0-05_ | SIL OFL 1.1 | fonts.google.com | Yes | Hindi headings — serif register matching Cormorant |
| Mukta _or_ Noto Sans Devanagari | _proposed, confirm in P0-05_ | SIL OFL 1.1 | fonts.google.com | Yes | Hindi body — pairs with Inter |

**Critical:** Cormorant Garamond, Inter and Jost have **no Devanagari coverage**. Without the two Devanagari faces above, the Hindi locale renders as boxes or uncontrolled browser fallbacks. OFL notices must ship with the self-hosted files.

## 3. Images, video and other assets

| Asset | Source | License | Link to license | Attribution required | Recorded by | Notes |
|---|---|---|---|---|---|---|
| _(none used yet)_ | | | | | | |

Placeholder policy: Unsplash and Pexels permit commercial use, but **each image's own terms must be checked and recorded here before it ships**. Replace with owned photography after the shoot.

## 4. Paid services and scaling costs (not license issues, but budget issues)

| Service | Free tier / included | When it starts costing | Estimated cost | Trigger to review |
|---|---|---|---|---|
| Domain | — | Immediately | ~₹800 to ₹1,500/year for `.com` | At purchase |
| Storefront hosting (e.g. Vercel/Cloudflare) | Generous free tier | Bandwidth or build-minute limits exceeded | — | Before launch |
| Backend hosting (VPS / Railway / Render / Fly) | Limited or none | Immediately in practice | — | Phase 1 |
| PostgreSQL + Redis | Depends on host | At scale | — | Phase 1 |
| Payment gateway | Code is free | Per transaction, from the first sale | Typically ~2% + tax in India | Phase 2 |
| Email (SMTP) | Free tier | Volume beyond the tier | — | Phase 2 |
| SMS / WhatsApp | Low or none | Per message; WhatsApp Business API has per-conversation pricing | — | Phase 8 |
| Meilisearch Cloud | — | Only if not self-hosted | Self-host instead | Phase 2 |

## 5. Legal review checklist (before launch, Phase 9)

- [ ] Every row above filled and license text checked, not assumed.
- [ ] No GPL/AGPL in distributed code, or founder approval recorded.
- [ ] Font files self-hosted with OFL notices included.
- [ ] Every shipped image has a recorded source and license.
- [ ] Privacy policy and cookie consent match the analytics tool actually used.
- [ ] Returns, GST invoicing and consumer protection wording reviewed for the launch country.
- [ ] Third-party terms reviewed for the payment gateway, carrier and email provider.
