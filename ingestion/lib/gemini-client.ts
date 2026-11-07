import type { GeminiClient, GeminiExtraction, IngestionConfig, Logger, StoredEvent } from "./types.js";
import { buildExtractionPrompt, GEMINI_RESPONSE_SCHEMA, parseGeminiJson } from "./gemini-schema.js";

export type FetchFn = (
  url: string,
  options: { method: string; headers: Record<string, string>; payload?: string; muteHttpExceptions?: boolean }
) => { getResponseCode(): number; getContentText(): string };

const MAX_RETRIES = 3;

export function createGeminiClient(config: IngestionConfig, log: Logger, fetchFn: FetchFn): GeminiClient {
  return {
    async extractFromEmail(input) {
      const attachmentNames = input.attachmentParts.map((p) => p.fileName);
      let revisionBlock: string | undefined;
      if (input.revisionContext) {
        revisionBlock = [
          `A traveler says this extraction is wrong: «${input.revisionContext.note}».`,
          `Current stored event JSON: ${JSON.stringify(stripEventForPrompt(input.revisionContext.currentEvent))}.`,
          "Return the corrected event(s) only in the events array (same schema).",
        ].join("\n");
      }

      const prompt = buildExtractionPrompt({
        trip: input.trip,
        emailSubject: input.email.subject,
        emailBody: input.email.bodyText,
        attachmentNames,
        reparseNote: input.reparseNote,
        revisionBlock,
      });

      const parts: Record<string, unknown>[] = [{ text: prompt }];
      for (const att of input.attachmentParts) {
        parts.push({
          inlineData: {
            mimeType: att.mimeType,
            data: att.base64,
          },
        });
      }

      const body = {
        contents: [{ role: "user", parts }],
        generationConfig: {
          responseMimeType: "application/json",
          responseSchema: GEMINI_RESPONSE_SCHEMA,
          temperature: 0.2,
        },
      };

      const url = `https://generativelanguage.googleapis.com/v1beta/models/${config.geminiModel}:generateContent?key=${encodeURIComponent(config.geminiApiKey)}`;

      let lastErr = "unknown";
      for (let attempt = 0; attempt < MAX_RETRIES; attempt++) {
        if (attempt > 0) {
          const backoffMs = 500 * 2 ** attempt;
          log.warn("Gemini retry", { attempt, backoffMs });
          await sleep(backoffMs);
        }
        const resp = fetchFn(url, {
          method: "post",
          headers: { "Content-Type": "application/json" },
          payload: JSON.stringify(body),
          muteHttpExceptions: true,
        });
        const code = resp.getResponseCode();
        const text = resp.getContentText();
        if (code >= 200 && code < 300) {
          try {
            const parsed = JSON.parse(text) as {
              candidates?: { content?: { parts?: { text?: string }[] } }[];
            };
            const outText = parsed.candidates?.[0]?.content?.parts?.[0]?.text;
            if (!outText) throw new Error("Empty Gemini candidate");
            return parseGeminiJson(outText);
          } catch (e) {
            lastErr = e instanceof Error ? e.message : String(e);
            log.warn("Gemini parse failed", { lastErr });
            continue;
          }
        }
        lastErr = `HTTP ${code}: ${text.slice(0, 300)}`;
        if (code !== 429 && code < 500) {
          break;
        }
      }
      throw new Error(`Gemini failed after retries: ${lastErr}`);
    },
  };
}

function stripEventForPrompt(ev: StoredEvent): Record<string, unknown> {
  const { edited_fields: _e, notes: _n, ...rest } = ev;
  return rest;
}

function sleep(ms: number): Promise<void> {
  return new Promise((r) => setTimeout(r, ms));
}

/** Fallback extraction when Gemini unavailable (tests / emergency) */
export function fallbackExtraction(): GeminiExtraction {
  return {
    is_travel_related: false,
    summary: "fallback",
    events: [],
  };
}

export type { GeminiExtraction };
