/** @jsxImportSource preact */

import { render } from "preact-render-to-string";
import { DOCUMENT_CSS } from "./css.ts";
import { formatAddress, formatUsd } from "./data.ts";
import type {
  ConceptImageView,
  JobView,
  LetterheadView,
  LineItemView,
  ProposalView,
} from "./types.ts";

function QdMark() {
  return (
    <svg viewBox="0 0 120 120" role="img" aria-label="Quality Deck">
      <circle cx="60" cy="60" r="58" fill="#0b1a28" stroke="#c4a24a" stroke-width="3" />
      <path
        d="M38 38c0-8 8-14 22-14 18 0 28 10 28 26 0 14-8 24-22 28l16 16h-16l-14-14c-2 0-4 0-6-.5C40 77 38 68 38 58V38z"
        fill="none"
        stroke="#f4f6f8"
        stroke-width="7"
        stroke-linejoin="round"
      />
      <path
        d="M58 36c10 0 18 6 18 16 0 9-6 15-16 18"
        fill="none"
        stroke="#c4a24a"
        stroke-width="6"
        stroke-linecap="round"
      />
      <path d="M78 86l16 2-10 12-6-14z" fill="#c4a24a" />
    </svg>
  );
}

export function Letterhead({ letterhead }: { letterhead: LetterheadView }) {
  const lines = [
    letterhead.address
      ? `${letterhead.address.street.toUpperCase()}`
      : null,
    letterhead.address
      ? `${letterhead.address.city.toUpperCase()}, ${letterhead.address.state} ${letterhead.address.zip}`
      : null,
    letterhead.licenseNumber?.toUpperCase() ?? null,
    letterhead.phone ?? null,
    letterhead.email?.toUpperCase() ?? null,
    letterhead.website?.toUpperCase() ?? null,
  ].filter((line): line is string => line != null);

  return (
    <header class="letterhead">
      <div class="letterhead-left">
        <div class="logo">
          {letterhead.logoUrl ? <img src={letterhead.logoUrl} alt="" /> : <QdMark />}
        </div>
      </div>
      {lines.length > 0 && (
        <div class="contact">
          {lines.map((line) => <div key={line}>{line}</div>)}
        </div>
      )}
    </header>
  );
}

export function ClientBlock({
  projectTitle,
  siteAddress,
  issueDate,
  attention,
  proposalNumber,
  validUntil,
}: {
  projectTitle: string;
  siteAddress: ProposalView["siteAddress"];
  issueDate: string;
  attention: string;
  proposalNumber: string;
  validUntil: string;
}) {
  return (
    <section class="meta">
      <div class="meta-row">
        <div class="meta-label">Project:</div>
        <div class="meta-value">{projectTitle}</div>
      </div>
      <div class="meta-row">
        <div class="meta-label">Location:</div>
        <div class="meta-value">{formatAddress(siteAddress)}</div>
      </div>
      <div class="meta-row">
        <div class="meta-label">Date:</div>
        <div class="meta-value">{issueDate}</div>
      </div>
      <div class="meta-row">
        <div class="meta-label">Attention:</div>
        <div class="meta-value">{attention}</div>
      </div>
      <div class="meta-row">
        <div class="meta-label">Proposal:</div>
        <div class="meta-value">{proposalNumber}</div>
      </div>
      <div class="meta-row">
        <div class="meta-label">Valid until:</div>
        <div class="meta-value">{validUntil}</div>
      </div>
    </section>
  );
}

export function LineItemTable({ items }: { items: LineItemView[] }) {
  if (items.length === 0) return null;
  return (
    <ul class="line-list">
      {items.map((item) => (
        <li key={`${item.name}-${item.totalCents}`}>
          <span class="line-name">{item.name}</span>
          {" — "}
          <span class="line-qty">{item.quantityLabel}</span>
          {" — "}
          {formatUsd(item.totalCents)}
          {item.description ? ` — ${item.description}` : ""}
        </li>
      ))}
    </ul>
  );
}

export function JobSection({ job }: { job: JobView }) {
  return (
    <tr class="job-row">
      <td class="line-no">{job.numberLabel}</td>
      <td>
        <h2 class="job-heading">{job.title}</h2>
        {job.jobType && <div class="job-type">{job.jobType}</div>}
        {job.description && <p class="scope">{job.description}</p>}
        <LineItemTable items={job.lineItems} />
        {job.laborCents != null && (
          <p class="option-price">Labor {formatUsd(job.laborCents)}</p>
        )}
        {job.exclusions && (
          <p class="exclusions">
            <strong>Exclusions: </strong>
            {job.exclusions}
          </p>
        )}
      </td>
      <td class="price">
        <span class="price-value">{formatUsd(job.totalCents)}</span>
      </td>
    </tr>
  );
}

export function ConceptImages({ images }: { images: ConceptImageView[] }) {
  if (images.length === 0) return null;
  return (
    <>
      {images.map((image) => (
        <figure class="concept" key={image.url}>
          <img src={image.url} alt="" width={image.width} height={image.height} />
          <figcaption>Conceptual rendering – not to scale</figcaption>
        </figure>
      ))}
    </>
  );
}

