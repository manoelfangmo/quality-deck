import { createClient } from "@supabase/supabase-js";
import {
  collectMissing,
  isUuid,
  proposalFileName,
  proposalTotals,
  toProposalView,
} from "./data.ts";
import { loadFontCss } from "./fonts.ts";
import { loadProject, signPaths } from "./load.ts";
import {
  convertHtmlToPdf,
  PdfShiftClientError,
  PdfShiftFailedError,
} from "./pdfshift.ts";
import { savePdfAndRecord } from "./persist.ts";
import { pdfshiftFooterHtml, renderProposalHtml } from "./template.tsx";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const IMAGE_URL_TTL = 10 * 60;
const DOWNLOAD_URL_TTL = 60 * 60;

type JsonBody = Record<string, unknown>;

function json(status: number, body: JsonBody): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json; charset=utf-8",
    },
  });
}

function env(name: string): string {
  const value = Deno.env.get(name);
  if (!value) throw new Error(`missing_env:${name}`);
  return value;
}

function sandboxMode(): boolean {
  return Deno.env.get("PDFSHIFT_SANDBOX") !== "false";
}

function logExport(fields: Record<string, unknown>) {
  console.log(JSON.stringify({ event: "export_proposal", ...fields }));
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return json(400, { error: "invalid_request" });
  }

  const started = performance.now();
  let loadMs = 0;
  let renderMs = 0;
  let pdfMs = 0;
  let storeMs = 0;
  let pdfshiftStatus: number | null = null;

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) return json(401, { error: "unauthorized" });

    const supabaseUrl = env("SUPABASE_URL");
    const anonKey = Deno.env.get("SUPABASE_ANON_KEY") ?? env("SUPABASE_PUBLISHABLE_KEY");
    const serviceKey = env("SUPABASE_SERVICE_ROLE_KEY");

    const userClient = createClient(supabaseUrl, anonKey, {
      global: { headers: { Authorization: authHeader } },
      auth: { persistSession: false, autoRefreshToken: false },
    });

    const { data: userData, error: userError } = await userClient.auth.getUser();
    if (userError || userData.user == null) {
      return json(401, { error: "unauthorized" });
    }
    const userId = userData.user.id;

    let body: unknown;
    try {
      body = await req.json();
    } catch {
      return json(400, { error: "invalid_request" });
    }
    const projectId = (body as JsonBody)?.projectId;
    if (!isUuid(projectId)) {
      return json(400, { error: "invalid_request" });
    }

    const loadStarted = performance.now();
    const project = await loadProject(userClient, projectId);
    loadMs = Math.round(performance.now() - loadStarted);
    if (project == null) {
      return json(404, { error: "not_found" });
    }

    const missing = collectMissing(project);
    if (missing.length > 0) {
      return json(422, { error: "missing_data", missing });
    }

    const admin = createClient(supabaseUrl, serviceKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });

    const { data: assigned, error: assignError } = await admin.rpc(
      "next_proposal_export",
      { p_project_id: projectId },
    );
    if (assignError || assigned == null) {
      throw assignError ?? new Error("assign_failed");
    }
    const row = Array.isArray(assigned) ? assigned[0] : assigned;
    const version = Number(row.version);
    const proposalNumber = String(row.proposal_number);
    const businessId = String(row.business_id);

    const conceptPaths = project.jobs.flatMap((job) =>
      job.photos
        .filter((photo) => photo.kind === "concept")
        .map((photo) => photo.storagePath)
    );
    const logoPaths = project.business.logoPath ? [project.business.logoPath] : [];
    const [conceptUrls, logoUrls, fontCss] = await Promise.all([
      signPaths(admin, "job-photos", conceptPaths, IMAGE_URL_TTL),
      signPaths(admin, "business-assets", logoPaths, IMAGE_URL_TTL),
      loadFontCss(),
    ]);

    const issuedAt = new Date().toISOString();
    const { data: exporter } = await userClient
      .from("users")
      .select("full_name")
      .eq("id", userId)
      .maybeSingle();
    const preparedBy = [
      (exporter?.full_name as string | undefined)?.trim() ||
        project.business.ownerName,
      project.business.name,
    ].filter(Boolean).join(", ");

    const view = toProposalView(project, {
      proposalNumber,
      version,
      issuedAt,
      preparedBy: preparedBy || project.business.name,
      fontCss,
      logoUrl: project.business.logoPath
        ? logoUrls.get(project.business.logoPath) ?? null
        : null,
      conceptUrls,
    });

    const renderStarted = performance.now();
    const html = renderProposalHtml(view);
    renderMs = Math.round(performance.now() - renderStarted);

    const apiKey = env("PDFSHIFT_API_KEY");
    const pdfStarted = performance.now();
    const converted = await convertHtmlToPdf({
      html,
      apiKey,
      sandbox: sandboxMode(),
      footerHtml: pdfshiftFooterHtml(
        project.business.name,
        project.business.phone,
      ),
    });
    pdfMs = Math.round(performance.now() - pdfStarted);
    pdfshiftStatus = converted.status;

    const exportId = crypto.randomUUID();
    const storagePath = `${businessId}/${projectId}/v${version}-${exportId}.pdf`;
    const fileName = proposalFileName({
      businessName: project.business.name,
      projectTitle: project.title,
      version,
    });
    const totalCents = proposalTotals(project).totalCents;

    const storeStarted = performance.now();
    await savePdfAndRecord({
      upload: () =>
        admin.storage.from("proposal-pdfs").upload(storagePath, converted.pdf, {
          contentType: "application/pdf",
          upsert: false,
        }),
      insert: async () => {
        const { error } = await admin.from("proposal_exports").insert({
          id: exportId,
          business_id: businessId,
          project_id: projectId,
          version,
          proposal_number: proposalNumber,
          storage_path: storagePath,
          total_cents: totalCents,
          page_count: converted.pageCount,
          created_by: userId,
        });
        return { error };
      },
      remove: async () => {
        await admin.storage.from("proposal-pdfs").remove([storagePath]);
      },
    });

    const { data: signed, error: signError } = await admin.storage
      .from("proposal-pdfs")
      .createSignedUrl(storagePath, DOWNLOAD_URL_TTL);
    if (signError || signed?.signedUrl == null) {
      throw signError ?? new Error("sign_failed");
    }
    storeMs = Math.round(performance.now() - storeStarted);

    const urlExpiresAt = new Date(Date.now() + DOWNLOAD_URL_TTL * 1000)
      .toISOString();

    logExport({
      exportId,
      version,
      timings: {
        loadMs,
        renderMs,
        pdfMs,
        storeMs,
        totalMs: Math.round(performance.now() - started),
      },
      pdfshiftStatus,
    });

    return json(200, {
      exportId,
      version,
      fileName,
      storagePath,
      url: signed.signedUrl,
      urlExpiresAt,
      pageCount: converted.pageCount,
    });
  } catch (error) {
    if (error instanceof PdfShiftClientError || error instanceof PdfShiftFailedError) {
      logExport({
        error: "pdf_service_failed",
        pdfshiftStatus: error.status ?? pdfshiftStatus,
        timings: { loadMs, renderMs, pdfMs, storeMs },
      });
      return json(502, { error: "pdf_service_failed" });
    }
    logExport({
      error: "internal",
      timings: { loadMs, renderMs, pdfMs, storeMs },
      pdfshiftStatus,
    });
    return json(500, { error: "internal" });
  }
});
