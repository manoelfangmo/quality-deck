import type { LoadedProject } from "./types.ts";
import { toProposalView } from "./data.ts";

function line(
  name: string,
  quantity: string,
  saved: number,
  extra: Partial<{
    description: string | null;
    pricingType: string;
    overridePriceCents: number | null;
    isCustom: boolean;
    position: number;
  }> = {},
) {
  return {
    name,
    description: extra.description ?? null,
    quantity,
    pricingType: extra.pricingType ?? "per_sq_ft",
    savedPriceCents: saved,
    overridePriceCents: extra.overridePriceCents ?? null,
    isCustom: extra.isCustom ?? false,
    position: extra.position ?? 0,
  };
}

const qualityDeck = {
  name: "Quality Deck",
  timezone: "America/New_York",
  street: "11510 Laurel Walk Dr",
  city: "Laurel",
  state: "MD",
  zip: "20708",
  phone: "301-886-9355",
  email: "info@quality-deck.com",
  website: "www.quality-deck.com",
  licenseNumber: "MHIC LICENSE # 153656",
  tagline: "DECKS | PORCHES | OUTDOOR LIVING",
  terms: null,
  logoPath: null,
  ownerName: "Moises Melgar",
};

function project(partial: Partial<LoadedProject> & Pick<LoadedProject, "jobs" | "title">): LoadedProject {
  return {
    id: "11111111-1111-4111-8111-111111111111",
    businessId: "00000000-0000-4000-8000-000000000011",
    siteStreet: "1301 Windham Ln",
    siteCity: "Silver Spring",
    siteState: "MD",
    siteZip: "20902",
    createdAt: "2026-10-15T14:00:00Z",
    overheadBps: null,
    proposalNumber: "QD-2026-0001",
    client: {
      fullName: "Leibel",
      email: "leibel@example.test",
      phone: "301-555-0100",
      street: "1301 Windham Ln",
      city: "Silver Spring",
      state: "MD",
      zip: "20902",
    },
    business: qualityDeck,
    ...partial,
  };
}

export const typicalProject = project({
  title: "Deck Restoration",
  jobs: [
    {
      id: "job-1",
      title: "Deck Repainting / Rotten Wood Replacement",
      jobType: "deck",
      description:
        "Deck Restoration & Recoating – 278 Sq. Ft.\nProtection of surrounding areas, railing repairs, surface preparation, crack preparation, two coats of SuperDeck, and final cleanup.",
      exclusions: "Existing structural beams and support posts are excluded from this scope of work.",
      timeframe: "1-2 Days",
      laborHours: null,
      laborRateCents: null,
      createdAt: "2026-10-01T00:00:00Z",
      lineItems: [
        line("Decking recoat", "278", 800, { position: 0 }),
        line("Railing repairs", "1", 700, { pricingType: "fixed", position: 1 }),
        line("Surface prep", "278", 200, { position: 2 }),
        line("Protective coating", "278", 500, { position: 3 }),
        line("Cleanup", "1", 200, { pricingType: "fixed", position: 4 }),
      ],
      photos: [
        {
          kind: "concept",
          storagePath: "biz/job-1/one.jpg",
          width: 1200,
          height: 800,
          createdAt: "2026-10-02T00:00:00Z",
        },
        {
          kind: "concept",
          storagePath: "biz/job-1/two.jpg",
          width: 1200,
          height: 800,
          createdAt: "2026-10-02T00:00:01Z",
        },
      ],
    },
    {
      id: "job-2",
      title: "Stair refinish",
      jobType: "deck",
      description: "Sand and recoat stair treads and risers.",
      exclusions: null,
      timeframe: "1-2 Days",
      laborHours: "4",
      laborRateCents: 7500,
      createdAt: "2026-10-01T00:00:01Z",
      lineItems: [
        line("Stair coating", "40", 900, { position: 0 }),
        line("Custom trim", "12", 1500, {
          pricingType: "per_linear_ft",
          isCustom: true,
          position: 1,
        }),
        line("Fasteners", "1", 25000, {
          pricingType: "fixed",
          overridePriceCents: 18000,
          position: 2,
        }),
        line("Landing recoat", "24", 850, { position: 3 }),
        line("Railing stain", "30", 400, { pricingType: "per_linear_ft", position: 4 }),
      ],
      photos: [
        {
          kind: "concept",
          storagePath: "biz/job-2/three.jpg",
          width: 800,
          height: 1000,
          createdAt: "2026-10-03T00:00:00Z",
        },
        {
          kind: "concept",
          storagePath: "biz/job-2/four.jpg",
          width: 800,
          height: 1000,
          createdAt: "2026-10-03T00:00:01Z",
        },
      ],
    },
  ],
});

