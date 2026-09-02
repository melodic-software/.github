import assert from "node:assert/strict";
import { describe, it } from "node:test";

import {
  DriftError,
  FetchError,
  collectDrift,
  fetchReusable,
  formatList,
  parseCallerPin,
  parseGateSections,
  parseSourceControlSections,
  parseTemplateHeadings,
  sourceOfTruth,
  stripHtmlComments,
} from "./pr-section-drift.mjs";

const SHA = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
const OTHER_SHA = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";

function callerYaml(sha) {
  return [
    "jobs:",
    "  pr-issue-linkage:",
    `    uses: melodic-software/ci-workflows/.github/workflows/pr-issue-linkage.yml@${sha} # v9.9.9`,
    "",
  ].join("\n");
}

function reusableYaml(sectionBlock) {
  return [
    "jobs:",
    "  pr-issue-linkage:",
    "    steps:",
    "      - uses: actions/github-script@v7",
    "        with:",
    "          script: |",
    "              const requiredSections = [",
    sectionBlock,
    "              ];",
    "",
  ].join("\n");
}

function namedSections(...names) {
  return names
    .map(
      (name, index) =>
        `                {\n                  name: "${name}",\n                  guidance: "fixture ${index}",\n                },`,
    )
    .join("\n");
}

function sourceControl(...names) {
  return [
    "## subject_pattern",
    "",
    "Conventional Commits",
    "",
    "## pr_body_required_sections",
    "",
    ...names.map((name) => `- ${name}`),
    "",
    "## babysit_loop_merge",
    "",
    "c3-autonomous",
    "",
  ].join("\n");
}

describe("parseCallerPin", () => {
  it("returns the single 40-hex pin on a uses: line", () => {
    assert.equal(parseCallerPin(callerYaml(SHA)), SHA);
  });

  it("accepts the same pin repeated", () => {
    const text = `${callerYaml(SHA)}\n${callerYaml(SHA)}`;
    assert.equal(parseCallerPin(text), SHA);
  });

  it("fails when no pin is present", () => {
    assert.throws(() => parseCallerPin("uses: actions/checkout@v4\n"), /no 40-hex/);
  });

  it("fails when two distinct pins are present", () => {
    const text = `${callerYaml(SHA)}\n${callerYaml(OTHER_SHA)}`;
    assert.throws(() => parseCallerPin(text), /multiple distinct/);
  });

  it("ignores a SHA that is not on a uses: pin line", () => {
    const text = `# mentioned ${SHA} only in a comment\n${callerYaml(OTHER_SHA)}`;
    assert.equal(parseCallerPin(text), OTHER_SHA);
  });
});

