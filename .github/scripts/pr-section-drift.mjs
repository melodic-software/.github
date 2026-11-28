#!/usr/bin/env node

import { readFile } from "node:fs/promises";
import path from "node:path";
import { setTimeout as sleep } from "node:timers/promises";
import { fileURLToPath, pathToFileURL } from "node:url";

const CALLER_PATH = ".github/workflows/pr-require-checks.yml";
const TEMPLATE_PATH = ".github/PULL_REQUEST_TEMPLATE.md";
const SOURCE_CONTROL_PATH = "docs/conventions/source-control.yaml";
const UPSTREAM_REPO = "melodic-software/ci-workflows";
const UPSTREAM_GATE = ".github/actions/pr-require-checks/check-contract/run.sh";
const SOURCE_CONTROL_HEADING = "pr_body_required_sections";
const FETCH_ATTEMPTS = 3;
const CONTRACT_FOOTER =
  "The composite at that ref is the enforcement authority; the fleet convention record is " +
  "melodic-software/standards components/pr-convention-policy/policy.json (ADR-0008). " +
  "Change the contract there, then update both local files in the same PR.";

const CALLER_PIN_RE =
  /uses:\s*melodic-software\/ci-workflows\/\.github\/actions\/pr-require-checks\/(?:check-contract|report-ci-status)@([0-9a-f]{40}|main)(?=[\s"']|$)/gm;
const SECTION_REPORT_RE = /section_report\("([^"]+)"\)/g;

export class DriftError extends Error {
  name = "DriftError";
}

export class FetchError extends Error {
  name = "FetchError";
}

export function sourceOfTruth(sha) {
  return `${UPSTREAM_REPO}/${UPSTREAM_GATE}@${sha} section_report calls`;
}

export function parseCallerPin(callerText, location = CALLER_PATH) {
  const unique = [...new Set([...callerText.matchAll(CALLER_PIN_RE)].map((match) => match[1]))];
  if (unique.length === 0) {
    throw new DriftError(
      `${location}: no check-contract@ or report-ci-status@ ref (40-hex or main) found on a uses: line`,
    );
  }
  if (unique.length > 1) {
    throw new DriftError(
      `${location}: multiple distinct check-contract or report-ci-status refs: ${unique.join(", ")}`,
    );
  }
  return unique[0];
}

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

export function parseSourceControlSections(yamlText, location = SOURCE_CONTROL_PATH) {
  const lines = yamlText.split(/\r?\n/);
  const keyRe = new RegExp(`^${SOURCE_CONTROL_HEADING}:\\s*(#.*)?$`);
  const starts = lines.flatMap((line, index) => (keyRe.test(line) ? [index] : []));
  if (starts.length === 0) {
    throw new DriftError(`${location}: no top-level ${SOURCE_CONTROL_HEADING} list found`);
  }
  if (starts.length > 1) {
    throw new DriftError(`${location}: ${SOURCE_CONTROL_HEADING} appears more than once`);
  }
  const names = [];
  for (const line of lines.slice(starts[0] + 1)) {
    if (line.trim() === "" || /^\s*#/.test(line)) {
      continue;
    }
    if (!/^\s/.test(line) && !line.startsWith("- ")) {
      break;
    }
    const item = line.match(/^\s*- (.+?)\s*$/);
    if (item) {
      names.push(item[1].replace(/^(["'])(.*)\1$/, "$2"));
    }
  }
  if (names.length === 0) {
    throw new DriftError(`${location}: ${SOURCE_CONTROL_HEADING} carries no list items`);
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
  const expected = `${sourceOfTruth(sha)} ${formatList(contract)}`;
  return [
    [`${TEMPLATE_PATH} ## headings`, templateHeadings],
    [`${SOURCE_CONTROL_PATH} ${SOURCE_CONTROL_HEADING}`, sourceControlSections],
  ]
    .filter(([, names]) => !listsEqual(names, contract))
    .map(([label, names]) => `drift: ${label} ${formatList(names)} != ${expected}`);
}

function contentsUrl(sha) {
  return `https://api.github.com/repos/${UPSTREAM_REPO}/contents/${UPSTREAM_GATE}?ref=${sha}`;
}

export async function fetchGateSource(sha, fetchImpl = fetch, { backoffMs } = {}) {
  const url = contentsUrl(sha);
  const headers = { Accept: "application/vnd.github.raw+json" };
  if (process.env.GITHUB_TOKEN) {
    headers.Authorization = `Bearer ${process.env.GITHUB_TOKEN}`;
  }
  let lastError;
  for (let attempt = 1; attempt <= FETCH_ATTEMPTS; attempt += 1) {
    try {
      const response = await fetchImpl(url, { headers });
      if (response.ok) {
        return await response.text();
      }
      lastError = new Error(`HTTP ${response.status}`);
    } catch (error) {
      lastError = error;
    }
    const delay = backoffMs === undefined ? attempt * 2000 : backoffMs;
    if (attempt < FETCH_ATTEMPTS && delay > 0) {
      await sleep(delay);
    }
  }
  throw new FetchError(`fetch-error: ${url}: ${lastError.message}`);
}

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

async function runLiveCheck(repoRoot, fetchImpl = fetch) {
  const read = (relativePath) => readFile(path.join(repoRoot, relativePath), "utf8");
  const sha = parseCallerPin(await read(CALLER_PATH));
  const contract = parseGateSections(await fetchGateSource(sha, fetchImpl), sourceOfTruth(sha));
  const templateHeadings = parseTemplateHeadings(await read(TEMPLATE_PATH));
  const sourceControlSections = parseSourceControlSections(await read(SOURCE_CONTROL_PATH));
  return { sha, contract, errors: collectDrift(contract, templateHeadings, sourceControlSections, sha) };
}

const invokedDirectly = import.meta.url === pathToFileURL(process.argv[1] ?? "").href;

if (invokedDirectly) {
  const repoRoot = fileURLToPath(new URL("../..", import.meta.url));
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
