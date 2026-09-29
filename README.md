# .github

Organization-wide community-health defaults for the
[`melodic-software`](https://github.com/melodic-software) GitHub organization.

GitHub falls back to these files for any repository without its own, so every
repository inherits one contribution and disclosure workflow.

They are the file-based governance defaults GitHub's API cannot express.
Everything the Pulumi GitHub provider *can* express (repository settings, custom
properties, rulesets, and labels) is infrastructure-as-code in the private
`github-iac` repository. That name is deliberately not a link: it 404s for
readers outside the organization, and `lychee.toml` excludes it from the online
link lane for the same reason.

## What's here

- **Policies**: `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `GOVERNANCE.md`,
  `SECURITY.md`, and `SUPPORT.md`. A repository that ships its own copy
  overrides the default; everything else inherits these.
- **Templates**: `.github/ISSUE_TEMPLATE/` (bug report, feature request, task,
  and the chooser config that disables blank issues) and
  `.github/PULL_REQUEST_TEMPLATE.md`.
- **Profile**: `profile/README.md` renders as the organization's public profile
  page. Other repositories do not inherit it.
- **This repository's own CI**: `.github/workflows/` and `.github/scripts/`.
  `ci.yml` runs the SHA-pinned lint and hygiene lanes from
  [`ci-workflows`](https://github.com/melodic-software/ci-workflows) and
  aggregates them into the single `ci-status` check the org ruleset requires.
  The pull-request contract itself (Conventional Commits title, `do-not-merge`
  label, issue linkage) is the `pr-contract` step inside the `ci-status` job,
  so there are no separate caller workflows for it.
  The `pr-section-drift` lane is a local script (`.github/scripts/pr-section-drift.mjs`
  and its tests) that compares `.github/PULL_REQUEST_TEMPLATE.md` and
  `.claude/source-control.md` against the `pr-contract` composite at the
  SHA `.github/workflows/ci.yml` pins.
  `.github/dependabot.yml` keeps `actions/checkout` current; the `ci-workflows`
  pins move by hand (see its `ignore` block).
  - Give every action pin a `# vX.Y.Z` tag comment. Standards'
    pin-comment convention also permits a short-sha-and-date fallback, but
    Dependabot reads the current version out of that comment, so the fallback
    form leaves an action silently un-updated.
- **Quality configs**: the root dotfiles the CI lanes run against.
  `.editorconfig`, `.gitattributes`, `.markdownlint-cli2.jsonc`, `_typos.toml`,
  `.gitleaks.toml`, `lychee.toml`, and `.editorconfig-checker.json` are synced
  from [`standards`](https://github.com/melodic-software/standards);
  `.gitignore` is owned by this repository. Change a lint or hygiene rule in
  `standards` and let the sync land it here. An edit made directly to one of
  these files survives only until the next sync commit overwrites it.
  `.shellcheckrc` is the exception: a byte-identical copy of the canonical file,
  but this repository is not on the `shellcheck` component's managed list, so
  nothing syncs or overwrites it. It drifts silently until the component is
  adopted upstream.
- **Agent config**: `.claude/settings.json` declares the `melodic-software`
  plugin marketplace and the SessionStart hook that runs `.claude/cloud-bootstrap.sh`, itself synced from
  [`standards`](https://github.com/melodic-software/standards)
  and extended per-repo by an optional `.claude/cloud-bootstrap.local.sh`.
  It also denies Read on secret files (`.env*`, `secrets/`, keys).
  `.claude/source-control.md` is the tracked team layer of the source-control
  convention (commit and PR-title pattern, required PR-body sections, merge
  lane); `.work-item-tracker.json` binds the work-items tracker provider.
  `.claude/source-control.md` and `.work-item-tracker.json` each resolve an
  optional gitignored `*.local.*` overlay for per-operator deviations.
  `.claude/rules/pr-body-contract.md`, synced from `standards`, states the
  pull-request body contract; `.claude/ai-slop.json` configures the AI-writing
  audit for this repository.
  `CLAUDE.md` is the agent-loaded entry point: it routes to this file rather
  than restating it, and carries only what no other file states.
- **Cloud Agent environment**: `.cursor/environment.json` is the repo-managed
  [Cursor Cloud Agent](https://cursor.com/docs/cloud-agent/setup) config and the
  highest-precedence environment source. Its `install` runs `.cursor/install.sh`,
  which installs the same lint/hygiene tools `.github/workflows/ci.yml` runs,
  each pinned to the version the SHA-pinned `ci-workflows` action uses, so
  `.cursor/check.sh` reproduces the gating CI lanes and
  their `ci-status` aggregate locally, plus the advisory `pr-section-drift`.

The inventory above covers every tracked file, and no check enforces that. When
a file is added or removed, update this section in the same change.

Editing a policy here changes it for every repository that has not overridden
it, so treat these files as org-wide.
