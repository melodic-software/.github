# .github

Organization-wide community-health defaults for the
[`melodic-software`](https://github.com/melodic-software) GitHub organization.

GitHub falls back to the files in this special repository for any repository
that does not provide its own, so they all inherit the same contribution and
disclosure workflow without redefining it.

These are the file-based governance defaults that GitHub's API cannot express.
Everything the Pulumi GitHub provider *can* express — repository settings,
custom properties, rulesets, and labels — is managed as infrastructure-as-code
in [`github-iac`](https://github.com/melodic-software/github-iac), not here.

## What's here

- **Policies** — `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `GOVERNANCE.md`,
  `SECURITY.md`, and `SUPPORT.md`. A repository that ships its own copy
  overrides the default; everything else inherits these.
- **Templates** — `.github/ISSUE_TEMPLATE/` (bug report, feature request, task,
  and the chooser config that disables blank issues) and
  `.github/PULL_REQUEST_TEMPLATE.md`.
- **Profile** — `profile/README.md` renders as the organization's public profile
  page. Other repositories do not inherit it.
- **This repository's own CI** — `.github/workflows/`. `ci.yml` runs the
  SHA-pinned lint and hygiene lanes from
  [`ci-workflows`](https://github.com/melodic-software/ci-workflows) and
  aggregates them into the single `ci-status` check the org ruleset requires.
  `pr-title.yml`, `pr-issue-linkage.yml`, and `do-not-merge.yml` are thin
  callers of the shared PR gates. `link-check.yml` is a weekly advisory sweep of
  external links. `.github/dependabot.yml` keeps the pinned actions current.
- **Quality configs** — the root dotfiles the CI lanes run against.
  `.editorconfig`, `.gitattributes`, `.markdownlint-cli2.jsonc`, `_typos.toml`,
  `.gitleaks.toml`, `lychee.toml`, and `.editorconfig-checker.json` are synced
  from [`standards`](https://github.com/melodic-software/standards);
  `.gitignore` is owned by this repository.
- **Agent config** — `.claude/` declares the `melodic-software` plugin
  marketplace, the plugins enabled for this project, and the tracked
  source-control settings (required PR-body sections, merge lane).
  `.work-item-tracker.json` and `.github/recurring-schedule.json` hold the
  work-item tooling's tracked state.

Editing a policy here changes it for every repository that has not overridden
it, so treat these files as org-wide.
