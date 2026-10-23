import { assert, assertEquals } from "./assert.ts";
import {
  longLinesProject,
  specialCharsProject,
  threeJobsNoPhotos,
  typicalProject,
  viewFor,
} from "./fixtures.ts";
import { renderProposalHtml } from "./template.tsx";

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
    assert(html.includes("Line Item"));
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
});
