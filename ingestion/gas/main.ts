import { loadConfigFromRecord } from "../lib/config.js";
import { createLogger, formatLogLine } from "../lib/logger.js";
import { createGeminiClient } from "../lib/gemini-client.js";
import { createSupabaseClient, verifySupabaseReachable } from "../lib/supabase-client.js";
import { runPipeline } from "../lib/run-pipeline.js";
import type { RuntimeDeps } from "../lib/types.js";
import { createGmailClient, ensureGmailLabels } from "./gmail.js";
import { sha256HexGas, toGeminiFetch, toLibFetch, urlFetchAdapter } from "./fetch.js";

const SCRIPT_PROP_LAST_ALERT = "LAST_ALERT_EPOCH_MS";

function buildDeps(): RuntimeDeps {
  const props = PropertiesService.getScriptProperties().getProperties();
  const config = loadConfigFromRecord(props);
  const log = createLogger((entry) => console.log(formatLogLine(entry)));
  const gasFetch = urlFetchAdapter();
  const supabase = createSupabaseClient(config, log, toLibFetch(gasFetch));
  const gemini = createGeminiClient(config, log, toGeminiFetch(gasFetch));
  const gmail = createGmailClient(config.bodyTextMaxBytes);

  return {
    config,
    log,
    supabase,
    gemini,
    gmail,
    sha256: sha256HexGas,
    tryAcquireLock(name, waitMs) {
      const lock = LockService.getScriptLock();
      if (!lock.tryLock(waitMs)) return null;
      return { release: () => lock.releaseLock() };
    },
    sendAlert(subject, body) {
      if (config.alertEmail) {
        MailApp.sendEmail(config.alertEmail, subject, body);
      }
    },
    lastAlertAt() {
      const v = PropertiesService.getScriptProperties().getProperty(SCRIPT_PROP_LAST_ALERT);
      return v ? parseInt(v, 10) : null;
    },
    setLastAlertAt(ms) {
      PropertiesService.getScriptProperties().setProperty(SCRIPT_PROP_LAST_ALERT, String(ms));
    },
  };
}

export async function run(): Promise<void> {
  const deps = buildDeps();
  await runPipeline(deps);
}

export function setup(): string {
  const deps = buildDeps();
  ensureGmailLabels(deps.config.gmailLabel, deps.config.processedLabel);
  const reachable = verifySupabaseReachable(deps.config, toLibFetch(urlFetchAdapter()));
  const lines = [
    `Labels: ${deps.config.gmailLabel}, ${deps.config.processedLabel}`,
    `Supabase: ${reachable ? "OK" : "FAILED — check URL, service key, and trip row"}`,
  ];
  lines.forEach((l) => deps.log.info(l));
  return lines.join("\n");
}

export function installTrigger(): string {
  for (const t of ScriptApp.getProjectTriggers()) {
    if (t.getHandlerFunction() === "run") {
      ScriptApp.deleteTrigger(t);
    }
  }
  ScriptApp.newTrigger("run").timeBased().everyMinutes(10).create();
  return "Installed 10-minute trigger for run()";
}

export function removeTrigger(): string {
  for (const t of ScriptApp.getProjectTriggers()) {
    if (t.getHandlerFunction() === "run") {
      ScriptApp.deleteTrigger(t);
    }
  }
  return "Removed run() triggers";
}

export function doGet(e: GoogleAppsScript.Events.DoGet): GoogleAppsScript.Content.TextOutput {
  const deps = buildDeps();
  const key = e?.parameter?.key ?? "";
  if (deps.config.webappSecret && key !== deps.config.webappSecret) {
    return ContentService.createTextOutput("Unauthorized").setMimeType(ContentService.MimeType.TEXT);
  }
  run()
    .then(() => deps.log.info("doGet run complete"))
    .catch((err) => deps.log.error("doGet run failed", { error: String(err) }));
  return ContentService.createTextOutput("ok").setMimeType(ContentService.MimeType.TEXT);
}
