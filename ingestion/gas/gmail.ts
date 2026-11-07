import type { EmailAttachmentMeta, GmailClient, ParsedEmail } from "../lib/types.js";
import { truncateUtf8 } from "../lib/validation.js";

export function createGmailClient(bodyMaxBytes: number): GmailClient {
  return {
    async searchUnprocessed(query, maxResults) {
      const threads = GmailApp.search(query, 0, maxResults);
      const emails: ParsedEmail[] = [];
      for (const thread of threads) {
        for (const message of thread.getMessages()) {
          emails.push(parseMessage(message, bodyMaxBytes));
          if (emails.length >= maxResults) return emails;
        }
      }
      return emails;
    },

    markProcessed(messageId, processedLabel) {
      const msg = GmailApp.getMessageById(messageId);
      if (!msg) return;
      let label = GmailApp.getUserLabelByName(processedLabel);
      if (!label) {
        label = GmailApp.createLabel(processedLabel);
      }
      msg.addLabel(label);
    },

    async getMessageById(messageId) {
      const msg = GmailApp.getMessageById(messageId);
      if (!msg) return null;
      return parseMessage(msg, bodyMaxBytes);
    },
  };
}

function parseMessage(message: GoogleAppsScript.Gmail.GmailMessage, bodyMaxBytes: number): ParsedEmail {
  const id = message.getId();
  const attachments: EmailAttachmentMeta[] = [];
  const attList = message.getAttachments({ includeInlineImages: false, includeAttachments: true });
  for (let i = 0; i < attList.length; i++) {
    const att = attList[i]!;
    const bytes = new Uint8Array(att.getBytes());
    attachments.push({
      name: att.getName(),
      mimeType: att.getContentType(),
      sizeBytes: bytes.length,
      gmailAttachmentId: `${id}:${i}`,
      bytes,
    });
  }

  const plain = message.getPlainBody() || htmlToText(message.getBody());
  return {
    gmailMessageId: id,
    threadId: message.getThread().getId(),
    fromAddr: message.getFrom(),
    subject: message.getSubject(),
    receivedAt: message.getDate().toISOString(),
    snippet: message.getSubject().slice(0, 120),
    bodyText: truncateUtf8(plain, bodyMaxBytes),
    gmailLink: `https://mail.google.com/mail/u/0/#inbox/${id}`,
    attachments,
  };
}

function htmlToText(html: string): string {
  return html
    .replace(/<style[\s\S]*?<\/style>/gi, "")
    .replace(/<script[\s\S]*?<\/script>/gi, "")
    .replace(/<[^>]+>/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

export function ensureGmailLabels(gmailLabel: string, processedLabel: string): void {
  for (const name of [gmailLabel, processedLabel]) {
    if (!GmailApp.getUserLabelByName(name)) {
      GmailApp.createLabel(name);
    }
  }
}
