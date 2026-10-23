import { assertEquals, assertRejects } from "./assert.ts";
import {
  convertHtmlToPdf,
  PdfShiftClientError,
  PdfShiftFailedError,
} from "./pdfshift.ts";

const pdfBytes = Uint8Array.from([0x25, 0x50, 0x44, 0x46, 0x2d, 0x31, 0x2e, 0x34]);

function jsonResponse(status: number, body: unknown = { error: "nope" }) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

Deno.test("retries once on 5xx then succeeds", async () => {
  let calls = 0;
  const fetchImpl: typeof fetch = async () => {
    calls += 1;
    if (calls === 1) return jsonResponse(502);
    return new Response(pdfBytes, { status: 200 });
  };
  const result = await convertHtmlToPdf({
    html: "<html></html>",
    apiKey: "sk_test",
    sandbox: true,
    footerHtml: "<div></div>",
    fetchImpl,
  });
  assertEquals(calls, 2);
  assertEquals(result.status, 200);
  assertEquals(result.pdf[0], 0x25);
});

Deno.test("retries once on timeout then returns 502", async () => {
  let calls = 0;
  const fetchImpl: typeof fetch = async () => {
    calls += 1;
    throw new DOMException("Aborted", "AbortError");
  };
  await assertRejects(
    () =>
      convertHtmlToPdf({
        html: "<html></html>",
        apiKey: "sk_test",
        sandbox: true,
        footerHtml: "<div></div>",
        fetchImpl,
      }),
    PdfShiftFailedError,
  );
  assertEquals(calls, 2);
});

Deno.test("does not retry 4xx", async () => {
  let calls = 0;
  const fetchImpl: typeof fetch = async () => {
    calls += 1;
    return jsonResponse(401);
  };
  await assertRejects(
    () =>
      convertHtmlToPdf({
        html: "<html></html>",
        apiKey: "sk_test",
        sandbox: true,
        footerHtml: "<div></div>",
        fetchImpl,
      }),
    PdfShiftClientError,
  );
  assertEquals(calls, 1);
});

Deno.test("rejects a non-PDF body", async () => {
  const fetchImpl: typeof fetch = async () =>
    new Response("not a pdf", { status: 200 });
  await assertRejects(
    () =>
      convertHtmlToPdf({
        html: "<html></html>",
        apiKey: "sk_test",
        sandbox: true,
        footerHtml: "<div></div>",
        fetchImpl,
      }),
    PdfShiftFailedError,
  );
});
