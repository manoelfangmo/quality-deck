export const DOCUMENT_CSS = `
@page { size: Letter; margin: 0; }
* { box-sizing: border-box; }
html, body {
  margin: 0;
  padding: 0;
  color: #111;
  background: #fff;
  font-family: 'Source Sans 3', 'Segoe UI', sans-serif;
  font-size: 10.5pt;
  line-height: 1.35;
  orphans: 3;
  widows: 3;
}
p, h1, h2, h3, li, td, th, address {
  overflow-wrap: anywhere;
}
.page {
  min-height: 10.6in;
}
.letterhead {
  background: #0b1a28;
  color: #fff;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18px 36px 14px;
  gap: 24px;
}
.letterhead-left {
  display: flex;
  align-items: center;
  gap: 16px;
  min-width: 0;
}
.logo {
  width: 92px;
  height: 92px;
  flex: 0 0 92px;
}
.logo img, .logo svg {
  width: 92px;
  height: 92px;
  display: block;
  object-fit: contain;
}
.contact {
  text-align: right;
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 500;
  font-size: 9.5pt;
  letter-spacing: 0.12em;
  line-height: 1.45;
  text-transform: uppercase;
  color: #f4f6f8;
}
.gold-rule {
  height: 5px;
  background: #c4a24a;
}
.tagline {
  background: #fff;
  color: #c4a24a;
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 500;
  letter-spacing: 0.28em;
  font-size: 11pt;
  text-transform: uppercase;
  padding: 10px 36px 0;
}
.body {
  display: flex;
  align-items: stretch;
  padding: 12px 0 24px;
  min-height: 8.6in;
}
.main {
  flex: 1 1 auto;
  padding: 0 28px 0 36px;
  min-width: 0;
}
.sidebar {
  flex: 0 0 2.35in;
  background: #c4a24a;
  color: #0b1a28;
  padding: 16px 14px 20px;
}
.meta {
  margin: 8px 0 16px;
}
.meta-row {
  display: grid;
  grid-template-columns: 92px 1fr;
  gap: 8px;
  margin: 0 0 4px;
  break-inside: avoid;
}
.meta-label {
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 700;
  letter-spacing: 0.08em;
  font-size: 9pt;
  color: #0b1a28;
  text-transform: uppercase;
}
.meta-value {
  font-weight: 600;
}
.line-items {
  width: 100%;
  border-collapse: collapse;
}
.line-items thead {
  display: table-header-group;
}
.line-items th {
  background: #0b1a28;
  color: #fff;
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 500;
  font-size: 8.5pt;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  text-align: left;
  padding: 8px 10px;
}
.line-items th.price, .line-items td.price {
  text-align: right;
  width: 1.35in;
  white-space: nowrap;
}
.line-items th.line-no, .line-items td.line-no {
  width: 0.85in;
  vertical-align: top;
}
.line-items td {
  vertical-align: top;
  padding: 12px 10px 14px;
  border-bottom: 1px solid #d7d7d7;
}
.line-items tr.job-row {
  break-inside: avoid;
}
.line-items tr.job-row td {
  padding-top: 16px;
}
.job-heading {
  break-after: avoid;
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 700;
  font-size: 11.5pt;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: #0b1a28;
  margin: 0 0 6px;
}
.job-type {
  font-size: 8.5pt;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #666;
  margin: 0 0 8px;
}
.scope {
  white-space: pre-wrap;
  margin: 0 0 8px;
}
.scope-list, .line-list {
  margin: 0 0 8px;
  padding-left: 18px;
}
.scope-list li, .line-list li {
  margin: 0 0 4px;
  break-inside: avoid;
}
.line-name {
  font-weight: 700;
}
.line-qty {
  color: #444;
  font-size: 9.5pt;
}
.exclusions {
  margin: 8px 0 0;
  font-size: 9.5pt;
}
.price-value {
  color: #c4a24a;
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 700;
  font-size: 16pt;
  letter-spacing: 0.02em;
}
.option-price {
  display: block;
  margin-top: 8px;
  color: #c4a24a;
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 700;
  font-size: 10.5pt;
  letter-spacing: 0.06em;
  text-transform: uppercase;
}
.totals {
  break-inside: avoid;
  margin: 18px 0 8px;
  padding-top: 8px;
}
.totals-row {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  padding: 4px 10px;
}
.totals-row.grand {
  background: #0b1a28;
  color: #fff;
  padding: 10px;
  margin-top: 6px;
}
.totals-row.grand .price-value {
  color: #c4a24a;
}
.totals-label {
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 700;
  letter-spacing: 0.06em;
  text-transform: uppercase;
}
.sidebar h2 {
  break-after: avoid;
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 700;
  font-size: 10pt;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  margin: 0 0 6px;
  color: #0b1a28;
}
.sidebar-card {
  margin: 0 0 16px;
  break-inside: avoid;
}
.sidebar-card p {
  margin: 0;
  font-size: 8.5pt;
  line-height: 1.4;
}
.concept {
  break-inside: avoid;
  margin: 8px 0 0;
}
.concept img {
  display: block;
  width: 100%;
  height: auto;
  max-height: 160px;
  object-fit: cover;
  background: #0b1a28;
}
.concept figcaption {
  font-size: 7.5pt;
  margin-top: 4px;
  font-style: italic;
}
.closing {
  padding: 8px 36px 28px;
}
.thank-you {
  text-align: right;
  margin: 8px 0 18px;
}
.thank-you .script {
  font-family: 'Great Vibes', cursive;
  font-size: 34pt;
  color: #0b1a28;
  line-height: 1;
}
.thank-you .rest {
  font-family: 'Oswald', 'Arial Narrow', sans-serif;
  font-weight: 500;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  font-size: 11pt;
  color: #0b1a28;
  margin-top: 4px;
}
.sign-row {
  display: flex;
  gap: 32px;
  align-items: flex-end;
  font-size: 10pt;
}
.sign-by {
  flex: 1 1 auto;
}
.sign-line {
  flex: 1 1 2.4in;
}
.sign-rule {
  border-bottom: 1px solid #111;
  height: 18px;
  margin-top: 2px;
}
.extra-terms {
  padding: 0 36px 24px;
  font-size: 9.5pt;
  white-space: pre-wrap;
}
`;
