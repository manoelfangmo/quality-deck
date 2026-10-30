export type AddressView = {
  street: string;
  city: string;
  state: string;
  zip: string;
};

export type LineItemView = {
  name: string;
  description: string | null;
  quantityLabel: string;
  isCustom: boolean;
  hasOverride: boolean;
  totalCents: number;
};

export type ConceptImageView = {
  url: string;
  width: number;
  height: number;
};

export type JobView = {
  number: number;
  numberLabel: string;
  title: string;
  jobType: string | null;
  description: string | null;
  exclusions: string | null;
  timeframe: string | null;
  lineItems: LineItemView[];
  laborCents: number | null;
  totalCents: number;
  conceptImages: ConceptImageView[];
  alternateOfJobId: string | null;
};

export type LetterheadView = {
  name: string;
  logoUrl: string | null;
  address: AddressView | null;
  phone: string | null;
  email: string | null;
  website: string | null;
  licenseNumber: string | null;
  tagline: string | null;
};

export type ClientView = {
  name: string;
  email: string | null;
  phone: string | null;
  address: AddressView | null;
};

export type PackageView = {
  label: string;
  subtotalCents: number;
  overheadCents: number | null;
  totalCents: number;
};

export type TotalsView = {
  jobs: { numberLabel: string; title: string; totalCents: number }[];
  packages: PackageView[];
  hasAlternates: boolean;
  subtotalCents: number;
  overheadLabel: string | null;
  overheadCents: number | null;
  totalCents: number;
};

export type ProposalView = {
  letterhead: LetterheadView;
  client: ClientView;
  projectTitle: string;
  siteAddress: AddressView;
  proposalNumber: string;
  issueDate: string;
  validUntil: string;
  preparedBy: string;
  jobs: JobView[];
  totals: TotalsView;
  extraTerms: string | null;
  fontCss: string;
};

export type LoadedLineItem = {
  name: string;
  description: string | null;
  quantity: unknown;
  pricingType: string;
  savedPriceCents: number;
  overridePriceCents: number | null;
  isCustom: boolean;
  position: number;
};

export type LoadedPhoto = {
  kind: string;
  storagePath: string;
  width: number;
  height: number;
  createdAt: string;
};

export type LoadedJob = {
  id: string;
  title: string;
  jobType: string;
  description: string | null;
  exclusions: string | null;
  timeframe: string | null;
  laborHours: unknown;
  laborRateCents: number | null;
  createdAt: string;
  alternateOfJobId: string | null;
  lineItems: LoadedLineItem[];
  photos: LoadedPhoto[];
};

export type LoadedProject = {
  id: string;
  businessId: string;
  title: string;
  siteStreet: string;
  siteCity: string;
  siteState: string;
  siteZip: string;
  createdAt: string;
  overheadBps: number | null;
  proposalNumber: string | null;
  client: {
    fullName: string | null;
    email: string | null;
    phone: string | null;
    street: string | null;
    city: string | null;
    state: string | null;
    zip: string | null;
  } | null;
  business: {
    name: string;
    timezone: string;
    street: string | null;
    city: string | null;
    state: string | null;
    zip: string | null;
    phone: string | null;
    email: string | null;
    website: string | null;
    licenseNumber: string | null;
    tagline: string | null;
    terms: string | null;
    logoPath: string | null;
    ownerName: string | null;
  };
  jobs: LoadedJob[];
};
