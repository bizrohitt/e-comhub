# LICENSES — The House Of Sahas

**Status:** skeleton, Phase 0. Populated in Phase 1 as dependencies are actually installed, and verified again at every upgrade.

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

| Name | Version | License | OSI approved | Permits modification + commercial use | Link | Used in | Notes |
|---|---|---|---|---|---|---|---|
| _(none installed yet)_ | | | | | | | |

Proposed stack to verify at install time: Medusa, Next.js, Tailwind CSS, Payload CMS, Expo / React Native, Lenis, Motion, Lucide, Meilisearch, React Email, Plausible or Umami, Vitest, Playwright, PostgreSQL client, Redis client.

## 2. Fonts

| Name | Version / cut | License | Link | Self-hosted | Notes |
|---|---|---|---|---|---|
| Cormorant Garamond | — | SIL OFL 1.1 | — | Yes (planned) | Headings. Preload hero weight only. |
| Jost **or** Inter | — | SIL OFL 1.1 | — | Yes (planned) | Body. Choice pending P0-05. |

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
