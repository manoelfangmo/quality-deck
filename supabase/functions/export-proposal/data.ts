import type {
  AddressView,
  JobView,
  LineItemView,
  LoadedJob,
  LoadedLineItem,
  LoadedProject,
  ProposalView,
} from "./types.ts";

export const UUID_RE =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

export const VALIDITY_DAYS = 30;

/** Matches Dart `(quantity.hundredths * priceCents + 50) ~/ 100`. */
export function lineTotalCents(
  quantityHundredths: number,
  priceCents: number,
): number {
  return Math.trunc((quantityHundredths * priceCents + 50) / 100);
}

/** Matches Dart `(subtotal * bps + 5000) ~/ 10000`. */
export function overheadAmountCents(
  subtotalCents: number,
  basisPoints: number,
): number {
  return Math.trunc((subtotalCents * basisPoints + 5000) / 10000);
}

export function parseHundredths(value: unknown): number {
  if (typeof value === "number" && Number.isFinite(value)) {
    return Math.round(value * 100);
  }
  const text = String(value ?? "").trim();
  const match = text.match(/^(\d+)(?:\.(\d{1,2}))?$/);
  if (!match) return 0;
  const whole = Number(match[1]);
  const fraction = (match[2] ?? "").padEnd(2, "0");
  return whole * 100 + Number(fraction);
}

export function effectiveUnitPriceCents(line: LoadedLineItem): number {
  return line.overridePriceCents ?? line.savedPriceCents;
}

export function lineItemTotalCents(line: LoadedLineItem): number {
  return lineTotalCents(
    parseHundredths(line.quantity),
    effectiveUnitPriceCents(line),
  );
}

export function laborTotalCents(job: LoadedJob): number {
  if (job.laborHours == null || job.laborRateCents == null) return 0;
  return lineTotalCents(parseHundredths(job.laborHours), job.laborRateCents);
}

export function jobTotalCents(job: LoadedJob): number {
  let total = 0;
  for (const line of job.lineItems) {
    total += lineItemTotalCents(line);
  }
  return total + laborTotalCents(job);
}

export function proposalTotals(project: LoadedProject): {
  jobs: { job: LoadedJob; totalCents: number }[];
  subtotalCents: number;
  overheadCents: number | null;
  totalCents: number;
} {
  const jobs = project.jobs.map((job) => ({
    job,
    totalCents: jobTotalCents(job),
  }));
  const subtotalCents = jobs.reduce((sum, row) => sum + row.totalCents, 0);
  const overheadCents = project.overheadBps == null
    ? null
    : overheadAmountCents(subtotalCents, project.overheadBps);
  return {
    jobs,
    subtotalCents,
    overheadCents,
    totalCents: subtotalCents + (overheadCents ?? 0),
  };
}

export function collectMissing(project: LoadedProject): string[] {
  const missing: string[] = [];
  if (!blankToNull(project.business.name)) missing.push("business.name");
  if (!blankToNull(project.client?.fullName)) missing.push("client.name");
  if (
    !blankToNull(project.siteStreet) ||
    !blankToNull(project.siteCity) ||
    !blankToNull(project.siteState) ||
    !blankToNull(project.siteZip)
  ) {
    missing.push("project.siteAddress");
  }
  if (project.jobs.length === 0) {
    missing.push("jobs");
    return missing;
  }
  for (let i = 0; i < project.jobs.length; i++) {
    if (project.jobs[i].lineItems.length === 0) {
      missing.push(`jobs[${i + 1}].lineItems`);
    }
  }
  return missing;
}

export function blankToNull(value: string | null | undefined): string | null {
  if (value == null) return null;
  const trimmed = value.trim();
  return trimmed.length === 0 ? null : trimmed;
}

export function formatUsd(cents: number): string {
  const sign = cents < 0 ? "-" : "";
  const absolute = Math.abs(cents);
  const dollars = Math.floor(absolute / 100);
  const remainder = absolute % 100;
  return `${sign}$${dollars.toLocaleString("en-US")}.${
    remainder.toString().padStart(2, "0")
  }`;
}

export function formatProposalNumber(
  prefix: string,
  year: number,
  sequence: number,
): string {
  return `${prefix}-${year}-${sequence.toString().padStart(4, "0")}`;
}

export function slug(text: string): string {
  const cleaned = text
    .normalize("NFKD")
    .replace(/[^\w\s-]/g, "")
    .trim()
    .replace(/[\s_]+/g, "-")
    .replace(/-+/g, "-");
  return cleaned.length === 0 ? "Proposal" : cleaned;
}

export function proposalFileName(input: {
  businessName: string;
  projectTitle: string;
  version: number;
}): string {
  return `${slug(input.businessName)}-Proposal-${slug(input.projectTitle)}-v${
    input.version
  }.pdf`;
}

export function formatLongDate(isoDate: string, timeZone: string): string {
  const date = new Date(isoDate);
  return new Intl.DateTimeFormat("en-US", {
    timeZone,
    month: "long",
    day: "numeric",
    year: "numeric",
  }).format(date);
}

export function addDaysIso(isoDate: string, days: number): string {
  const date = new Date(isoDate);
  date.setUTCDate(date.getUTCDate() + days);
  return date.toISOString();
}

