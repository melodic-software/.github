# melodic-software/.github

Org-wide fallback repository for the `melodic-software` organization.
[`README.md`](README.md) is the canonical description of what it holds and what inherits
it; the sections below route rather than restate.

## Read before editing a tracked file

- **Adding, moving, or deleting anything**: read [`README.md`](README.md) "What's here"
  first. It is the inventory: which files are inherited org-wide, which are synced from
  elsewhere, and which are owned here.
- **Root policy files and templates** propagate to every org repo that has not overridden
  them; confirm that blast radius is intended.
- **The synced root dotfiles** are upstream-owned. `README.md` "Quality configs" names
  them and states what an edit made here costs. Change the rule in
  [`standards`](https://github.com/melodic-software/standards) instead.

## Where a change belongs

Repository settings, rulesets, labels, and custom properties are Pulumi IaC in the
private `github-iac` repository (unlinked here and in `README.md` because `github-iac`
404s for readers outside the org); what a CI lane actually
runs lives in [`ci-workflows`](https://github.com/melodic-software/ci-workflows), which
`.github/workflows/` only pins by SHA and calls. `README.md` covers why the split falls
where it does. Go there when a change fits none of the files already in this repo.

## Adding or renaming a CI lane

The wiring rule sits in `.github/workflows/ci.yml`'s header comment, above `jobs:`.
A gating lane is done when the `ci-status` job's `needs:` roster names it and
a PR run shows `ci-status` waiting on it.

## Checks

`bash .cursor/check.sh` runs every CI lane locally, with the tools `.cursor/install.sh`
pins, and exits non-zero when any lane fails.

## Opening a PR here

[`.claude/rules/pr-body-contract.md`](.claude/rules/pr-body-contract.md) states the rule
and what is gating versus advisory;
[`.github/PULL_REQUEST_TEMPLATE.md`](.github/PULL_REQUEST_TEMPLATE.md) carries the layout
and [`.claude/source-control.md`](.claude/source-control.md) the section list.
