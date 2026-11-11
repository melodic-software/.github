import assert from "node:assert/strict";
import { describe, it } from "node:test";

import { collectDrift, compareForm, parseForm } from "./issue-form-drift.mjs";

const contract = {
  types: {
    bug: {
      form: "bug-report.yml",
      name: "Bug Report",
      description: "Report an unexpected problem or behavior.",
      nativeType: "Bug",
      labels: ["needs-triage"],
      fields: [
        { id: "steps", heading: "Steps to reproduce", kind: "textarea", required: true },
        { id: "severity", heading: "Severity", kind: "dropdown", required: true },
        { id: "fix-location", heading: "Suggested fix location", kind: "input", required: false },
      ],
    },
    "agent-ready": {
      form: "agent-ready.yml",
      name: "Agent-Ready Work Item",
      description: "Work written as an agent brief.",
      nativeType: null,
      labels: ["needs-triage"],
      fields: [{ id: "summary", heading: "Summary", kind: "input", required: true }],
    },
  },
};

// Shaped like the standards generator's output (yaml.stringify, lineWidth 0).
const BUG = [
  "# Generated from melodic-software/standards components/issue-body-contract/contract.json.",
  "name: Bug Report",
  "description: Report an unexpected problem or behavior.",
  "type: Bug",
  "labels:",
  "  - needs-triage",
  "body:",
  "  - type: textarea",
  "    id: steps",
  "    attributes:",
  "      label: Steps to reproduce",
  "      placeholder: |-",
  "        1. ...",
  "    validations:",
  "      required: true",
  "  - type: dropdown",
  "    id: severity",
  "    attributes:",
  "      label: Severity",
  "      options:",
  "        - low",
  "    validations:",
  "      required: true",
  "  - type: input",
  "    id: fix-location",
  "    attributes:",
  "      label: Suggested fix location",
  '      description: "One sentence: where."',
  "",
].join("\n");

const AGENT = [
  "name: Agent-Ready Work Item",
  "description: Work written as an agent brief.",
  "labels:",
  "  - needs-triage",
  "body:",
  "  - type: input",
  "    id: summary",
  "    attributes:",
  "      label: Summary",
  "    validations:",
  "      required: true",
  "",
].join("\n");

describe("parseForm", () => {
  it("reads the top-level keys, labels and each field", () => {
    assert.deepEqual(parseForm(BUG), {
      name: "Bug Report",
      description: "Report an unexpected problem or behavior.",
      type: "Bug",
      labels: ["needs-triage"],
      fields: [
        { id: "steps", kind: "textarea", heading: "Steps to reproduce", required: true },
        { id: "severity", kind: "dropdown", heading: "Severity", required: true },
        { id: "fix-location", kind: "input", heading: "Suggested fix location", required: false },
      ],
    });
  });

  it("reads a form with no native type as type null", () => {
    assert.equal(parseForm(AGENT).type, null);
  });
});

describe("collectDrift", () => {
  it("passes forms that match the contract", () => {
    assert.deepEqual(collectDrift(contract, { "bug-report.yml": BUG, "agent-ready.yml": AGENT }), []);
  });

  it("reports a missing form and a form the contract does not declare", () => {
    assert.deepEqual(collectDrift(contract, { "bug-report.yml": BUG, "question.yml": AGENT }), [
      "question.yml: no contract type declares this form",
      "agent-ready.yml: missing (contract type Agent-Ready Work Item)",
    ]);
  });

  it("reports a hand-added native type and an added label", () => {
    const edited = AGENT.replace("labels:\n  - needs-triage", "type: Task\nlabels:\n  - needs-triage\n  - agent-ready");
    assert.deepEqual(collectDrift(contract, { "bug-report.yml": BUG, "agent-ready.yml": edited }), [
      'agent-ready.yml: type "Task" != contract null',
      'agent-ready.yml: labels ["needs-triage","agent-ready"] != contract ["needs-triage"]',
    ]);
  });

  it("reports a renamed heading and a dropped required flag", () => {
    const edited = BUG.replace("label: Severity", "label: Impact").replace(
      "      label: Steps to reproduce\n      placeholder: |-\n        1. ...\n    validations:\n      required: true\n",
      "      label: Steps to reproduce\n",
    );
    assert.deepEqual(collectDrift(contract, { "bug-report.yml": edited, "agent-ready.yml": AGENT }), [
      "bug-report.yml: field steps required false != contract true",
      'bug-report.yml: field severity heading "Impact" != contract "Severity"',
    ]);
  });
});

describe("compareForm", () => {
  it("stops at a field list mismatch instead of comparing by position", () => {
    const actual = parseForm(BUG);
    actual.fields.reverse();
    const drift = compareForm("bug-report.yml", actual, {
      ...parseForm(BUG),
      type: "Bug",
    });
    assert.deepEqual(drift, [
      "bug-report.yml: fields [fix-location, severity, steps] != contract [steps, severity, fix-location]",
    ]);
  });
});
