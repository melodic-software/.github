#!/usr/bin/env node

// Local complement to standards' fleet lockstep (ADR-0008): this repository's
// two PR-body declarations — `.github/PULL_REQUEST_TEMPLATE.md` headings and
// `.claude/source-control.md`'s `pr_body_required_sections` — are unchecked
// mirrors of the section list the `pr-contract` composite enforces. ADR-0008
// fleet-checks the template and the pin from standards CI *after* merge; it
// deliberately does not check this repository's source-control key. This lane
// fails the PR that introduces either drift, comparing both mirrors to the
// exact composite bytes this repository's gate already executes.
//
// Comparison target is derived: the 40-hex `pr-contract` pin in
// `.github/workflows/ci.yml`, then that ref's `run.sh`. The four section names
// are not hardcoded here. Fetch failures are `fetch-error` (never a skip),
// matching standards' `lockstep-drift.mjs` posture.
//
// Parsing of the composite's section list uses the same regex as
// `melodic-software/standards` `components/pr-convention-policy/lockstep-drift.mjs`
// `parseCompositeSections`, so a shape change breaks both parsers together.
// The gate's awk block calls `section_report("<name>")` once per required
// section, in contract order; the function definition takes an unquoted
// parameter, so only the call sites match.

import { readFile } from "node:fs/promises";
import path from "node:path";
import process from "node:process";
import { fileURLToPath, pathToFileURL } from "node:url";

const CALLER_PATH = ".github/workflows/ci.yml";
const TEMPLATE_PATH = ".github/PULL_REQUEST_TEMPLATE.md";
const SOURCE_CONTROL_PATH = ".claude/source-control.md";
const UPSTREAM_REPO = "melodic-software/ci-workflows";
const UPSTREAM_GATE = ".github/actions/pr-contract/run.sh";
const SOURCE_CONTROL_HEADING = "pr_body_required_sections";

const CALLER_PIN_RE =
  /uses:\s*melodic-software\/ci-workflows\/\.github\/actions\/pr-contract@([0-9a-f]{40})/g;
const SECTION_REPORT_RE = /section_report\("([^"]+)"\)/g;

export class DriftError extends Error {
  constructor(message) {
    super(message);
    this.name = "DriftError";
  }
}

export class FetchError extends Error {
  constructor(message) {
    super(message);
    this.name = "FetchError";
  }
}

export function sourceOfTruth(sha) {
  return `${UPSTREAM_REPO}/${UPSTREAM_GATE}@${sha} section_report calls`;
}

export function parseCallerPin(callerText, location = CALLER_PATH) {
  const shas = [...callerText.matchAll(CALLER_PIN_RE)].map((match) => match[1]);
  const unique = [...new Set(shas)];
  if (unique.length === 0) {
    throw new DriftError(`${location}: no 40-hex pr-contract@ pin found on a uses: line`);
  }
  if (unique.length > 1) {
    throw new DriftError(`${location}: multiple distinct pr-contract pins: ${unique.join(", ")}`);
  }
  return unique[0];
}

// Same regex as standards lockstep-drift.mjs parseCompositeSections.
export function parseGateSections(runShText, location) {
  const names = [...runShText.matchAll(SECTION_REPORT_RE)].map((match) => match[1]);
  if (names.length === 0) {
    throw new DriftError(`${location}: no \`section_report("<name>")\` calls found in run.sh`);
  }
  const duplicates = names.filter((name, index) => names.indexOf(name) !== index);
  if (duplicates.length > 0) {
    throw new DriftError(
      `${location}: repeated section_report names: ${[...new Set(duplicates)].join(", ")}`,
    );
  }
  return names;
}

export function stripHtmlComments(markdownText) {
  return markdownText.replace(/<!--[\s\S]*?-->/g, "");
}

