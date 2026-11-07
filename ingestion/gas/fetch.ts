export type GasFetchFn = (
  url: string,
  options: GoogleAppsScript.URL_Fetch.URLFetchRequestOptions
) => GoogleAppsScript.URL_Fetch.HTTPResponse;

export function urlFetchAdapter(): GasFetchFn {
  return (url, options) => UrlFetchApp.fetch(url, options);
}

export function toLibFetch(gasFetch: GasFetchFn) {
  return (
    url: string,
    options: {
      method: "get" | "post" | "patch" | "put" | "delete";
      headers?: Record<string, string>;
      payload?: string;
      contentType?: string;
      muteHttpExceptions?: boolean;
    }
  ) => {
    const resp = gasFetch(url, {
      method: options.method as GoogleAppsScript.URL_Fetch.HttpMethod,
      headers: options.headers,
      payload: options.payload,
      contentType: options.contentType,
      muteHttpExceptions: options.muteHttpExceptions ?? true,
    });
    return {
      getResponseCode: () => resp.getResponseCode(),
      getContentText: () => resp.getContentText(),
    };
  };
}

export function toGeminiFetch(gasFetch: GasFetchFn) {
  return (
    url: string,
    options: { method: string; headers: Record<string, string>; payload?: string; muteHttpExceptions?: boolean }
  ) => {
    const resp = gasFetch(url, {
      method: options.method as GoogleAppsScript.URL_Fetch.HttpMethod,
      headers: options.headers,
      payload: options.payload,
      muteHttpExceptions: options.muteHttpExceptions ?? true,
    });
    return {
      getResponseCode: () => resp.getResponseCode(),
      getContentText: () => resp.getContentText(),
    };
  };
}

export function sha256HexGas(bytes: Uint8Array): string {
  const digest = Utilities.computeDigest(Utilities.DigestAlgorithm.SHA_256, bytes as unknown as number[]);
  return digest.map((b) => ((b + 256) % 256).toString(16).padStart(2, "0")).join("");
}

export function sleepGas(ms: number): void {
  Utilities.sleep(ms);
}