export const longLinesProject = project({
  title: "Long estimate",
  jobs: [
    {
      id: "job-long",
      title: "Full rebuild",
      jobType: "deck",
      description: "A".repeat(800),
      exclusions: null,
      timeframe: "3-4 Weeks",
      laborHours: null,
      laborRateCents: null,
      createdAt: "2026-10-01T00:00:00Z",
      lineItems: Array.from({ length: 25 }, (_, i) =>
        line(`Line ${i + 1}`, "10", 1200 + i, { position: i })
      ),
      photos: [],
    },
  ],
});

export const threeJobsNoPhotos = project({
  title: "Three scopes",
  jobs: [1, 2, 3].map((n) => ({
    id: `job-${n}`,
    title: `Option ${n}`,
    jobType: "deck",
    description: `Scope ${n}`,
    exclusions: null,
    timeframe: null,
    laborHours: null,
    laborRateCents: null,
    createdAt: `2026-10-0${n}T00:00:00Z`,
    lineItems: [line(`Work ${n}`, "1", 100000 * n, { pricingType: "fixed" })],
    photos: [],
  })),
});

export const specialCharsProject = project({
  title: 'Deck for "Smith & Sons <LLC>" 🪵',
  siteStreet: "123 Rue François & Co <Yard>",
  client: {
    fullName: 'Smith & Sons <LLC> "HQ"',
    email: "a&b@example.test",
    phone: "301-555-0199",
    street: "123 Rue François & Co <Yard>",
    city: "Laurel",
    state: "MD",
    zip: "20708",
  },
  jobs: [
    {
      id: "job-special",
      title: "Repair <south> rail & stairs",
      jobType: "deck",
      description: 'Use "premium" lumber & hardware <grade A>. ✨',
      exclusions: "Do not touch the neighbor's fence & gate <east>.",
      timeframe: "2 days",
      laborHours: null,
      laborRateCents: null,
      createdAt: "2026-10-01T00:00:00Z",
      lineItems: [
        line('Custom cap "A" & fascia <B>', "1", 50000, {
          pricingType: "fixed",
          isCustom: true,
          description: "Smith & Sons <notes>",
        }),
      ],
      photos: [],
    },
  ],
});

export const emptyRequiredProject: LoadedProject = {
  ...typicalProject,
  business: { ...qualityDeck, name: "   " },
  client: { ...typicalProject.client!, fullName: "" },
  siteStreet: "",
  jobs: [],
};

export function viewFor(
  loaded: LoadedProject,
  extras: Partial<Parameters<typeof toProposalView>[1]> = {},
) {
  const conceptUrls = new Map<string, string>();
  for (const job of loaded.jobs) {
    for (const photo of job.photos) {
      conceptUrls.set(photo.storagePath, `https://img.example/${photo.storagePath}`);
    }
  }
  return toProposalView(loaded, {
    proposalNumber: loaded.proposalNumber ?? "QD-2026-0001",
    version: 1,
    issuedAt: "2026-10-15T16:00:00Z",
    preparedBy: "Moises Melgar, Quality Deck",
    fontCss: "",
    logoUrl: null,
    conceptUrls,
    ...extras,
  });
}
