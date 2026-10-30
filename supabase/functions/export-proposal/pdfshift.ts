import { PAGE_TOP_MARGIN } from "./css.ts";

export const PDFSHIFT_URL = "https://api.pdfshift.io/v3/convert/pdf";
export const PDFSHIFT_TIMEOUT_MS = 45_000;

export class PdfShiftClientError extends Error {
  constructor(public readonly status: number) {
    super("pdfshift_client_error");
    this.name = "PdfShiftClientError";
  }
}

export class PdfShiftFailedError extends Error {
  constructor(public readonly status?: number) {
    super("pdf_service_failed");
    this.name = "PdfShiftFailedError";
  }
}

export type PdfShiftRequest = {
  html: string;
  apiKey: string;
  sandbox: boolean;
  footerHtml?: string;
  headerHtml?: string;
  fetchImpl?: typeof fetch;
};

export type PdfShiftResult = {
  pdf: Uint8Array;
  status: number;
  pageCount: number | null;
};

function pdfMagic(bytes: Uint8Array): boolean {
  return bytes.length >= 5 &&
    bytes[0] === 0x25 && // %
    bytes[1] === 0x50 && // P
    bytes[2] === 0x44 && // D
    bytes[3] === 0x46; // F
}

export function pageCountFromPdf(bytes: Uint8Array): number | null {
  const text = new TextDecoder("latin1").decode(bytes.subarray(0, Math.min(bytes.length, 2_000_000)));
  const pages = text.match(/\/Type\s*\/Page(?!s)\b/g);
  if (pages && pages.length > 0) return pages.length;
  const counts = [...text.matchAll(/\/Count\s+(\d+)/g)].map((m) => Number(m[1]));
  if (counts.length === 0) return null;
  return Math.max(...counts);
}

async function convertOnce(
  request: PdfShiftRequest,
  fetchImpl: typeof fetch,
): Promise<PdfShiftResult> {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), PDFSHIFT_TIMEOUT_MS);
  try {
    const response = await fetchImpl(PDFSHIFT_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-API-Key": request.apiKey,
      },
      body: JSON.stringify({
        source: request.html,
        sandbox: request.sandbox,
        format: "Letter",
        margin: {
          top: request.headerHtml ? PAGE_TOP_MARGIN : "0px",
          right: "0px",
          bottom: "0px",
          left: "0px",
        },
        header: request.headerHtml
          ? { source: request.headerHtml, spacing: "0" }
          : undefined,
        footer: request.footerHtml
          ? { source: request.footerHtml, spacing: "8" }
          : undefined,
        use_print: true,
      }),
      signal: controller.signal,
    });

    if (response.status >= 400 && response.status < 500) {
      throw new PdfShiftClientError(response.status);
    }
    if (!response.ok) {
      throw new PdfShiftFailedError(response.status);
    }

    const bytes = new Uint8Array(await response.arrayBuffer());
    if (bytes.byteLength === 0 || !pdfMagic(bytes)) {
      throw new PdfShiftFailedError(response.status);
    }
    return {
      pdf: bytes,
      status: response.status,
      pageCount: pageCountFromPdf(bytes),
    };
  } catch (error) {
    if (error instanceof PdfShiftClientError) throw error;
    if (error instanceof PdfShiftFailedError) throw error;
    throw new PdfShiftFailedError();
  } finally {
    clearTimeout(timer);
  }
}

export async function convertHtmlToPdf(
  request: PdfShiftRequest,
): Promise<PdfShiftResult> {
  const fetchImpl = request.fetchImpl ?? fetch;
  try {
    return await convertOnce(request, fetchImpl);
  } catch (error) {
    if (error instanceof PdfShiftClientError) throw error;
    return await convertOnce(request, fetchImpl);
  }
}
