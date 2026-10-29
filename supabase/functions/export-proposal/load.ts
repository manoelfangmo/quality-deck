import type { SupabaseClient } from "@supabase/supabase-js";
import type { LoadedJob, LoadedLineItem, LoadedPhoto, LoadedProject } from "./types.ts";

type Json = Record<string, unknown>;

function asString(value: unknown): string {
  return typeof value === "string" ? value : String(value ?? "");
}

function asStringOrNull(value: unknown): string | null {
  if (value == null) return null;
  return asString(value);
}

function asNumberOrNull(value: unknown): number | null {
  if (value == null) return null;
  if (typeof value === "number" && Number.isFinite(value)) return value;
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : null;
}

function asNumber(value: unknown, fallback = 0): number {
  return asNumberOrNull(value) ?? fallback;
}

function asArray(value: unknown): Json[] {
  if (!Array.isArray(value)) return [];
  return value.filter((row): row is Json => typeof row === "object" && row != null);
}

function asObject(value: unknown): Json | null {
  if (typeof value !== "object" || value == null || Array.isArray(value)) {
    return null;
  }
  return value as Json;
}

function mapLine(row: Json): LoadedLineItem {
  return {
    name: asString(row.name),
    description: asStringOrNull(row.description),
    quantity: row.quantity,
    pricingType: asString(row.pricing_type),
    savedPriceCents: asNumber(row.saved_price_cents),
    overridePriceCents: asNumberOrNull(row.override_price_cents),
    isCustom: Boolean(row.is_custom),
    position: asNumber(row.position),
  };
}

function mapPhoto(row: Json): LoadedPhoto {
  return {
    kind: asString(row.kind),
    storagePath: asString(row.storage_path),
    width: asNumber(row.width, 1),
    height: asNumber(row.height, 1),
    createdAt: asString(row.created_at),
  };
}

function mapJob(row: Json): LoadedJob {
  return {
    id: asString(row.id),
    title: asString(row.title),
    jobType: asString(row.job_type),
    description: asStringOrNull(row.description),
    exclusions: asStringOrNull(row.exclusions),
    timeframe: asStringOrNull(row.timeframe),
    laborHours: row.labor_hours,
    laborRateCents: asNumberOrNull(row.labor_rate_cents),
    createdAt: asString(row.created_at),
    alternateOfJobId: asStringOrNull(row.alternate_of_job_id),
    lineItems: asArray(row.line_items).map(mapLine),
    photos: asArray(row.job_photos).map(mapPhoto),
  };
}

function ownerName(business: Json): string | null {
  const owner = asObject(business.owner);
  if (owner) return asStringOrNull(owner.full_name);
  return null;
}

export function mapProjectRow(row: Json): LoadedProject {
  const client = asObject(row.clients) ?? asObject(row.client);
  const business = asObject(row.businesses) ?? asObject(row.business) ?? {};
  const jobs = asArray(row.jobs)
    .slice()
    .sort((a, b) => {
      const created = asString(a.created_at).localeCompare(asString(b.created_at));
      if (created !== 0) return created;
      return asString(a.id).localeCompare(asString(b.id));
    })
    .map(mapJob);

  return {
    id: asString(row.id),
    businessId: asString(row.business_id),
    title: asString(row.title),
    siteStreet: asString(row.site_street),
    siteCity: asString(row.site_city),
    siteState: asString(row.site_state),
    siteZip: asString(row.site_zip),
    createdAt: asString(row.created_at),
    overheadBps: asNumberOrNull(row.overhead_bps),
    proposalNumber: asStringOrNull(row.proposal_number),
    client: client
      ? {
        fullName: asStringOrNull(client.full_name),
        email: asStringOrNull(client.email),
        phone: asStringOrNull(client.phone),
        street: asStringOrNull(client.street),
        city: asStringOrNull(client.city),
        state: asStringOrNull(client.state),
        zip: asStringOrNull(client.zip),
      }
      : null,
    business: {
      name: asString(business.name),
      timezone: asString(business.timezone) || "America/New_York",
      street: asStringOrNull(business.street),
      city: asStringOrNull(business.city),
      state: asStringOrNull(business.state),
      zip: asStringOrNull(business.zip),
      phone: asStringOrNull(business.phone),
      email: asStringOrNull(business.email),
      website: asStringOrNull(business.website),
      licenseNumber: asStringOrNull(business.license_number),
      tagline: asStringOrNull(business.tagline),
      terms: asStringOrNull(business.terms),
      logoPath: asStringOrNull(business.logo_path),
      ownerName: ownerName(business),
    },
    jobs,
  };
}

const PROJECT_SELECT = `
  id, business_id, title, site_street, site_city, site_state, site_zip,
  created_at, overhead_bps, proposal_number,
  clients ( full_name, email, phone, street, city, state, zip ),
  businesses (
    name, timezone, street, city, state, zip, phone, email, website,
    license_number, tagline, terms, logo_path
  ),
  jobs (
    id, title, job_type, description, exclusions, timeframe,
    labor_hours, labor_rate_cents, created_at, alternate_of_job_id,
    line_items (
      name, description, quantity, pricing_type,
      saved_price_cents, override_price_cents, is_custom, position
    ),
    job_photos ( kind, storage_path, width, height, created_at )
  )
`;

export async function loadProject(
  client: SupabaseClient,
  projectId: string,
): Promise<LoadedProject | null> {
  const { data, error } = await client
    .from("projects")
    .select(PROJECT_SELECT)
    .eq("id", projectId)
    .maybeSingle();
  if (error) throw error;
  if (data == null) return null;
  return mapProjectRow(data as Json);
}

export async function signPaths(
  admin: SupabaseClient,
  bucket: string,
  paths: string[],
  expiresIn: number,
): Promise<Map<string, string>> {
  const unique = [...new Set(paths.filter((path) => path.length > 0))];
  const urls = new Map<string, string>();
  if (unique.length === 0) return urls;
  const { data, error } = await admin.storage
    .from(bucket)
    .createSignedUrls(unique, expiresIn);
  if (error) throw error;
  for (const row of data ?? []) {
    if (row.path && row.signedUrl && !row.error) {
      urls.set(row.path, row.signedUrl);
    }
  }
  return urls;
}
