const BRONZE = "#64532b";
const CREAM = "#efead8";
const INK = "#222";
const MUTED = "#5c5648";

const LETTERHEAD_CSS = `
.letterhead {
  display: grid;
  grid-template-columns: 2.45in 1fr 2.15in;
  align-items: center;
  column-gap: 16px;
  padding: 10px 36px 8px;
  background: #fff;
  color: ${INK};
}
.brand {
  display: flex;
  align-items: center;
  gap: 10px;
  min-width: 0;
}
.qd-mark {
  width: 70px;
  height: 70px;
  flex: 0 0 70px;
  border: 6px solid ${BRONZE};
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 700;
  font-size: 26pt;
  letter-spacing: -0.02em;
  color: ${INK};
  line-height: 1;
}
.brand-text {
  min-width: 0;
}
.brand-name {
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 700;
  font-size: 16pt;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  line-height: 1.05;
}
.brand-sub {
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 500;
  font-size: 7.5pt;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: ${INK};
  margin-top: 4px;
}
.logo {
  width: 210px;
  height: 70px;
  flex: 0 0 auto;
}
.logo img {
  width: 210px;
  height: 70px;
  display: block;
  object-fit: contain;
  object-position: left center;
}
.contact {
  text-align: center;
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 500;
  font-size: 7.5pt;
  letter-spacing: 0.05em;
  line-height: 1.35;
  text-transform: uppercase;
  color: ${INK};
}
.tag-block {
  text-align: right;
  flex: 0 0 auto;
}
.slogan {
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 500;
  font-size: 9pt;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: ${INK};
  line-height: 1.25;
  padding-bottom: 4px;
  border-bottom: 2px solid ${BRONZE};
  display: inline-block;
}
.tagline {
  background: transparent;
  color: ${INK};
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 500;
  letter-spacing: 0.12em;
  font-size: 8pt;
  text-transform: uppercase;
  padding: 6px 0 0;
}
.gold-rule {
  height: 9px;
  background: ${BRONZE};
}
`;

const THANK_YOU_CSS = `
.thank-you-corner {
  position: absolute;
  right: 0;
  bottom: 0;
  width: 2.05in;
  background: ${BRONZE};
  color: #fff;
  min-height: 1.35in;
  padding: 18px 14px 8px 28px;
  clip-path: polygon(34% 0, 100% 0, 100% 100%, 0 100%);
  text-align: right;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
}
.thank-you-corner .script {
  font-family: 'Great Vibes', cursive;
  font-size: 26pt;
  line-height: 1;
  margin-bottom: 2px;
}
.thank-you-corner .rest {
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 500;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  font-size: 7.5pt;
  line-height: 1.3;
}
`;

export const HEADER_CSS = `
* { box-sizing: border-box; }
html, body {
  margin: 0;
  padding: 0;
  background: transparent;
  color: ${INK};
  font-family: 'Source Sans 3', 'Segoe UI', sans-serif;
}
.pdf-header {
  width: 100%;
  height: 1.18in;
  overflow: hidden;
  background: transparent;
}
${LETTERHEAD_CSS}
`;

