import { typicalProject, viewFor } from "./fixtures.ts";
import { renderProposalHtml } from "./template.tsx";

const html = renderProposalHtml(viewFor(typicalProject));
const path = new URL("./samples/leibel.html", import.meta.url);
await Deno.mkdir(new URL("./samples/", import.meta.url), { recursive: true });
await Deno.writeTextFile(path, html);
console.log(`Wrote ${path.pathname}`);
