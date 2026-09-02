# .github

Organization-wide community-health defaults for the
[`melodic-software`](https://github.com/melodic-software) GitHub organization.

GitHub falls back to the files in this special repository for any repository
that does not provide its own, so they all inherit the same contribution and
disclosure workflow without redefining it.

These are the file-based governance defaults that GitHub's API cannot express.
Everything the Pulumi GitHub provider *can* express — repository settings,
custom properties, rulesets, and labels — is managed as infrastructure-as-code
in the private `github-iac` repository, not here. That name is deliberately not
a link: the repository is private, so a link 404s for every reader outside the
organization, which is also why `lychee.toml` excludes it from the online link
lane.

## What's here

- **Policies** — `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `GOVERNANCE.md`,
  `SECURITY.md`, and `SUPPORT.md`. A repository that ships its own copy
  overrides the default; everything else inherits these.
- **Templates** — `.github/ISSUE_TEMPLATE/` (bug report, feature request, task,
  and the chooser config that disables blank issues) and
  `.github/PULL_REQUEST_TEMPLATE.md`.
- **Profile** — `profile/README.md` renders as the organization's public profile
  page. Other repositories do not inherit it.
- **This repository's own CI** — `.github/workflows/` and `.github/scripts/`.
  `ci.yml` runs the SHA-pinned lint and hygiene lanes from
  [`ci-workflows`](https://github.com/melodic-software/ci-workflows) and
  aggregates them into the single `ci-status` check the org ruleset requires.
  The `pr-section-drift` lane is a local script (`.github/scripts/pr-section-drift.mjs`
  and its tests) that compares `.github/PULL_REQUEST_TEMPLATE.md` and
  `.claude/source-control.md` against the `pr-issue-linkage` reusable at the
  SHA `.github/workflows/pr-issue-linkage.yml` pins.
  `pr-title.yml`, `pr-issue-linkage.yml`, and `do-not-merge.yml` are thin
  callers of the shared PR gates. `link-check.yml` is a weekly advisory sweep of
  external links. `.github/dependabot.yml` keeps the SHA-pinned composite actions
  current. It does not touch the three reusable-workflow pins: the standards
  runner-policy allowlist admits only independently reviewed refs, so those move
  through explicit reviewed pull requests. Give every composite-action pin a
  `# vX.Y.Z` tag comment. Standards' pin-comment convention also permits a
  short-sha-and-date fallback, but Dependabot reads the current version out of
  that comment, so the fallback form leaves an action silently un-updated.
- **Quality configs** — the root dotfiles the CI lanes run against.
  `.editorconfig`, `.gitattributes`, `.markdownlint-cli2.jsonc`, `_typos.toml`,
  `.gitleaks.toml`, `lychee.toml`, and `.editorconfig-checker.json` are synced
  from [`standards`](https://github.com/melodic-software/standards);
  `.gitignore` is owned by this repository. Change a lint or hygiene rule in
  `standards` and let the sync land it here — an edit made directly to one of
  these files survives only until the next sync commit overwrites it.
  `.shellcheckrc` is the exception. It is a byte-identical copy of the same
  canonical file, but this repository is not on the `shellcheck` component's
  managed list, so nothing syncs it and nothing overwrites a local edit either.
  Adopting the component upstream is the durable fix; until then the copy drifts
  silently.
- **Agent config** — `.claude/settings.json` declares the `melodic-software`
  plugin marketplace, the plugins enabled for this project, and the SessionStart
  hook that runs `.claude/cloud-bootstrap.sh`, itself synced from
  [`standards`](https://github.com/melodic-software/standards)
  and extended per-repo by an optional `.claude/cloud-bootstrap.local.sh`.
  `.claude/source-control.md` is the tracked team layer of the source-control
  convention seam (commit and PR-title pattern, required PR-body sections, merge
  lane); `.work-item-tracker.json` binds the work-items tracker provider and
  `.github/recurring-schedule.json` holds its recurring-work schedule. The two
  config surfaces each resolve an optional gitignored `*.local.*` overlay for
  per-operator deviations. `CLAUDE.md` is the agent-loaded entry point: it
  routes to this file rather than restating it, and carries only what no other
  file states.

The inventory above covers every tracked file, and no check enforces that. When
a file is added or removed, update this section in the same change.

Editing a policy here changes it for every repository that has not overridden
it, so treat these files as org-wide.
