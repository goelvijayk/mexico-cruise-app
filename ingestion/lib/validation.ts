import { EVENT_TYPES, type EventStatus, type GeminiEvent, type GeminiExtraction } from "./types.js";
import { isValidIanaZone } from "./iana-zones.js";

const LOCAL_TS = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}$/;

export function validateLocalTimestamp(value: string): boolean {
  return LOCAL_TS.test(value);
}

export function validateGeminiEvent(ev: GeminiEvent, index: number): string | null {
  if (!EVENT_TYPES.includes(ev.type)) {
    return `events[${index}].type invalid`;
  }
  if (!ev.title?.trim()) {
    return `events[${index}].title required`;
  }
  if (!validateLocalTimestamp(ev.start_local)) {
    return `events[${index}].start_local must be YYYY-MM-DDTHH:mm:ss`;
  }
  if (!isValidIanaZone(ev.start_tz)) {
    return `events[${index}].start_tz not in bundled IANA list`;
  }
  if (ev.end_local != null && ev.end_local !== "" && !validateLocalTimestamp(ev.end_local)) {
    return `events[${index}].end_local invalid`;
  }
  if (ev.end_tz && !isValidIanaZone(ev.end_tz)) {
    return `events[${index}].end_tz not in bundled IANA list`;
  }
  if (typeof ev.confidence !== "number" || ev.confidence < 0 || ev.confidence > 1) {
    return `events[${index}].confidence must be 0..1`;
  }
  if (ev.status && !["confirmed", "tentative", "cancelled"].includes(ev.status)) {
    return `events[${index}].status invalid`;
  }
  return null;
}

export function validateExtraction(data: GeminiExtraction): string | null {
  if (typeof data.is_travel_related !== "boolean") {
    return "is_travel_related must be boolean";
  }
  if (typeof data.summary !== "string") {
    return "summary must be string";
  }
  if (!Array.isArray(data.events)) {
    return "events must be array";
  }
  for (let i = 0; i < data.events.length; i++) {
    const err = validateGeminiEvent(data.events[i]!, i);
    if (err) return err;
  }
  return null;
}

export function normalizeEventStatus(status?: EventStatus): EventStatus {
  return status ?? "confirmed";
}

export function truncateUtf8(text: string, maxBytes: number): string {
  const enc = new TextEncoder();
  const bytes = enc.encode(text);
  if (bytes.length <= maxBytes) return text;
  let end = maxBytes;
  while (end > 0 && (bytes[end - 1]! & 0xc0) === 0x80) end--;
  return new TextDecoder().decode(bytes.slice(0, end));
}

export function storagePathFor(tripId: string, sha256: string, fileName: string): string {
  const ext = fileName.includes(".") ? fileName.split(".").pop()!.toLowerCase() : "bin";
  return `${tripId}/${sha256}.${ext}`;
}

export const UPLOADABLE_MIME_PREFIXES = [
  "application/pdf",
  "image/",
  "application/vnd.apple.pkpass",
  "text/calendar",
];

export function isUploadableMime(mime: string): boolean {
  const m = mime.toLowerCase();
  return UPLOADABLE_MIME_PREFIXES.some((p) => (p.endsWith("/") ? m.startsWith(p) : m === p));
}
