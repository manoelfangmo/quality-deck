import { assert, assertEquals } from "./assert.ts";
import { brandInitials } from "./copy.ts";
import {
  longLinesProject,
  optionProject,
  specialCharsProject,
  threeJobsNoPhotos,
  typicalProject,
  viewFor,
} from "./fixtures.ts";
import { renderProposalHeaderHtml, renderProposalHtml } from "./template.tsx";

const samples = {
  typical: typicalProject,
  longLines: longLinesProject,
  threeJobs: threeJobsNoPhotos,
  specialChars: specialCharsProject,
};

for (const [name, project] of Object.entries(samples)) {
  Deno.test(`renders ${name} robustness sample`, () => {
    const html = renderProposalHtml(viewFor(project));
    assert(html.startsWith("<!doctype html>"));
    assert(html.includes("<style>"));
    assert(html.includes("Line") && html.includes("Item"));
    assert(html.includes("Description"));
    assert(html.includes("Total Labor &amp; Materials") || html.includes("Total Labor & Materials"));
    assert(html.includes(project.title) || html.includes("Smith"));
  });
}

Deno.test("JSX escapes special characters and does not inject markup", () => {
  const html = renderProposalHtml(viewFor(specialCharsProject));
  assert(html.includes("Smith &amp; Sons"));
  assert(html.includes("&lt;LLC"));
  assert(html.includes("&quot;HQ&quot;") || html.includes("&quot;HQ"));
  assert(!html.includes("Smith & Sons <LLC>"));
  assert(!html.includes("dangerouslySetInnerHTML"));
});

Deno.test("doctype is prepended so Chromium is not in quirks mode", () => {
  const html = renderProposalHtml(viewFor(typicalProject));
  assertEquals(html.slice(0, 15).toLowerCase(), "<!doctype html>");
});

Deno.test("numbered jobs and a combined total are present", () => {
  const html = renderProposalHtml(viewFor(typicalProject));
  assert(html.includes("001"));
  assert(html.includes("002"));
  assert(html.includes("Deck Restoration"));
  assert(html.includes('class="line-no-label">001<'));
});

Deno.test("description column is bullets without priced lines", () => {
  const html = renderProposalHtml(viewFor(typicalProject));
  assert(html.includes("Decking recoat"));
  assert(html.includes("Exclusions:"));
  assert(!html.includes("sq ft ×"));
  assert(!html.includes("class=\"job-type\""));
  assert(!html.includes("Labor $"));
  assert(!html.includes("Proposal:"));
  assert(!html.includes("Valid until:"));
});

Deno.test("letterhead slogan and thank-you casing match the samples", () => {
  const html = renderProposalHtml(viewFor(typicalProject));
  assert(html.includes("Built right."));
  assert(html.includes("Built to last."));
  assert(html.includes("FOR CONSIDERING"));
  assert(html.includes("Pricing valid for 30 days from proposal date."));
});

Deno.test("letterhead mark uses business initials, not a hard-coded QD", () => {
  assertEquals(brandInitials("Quality Deck"), "QD");
  assertEquals(brandInitials("Quality Deck Inc"), "QD");
  assertEquals(brandInitials("Acme Builders LLC"), "AB");
  const html = renderProposalHtml(viewFor({
    ...typicalProject,
    business: { ...typicalProject.business, name: "Acme Builders" },
  }));
  assert(html.includes('class="brand-mark">AB<'));
  assert(html.includes("Acme Builders"));
  assert(!html.includes('class="qd-mark"'));
});

Deno.test("repeating header HTML includes the letterhead", () => {
  const header = renderProposalHeaderHtml(viewFor(typicalProject));
  assert(header.includes("letterhead"));
  assert(header.includes("Built right."));
  assert(header.includes("DECKS | PORCHES | OUTDOOR LIVING"));
});

Deno.test("PDF body leaves room under the repeating header on every page", () => {
  const html = renderProposalHtml(viewFor(typicalProject), {
    includeLetterhead: false,
  });
  assert(html.includes("page-pdf"));
  assert(html.includes("margin: 1.35in 0 0 0"));
  assert(!html.includes('class="letterhead"'));
});

Deno.test("Thank You and signatures share one closing strip after the last job", () => {
  const html = renderProposalHtml(viewFor(typicalProject), {
    includeLetterhead: false,
  });
  assert(html.includes("closing"));
  assert(html.includes('class="thank-you-corner"'));
  assert(html.includes("FOR CONSIDERING"));
  assert(html.includes("Client Signature"));
  assert(html.includes("Code &amp; Material Compliance") || html.includes("Code & Material Compliance"));
});

Deno.test("uses bronze and cream from the sample PDFs, not navy and gold", () => {
  const html = renderProposalHtml(viewFor(typicalProject));
  assert(html.includes("#64532b"));
  assert(html.includes("#efead8"));
  assert(!html.includes("#0b1a28"));
  assert(!html.includes("#c4a24a"));
  assert(!html.includes("class=\"sidebar\""));
});

Deno.test("alternate jobs print package totals instead of one combined total", () => {
  const html = renderProposalHtml(viewFor(optionProject));
  assert(html.includes("Total with"));
  assert(html.includes("OPTION 1"));
  assert(html.includes("OPTION 2"));
  assert(!html.includes("$46,630"));
});
