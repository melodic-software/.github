# melodic-software/.github

GitHub's org-wide fallback repository. Any repo in the organization that does not ship its
own copy of a file inherits the one here, so editing a policy file changes behavior for
every such repo — confirm that blast radius is intended before touching one.

## Root dotfiles are upstream-owned

These seven are synced verbatim from
[`standards`](https://github.com/melodic-software/standards): `.editorconfig`,
`.editorconfig-checker.json`, `.gitattributes`, `.gitleaks.toml`,
`.markdownlint-cli2.jsonc`, `_typos.toml`, `lychee.toml`. Change a lint or hygiene rule in
`standards` and let the sync land it here; an edit made here survives only until the next
`chore: sync standards components` commit overwrites it. Everything else in the repo is
owned here and edited directly.

## Where a change belongs

| To change | Go to |
|---|---|
| Repo settings, rulesets, labels, custom properties | [`github-iac`](https://github.com/melodic-software/github-iac) — the GitHub provider expresses these as Pulumi IaC; this repo carries only the file-based defaults its API cannot |
| Lint and hygiene rules | [`standards`](https://github.com/melodic-software/standards), then sync — see above |
| What a CI lane actually runs | [`ci-workflows`](https://github.com/melodic-software/ci-workflows) — `.github/workflows/` here only pins those reusables by SHA and calls them |
| Issue forms, PR template, policy Markdown, `profile/README.md` | here, with the org-wide blast radius in mind |

## Adding or renaming a CI lane

`.github/workflows/ci.yml` fans out into one job per tool and aggregates them into
`ci-status`, the single check the org `ci-gate` ruleset requires. A new job gates merges
only once its name appears in BOTH the `ci-status` job's `needs:` list and its `results:`
expression; adding the job alone leaves it running but ignored. The lane is wired when
both references name it and a PR run shows `ci-status` waiting on it.

## Opening a PR here

PR bodies are gated by the `pr-issue-linkage` check: a closing keyword (or a stated
no-issue reason) plus four non-empty `##` sections.
[`.github/PULL_REQUEST_TEMPLATE.md`](.github/PULL_REQUEST_TEMPLATE.md) carries the layout
and [`.claude/source-control.md`](.claude/source-control.md) the tracked section list;
where they disagree with the check's own output, the check output is authoritative on the
accepted forms.
