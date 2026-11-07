import type { LogEntry, Logger } from "./types.js";

export function createLogger(sink?: (entry: LogEntry) => void): Logger {
  const buffer: LogEntry[] = [];

  const write = (level: LogEntry["level"], message: string, context?: Record<string, unknown>) => {
    const entry: LogEntry = {
      level,
      message,
      context,
      ts: new Date().toISOString(),
    };
    buffer.push(entry);
    sink?.(entry);
  };

  return {
    info: (m, c) => write("info", m, c),
    warn: (m, c) => write("warn", m, c),
    error: (m, c) => write("error", m, c),
    flush: () => [...buffer],
  };
}

export function formatLogLine(entry: LogEntry): string {
  const ctx = entry.context ? ` ${JSON.stringify(entry.context)}` : "";
  return `[${entry.ts}] ${entry.level.toUpperCase()} ${entry.message}${ctx}`;
}
