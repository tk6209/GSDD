#!/usr/bin/env node

import fs from "node:fs";

const version = "0.1.0-experimental.0";
const requiredMarkers = ["MODE:", "TASK:", "READ_SCOPE:", "WRITE_SCOPE:", "OUTPUT REQUIRED:"];

function help(exitCode = 0) {
  console.log(`gsdd v${version}

Usage:
  gsdd --help
  gsdd --version
  gsdd verify <spec-file>

Commands:
  verify   Validate minimum GSDD spec markers`);
  process.exit(exitCode);
}

function fail(message) {
  console.error(`❌ ${message}`);
  process.exit(1);
}

const [, , command, target] = process.argv;

if (command === "--help" || command === "-h") help(0);
if (command === "--version" || command === "-v") {
  console.log(version);
  process.exit(0);
}

if (!command) {
  console.error("❌ No command provided.");
  help(1);
}

if (command !== "verify") {
  fail(`Unknown command: ${command}`);
}

if (!target) {
  fail("Missing spec file path.");
}

if (!fs.existsSync(target)) {
  fail(`File not found: ${target}`);
}

const content = fs.readFileSync(target, "utf8");

for (const marker of requiredMarkers) {
  const count = content.split(marker).length - 1;
  if (count === 0) fail(`Missing marker: ${marker}`);
  if (count > 1) fail(`Duplicate marker found: ${marker}`);
}

console.log("✅ GSDD verify passed");
