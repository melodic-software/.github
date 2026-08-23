# .github

Organization-wide community-health defaults for the
[`melodic-software`](https://github.com/melodic-software) GitHub organization.

GitHub falls back to the files in this special repository for any repo that does
not provide its own. It supplies default issue forms, a pull request template,
the security policy, and the contribution, governance, conduct, and support
policies, so individual repositories inherit a consistent contribution and
disclosure workflow without each one redefining it.

These are the file-based governance defaults that GitHub's API cannot express.
Everything the GitHub provider *can* express — repository settings, custom
properties, rulesets, and labels — is managed as Pulumi IaC in the private
`github-iac` repository, not here. (Unlinked deliberately: that repo is private,
so a link 404s for every reader outside the org — the same reason `lychee.toml`
excludes it from the online link lane.)

## What's here

- **Policies** — `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `GOVERNANCE.md`,
  `SECURITY.md`, and `SUPPORT.md`. A repository that ships its own copy
  overrides the default; everything else inherits these.
- **Templates** — `.github/ISSUE_TEMPLATE/` (bug report, feature request, task,
  and the chooser config that disables blank issues) and
  `.github/PULL_REQUEST_TEMPLATE.md`.
- **Profile** — `profile/README.md`, which renders as the organization's public
  profile page. It is not inherited by other repositories.
- **This repo's own CI** — `.github/workflows/`: `ci.yml` runs the SHA-pinned
  lint and hygiene lanes from
  [`ci-workflows`](https://github.com/melodic-software/ci-workflows) and
  aggregates them into the single `ci-status` check the org ruleset requires;
  `pr-title.yml`, `pr-issue-linkage.yml`, and `do-not-merge.yml` are thin
  callers of the shared PR gates; `link-check.yml` is a weekly advisory online
  link sweep. `.github/dependabot.yml` keeps the SHA-pinned *composite actions*
  in `ci.yml` current — the three reusable-workflow pins are deliberately
  excluded from it, because the standards runner-policy allowlist admits only
  independently reviewed refs, so those move through explicit reviewed PRs
  instead. Prefer the `# vX.Y.Z` tag form on a composite-action pin comment:
  standards' pin-comment convention also permits a `# <short-sha> <date>`
  fallback, but Dependabot reads the current version out of that comment, so
  the fallback form leaves an action silently un-updated.
- **Quality configs** — the root dotfiles (`.editorconfig`, `.gitattributes`,
  `.markdownlint-cli2.jsonc`, `_typos.toml`, `.gitleaks.toml`, `lychee.toml`,
  `.editorconfig-checker.json`) are synced from
  [`standards`](https://github.com/melodic-software/standards) and are what the
  CI lanes run against; `.gitignore` is owned by this repository. `.shellcheckrc`
  is a byte-identical copy of the same canonical file but is **not** synced —
  this repo is not on the `shellcheck` component's managed list, so adopting it
  there is the durable fix and this copy is interim.
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
  per-operator deviations.

Editing a policy here changes it for every repository that has not overridden
it, so treat these files as org-wide.
