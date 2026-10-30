import { VALIDITY_DAYS } from "./data.ts";

/**
 * Boilerplate the PDF prints today. When a second business needs its own
 * slogan, trade line, or terms, load those from `businesses` and pass them
 * through LetterheadView instead of editing the template.
 */
export const proposalCopy = {
  trade: "Design & Construction",
  sloganLines: ["Built right.", "Built to last."] as const,
  paymentSchedule: "1/3 deposit • 2/3 at project start • 3/3 upon completion",
  validityBlurb: `Pricing valid for ${VALIDITY_DAYS} days from proposal date.`,
  weatherNote: "weather depending*.",
};

const SKIP = new Set(["inc", "llc", "ltd", "co", "corp", "the", "and"]);

/** First letters of the first two significant words: "Quality Deck Inc" → "QD". */
export function brandInitials(name: string): string {
  const parts = name
    .trim()
    .split(/\s+/)
    .filter((word) => !SKIP.has(word.replace(/[.]/g, "").toLowerCase()));
  if (parts.length === 0) return "";
  if (parts.length === 1) return parts[0].slice(0, 2).toUpperCase();
  return `${parts[0][0] ?? ""}${parts[1][0] ?? ""}`.toUpperCase();
}
