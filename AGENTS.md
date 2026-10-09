# melodic-software/.github

## Org architecture

Org architecture (cross-repo decisions, glossary, why each trust link exists): private repo `melodic-software/architecture`. Repo map: `gh api orgs/melodic-software/properties/values` (system and role per repo). Read it with `gh api repos/melodic-software/architecture/contents/<path>`; on Claude Code on the web, attach it at session start; in CI, check it out with a read-only App token. If access is denied, stop and tell the user.

## Code Review Rules

Each line names a rule CI does not enforce; the linked file states it in full.

- Org-wide criteria: [`REVIEW.md`](https://github.com/melodic-software/standards/blob/main/REVIEW.md) in `melodic-software/standards`.
- Org-wide blast radius and upstream-owned dotfiles: [rule](CLAUDE.md#read-before-editing-a-tracked-file).
- Tracked-file inventory and action pin comments: [rule](README.md#whats-here).
- CI lane wiring into `ci-status` `needs:`: [rule](.github/workflows/pr-require-checks.yml).
