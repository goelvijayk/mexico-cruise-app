import type { IngestionConfig } from "./types.js";

export const DEFAULT_CONFIG: Omit<
  IngestionConfig,
  "supabaseUrl" | "supabaseServiceKey" | "geminiApiKey" | "tripId"
> = {
  gmailLabel: "Trip-Mexico",
  processedLabel: "Trip-Mexico/processed",
  alertEmail: "",
  webappSecret: "",
  maxStorageUploadBytes: 50 * 1024 * 1024,
  maxGeminiInlineBytes: 20 * 1024 * 1024,
  maxEmailsPerRun: 5,
  bodyTextMaxBytes: 200 * 1024,
  geminiModel: "gemini-2.0-flash",
};

export function loadConfigFromRecord(
  props: Record<string, string | undefined>
): IngestionConfig {
  const required = ["SUPABASE_URL", "SUPABASE_SERVICE_KEY", "GEMINI_API_KEY", "TRIP_ID"] as const;
  for (const key of required) {
    if (!props[key]?.trim()) {
      throw new Error(`Missing Script Property: ${key}`);
    }
  }
  return {
    supabaseUrl: props.SUPABASE_URL!.replace(/\/$/, ""),
    supabaseServiceKey: props.SUPABASE_SERVICE_KEY!,
    geminiApiKey: props.GEMINI_API_KEY!,
    tripId: props.TRIP_ID!,
    gmailLabel: props.GMAIL_LABEL?.trim() || DEFAULT_CONFIG.gmailLabel,
    processedLabel: props.PROCESSED_LABEL?.trim() || DEFAULT_CONFIG.processedLabel,
    alertEmail: props.ALERT_EMAIL?.trim() || "",
    webappSecret: props.WEBAPP_SECRET?.trim() || "",
    maxStorageUploadBytes: DEFAULT_CONFIG.maxStorageUploadBytes,
    maxGeminiInlineBytes: DEFAULT_CONFIG.maxGeminiInlineBytes,
    maxEmailsPerRun: DEFAULT_CONFIG.maxEmailsPerRun,
    bodyTextMaxBytes: DEFAULT_CONFIG.bodyTextMaxBytes,
    geminiModel: props.GEMINI_MODEL?.trim() || DEFAULT_CONFIG.geminiModel,
  };
}

export function gmailSearchQuery(gmailLabel: string, processedLabel: string): string {
  return `label:${quoteLabel(gmailLabel)} -label:${quoteLabel(processedLabel)} newer_than:60d`;
}

function quoteLabel(label: string): string {
  return label.includes(" ") || label.includes("/") ? `"${label}"` : label;
}
