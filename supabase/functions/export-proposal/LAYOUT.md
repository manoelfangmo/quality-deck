# Quality Deck proposal layout

Rebuilt from the attached samples (Leibel, LaRosa Arroyo, Nancy Duffy).

## Sections, in order

1. **Letterhead** — white bar. Square QD lockup on the left with **QUALITY DECK** / **DESIGN & CONSTRUCTION** (hidden when a stored `logo_path` is used); condensed uppercase contact block in the center (street, city/state/zip, license, phone, email, website); **BUILT RIGHT. BUILT TO LAST.** and the tagline on the right. Repeats on every PDF page via the PDFShift header.
2. **Bronze rule** — 9px `#64532b` bar under the letterhead.
3. **Tagline** — `DECKS | PORCHES | OUTDOOR LIVING` under the slogan, hidden when `businesses.tagline` is empty.
4. **Client and site block** — Project and Location on the left; Date and Attention on the right. Proposal number and 30-day validity are generated internally (filename and the Pricing Validity card) and are not printed here.
5. **Line-item table** — bronze header `LINE ITEM | DESCRIPTION | PRICE`. Each job is a numbered row (`001`, `002`, …) with a cream title bar, optional scope paragraph, bullets from line-item names (and descriptions when set), optional exclusions bullet, and the job total in a cream price box. Quantity, unit price, labor, and job type are not printed. Labor still counts in the job price.
6. **Concept images** — stacked on the left of the description column. Hidden when a project has none. Process photos are out of scope.
7. **Totals** — when a proposal has a single non-alternate job, the cream price box is labeled `Total Labor & Materials` and there is no extra totals row. When several jobs are included: one `Total Labor & Materials` after the table. When a job has `alternate_of_job_id` set: one labeled package total per package (`Total with {base title}`, `Total with {alternate title}`). Shared (non-alternate) jobs stay in every package. Overhead, if set, is folded into each package total. The stored export total is the default package (non-alternate jobs).
8. **Closing strip (after the last line item)** — one section: Code & Material Compliance and signature lines on the left, standard terms in the middle, bronze “Thank You / FOR CONSIDERING / {business}” on the right. No repeating page footer.

## Visual notes from the samples

- **Page:** US Letter, white letterhead, ~0.5in inner inset. No navy bar and no gold sidebar.
- **Colors:** bronze `#64532b` (table header, rule, price-box border, Thank You corner), cream `#efead8` (job title bars and price boxes), ink `#222`, white page. Prices are black, not gold.
- **Fonts (embedded WOFF2):** Oswald (labels/headings), Source Sans 3 (body), Great Vibes (“Thank You”).
- **Logo:** left square QD mark plus wordmark. A stored `logo_path` replaces the mark and wordmark.
- **Prices:** `$12,450` when whole dollars; cents only when they are non-zero. Job price sits in the PRICE column; line items are listed as bullets in the description.

## Alternate jobs

A job may point at another job on the same project (`jobs.alternate_of_job_id`). The target cannot itself be an alternate. The estimate screen and the PDF use the same package math: the default package is every non-alternate job; each alternate replaces its base in a second package. Two independent alternate groups do not explode into every combination.

Wood vs composite prices inside one job are not a separate data model: create two jobs and mark one as an alternate of the other.

## Sample sections the data model cannot fill yet

Kept in the template and hidden when empty:

- Business logo, license, address, phone, email, website, tagline, extra terms
- Job exclusions and timeframe
- Concept photos (included when present; every concept photo, not a subset)

Jobs have no Declined flag in this schema. Non-alternate jobs are included; alternate jobs are shown with their own price and are not added to the default total. Line items have no minimum-charge column; totals use the same rule as the app: `round(quantity × coalesce(override, saved))`, plus labor, plus overhead on each package.
