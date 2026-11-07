import * as esbuild from "esbuild";
import { cpSync, mkdirSync } from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const root = join(__dirname, "..");
const dist = join(root, "dist");

mkdirSync(dist, { recursive: true });

await esbuild.build({
  entryPoints: [join(root, "gas", "main.ts")],
  bundle: true,
  outfile: join(dist, "Code.js"),
  platform: "neutral",
  target: "es2020",
  format: "iife",
  globalName: "Ingestion",
  banner: {
    js: "/* Mexico Cruise ingestion — built bundle; edit sources under gas/ and lib/ */",
  },
  footer: {
    js: `
function run() { return Ingestion.run(); }
function setup() { return Ingestion.setup(); }
function doGet(e) { return Ingestion.doGet(e); }
function installTrigger() { return Ingestion.installTrigger(); }
function removeTrigger() { return Ingestion.removeTrigger(); }
`,
  },
});

cpSync(join(root, "appsscript.json"), join(dist, "appsscript.json"));
console.log("Built dist/Code.js");
