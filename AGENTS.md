# melodic-software/.github

## Code Review Rules

Each line names a rule CI does not enforce; the linked file states it in full.

- Org-wide criteria: [`REVIEW.md`](https://github.com/melodic-software/standards/blob/main/REVIEW.md) in `melodic-software/standards`.
- Root policy files and templates apply to every org repo without its own copy, and the synced
  root dotfiles change in `standards`, not here: [rule](CLAUDE.md#read-before-editing-a-tracked-file).
- A change that adds or removes a tracked file updates the inventory, and every action pin carries
  a `# vX.Y.Z` tag comment: [rule](README.md#whats-here).
- A new CI lane gates merges only once the `ci-status` job's `needs:` names it:
  [rule](.github/workflows/ci.yml).