describe("parseGateSections", () => {
  it("parses a reusable fixture shaped like the real requiredSections block", () => {
    const text = reusableYaml(namedSections("Alpha", "Beta", "Gamma"));
    assert.deepEqual(parseGateSections(text, "fixture"), ["Alpha", "Beta", "Gamma"]);
  });

  it("fails loud when the requiredSections block is absent", () => {
    assert.throws(
      () => parseGateSections("jobs: {}\n", "fixture"),
      (error) => error instanceof DriftError && /no `const requiredSections/.test(error.message),
    );
  });

  it("fails loud when the block carries zero name: entries", () => {
    const text = reusableYaml("                // empty on purpose");
    assert.throws(
      () => parseGateSections(text, "fixture"),
      (error) => error instanceof DriftError && /no name: entries/.test(error.message),
    );
  });
});

describe("parseTemplateHeadings", () => {
  it("reads ## headings and ignores HTML comments", () => {
    const text = [
      "<!--",
      "## Hidden",
      "-->",
      "",
      "## Alpha",
      "",
      "<!-- What changes. -->",
      "",
      "## Beta",
      "",
    ].join("\n");
    assert.deepEqual(parseTemplateHeadings(text), ["Alpha", "Beta"]);
  });
});

describe("parseSourceControlSections", () => {
  it("reads the closed bullet list under pr_body_required_sections", () => {
    assert.deepEqual(parseSourceControlSections(sourceControl("Alpha", "Beta")), ["Alpha", "Beta"]);
  });

  it("fails when the section is missing", () => {
    assert.throws(() => parseSourceControlSections("## other\n\n- Alpha\n"), /no ## pr_body_required_sections/);
  });

  it("fails when the list is empty", () => {
    assert.throws(
      () => parseSourceControlSections("## pr_body_required_sections\n\n## next\n"),
      /carries no list items/,
    );
  });

  it("fails when the heading appears twice", () => {
    const text = `${sourceControl("Alpha")}\n## pr_body_required_sections\n\n- Beta\n`;
    assert.throws(() => parseSourceControlSections(text), /appears more than once/);
  });
});

describe("collectDrift", () => {
  const contract = ["Alpha", "Beta"];

  it("is silent when both mirrors match in order", () => {
    assert.deepEqual(collectDrift(contract, ["Alpha", "Beta"], ["Alpha", "Beta"], SHA), []);
  });

  it("reports a missing template heading", () => {
    const errors = collectDrift(contract, ["Alpha"], ["Alpha", "Beta"], SHA);
    assert.equal(errors.length, 1);
    assert.match(errors[0], /PULL_REQUEST_TEMPLATE\.md ## headings \[Alpha\]/);
    assert.match(errors[0], new RegExp(`${sourceOfTruth(SHA).replaceAll(".", "\\.")} \\[Alpha, Beta\\]`));
  });

  it("reports an extra template heading", () => {
    const errors = collectDrift(contract, ["Alpha", "Beta", "Gamma"], ["Alpha", "Beta"], SHA);
    assert.equal(errors.length, 1);
    assert.match(errors[0], /\[Alpha, Beta, Gamma\]/);
  });

  it("reports a reordered source-control list", () => {
    const errors = collectDrift(contract, ["Alpha", "Beta"], ["Beta", "Alpha"], SHA);
    assert.equal(errors.length, 1);
    assert.match(errors[0], /source-control\.md pr_body_required_sections \[Beta, Alpha\]/);
  });

  it("reports a missing source-control bullet", () => {
    const errors = collectDrift(contract, ["Alpha", "Beta"], ["Alpha"], SHA);
    assert.equal(errors.length, 1);
    assert.match(errors[0], /pr_body_required_sections \[Alpha\]/);
  });

  it("reports both mirrors when each has drifted independently", () => {
    const errors = collectDrift(contract, ["Alpha"], ["Beta"], SHA);
    assert.equal(errors.length, 2);
    assert.match(errors[0], /PULL_REQUEST_TEMPLATE/);
    assert.match(errors[1], /source-control/);
  });

  it("names the pinned reusable as the source of truth", () => {
    const errors = collectDrift(contract, ["Alpha"], ["Alpha", "Beta"], SHA);
    assert.match(errors[0], /melodic-software\/ci-workflows\/\.github\/workflows\/pr-issue-linkage\.yml@aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa requiredSections/);
  });
});

describe("fetchReusable", () => {
  it("returns the body of a 2xx Contents API response", async () => {
    const text = reusableYaml(namedSections("Alpha"));
    const fetchImpl = async () => ({ ok: true, text: async () => text });
    assert.equal(await fetchReusable(SHA, fetchImpl), text);
  });

  it("fails closed as fetch-error after repeated non-2xx", async () => {
    const fetchImpl = async () => ({ ok: false, status: 503, text: async () => "" });
    await assert.rejects(
      () => fetchReusable(SHA, fetchImpl, { backoffMs: 0 }),
      (error) => error instanceof FetchError && /^fetch-error:/.test(error.message),
    );
  });
});

describe("stripHtmlComments / formatList", () => {
  it("drops multiline comments", () => {
    assert.equal(stripHtmlComments("a<!--\n## X\n-->b"), "ab");
  });

  it("formats lists the way failure messages do", () => {
    assert.equal(formatList(["Alpha", "Beta"]), "[Alpha, Beta]");
  });
});
