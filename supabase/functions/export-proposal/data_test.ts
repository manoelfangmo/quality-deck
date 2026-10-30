import { assertEquals } from "./assert.ts";
import {
  collectMissing,
  formatProposalNumber,
  formatUsd,
  jobTotalCents,
  lineTotalCents,
  overheadAmountCents,
  proposalFileName,
  proposalPackages,
  proposalTotals,
  slug,
} from "./data.ts";
import {
  emptyRequiredProject,
  optionProject,
  specialCharsProject,
  typicalProject,
} from "./fixtures.ts";

Deno.test("line totals match the app half-up cents rule", () => {
  assertEquals(lineTotalCents(27800, 800), 222400);
  assertEquals(lineTotalCents(125, 100), 125);
  assertEquals(lineTotalCents(150, 1), 2);
});

Deno.test("job total includes line items and labor", () => {
  // 40×$9 + 12×$15 + override $180 + 24×$8.50 + 30×$4 + 4h×$75
  assertEquals(jobTotalCents(typicalProject.jobs[1]), 134400);
});

Deno.test("proposal total adds overhead the same way the app does", () => {
  const withOverhead = {
    ...typicalProject,
    overheadBps: 1000,
  };
  const totals = proposalTotals(withOverhead);
  assertEquals(
    totals.overheadCents,
    overheadAmountCents(totals.subtotalCents, 1000),
  );
  assertEquals(totals.totalCents, totals.subtotalCents + totals.overheadCents!);
});

Deno.test("required-data checks list every problem", () => {
  assertEquals(collectMissing(emptyRequiredProject), [
    "business.name",
    "client.name",
    "project.siteAddress",
    "jobs",
  ]);

  const missingLines = {
    ...typicalProject,
    jobs: [
      typicalProject.jobs[0],
      { ...typicalProject.jobs[1], lineItems: [] },
    ],
  };
  assertEquals(collectMissing(missingLines), ["jobs[2].lineItems"]);
});

Deno.test("proposal numbers are QD-YYYY-####", () => {
  assertEquals(formatProposalNumber("QD", 2026, 42), "QD-2026-0042");
  assertEquals(formatProposalNumber("OC", 2026, 1), "OC-2026-0001");
});

Deno.test("file names are stable slugs with a version", () => {
  assertEquals(
    proposalFileName({
      businessName: "Quality Deck",
      projectTitle: "Melgar Deck",
      version: 3,
    }),
    "Quality-Deck-Proposal-Melgar-Deck-v3.pdf",
  );
  assertEquals(slug('Smith & Sons <LLC> "HQ"'), "Smith-Sons-LLC-HQ");
});

Deno.test("money formatting drops .00 on whole dollars", () => {
  assertEquals(formatUsd(1245000), "$12,450");
  assertEquals(formatUsd(330000), "$3,300");
  assertEquals(formatUsd(0), "$0");
  assertEquals(formatUsd(330050), "$3,300.50");
});

Deno.test("alternate jobs produce one package per option, not a combined total", () => {
  const packages = proposalPackages(optionProject);
  assertEquals(packages.length, 2);
  assertEquals(packages[0].totalCents, 1724800);
  assertEquals(packages[1].totalCents, 2938200);
  assertEquals(proposalTotals(optionProject).totalCents, 1724800);
});

Deno.test("special-character project still has a client name", () => {
  assertEquals(collectMissing(specialCharsProject), []);
});
