import { assert } from "./assert.ts";
import { loadFontCss } from "./fonts.ts";

Deno.test("embeds woff2 faces as data URLs", async () => {
  const css = await loadFontCss();
  assert(css.includes("@font-face"));
  assert(css.includes("font-family:'Oswald'"));
  assert(css.includes("font-family:'Source Sans 3'"));
  assert(css.includes("font-family:'Great Vibes'"));
  assert(css.includes("data:font/woff2;base64,"));
  assert(css.includes("unicode-range:"));
});