export function padJobNumber(number: number): string {
  return number.toString().padStart(3, "0");
}

function quantityLabel(line: LoadedLineItem): string {
  if (line.pricingType === "fixed") return "Fixed";
  const quantity = parseHundredths(line.quantity) / 100;
  const formatted = Number.isInteger(quantity)
    ? quantity.toString()
    : quantity.toFixed(2).replace(/0$/, "").replace(/\.0$/, "");
  const unit = quantityUnit(line.pricingType);
  const price = formatUsd(effectiveUnitPriceCents(line));
  return unit ? `${formatted} ${unit} × ${price}` : `${formatted} × ${price}`;
}

function quantityUnit(pricingType: string): string {
  switch (pricingType) {
    case "per_sq_ft":
      return "sq ft";
    case "per_linear_ft":
      return "linear ft";
    case "per_step":
      return "steps";
    case "per_unit":
      return "units";
    default:
      return "";
  }
}

function addressOrNull(
  street: string | null | undefined,
  city: string | null | undefined,
  state: string | null | undefined,
  zip: string | null | undefined,
): AddressView | null {
  const s = blankToNull(street);
  const c = blankToNull(city);
  const st = blankToNull(state);
  const z = blankToNull(zip);
  if (!s || !c || !st || !z) return null;
  return { street: s, city: c, state: st, zip: z };
}

function toLineItemView(line: LoadedLineItem): LineItemView {
  return {
    name: line.name,
    description: blankToNull(line.description),
    quantityLabel: quantityLabel(line),
    isCustom: line.isCustom,
    hasOverride: line.overridePriceCents != null,
    totalCents: lineItemTotalCents(line),
  };
}

export function toProposalView(
  project: LoadedProject,
  input: {
    proposalNumber: string;
    version: number;
    issuedAt: string;
    preparedBy: string;
    fontCss: string;
    logoUrl: string | null;
    conceptUrls: Map<string, string>;
  },
): ProposalView {
  const totals = proposalTotals(project);
  const timeZone = project.business.timezone || "America/New_York";
  const jobs: JobView[] = totals.jobs.map((row, index) => {
    const number = index + 1;
    const labor = laborTotalCents(row.job);
    return {
      number,
      numberLabel: padJobNumber(number),
      title: row.job.title,
      jobType: blankToNull(row.job.jobType),
      description: blankToNull(row.job.description),
      exclusions: blankToNull(row.job.exclusions),
      timeframe: blankToNull(row.job.timeframe),
      lineItems: [...row.job.lineItems]
        .sort((a, b) => a.position - b.position)
        .map(toLineItemView),
      laborCents: labor > 0 ? labor : null,
      totalCents: row.totalCents,
      conceptImages: row.job.photos
        .filter((photo) => photo.kind === "concept")
        .sort((a, b) => a.createdAt.localeCompare(b.createdAt))
        .flatMap((photo) => {
          const url = input.conceptUrls.get(photo.storagePath);
          if (!url) return [];
          return [{ url, width: photo.width, height: photo.height }];
        }),
    };
  });

  const overheadLabel = project.overheadBps == null
    ? null
    : `Overhead (${(project.overheadBps / 100).toFixed(
      project.overheadBps % 100 === 0 ? 0 : 2,
    )}%)`;

  return {
    letterhead: {
      name: project.business.name,
      logoUrl: input.logoUrl,
      address: addressOrNull(
        project.business.street,
        project.business.city,
        project.business.state,
        project.business.zip,
      ),
      phone: blankToNull(project.business.phone),
      email: blankToNull(project.business.email),
      website: blankToNull(project.business.website),
      licenseNumber: blankToNull(project.business.licenseNumber),
      tagline: blankToNull(project.business.tagline),
    },
    client: {
      name: project.client?.fullName?.trim() ?? "",
      email: blankToNull(project.client?.email),
      phone: blankToNull(project.client?.phone),
      address: addressOrNull(
        project.client?.street,
        project.client?.city,
        project.client?.state,
        project.client?.zip,
      ),
    },
    projectTitle: project.title,
    siteAddress: {
      street: project.siteStreet,
      city: project.siteCity,
      state: project.siteState,
      zip: project.siteZip,
    },
    proposalNumber: input.proposalNumber,
    issueDate: formatLongDate(input.issuedAt, timeZone),
    validUntil: formatLongDate(addDaysIso(input.issuedAt, VALIDITY_DAYS), timeZone),
    preparedBy: input.preparedBy,
    jobs,
    totals: {
      jobs: jobs.map((job) => ({
        numberLabel: job.numberLabel,
        title: job.title,
        totalCents: job.totalCents,
      })),
      subtotalCents: totals.subtotalCents,
      overheadLabel,
      overheadCents: totals.overheadCents,
      totalCents: totals.totalCents,
    },
    extraTerms: blankToNull(project.business.terms),
    fontCss: input.fontCss,
  };
}

export function formatAddress(address: AddressView): string {
  return `${address.street}, ${address.city}, ${address.state} ${address.zip}`;
}

export function isUuid(value: unknown): value is string {
  return typeof value === "string" && UUID_RE.test(value);
}
