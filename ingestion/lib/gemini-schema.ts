import type { EventType, GeminiExtraction } from "./types.js";

const EVENT_TYPE_ENUM: EventType[] = [
  "flight",
  "hotel",
  "cruise_embark",
  "cruise_disembark",
  "port_call",
  "sea_day",
  "excursion",
  "transfer",
  "dining",
  "meetup",
  "other",
];

/** JSON schema for Gemini structured output (responseSchema). */
export const GEMINI_RESPONSE_SCHEMA = {
  type: "object",
  properties: {
    is_travel_related: { type: "boolean" },
    summary: { type: "string" },
    supersedes_booking_refs: {
      type: "array",
      items: { type: "string" },
    },
    events: {
      type: "array",
      items: {
        type: "object",
        properties: {
          type: { type: "string", enum: [...EVENT_TYPE_ENUM] },
          status: { type: "string", enum: ["confirmed", "tentative", "cancelled"] },
          title: { type: "string" },
          start_local: { type: "string" },
          start_tz: { type: "string" },
          end_local: { type: "string", nullable: true },
          end_tz: { type: "string", nullable: true },
          all_day: { type: "boolean" },
          location: { type: "object", nullable: true },
          provider: { type: "string", nullable: true },
          booking_ref: { type: "string", nullable: true },
          details: { type: "object", nullable: true },
          travelers: { type: "array", items: { type: "string" } },
          cost: { type: "object", nullable: true },
          attachment_indexes: { type: "array", items: { type: "integer" } },
          confidence: { type: "number" },
        },
        required: ["type", "title", "start_local", "start_tz", "confidence"],
      },
    },
  },
  required: ["is_travel_related", "summary", "events"],
} as const;

export function buildExtractionPrompt(params: {
  trip: {
    name: string;
    start_date: string;
    end_date: string;
    ship_time_zone: string;
    home_time_zone: string;
  };
  emailSubject: string;
  emailBody: string;
  attachmentNames: string[];
  reparseNote?: string;
  revisionBlock?: string;
}): string {
  const lines = [
    "You extract structured cruise-trip itinerary events from booking emails.",
    `Trip: ${params.trip.name} (${params.trip.start_date} to ${params.trip.end_date}).`,
    `Ship time zone: ${params.trip.ship_time_zone}. Home time zone: ${params.trip.home_time_zone}.`,
    "Times are local to where the event happens; if the email says ship time, use ship_time_zone.",
    "Never invent booking references — use null if absent.",
    "Put every concrete fact into details; do not summarize away numbers, refs, or times.",
    "Set is_travel_related=false for marketing/newsletters with no actionable booking.",
    "start_local/end_local format: YYYY-MM-DDTHH:mm:ss (no offset). start_tz/end_tz: IANA names from the allowed list in schema.",
    "attachment_indexes refers to 0-based indexes in the attachment list provided.",
    "",
    `Subject: ${params.emailSubject}`,
    `Attachments: ${params.attachmentNames.length ? params.attachmentNames.join(", ") : "(none)"}`,
  ];
  if (params.reparseNote) {
    lines.push("", `Re-parse note from traveler: ${params.reparseNote}`);
  }
  if (params.revisionBlock) {
    lines.push("", params.revisionBlock);
  }
  lines.push("", "--- EMAIL BODY ---", params.emailBody);
  return lines.join("\n");
}

export function parseGeminiJson(text: string): GeminiExtraction {
  const trimmed = text.trim();
  const jsonStr = trimmed.startsWith("{") ? trimmed : extractJsonBlock(trimmed);
  return JSON.parse(jsonStr) as GeminiExtraction;
}

function extractJsonBlock(text: string): string {
  const start = text.indexOf("{");
  const end = text.lastIndexOf("}");
  if (start === -1 || end === -1) throw new Error("No JSON object in Gemini response");
  return text.slice(start, end + 1);
}