export function parseTemplateHeadings(markdownText) {
  return [...stripHtmlComments(markdownText).matchAll(/^## (.+)$/gm)].map((match) => match[1].trim());
}

export function parseSourceControlSections(markdownText, location = SOURCE_CONTROL_PATH) {
  const lines = markdownText.split(/\r?\n/);
  const starts = [];
  for (let index = 0; index < lines.length; index += 1) {
    if (lines[index].trim() === `## ${SOURCE_CONTROL_HEADING}`) {
      starts.push(index);
    }
  }
  if (starts.length === 0) {
    throw new DriftError(`${location}: no ## ${SOURCE_CONTROL_HEADING} section found`);
  }
  if (starts.length > 1) {
    throw new DriftError(`${location}: ## ${SOURCE_CONTROL_HEADING} appears more than once`);
  }
  const names = [];
  for (let index = starts[0] + 1; index < lines.length; index += 1) {
    const line = lines[index];
    if (line.startsWith("## ")) {
      break;
    }
    const bullet = line.match(/^- (.+)$/);
    if (bullet) {
      names.push(bullet[1].trim());
    }
  }
  if (names.length === 0) {
    throw new DriftError(`${location}: ## ${SOURCE_CONTROL_HEADING} carries no list items`);
  }
  return names;
}

export function formatList(names) {
  return `[${names.join(", ")}]`;
}

function listsEqual(left, right) {
  return left.length === right.length && left.every((name, index) => name === right[index]);
}

export function collectDrift(contract, templateHeadings, sourceControlSections, sha) {
  const errors = [];
  if (!listsEqual(templateHeadings, contract)) {
    errors.push(
      `drift: ${TEMPLATE_PATH} ## headings ${formatList(templateHeadings)} != ${sourceOfTruth(sha)} ${formatList(contract)}`,
    );
  }
  if (!listsEqual(sourceControlSections, contract)) {
    errors.push(
      `drift: ${SOURCE_CONTROL_PATH} ${SOURCE_CONTROL_HEADING} ${formatList(sourceControlSections)} != ${sourceOfTruth(sha)} ${formatList(contract)}`,
    );
  }
  return errors;
}

export function contentsUrl(sha) {
  return `https://api.github.com/repos/${UPSTREAM_REPO}/contents/${UPSTREAM_GATE}?ref=${sha}`;
}

export async function fetchGateSource(sha, fetchImpl = fetch, { backoffMs } = {}) {
  const url = contentsUrl(sha);
  const headers = { Accept: "application/vnd.github.raw+json" };
  if (process.env.GITHUB_TOKEN) {
    headers.Authorization = `Bearer ${process.env.GITHUB_TOKEN}`;
  }
  let lastError;
  for (let attempt = 1; attempt <= 3; attempt += 1) {
    try {
      const response = await fetchImpl(url, { headers });
      if (response.ok) {
        return await response.text();
      }
      lastError = new Error(`HTTP ${response.status}`);
    } catch (error) {
      lastError = error;
    }
    if (attempt < 3) {
      const delay = backoffMs === undefined ? attempt * 2000 : backoffMs;
      if (delay > 0) {
        await new Promise((resolve) => setTimeout(resolve, delay));
      }
    }
  }
  throw new FetchError(`fetch-error: ${url}: ${lastError.message}`);
}

const CONTRACT_FOOTER =
  "The pinned composite is the enforcement authority; the fleet convention record is " +
  "melodic-software/standards components/pr-convention-policy/policy.json (ADR-0008). " +
  "Change the contract there and bump the pin, then update both local files in the same PR.";

function emitErrors(messages) {
  for (const message of messages) {
    const fileMatch = message.match(/^drift: (\S+)/);
    if (fileMatch) {
      console.error(`::error file=${fileMatch[1]}::${message}`);
    }
    console.error(message);
  }
  console.error(CONTRACT_FOOTER);
}

export async function runLiveCheck(repoRoot, fetchImpl = fetch) {
  const callerText = await readFile(path.join(repoRoot, CALLER_PATH), "utf8");
  const sha = parseCallerPin(callerText);
  const runShText = await fetchGateSource(sha, fetchImpl);
  const contract = parseGateSections(runShText, sourceOfTruth(sha));
  const templateHeadings = parseTemplateHeadings(
    await readFile(path.join(repoRoot, TEMPLATE_PATH), "utf8"),
  );
  const sourceControlSections = parseSourceControlSections(
    await readFile(path.join(repoRoot, SOURCE_CONTROL_PATH), "utf8"),
  );
  return { sha, contract, errors: collectDrift(contract, templateHeadings, sourceControlSections, sha) };
}

const invokedDirectly = import.meta.url === pathToFileURL(process.argv[1] ?? "").href;

if (invokedDirectly) {
  const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..", "..");
  try {
    const { sha, contract, errors } = await runLiveCheck(repoRoot);
    if (errors.length > 0) {
      emitErrors(errors);
      process.exit(1);
    }
    console.log(`pr-section-drift: local mirrors match ${sourceOfTruth(sha)} ${formatList(contract)}`);
  } catch (error) {
    console.error(error.message);
    process.exit(1);
  }
}
