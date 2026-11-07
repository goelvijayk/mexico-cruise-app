import { gmailSearchQuery } from "./config.js";
import { applyRevisionRequest } from "./revision.js";
import { processOneEmail } from "./process-email.js";
import type { RuntimeDeps } from "./types.js";

const ALERT_COOLDOWN_MS = 60 * 60 * 1000;

export async function runPipeline(deps: RuntimeDeps): Promise<void> {
  const lock = deps.tryAcquireLock("ingestion-run", 30_000);
  if (!lock) {
    deps.log.warn("Could not acquire script lock; skipping run");
    return;
  }

  try {
    await runPipelineUnlocked(deps);
  } catch (e) {
    deps.log.error("Uncaught pipeline error", { error: String(e) });
    maybeSendAlert(deps, "Mexico Cruise ingestion error", String(e));
    throw e;
  } finally {
    lock.release();
  }
}

async function runPipelineUnlocked(deps: RuntimeDeps): Promise<void> {
  const { config, log, supabase, gmail } = deps;
  const trip = await supabase.getTrip(config.tripId);
  if (!trip) {
    throw new Error(`Trip not found: ${config.tripId}`);
  }

  const query = gmailSearchQuery(config.gmailLabel, config.processedLabel);
  const candidates = await gmail.searchUnprocessed(query, config.maxEmailsPerRun);
  log.info("Gmail candidates", { count: candidates.length });

  for (const email of candidates) {
    try {
      const existing = await supabase.getIngestedEmail(email.gmailMessageId);
      if (existing && existing.status !== "failed") {
        log.info("Skip already ingested", { id: email.gmailMessageId, status: existing.status });
        gmail.markProcessed(email.gmailMessageId, config.processedLabel);
        continue;
      }
      await processOneEmail(deps, trip, email);
    } catch (e) {
      log.error("Email processing error", {
        gmailMessageId: email.gmailMessageId,
        error: String(e),
      });
    } finally {
      gmail.markProcessed(email.gmailMessageId, config.processedLabel);
    }
  }

  const revisions = await supabase.listOpenRevisionRequests();
  for (const req of revisions) {
    try {
      await applyRevisionRequest(deps, req, trip);
    } catch (e) {
      log.error("Revision failed", { id: req.id, error: String(e) });
    }
  }

  const reparseRows = await supabase.listReparseRequested();
  for (const row of reparseRows.slice(0, config.maxEmailsPerRun)) {
    const email = await gmail.getMessageById(row.gmail_message_id);
    if (!email) {
      await supabase.upsertIngestedEmail({
        gmail_message_id: row.gmail_message_id,
        trip_id: config.tripId,
        status: "failed",
        failure_reason: "Gmail message missing for reparse",
        reparse_requested: false,
        updated_at: supabase.nowIso(),
      });
      continue;
    }
    await processOneEmail(deps, trip, email, { reparseNote: row.reparse_note ?? undefined });
    gmail.markProcessed(email.gmailMessageId, config.processedLabel);
  }

  log.info("Run complete", { emails: candidates.length, revisions: revisions.length });
}

function maybeSendAlert(deps: RuntimeDeps, subject: string, body: string): void {
  if (!deps.config.alertEmail) return;
  const last = deps.lastAlertAt?.() ?? null;
  const now = Date.now();
  if (last != null && now - last < ALERT_COOLDOWN_MS) return;
  deps.sendAlert(subject, body);
  deps.setLastAlertAt?.(now);
}