export function Totals({ totals }: { totals: ProposalView["totals"] }) {
  return (
    <section class="totals">
      {totals.jobs.length > 1 &&
        totals.jobs.map((job) => (
          <div class="totals-row" key={job.numberLabel}>
            <span>{job.numberLabel} {job.title}</span>
            <span>{formatUsd(job.totalCents)}</span>
          </div>
        ))}
      {totals.overheadCents != null && totals.overheadLabel && (
        <div class="totals-row">
          <span>{totals.overheadLabel}</span>
          <span>{formatUsd(totals.overheadCents)}</span>
        </div>
      )}
      <div class="totals-row grand">
        <span class="totals-label">Total Labor & Materials</span>
        <span class="price-value">{formatUsd(totals.totalCents)}</span>
      </div>
    </section>
  );
}

export function Terms({
  extraTerms,
  timeframes,
}: {
  extraTerms: string | null;
  timeframes: string[];
}) {
  return (
    <>
      <div class="sidebar-card">
        <h2>Code & Material Compliance</h2>
        <p>
          All work will be completed in accordance with applicable local building
          codes and requirements. All hardware, fasteners, structural connections,
          and materials will be new and code-approved for the intended
          application, installed per code and manufacturer specifications.
        </p>
      </div>
      <div class="sidebar-card">
        <h2>Pricing Validity</h2>
        <p>Pricing valid for 30 days from proposal date.</p>
      </div>
      <div class="sidebar-card">
        <h2>Field Verification</h2>
        <p>Final dimensions and details will be confirmed in the field.</p>
      </div>
      {timeframes.length > 0 && (
        <div class="sidebar-card">
          <h2>Project Timeframe</h2>
          <p>Estimated project timeframe:</p>
          {timeframes.map((item) => <p key={item}>{item}</p>)}
          <p>weather depending*.</p>
        </div>
      )}
      <div class="sidebar-card">
        <h2>Scope Changes</h2>
        <p>Any changes to the scope may affect pricing.</p>
      </div>
      <div class="sidebar-card">
        <h2>Payment Schedule</h2>
        <p>1/3 deposit • 2/3 at project start • 3/3 upon completion</p>
      </div>
      {extraTerms && (
        <div class="sidebar-card">
          <h2>Additional Terms</h2>
          <p>{extraTerms}</p>
        </div>
      )}
    </>
  );
}

export function Footer({
  preparedBy,
  businessName,
}: {
  preparedBy: string;
  businessName: string;
}) {
  return (
    <footer class="closing">
      <div class="thank-you">
        <div class="script">Thank You</div>
        <div class="rest">For considering</div>
        <div class="rest">{businessName}</div>
      </div>
      <div class="sign-row">
        <div class="sign-by">Proposal by: {preparedBy}</div>
        <div class="sign-line">
          Client Signature:
          <div class="sign-rule" />
        </div>
        <div class="sign-line">
          Date:
          <div class="sign-rule" />
        </div>
      </div>
    </footer>
  );
}

export function ProposalDocument({ proposal }: { proposal: ProposalView }) {
  const conceptImages = proposal.jobs.flatMap((job) => job.conceptImages);
  const timeframes = proposal.jobs
    .map((job) => job.timeframe)
    .filter((value): value is string => value != null);

  return (
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <title>{proposal.letterhead.name} Proposal</title>
        <style>{proposal.fontCss + DOCUMENT_CSS}</style>
      </head>
      <body>
        <div class="page">
          <Letterhead letterhead={proposal.letterhead} />
          <div class="gold-rule" />
          {proposal.letterhead.tagline && (
            <div class="tagline">{proposal.letterhead.tagline}</div>
          )}
          <div class="body">
            <div class="main">
              <ClientBlock
                projectTitle={proposal.projectTitle}
                siteAddress={proposal.siteAddress}
                issueDate={proposal.issueDate}
                attention={proposal.client.name}
                proposalNumber={proposal.proposalNumber}
                validUntil={proposal.validUntil}
              />
              <table class="line-items">
                <thead>
                  <tr>
                    <th class="line-no">Line Item</th>
                    <th>Description</th>
                    <th class="price">Price</th>
                  </tr>
                </thead>
                <tbody>
                  {proposal.jobs.map((job) => (
                    <JobSection key={job.numberLabel} job={job} />
                  ))}
                </tbody>
              </table>
              <Totals totals={proposal.totals} />
            </div>
            <aside class="sidebar">
              <Terms extraTerms={proposal.extraTerms} timeframes={timeframes} />
              {conceptImages.length > 0 && (
                <div class="sidebar-card">
                  <h2>Conceptual Renderings</h2>
                  <p>
                    Conceptual renderings are for illustration purposes only.
                  </p>
                  <ConceptImages images={conceptImages} />
                </div>
              )}
            </aside>
          </div>
          <Footer
            preparedBy={proposal.preparedBy}
            businessName={proposal.letterhead.name}
          />
        </div>
      </body>
    </html>
  );
}

export function renderProposalHtml(proposal: ProposalView): string {
  return `<!doctype html>${render(<ProposalDocument proposal={proposal} />)}`;
}

export function pdfshiftFooterHtml(businessName: string, phone: string | null): string {
  const left = phone ? `${businessName} · ${phone}` : businessName;
  return `<div style="font-family:Helvetica,Arial,sans-serif;font-size:9px;color:#333;width:100%;padding:0 36px;display:flex;justify-content:space-between;">
    <span>${escapeHtml(left)}</span>
    <span>Page {{page}} of {{total}}</span>
  </div>`;
}

function escapeHtml(value: string): string {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}
