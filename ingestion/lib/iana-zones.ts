/** Subset + common Mexico/US cruise zones; extend as needed. */
export const IANA_TIME_ZONES: readonly string[] = [
  "America/Los_Angeles",
  "America/Denver",
  "America/Phoenix",
  "America/Chicago",
  "America/New_York",
  "America/Mexico_City",
  "America/Cancun",
  "America/Mazatlan",
  "America/Hermosillo",
  "America/Tijuana",
  "America/Boise",
  "America/Detroit",
  "America/Indiana/Indianapolis",
  "Pacific/Honolulu",
  "UTC",
];

export function isValidIanaZone(zone: string, list: readonly string[] = IANA_TIME_ZONES): boolean {
  return list.includes(zone);
}
