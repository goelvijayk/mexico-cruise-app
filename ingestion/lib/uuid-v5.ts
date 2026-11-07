/**
 * Deterministic UUID v5 (RFC 4122) for idempotent event ids:
 * uuid_v5(fixed_namespace, `${gmailMessageId}:${index}`)
 */
const NAMESPACE_BYTES = hexToBytes("6ba7b810-9dad-11d1-80b4-00c04fd430c8");

export function eventIdForMessage(gmailMessageId: string, index: number): string {
  return uuidV5(NAMESPACE_BYTES, `${gmailMessageId}:${index}`);
}

export function uuidV5(namespace: Uint8Array, name: string): string {
  const nameBytes = new TextEncoder().encode(name);
  const data = new Uint8Array(namespace.length + nameBytes.length);
  data.set(namespace, 0);
  data.set(nameBytes, namespace.length);
  const hash = sha1(data);
  hash[6] = (hash[6]! & 0x0f) | 0x50;
  hash[8] = (hash[8]! & 0x3f) | 0x80;
  return bytesToUuid(hash);
}

function sha1(data: Uint8Array): Uint8Array {
  // Minimal SHA-1 for UUID v5 (works in GAS V8 and Node tests via bundled copy)
  return sha1Impl(data);
}

/** Portable SHA-1 (small, no deps) */
function sha1Impl(message: Uint8Array): Uint8Array {
  const ml = message.length;
  const withPadding = new Uint8Array(((ml + 8 >> 6) + 1) * 64);
  withPadding.set(message);
  withPadding[ml] = 0x80;
  const view = new DataView(withPadding.buffer);
  view.setUint32(withPadding.length - 4, ml * 8, false);

  let h0 = 0x67452301;
  let h1 = 0xefcdab89;
  let h2 = 0x98badcfe;
  let h3 = 0x10325476;
  let h4 = 0xc3d2e1f0;

  const w = new Uint32Array(80);
  for (let i = 0; i < withPadding.length; i += 64) {
    for (let t = 0; t < 16; t++) {
      w[t] = view.getUint32(i + t * 4, false);
    }
    for (let t = 16; t < 80; t++) {
      w[t] = rotl(w[t - 3]! ^ w[t - 8]! ^ w[t - 14]! ^ w[t - 16]!, 1);
    }
    let a = h0;
    let b = h1;
    let c = h2;
    let d = h3;
    let e = h4;
    for (let t = 0; t < 80; t++) {
      let f: number;
      let k: number;
      if (t < 20) {
        f = (b & c) | (~b & d);
        k = 0x5a827999;
      } else if (t < 40) {
        f = b ^ c ^ d;
        k = 0x6ed9eba1;
      } else if (t < 60) {
        f = (b & c) | (b & d) | (c & d);
        k = 0x8f1bbcdc;
      } else {
        f = b ^ c ^ d;
        k = 0xca62c1d6;
      }
      const temp = (rotl(a, 5) + f + e + k + w[t]!) >>> 0;
      e = d;
      d = c;
      c = rotl(b, 30) >>> 0;
      b = a;
      a = temp;
    }
    h0 = (h0 + a) >>> 0;
    h1 = (h1 + b) >>> 0;
    h2 = (h2 + c) >>> 0;
    h3 = (h3 + d) >>> 0;
    h4 = (h4 + e) >>> 0;
  }
  const out = new Uint8Array(20);
  const dv = new DataView(out.buffer);
  dv.setUint32(0, h0, false);
  dv.setUint32(4, h1, false);
  dv.setUint32(8, h2, false);
  dv.setUint32(12, h3, false);
  dv.setUint32(16, h4, false);
  return out;
}

function rotl(n: number, s: number): number {
  return (n << s) | (n >>> (32 - s));
}

function hexToBytes(uuid: string): Uint8Array {
  const hex = uuid.replace(/-/g, "");
  const out = new Uint8Array(16);
  for (let i = 0; i < 16; i++) {
    out[i] = parseInt(hex.slice(i * 2, i * 2 + 2), 16);
  }
  return out;
}

function bytesToUuid(bytes: Uint8Array): string {
  const hex = [...bytes].map((b) => b.toString(16).padStart(2, "0")).join("");
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20)}`;
}
