# .github

Organization-wide community-health defaults for the
[`melodic-software`](https://github.com/melodic-software) GitHub organization.

GitHub falls back to the files in this special repository for any repo that does
not provide its own. It supplies default issue forms, a pull request template,
the security policy, and the contribution, governance, conduct, and support
policies, so individual repositories inherit a consistent contribution and
disclosure workflow without each one redefining it.

These are the file-based governance defaults that GitHub's API cannot express.
Everything the [GitHub provider](https://github.com/melodic-software/github-iac)
*can* express — repository settings, custom properties, rulesets, and labels — is
managed as Pulumi IaC there, not here.

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
  link sweep. `.github/dependabot.yml` keeps the pinned actions current.
- **Quality configs** — the root dotfiles (`.editorconfig`, `.gitattributes`,
  `.markdownlint-cli2.jsonc`, `_typos.toml`, `.gitleaks.toml`, `lychee.toml`,
  `.editorconfig-checker.json`) are synced from
  [`standards`](https://github.com/melodic-software/standards) and are what the
  CI lanes run against. Change a lint or hygiene rule in `standards` and let the
  sync land it here; an edit made directly to one of these files survives only
  until the next sync commit overwrites it. `.gitignore` is owned by this
  repository.
- **Agent config** — `.claude/settings.json` declares the `melodic-software`
  plugin marketplace, the plugins enabled for this project, and the SessionStart
  hook that runs `.claude/cloud-bootstrap.sh`, itself synced from
  [`claude-code-plugins`](https://github.com/melodic-software/claude-code-plugins)
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
