function bytesToBase64(bytes: Uint8Array): string {
  let binary = "";
  const chunk = 0x8000;
  for (let i = 0; i < bytes.length; i += chunk) {
    binary += String.fromCharCode(...bytes.subarray(i, i + chunk));
  }
  return btoa(binary);
}

function fontPaths(fileName: string): Array<string | URL> {
  const relative = `./fonts/${fileName}`;
  const paths: Array<string | URL> = [new URL(relative, import.meta.url)];
  // `functions serve` compiles TS into /var/tmp/sb-compile-edge-runtime but
  // leaves static assets on the bind-mounted source tree (cwd = project root).
  const compiled = import.meta.url.match(/sb-compile-edge-runtime\/([^/]+)\//);
  if (compiled) {
    paths.push(
      `${Deno.cwd()}/supabase/functions/${compiled[1]}/fonts/${fileName}`,
    );
  }
  paths.push(relative);
  return paths;
}

async function readFont(fileName: string): Promise<string> {
  let lastError: unknown;
  for (const path of fontPaths(fileName)) {
    try {
      return bytesToBase64(await Deno.readFile(path));
    } catch (error) {
      lastError = error;
    }
  }
  throw lastError;
}

const LATIN =
  "U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD";
const LATIN_EXT =
  "U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C4, U+2113, U+2C60-2C7F, U+A720-A7FF";

function face(
  family: string,
  weight: string,
  base64: string,
  unicodeRange: string,
): string {
  return `@font-face{font-family:'${family}';font-style:normal;font-weight:${weight};font-display:block;src:url(data:font/woff2;base64,${base64}) format('woff2');unicode-range:${unicodeRange};}`;
}

export async function loadFontCss(): Promise<string> {
  const [
    oswald,
    oswaldExt,
    source,
    sourceExt,
    script,
    scriptExt,
  ] = await Promise.all([
    readFont("oswald-latin.woff2"),
    readFont("oswald-latin-ext.woff2"),
    readFont("source-sans-latin.woff2"),
    readFont("source-sans-latin-ext.woff2"),
    readFont("great-vibes-latin.woff2"),
    readFont("great-vibes-latin-ext.woff2"),
  ]);
  return [
    face("Oswald", "500 700", oswald, LATIN),
    face("Oswald", "500 700", oswaldExt, LATIN_EXT),
    face("Source Sans 3", "400 700", source, LATIN),
    face("Source Sans 3", "400 700", sourceExt, LATIN_EXT),
    face("Great Vibes", "400", script, LATIN),
    face("Great Vibes", "400", scriptExt, LATIN_EXT),
  ].join("");
}
