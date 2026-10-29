/** @jsxImportSource preact */

import { render } from "preact-render-to-string";
import { DOCUMENT_CSS, HEADER_CSS, PDF_PAGE_CSS } from "./css.ts";
import { formatAddress, formatUsd } from "./data.ts";
import type {
  ConceptImageView,
  JobView,
  LetterheadView,
  LineItemView,
  ProposalView,
} from "./types.ts";

function Icon({ d, viewBox = "0 0 24 24" }: { d: string; viewBox?: string }) {
  return (
    <svg class="icon" viewBox={viewBox} aria-hidden="true">
      <path fill="currentColor" d={d} />
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
      <div class="brand">
        {letterhead.logoUrl ? (
          <div class="logo">
            <img src={letterhead.logoUrl} alt="" />
          </div>
        ) : (
          <>
            <div class="qd-mark">QD</div>
            <div class="brand-text">
              <div class="brand-name">{letterhead.name}</div>
              <div class="brand-sub">Design & Construction</div>
            </div>
          </>
        )}
      </div>
      {lines.length > 0 && (
        <div class="contact">
          {lines.map((line) => <div key={line}>{line}</div>)}
        </div>
      )}
      <div class="tag-block">
        <div class="slogan">
          Built right.<br />Built to last.
        </div>
        {letterhead.tagline && <div class="tagline">{letterhead.tagline}</div>}
      </div>
    </header>
  );
}

export function ClientBlock({
  projectTitle,
  siteAddress,
  issueDate,
  attention,
}: {
  projectTitle: string;
  siteAddress: ProposalView["siteAddress"];
  issueDate: string;
  attention: string;
}) {
  return (
    <section class="meta">
      <div class="meta-col">
        <div class="meta-row">
          <div class="meta-label">Project:</div>
          <div class="meta-value">{projectTitle}</div>
        </div>
        <div class="meta-row">
          <div class="meta-label">Location:</div>
          <div class="meta-value">{formatAddress(siteAddress)}</div>
        </div>
      </div>
      <div class="meta-col">
        <div class="meta-row">
          <div class="meta-label">Date:</div>
          <div class="meta-value">{issueDate}</div>
        </div>
        <div class="meta-row">
          <div class="meta-label">Attention:</div>
          <div class="meta-value">{attention}</div>
        </div>
      </div>
    </section>
  );
}

export function ScopeList({
  items,
  exclusions,
}: {
  items: LineItemView[];
  exclusions: string | null;
}) {
  if (items.length === 0 && !exclusions) return null;
  return (
    <ul class="scope-list">
      {items.map((item) => (
        <li key={`${item.name}-${item.totalCents}`}>
          <span class="line-name">{item.name}</span>
          {item.description ? ` — ${item.description}` : ""}
        </li>
      ))}
      {exclusions && (
        <li>
          <span class="line-name">Exclusions: </span>
          {exclusions}
        </li>
      )}
    </ul>
  );
}

function shortKicker(description: string | null): string | null {
  if (description == null) return null;
  const trimmed = description.trim();
  if (trimmed.length === 0 || trimmed.includes("\n") || trimmed.length > 40) {
    return null;
  }
  if (/[.!?]/.test(trimmed)) return null;
  return trimmed;
}

function PriceBox({ label, cents }: { label: string; cents: number }) {
  return (
    <div class="price-box">
      <div class="price-label">{label}</div>
      <div class="price-value">{formatUsd(cents)}</div>
    </div>
  );
}

export function JobSection({
  job,
  priceLabel,
}: {
  job: JobView;
  priceLabel: string;
}) {
  const kicker = shortKicker(job.description);
  const intro = kicker ? null : job.description;
  return (
    <tr class="job-row">
      <td class="line-no">
        <div class="line-no-label">{job.numberLabel}</div>
      </td>
      <td>
        <div class="job-title-bar">
          <h2 class="job-heading">{job.title}</h2>
          {kicker && <div class="job-kicker">{kicker}</div>}
        </div>
        <div class="job-body">
          <div class="job-copy">
            {job.conceptImages.length > 0 && (
              <div class="job-photos">
                <ConceptImages images={job.conceptImages} />
              </div>
            )}
            <div>
              {intro && <p class="scope">{intro}</p>}
              <ScopeList items={job.lineItems} exclusions={job.exclusions} />
            </div>
          </div>
        </div>
      </td>
      <td class="price">
        <PriceBox label={priceLabel} cents={job.totalCents} />
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
        </figure>
      ))}
    </>
  );
}

