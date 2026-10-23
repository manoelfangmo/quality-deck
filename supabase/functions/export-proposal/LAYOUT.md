# Quality Deck proposal layout

Rebuilt from the attached samples (Leibel, LaRosa Arroyo, Nancy Duffy) before wiring live data.

## Sections, in order

1. **Letterhead** — full-bleed navy bar. Circular QD mark on the left; condensed uppercase contact block on the right (street, city/state/zip, license, phone, email, website).
2. **Gold rule** — 5px `#c4a24a` bar under the letterhead.
3. **Tagline** — `DECKS | PORCHES | OUTDOOR LIVING` in gold Oswald, hidden when `businesses.tagline` is empty.
4. **Client and site block** — Project, Location, Date, Attention, plus Proposal number and Valid until (not on the paper samples; required by this ticket).
5. **Line-item table** — navy header `LINE ITEM | DESCRIPTION | PRICE`. Each included job is a numbered row (`001`, `002`, …) with title, scope, line items, optional exclusions, and the job total in gold.
6. **Concept images** — in the gold sidebar, captioned `Conceptual rendering – not to scale`. Hidden when a project has none.
7. **Totals** — `Total Labor & Materials` plus a combined total. Overhead is included when the project has it, so the PDF matches the app to the cent.
8. **Standard terms (sidebar, from the samples)** — Code & Material Compliance, Pricing Validity (30 days), Field Verification, Project Timeframe (hidden when empty), Scope Changes, Payment Schedule. Extra `businesses.terms` copy is an Additional Terms card, hidden when empty.
9. **Acceptance** — “Thank You / For considering / {business}”, “Proposal by: {owner}, {business}”, Client Signature line, Date line.
10. **Repeating footer** — PDFShift footer: business name, phone, `Page {{page}} of {{total}}`.

## Visual notes from the samples

- **Page:** US Letter, full-bleed header, ~0.5in inner inset, gold sidebar ~2.35in.
- **Colors:** navy `#0b1a28`, gold `#c4a24a`, white type on navy, gold prices.
- **Fonts (embedded WOFF2):** Oswald (labels/headings), Source Sans 3 (body), Great Vibes (“Thank You”).
- **Logo:** left circular QD mark. A stored `logo_path` replaces the mark when present.
- **Prices:** `$12,450.00` (US, two decimals). Job price sits in the PRICE column; line items are listed in the description.

## Sample sections the data model cannot fill yet

Kept in the template and hidden when empty:

- Business logo, license, address, phone, email, website, tagline, extra terms
- Job exclusions and timeframe
- Concept photos (included when present; every concept photo, not a subset)

Jobs have no Declined flag in this schema, so every job is included in display order (`created_at`, then `id`). Line items have no minimum-charge column; totals use the same rule as the app: `round(quantity × coalesce(override, saved))`, plus labor and project overhead.

## Open questions — defaults taken from the samples

- **Signature / acceptance:** yes. One client signature and date, matching the samples. No per-job checkboxes (LaRosa’s wood/composite options are separate priced blocks, not checkboxes).
- **Proposal number:** `QD-YYYY-####` (per-business sequence, reused on later versions of the same project).
- **Validity:** 30 days from the issue date in the business time zone, shown on the PDF.
- **Concept photos:** every concept photo on each included job.
- **Terms:** the sidebar copy is the single Quality Deck template. `businesses.terms` is optional extra copy.

Layout changes after Moises signs off on a static HTML/PDF of this page are out of scope (SOW Section 10).
