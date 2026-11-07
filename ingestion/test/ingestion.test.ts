import { createHash } from "node:crypto";
import { readFileSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { describe, expect, it, vi } from "vitest";
import { loadConfigFromRecord } from "../lib/config.js";
import { createLogger } from "../lib/logger.js";
import { processOneEmail } from "../lib/process-email.js";
import { applyRevisionRequest } from "../lib/revision.js";
import { eventIdForMessage } from "../lib/uuid-v5.js";
import type {
  EmailAttachmentMeta,
  GeminiExtraction,
  IngestedEmailRow,
  ParsedEmail,
  RevisionRequestRow,
  RuntimeDeps,
  StoredEvent,
  TripContext,
} from "../lib/types.js";

const __dirname = dirname(fileURLToPath(import.meta.url));
const fixturesDir = join(__dirname, "fixtures");

function loadFixture(name: string): ParsedEmail {
  const raw = JSON.parse(readFileSync(join(fixturesDir, `${name}.json`), "utf8")) as ParsedEmail & {
    gemini?: GeminiExtraction;
    attachments: Array<
      EmailAttachmentMeta & { bytes?: string | Uint8Array }
    >;
  };
  return {
    ...raw,
    attachments: raw.attachments.map((a) => ({
      ...a,
      bytes:
        typeof a.bytes === "string"
          ? Uint8Array.from(Buffer.from(a.bytes, "base64"))
          : a.bytes,
    })),
  };
}

function sha256(bytes: Uint8Array): string {
  return createHash("sha256").update(bytes).digest("hex");
}

const trip: TripContext = {
  id: "mex-2026-12",
  name: "Mexico Cruise 2026",
  start_date: "2026-12-01",
  end_date: "2026-12-15",
  ship_time_zone: "America/Los_Angeles",
  home_time_zone: "America/Chicago",
};

function makeDeps(overrides?: {
  gemini?: GeminiExtraction;
  ingested?: Map<string, IngestedEmailRow>;
  events?: Map<string, StoredEvent>;
}): RuntimeDeps {
  const ingested = overrides?.ingested ?? new Map<string, IngestedEmailRow>();
  const events = overrides?.events ?? new Map<string, StoredEvent>();
  const storage = new Map<string, Uint8Array>();
  const attachments: import("../lib/types.js").StoredAttachment[] = [];

  const config = loadConfigFromRecord({
    SUPABASE_URL: "https://example.supabase.co",
    SUPABASE_SERVICE_KEY: "service-role-test",
    GEMINI_API_KEY: "test-gemini",
    TRIP_ID: trip.id,
  });

  const log = createLogger();

  const supabase: RuntimeDeps["supabase"] = {
    nowIso: () => new Date("2026-11-03T12:00:00.000Z").toISOString(),
    getTrip: async () => trip,
    getIngestedEmail: async (id: string) => ingested.get(id) ?? null,
    upsertIngestedEmail: async (row) => {
      const prev = ingested.get(row.gmail_message_id!) ?? ({} as IngestedEmailRow);
      ingested.set(row.gmail_message_id!, { ...prev, ...row } as IngestedEmailRow);
    },
    listReparseRequested: async () => [],
    listOpenRevisionRequests: async () => [],
    getEvent: async (id: string) => events.get(id) ?? null,
    getEventsByBookingRefs: async () => [],
    applyEventChanges: async (rows) => {
      for (const row of rows) {
        events.set(row.id as string, row as unknown as StoredEvent);
      }
      return { accepted: rows.map((r) => r.id as string), rejected: [] };
    },
    patchEvent: async (id, patch) => {
      const prev = events.get(id);
      if (prev) events.set(id, { ...prev, ...patch } as StoredEvent);
    },
    upsertAttachment: async (row) => {
      attachments.push(row as unknown as import("../lib/types.js").StoredAttachment);
    },
    getAttachmentBySha256: async (_tripId, hash) =>
      attachments.find((a) => a.sha256 === hash) ?? null,
    patchAttachment: async (id, patch) => {
      const idx = attachments.findIndex((a) => a.id === id);
      if (idx >= 0) attachments[idx] = { ...attachments[idx]!, ...patch } as import("../lib/types.js").StoredAttachment;
    },
    patchRevisionRequest: async () => {},
    uploadStorageObject: async (path, bytes) => {
      storage.set(path, bytes);
    },
  };

  const gemini = {
    extractFromEmail: async () =>
      overrides?.gemini ?? {
        is_travel_related: false,
        summary: "mock",
        events: [],
      },
  };

  return {
    config,
    log,
    supabase,
    gemini,
    gmail: {
      searchUnprocessed: async () => [],
      markProcessed: () => {},
      getMessageById: async () => null,
    },
    sha256,
    tryAcquireLock: () => ({ release: () => {} }),
    sendAlert: () => {},
  };
}

describe("processOneEmail", () => {
  it("parses airline fixture into deterministic event id", async () => {
    const email = loadFixture("airline-delta");
    const extraction: GeminiExtraction = {
      is_travel_related: true,
      summary: "Delta flight",
      events: [
        {
          type: "flight",
          title: "Delta 1234",
          start_local: "2026-12-01T06:15:00",
          start_tz: "America/Chicago",
          end_local: "2026-12-01T09:05:00",
          end_tz: "America/Los_Angeles",
          confidence: 0.92,
          booking_ref: "ABCDEF",
          attachment_indexes: [0],
        },
      ],
    };
    const deps = makeDeps({ gemini: extraction });
    const result = await processOneEmail(deps, trip, email);
    expect(result.status).toBe("parsed");
    expect(result.eventIds[0]).toBe(eventIdForMessage(email.gmailMessageId, 0));
    const ev = await deps.supabase.getEvent(result.eventIds[0]!);
    expect(ev?.type).toBe("flight");
    expect(ev?.booking_ref).toBe("ABCDEF");
  });

  it("marks marketing junk as ignored", async () => {
    const email = loadFixture("junk-newsletter");
    const deps = makeDeps({
      gemini: { is_travel_related: false, summary: "marketing", events: [] },
    });
    const result = await processOneEmail(deps, trip, email);
    expect(result.status).toBe("ignored");
  });

  it("records failed row when no events extracted", async () => {
    const email = loadFixture("hotel-marriott");
    const deps = makeDeps({
      gemini: { is_travel_related: true, summary: "empty", events: [] },
    });
    const result = await processOneEmail(deps, trip, email);
    expect(result.status).toBe("failed");
    expect(result.failureReason).toBe("no events found");
  });

  it("skips storage upload over 50MB but still parses body", async () => {
    const email = loadFixture("large-pdf");
    const deps = makeDeps({
      gemini: {
        is_travel_related: true,
        summary: "cruise",
        events: [
          {
            type: "cruise_embark",
            title: "Embarkation",
            start_local: "2026-12-05T13:00:00",
            start_tz: "America/Los_Angeles",
            confidence: 0.8,
          },
        ],
      },
    });
    const uploadSpy = vi.spyOn(deps.supabase, "uploadStorageObject");
    const result = await processOneEmail(deps, trip, email);
    expect(result.status).toBe("parsed");
    expect(email.attachments[0]!.sizeBytes).toBeGreaterThan(deps.config.maxStorageUploadBytes);
    expect(uploadSpy).not.toHaveBeenCalled();
  });
});

describe("applyRevisionRequest", () => {
  it("does not overwrite human-edited fields", async () => {
    const email = loadFixture("airline-delta");
    const eventId = eventIdForMessage(email.gmailMessageId, 0);
    const existing: StoredEvent = {
      id: eventId,
      trip_id: trip.id,
      type: "flight",
      status: "confirmed",
      title: "Delta 1234",
      start_local: "2026-12-01T06:15:00",
      start_tz: "America/Chicago",
      end_local: "2026-12-01T09:05:00",
      end_tz: "America/Los_Angeles",
      all_day: false,
      location: null,
      provider: "Delta",
      booking_ref: "ABCDEF",
      details: null,
      travelers: [],
      cost: null,
      notes: "Fix: gate changed manually",
      source: { kind: "email", gmail_message_id: email.gmailMessageId, event_index: 0 },
      review_state: "flagged",
      edited_fields: ["start_local", "start_tz"],
      created_by: "ingestion",
      updated_by: "Mom's Pixel",
      updated_at: "2026-11-01T00:00:00Z",
      deleted_at: null,
    };
    const events = new Map([[eventId, existing]]);
    const revision: RevisionRequestRow = {
      id: "rev-1",
      event_id: eventId,
      note: "Departure is 7:15 not 6:15",
      requested_by: "Dad's Pixel",
      requested_at: "2026-11-02T00:00:00Z",
      status: "open",
      result_note: null,
      diff: null,
      applied_at: null,
      updated_at: "2026-11-02T00:00:00Z",
    };

    let patched: Record<string, unknown> | null = null;
    const deps = makeDeps({
      events,
      gemini: {
        is_travel_related: true,
        summary: "corrected",
        events: [
          {
            type: "flight",
            title: "Delta 1234 NEW",
            start_local: "2026-12-01T07:15:00",
            start_tz: "America/Chicago",
            confidence: 0.95,
          },
        ],
      },
    });
    deps.gmail.getMessageById = async () => email;
    deps.supabase.patchEvent = async (id, patch) => {
      patched = patch;
      const prev = events.get(id)!;
      events.set(id, { ...prev, ...patch } as StoredEvent);
    };
    deps.supabase.patchRevisionRequest = async (_id, patch) => {
      expect(patch.status).toBe("applied");
    };

    await applyRevisionRequest(deps, revision, trip);
    expect(patched).not.toBeNull();
    expect(patched!.title).toBe("Delta 1234 NEW");
    expect(patched!.start_local).toBeUndefined();
    expect(events.get(eventId)?.start_local).toBe("2026-12-01T06:15:00");
  });
});

describe("validation harness", () => {
  it("loads all fixture files", () => {
    const names = [
      "airline-delta",
      "hotel-marriott",
      "cruise-carnival",
      "excursion-shore",
      "transfer-shuttle",
      "junk-newsletter",
      "large-pdf",
      "reparse-note",
    ];
    for (const n of names) {
      const f = loadFixture(n);
      expect(f.gmailMessageId).toBeTruthy();
      expect(f.bodyText.length).toBeGreaterThan(10);
    }
  });
});