export function Totals({ totals }: { totals: ProposalView["totals"] }) {
  if (totals.packages.length <= 1 && totals.jobs.length <= 1) return null;
  return (
    <section class="totals">
      {totals.packages.map((pkg) => (
        <PriceBox key={pkg.label} label={pkg.label} cents={pkg.totalCents} />
      ))}
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
    <div>
      <div class="terms-grid">
        <div class="term">
          <Icon d="M4 5h16v2H4zm2 4h12v11H6zm3 2v7h2v-7zm4 0v7h2v-7z" />
          <div>
            <h2>Conceptual Renderings</h2>
            <p>Conceptual renderings are for illustration purposes only.</p>
          </div>
        </div>
        <div class="term">
          <Icon d="M12 2a10 10 0 1 0 10 10A10 10 0 0 0 12 2zm1 5v5l4 2-.7 1.2L11 13V7z" />
          <div>
            <h2>Pricing Validity</h2>
            <p>Pricing valid for 30 days from proposal date.</p>
          </div>
        </div>
        <div class="term">
          <Icon d="M5 4h14v2H5zm0 4h10v2H5zm0 4h14v2H5zm0 4h8v2H5z" />
          <div>
            <h2>Field Verification</h2>
            <p>Final dimensions and details will be confirmed in the field.</p>
          </div>
        </div>
        <div class="term">
          <Icon d="M4 6h16v2H4zm2 4h12l-1.5 9h-9z" />
          <div>
            <h2>Scope Changes</h2>
            <p>Any changes to the scope may affect pricing.</p>
          </div>
        </div>
        {timeframes.length > 0 && (
          <div class="term">
            <Icon d="M5 3h2v2h10V3h2v2h2v16H3V5h2zm0 4v12h14V7z" />
            <div>
              <h2>Project Timeframe</h2>
              <p>Estimated project timeframe:</p>
              {timeframes.map((item) => <p key={item}>{item}</p>)}
              <p>weather depending*.</p>
            </div>
          </div>
        )}
        <div class="term">
          <Icon d="M12 2 4 6v6c0 5 3.4 9.4 8 10 4.6-.6 8-5 8-10V6zm0 17c-3.2-.6-6-4-6-8.2V7.4L12 5l6 2.4v3.4c0 4.2-2.8 7.6-6 8.2z" />
          <div>
            <h2>Payment Schedule</h2>
            <p>1/3 deposit • 2/3 at project start • 3/3 upon completion</p>
          </div>
        </div>
      </div>
      {extraTerms && <div class="extra-terms">{extraTerms}</div>}
    </div>
  );
}

export function ThankYouCorner({ businessName }: { businessName: string }) {
  return (
    <div class="thank-you-corner">
      <div class="script">Thank You</div>
      <div class="rest">FOR CONSIDERING</div>
      <div class="rest">{businessName}</div>
    </div>
  );
}

export function Footer({
  preparedBy,
  businessName,
  extraTerms,
  timeframes,
}: {
  preparedBy: string;
  businessName: string;
  extraTerms: string | null;
  timeframes: string[];
}) {
  return (
    <footer class="closing">
      <div class="closing-grid">
        <div>
          <div class="compliance">
            <div class="compliance-head">
              <Icon d="M12 2 4 6v6c0 5 3.4 9.4 8 10 4.6-.6 8-5 8-10V6zm-1.2 14-3.3-3.3 1.4-1.4 1.9 1.9 4.2-4.2 1.4 1.4z" />
              <h2>Code & Material Compliance</h2>
            </div>
            <p>
              All work will be completed in accordance with applicable local
              building codes and requirements. All hardware, fasteners,
              structural connections, and materials will be new and
              code-approved for the intended application, installed per code and
              manufacturer specifications.
            </p>
          </div>
          <div class="sign-block">
            <div class="sign-by">Proposal by: {preparedBy}</div>
            <div class="sign-lines">
              <div class="sign-line">
                Client Signature:
                <div class="sign-rule" />
              </div>
              <div class="sign-line">
                Date:
                <div class="sign-rule" />
              </div>
            </div>
          </div>
        </div>
        <Terms extraTerms={extraTerms} timeframes={timeframes} />
      </div>
      <ThankYouCorner businessName={businessName} />
    </footer>
  );
}

function jobPriceLabel(proposal: ProposalView, job: JobView): string {
  if (!proposal.totals.hasAlternates && proposal.jobs.length === 1) {
    return "Total Labor & Materials";
  }
  if (proposal.totals.hasAlternates) return job.title;
  return "Price";
}

export function ProposalDocument({
  proposal,
  includeLetterhead = true,
}: {
  proposal: ProposalView;
  includeLetterhead?: boolean;
}) {
  const timeframes = [
    ...new Set(
      proposal.jobs
        .map((job) => job.timeframe)
        .filter((value): value is string => value != null),
    ),
  ];

  return (
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <title>{proposal.letterhead.name} Proposal</title>
        <style>
          {proposal.fontCss + DOCUMENT_CSS +
            (includeLetterhead ? "" : PDF_PAGE_CSS)}
        </style>
      </head>
      <body>
        <div class={includeLetterhead ? "page" : "page page-pdf"}>
          {includeLetterhead && (
            <>
              <Letterhead letterhead={proposal.letterhead} />
              <div class="gold-rule" />
            </>
          )}
          <div class="body">
            <ClientBlock
              projectTitle={proposal.projectTitle}
              siteAddress={proposal.siteAddress}
              issueDate={proposal.issueDate}
              attention={proposal.client.name}
            />
            <table class="line-items">
              <thead>
                <tr>
                  <th class="line-no">Line<br />Item</th>
                  <th class="desc">Description</th>
                  <th class="price">Price</th>
                </tr>
              </thead>
              <tbody>
                {proposal.jobs.map((job) => (
                  <JobSection
                    key={job.numberLabel}
                    job={job}
                    priceLabel={jobPriceLabel(proposal, job)}
                  />
                ))}
              </tbody>
            </table>
            <Totals totals={proposal.totals} />
          </div>
          <Footer
            preparedBy={proposal.preparedBy}
            businessName={proposal.letterhead.name}
            extraTerms={proposal.extraTerms}
            timeframes={timeframes}
          />
        </div>
      </body>
    </html>
  );
}

export function renderProposalHtml(
  proposal: ProposalView,
  options: { includeLetterhead?: boolean } = {},
): string {
  return `<!doctype html>${
    render(
      <ProposalDocument
        proposal={proposal}
        includeLetterhead={options.includeLetterhead ?? true}
      />,
    )
  }`;
}

export function renderProposalHeaderHtml(proposal: ProposalView): string {
  return render(
    <div class="pdf-header">
      <style>{proposal.fontCss + HEADER_CSS}</style>
      <Letterhead letterhead={proposal.letterhead} />
      <div class="gold-rule" />
    </div>,
  );
}

