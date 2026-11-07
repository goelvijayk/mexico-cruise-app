import type { IngestionConfig, Logger, SupabaseClient } from "./types.js";

export type FetchFn = (
  url: string,
  options: {
    method: "get" | "post" | "patch" | "put" | "delete";
    headers?: Record<string, string>;
    payload?: string;
    contentType?: string;
    muteHttpExceptions?: boolean;
  }
) => { getResponseCode(): number; getContentText(): string; getHeaders?(): Record<string, string> };

export function createSupabaseClient(
  config: IngestionConfig,
  log: Logger,
  fetchFn: FetchFn
): SupabaseClient {
  const base = `${config.supabaseUrl}/rest/v1`;
  const storageBase = `${config.supabaseUrl}/storage/v1`;
  const headers = (): Record<string, string> => ({
    apikey: config.supabaseServiceKey,
    Authorization: `Bearer ${config.supabaseServiceKey}`,
    "Content-Type": "application/json",
  });

  async function rest<T>(
    path: string,
    method: "get" | "post" | "patch" | "delete",
    opts?: { query?: string; body?: unknown; prefer?: string }
  ): Promise<T> {
    const url = `${base}${path}${opts?.query ?? ""}`;
    const h = headers();
    if (opts?.prefer) h.Prefer = opts.prefer;
    const resp = fetchFn(url, {
      method,
      headers: h,
      payload: opts?.body !== undefined ? JSON.stringify(opts.body) : undefined,
      muteHttpExceptions: true,
    });
    const code = resp.getResponseCode();
    const text = resp.getContentText();
    if (code >= 200 && code < 300) {
      return text ? (JSON.parse(text) as T) : (null as T);
    }
    log.error("PostgREST error", { path, code, text: text.slice(0, 500) });
    throw new Error(`PostgREST ${method} ${path}: ${code}`);
  }

  return {
    nowIso: () => new Date().toISOString(),

    async getTrip(tripId) {
      const rows = await rest<{ id: string; name: string; start_date: string; end_date: string; ship_time_zone: string; home_time_zone: string }[]>(
        "/trip",
        "get",
        { query: `?id=eq.${encodeURIComponent(tripId)}&select=*` }
      );
      return rows[0] ?? null;
    },

    async getIngestedEmail(gmailMessageId) {
      const rows = await rest<import("./types.js").IngestedEmailRow[]>(
        "/ingested_emails",
        "get",
        { query: `?gmail_message_id=eq.${encodeURIComponent(gmailMessageId)}&select=*` }
      );
      return rows[0] ?? null;
    },

    async upsertIngestedEmail(row) {
      await rest("/ingested_emails", "post", {
        body: row,
        prefer: "resolution=merge-duplicates",
        query: "",
      });
    },

    async listReparseRequested() {
      return rest<import("./types.js").IngestedEmailRow[]>("/ingested_emails", "get", {
        query: "?reparse_requested=eq.true&select=*",
      });
    },

    async listOpenRevisionRequests() {
      return rest<import("./types.js").RevisionRequestRow[]>("/revision_requests", "get", {
        query: "?status=eq.open&select=*",
      });
    },

    async getEvent(id) {
      const rows = await rest<import("./types.js").StoredEvent[]>("/events", "get", {
        query: `?id=eq.${encodeURIComponent(id)}&select=*`,
      });
      return rows[0] ?? null;
    },

    async getEventsByBookingRefs(refs) {
      if (!refs.length) return [];
      const inList = refs.map((r) => encodeURIComponent(r)).join(",");
      return rest<import("./types.js").StoredEvent[]>("/events", "get", {
        query: `?booking_ref=in.(${inList})&deleted_at=is.null&select=*`,
      });
    },

    async applyEventChanges(rows) {
      const result = await rest<{ accepted?: string[]; rejected?: string[] }>("/rpc/apply_changes", "post", {
        body: { tbl: "events", rows },
      });
      return {
        accepted: result.accepted ?? [],
        rejected: result.rejected ?? [],
      };
    },

    async patchEvent(id, patch) {
      await rest(`/events?id=eq.${encodeURIComponent(id)}`, "patch", { body: patch });
    },

    async upsertAttachment(row) {
      await rest("/attachments", "post", {
        body: row,
        prefer: "resolution=merge-duplicates",
      });
    },

    async getAttachmentBySha256(tripId, sha256) {
      const rows = await rest<import("./types.js").StoredAttachment[]>("/attachments", "get", {
        query: `?trip_id=eq.${encodeURIComponent(tripId)}&sha256=eq.${encodeURIComponent(sha256)}&deleted_at=is.null&select=*`,
      });
      return rows[0] ?? null;
    },

    async patchAttachment(id, patch) {
      await rest(`/attachments?id=eq.${encodeURIComponent(id)}`, "patch", { body: patch });
    },

    async patchRevisionRequest(id, patch) {
      await rest(`/revision_requests?id=eq.${encodeURIComponent(id)}`, "patch", { body: patch });
    },

    async uploadStorageObject(storagePath, bytes, mimeType) {
      const bucket = "trip-docs";
      const url = `${storageBase}/object/${bucket}/${storagePath}`;
      const resp = fetchFn(url, {
        method: "post",
        headers: {
          apikey: config.supabaseServiceKey,
          Authorization: `Bearer ${config.supabaseServiceKey}`,
          "Content-Type": mimeType,
          "x-upsert": "true",
        },
        payload: uint8ToBinaryString(bytes),
        contentType: mimeType,
        muteHttpExceptions: true,
      });
      const code = resp.getResponseCode();
      if (code >= 200 && code < 300) return;
      throw new Error(`Storage upload failed: ${code} ${resp.getContentText().slice(0, 200)}`);
    },
  };
}

function uint8ToBinaryString(bytes: Uint8Array): string {
  let s = "";
  const chunk = 8192;
  for (let i = 0; i < bytes.length; i += chunk) {
    s += String.fromCharCode(...bytes.subarray(i, i + chunk));
  }
  return s;
}

/** Health check for setup() */
export async function verifySupabaseReachable(
  config: IngestionConfig,
  fetchFn: FetchFn
): Promise<boolean> {
  const url = `${config.supabaseUrl}/rest/v1/trip?id=eq.${encodeURIComponent(config.tripId)}&select=id`;
  const resp = fetchFn(url, {
    method: "get",
    headers: {
      apikey: config.supabaseServiceKey,
      Authorization: `Bearer ${config.supabaseServiceKey}`,
    },
    muteHttpExceptions: true,
  });
  return resp.getResponseCode() >= 200 && resp.getResponseCode() < 300;
}
