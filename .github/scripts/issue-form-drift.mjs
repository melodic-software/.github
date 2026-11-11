#!/usr/bin/env node

// Compares the org issue forms in `.github/ISSUE_TEMPLATE/` to the issue-body contract the
// standards sync delivers beside them (`.github/standards/issue-body-contract/contract.json`,
// generated from melodic-software/standards components/issue-body-contract/contract.json). A
// form that drifts from the contract (a hand edit, a stale sync, a form the contract does not
// declare) fails the PR that introduces it, with the field that differs named. `config.yml` is
// this repository's own and is not compared.
//
// The forms are the generator's YAML subset (no anchors, flow maps or multi-document streams), so
// a line reader covers them; a shape it cannot read is reported as drift, never skipped.

import { readFile, readdir } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

export const FORMS_DIR = ".github/ISSUE_TEMPLATE";
export const CONTRACT_PATH = ".github/standards/issue-body-contract/contract.json";
const OWNED_HERE = new Set(["config.yml"]);
const CONTRACT_FOOTER =
  "The contract is melodic-software/standards components/issue-body-contract/contract.json; " +
  "change it there and let the standards sync deliver the forms. Never edit a form here.";

function scalar(raw) {
  const value = raw.trim();
  if (value.startsWith('"') || value.startsWith("[")) return JSON.parse(value);
  if (value.startsWith("'")) return value.slice(1, -1).replaceAll("''", "'");
  return value;
}

// Returns { name, description, type, labels, fields: [{ id, kind, heading, required }] }.
export function parseForm(text) {
  const form = { type: null, labels: [], fields: [] };
  let list = null;
  let field = null;
  for (const line of text.split(/\r?\n/)) {
    if (line.trim() === "" || line.trimStart().startsWith("#")) continue;
    const top = line.match(/^([a-z_]+):(.*)$/);
    if (top) {
      const [, key, rest] = top;
      list = rest.trim() === "" ? key : null;
      if (list === null) form[key] = scalar(rest);
      continue;
    }
    if (list === "labels") {
      const item = line.match(/^ {2}- (.+)$/);
      if (item) form.labels.push(scalar(item[1]));
      continue;
    }
    if (list !== "body") continue;
    const element = line.match(/^ {2}- type: (.+)$/);
    if (element) {
      field = { id: null, kind: scalar(element[1]), heading: null, required: false };
      form.fields.push(field);
      continue;
    }
    const id = line.match(/^ {4}id: (.+)$/);
    const label = line.match(/^ {6}label: (.+)$/);
    const required = line.match(/^ {6}required: (.+)$/);
    if (field && id) field.id = scalar(id[1]);
    if (field && label) field.heading = scalar(label[1]);
    if (field && required) field.required = scalar(required[1]) === "true";
  }
  return form;
}

function expectedForm(type) {
  return {
    name: type.name,
    description: type.description,
    type: type.nativeType,
    labels: type.labels,
    fields: type.fields.map(({ id, kind, heading, required }) => ({ id, kind, heading, required })),
  };
}

export function compareForm(fileName, actual, expected) {
  const drift = [];
  for (const key of ["name", "description", "type"]) {
    if ((actual[key] ?? null) !== expected[key]) {
      drift.push(`${fileName}: ${key} ${JSON.stringify(actual[key] ?? null)} != contract ${JSON.stringify(expected[key])}`);
    }
  }
  if (JSON.stringify(actual.labels) !== JSON.stringify(expected.labels)) {
    drift.push(`${fileName}: labels ${JSON.stringify(actual.labels)} != contract ${JSON.stringify(expected.labels)}`);
  }
  const ids = (fields) => fields.map((field) => field.id).join(", ");
  if (ids(actual.fields) !== ids(expected.fields)) {
    drift.push(`${fileName}: fields [${ids(actual.fields)}] != contract [${ids(expected.fields)}]`);
    return drift;
  }
  expected.fields.forEach((want, index) => {
    const have = actual.fields[index];
    for (const key of ["kind", "heading", "required"]) {
      if (have[key] !== want[key]) {
        drift.push(`${fileName}: field ${want.id} ${key} ${JSON.stringify(have[key])} != contract ${JSON.stringify(want[key])}`);
      }
    }
  });
  return drift;
}

export function collectDrift(contract, forms) {
  const byFile = new Map(Object.values(contract.types).map((type) => [type.form, type]));
  const drift = [];
  for (const name of Object.keys(forms)) {
    if (!byFile.has(name)) drift.push(`${name}: no contract type declares this form`);
  }
  for (const [name, type] of byFile) {
    if (!(name in forms)) {
      drift.push(`${name}: missing (contract type ${type.name})`);
    } else {
      drift.push(...compareForm(name, parseForm(forms[name]), expectedForm(type)));
    }
  }
  return drift;
}

export async function readForms(repoRoot) {
  const dir = path.join(repoRoot, FORMS_DIR);
  const names = (await readdir(dir)).filter((name) => /\.ya?ml$/.test(name) && !OWNED_HERE.has(name));
  const forms = {};
  for (const name of names) forms[name] = await readFile(path.join(dir, name), "utf8");
  return forms;
}

if (import.meta.url === pathToFileURL(process.argv[1] ?? "").href) {
  const repoRoot = fileURLToPath(new URL("../..", import.meta.url));
  try {
    const contract = JSON.parse(await readFile(path.join(repoRoot, CONTRACT_PATH), "utf8"));
    const drift = collectDrift(contract, await readForms(repoRoot));
    if (drift.length > 0) {
      for (const line of drift) {
        process.stderr.write(`::error file=${FORMS_DIR}/${line.split(":")[0]}::drift: ${line}\n`);
      }
      process.stderr.write(`${CONTRACT_FOOTER}\n`);
      process.exit(1);
    }
    process.stdout.write(`issue-form-drift: ${Object.keys(contract.types).length} forms match ${CONTRACT_PATH}\n`);
  } catch (error) {
    process.stderr.write(`issue-form-drift: ${error.message}\n`);
    process.exit(1);
  }
}