export const DOCUMENT_CSS = `
@page { size: Letter; margin: 0; }
* { box-sizing: border-box; }
html, body {
  margin: 0;
  padding: 0;
  color: ${INK};
  background: #fff;
  font-family: 'Source Sans 3', 'Segoe UI', sans-serif;
  font-size: 10pt;
  line-height: 1.4;
  orphans: 3;
  widows: 3;
}
p, h1, h2, h3, li, td, th, address {
  overflow-wrap: anywhere;
}
.page {
  position: relative;
  min-height: 11in;
  display: flex;
  flex-direction: column;
  padding-bottom: 18px;
}
.page-pdf {
  min-height: 11in;
  padding-top: 1.28in;
  padding-bottom: 18px;
}
${LETTERHEAD_CSS}
.body {
  padding: 8px 36px 0;
  flex: 1 1 auto;
  display: flex;
  flex-direction: column;
  min-height: 0;
}
.meta {
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 4px 36px;
  margin: 8px 0 10px;
}
.meta-col {
  display: grid;
  gap: 2px;
}
.meta-row {
  display: grid;
  grid-template-columns: 84px 1fr;
  gap: 8px;
  align-items: baseline;
  break-inside: avoid;
}
.meta-col:last-child .meta-row {
  grid-template-columns: 88px auto;
}
.meta-label {
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 700;
  letter-spacing: 0.08em;
  font-size: 8pt;
  color: ${INK};
  text-transform: uppercase;
}
.meta-value {
  font-weight: 400;
  font-size: 9.5pt;
}
.line-items {
  width: 100%;
  border-collapse: collapse;
  border: 1.5px solid ${BRONZE};
  flex: 1 1 auto;
}
.line-items thead {
  display: table-row-group;
}
.line-items th {
  background: ${BRONZE};
  color: #fff;
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 500;
  font-size: 8pt;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  text-align: left;
  padding: 7px 10px;
  border-right: 1.5px solid ${BRONZE};
}
.line-items th.desc {
  text-align: center;
}
.line-items th.price, .line-items td.price {
  text-align: center;
  width: 1.55in;
  vertical-align: middle;
}
.line-items th.line-no {
  width: 0.58in;
  text-align: center;
  font-size: 7pt;
  letter-spacing: 0.12em;
  line-height: 1.15;
  padding: 6px 4px;
}
.line-items td.line-no {
  width: 0.58in;
  text-align: center;
  vertical-align: top;
  padding: 0;
  border-right: 1.5px solid ${BRONZE};
}
.line-no-label {
  background: ${CREAM};
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 700;
  color: ${BRONZE};
  font-size: 9pt;
  padding: 8px 4px;
  line-height: 1.2;
}
.line-items td {
  vertical-align: top;
  padding: 0;
  border-right: 1.5px solid ${BRONZE};
}
.line-items td:last-child,
.line-items th:last-child {
  border-right: none;
}
.job-row td {
  border-bottom: 1.5px solid ${BRONZE};
}
.job-title-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
  background: ${CREAM};
  padding: 7px 12px;
}
.job-heading {
  break-after: avoid;
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 700;
  font-size: 10pt;
  letter-spacing: 0.02em;
  color: ${INK};
  margin: 0;
}
.job-kicker {
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 500;
  font-size: 8pt;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: ${BRONZE};
  white-space: nowrap;
}
.job-body {
  padding: 12px 12px 16px;
}
.job-copy {
  display: flex;
  gap: 14px;
  align-items: flex-start;
}
.job-photos {
  flex: 0 0 2.05in;
  width: 2.05in;
}
.job-photos img {
  display: block;
  width: 100%;
  height: auto;
  margin: 0 0 8px;
  background: #eee;
}
.job-photos figcaption {
  display: none;
}
.scope {
  white-space: pre-wrap;
  margin: 0 0 8px;
}
.scope-list {
  margin: 0;
  padding-left: 18px;
}
.scope-list li {
  margin: 0 0 7px;
  break-inside: avoid;
}
.line-name {
  font-weight: 700;
}
.price-box {
  margin: 16px auto;
  width: 1.32in;
  background: ${CREAM};
  border: 1.5px solid ${BRONZE};
  padding: 10px 8px 8px;
  text-align: center;
}
.price-label {
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 500;
  font-size: 6.5pt;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: ${INK};
  margin-bottom: 4px;
  line-height: 1.25;
}
.price-value {
  color: ${INK};
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 700;
  font-size: 16pt;
  letter-spacing: 0.01em;
  line-height: 1.1;
}
.totals {
  break-inside: avoid;
  margin: 12px 0 0;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  flex-wrap: wrap;
}
.closing {
  position: relative;
  flex: 0 0 auto;
  margin-top: auto;
  padding: 8px 0 0 36px;
  min-height: 1.45in;
  overflow: hidden;
  break-inside: avoid;
  page-break-inside: avoid;
}
.closing-grid {
  display: grid;
  grid-template-columns: 2.35in 1fr;
  gap: 8px 16px;
  align-items: start;
  padding-right: 2.15in;
}
.compliance {
  border: 1px solid #cfc8b6;
  padding: 8px 10px 10px;
}
.compliance-head {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 4px;
}
.compliance-head h2 {
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 700;
  font-size: 8pt;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  margin: 0;
  color: ${INK};
}
.term h2 {
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 700;
  font-size: 8pt;
  letter-spacing: 0.02em;
  margin: 0 0 1px;
  color: ${INK};
  text-transform: none;
}
.compliance p,
.term p {
  margin: 0;
  font-size: 7.2pt;
  line-height: 1.3;
  color: ${MUTED};
}
.icon {
  width: 18px;
  height: 18px;
  flex: 0 0 18px;
  color: ${BRONZE};
}
.terms-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 8px 14px;
}
.term {
  display: flex;
  gap: 7px;
  align-items: flex-start;
  break-inside: avoid;
}
.sign-block {
  margin-top: 10px;
  font-size: 8.5pt;
}
.sign-by {
  margin-bottom: 8px;
}
.sign-lines {
  display: flex;
  gap: 20px;
}
.sign-line {
  flex: 1 1 auto;
}
.sign-rule {
  border-bottom: 1px solid ${INK};
  height: 14px;
  margin-top: 2px;
  min-width: 1.5in;
}
${THANK_YOU_CSS}
.closing .thank-you-corner {
  top: 0;
  min-height: 100%;
}
.extra-terms {
  font-size: 8.5pt;
  white-space: pre-wrap;
  margin-top: 8px;
}
`;

/** Applied only when the letterhead is a PDFShift header, so every page
 *  (including a second-page signature strip) clears the repeating header. */
export const PDF_PAGE_CSS = `
@page {
  size: Letter;
  margin: 1.35in 0 0 0;
}
.page-pdf {
  padding-top: 0;
}
`;
