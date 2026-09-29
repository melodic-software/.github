# Contributing

A repository's own `CONTRIBUTING.md`, with project-specific details, overrides this org-wide default.

## Ground rules

- Be respectful. All interaction is governed by our [Code of Conduct](CODE_OF_CONDUCT.md).
- Open an issue before significant work so we can discuss the approach.
- Keep changes focused: one logical change per pull request.

## Workflow

1. Branch from the default branch as `<type>/<short-description>` (for example, `feat/add-widget`), per the org's [branch-naming convention](https://github.com/melodic-software/standards/blob/main/conventions/engineering/naming.md#branch-names-type-prefix-then-a-behavior-naming-slug). It is a convention, not a requirement: no check enforces it by default, though a repository may gate it locally.
2. Make your change, with tests where applicable.
3. Ensure the project builds and its checks pass locally.
4. Open a pull request, fill out the template, and link the related issue.
   - Title it in [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) form with a standard type, `<type>[optional scope]: <description>`, for example `feat(api): add pagination`. The title becomes the squash-merge commit subject on the default branch.
   - Where the repository enforces this, the `ci-status` check reports on your pull request and must pass before merge.
5. Address review feedback. Pull requests are squash-merged once every review thread is resolved and any required checks pass.

## Reporting security issues

Do not open public issues for vulnerabilities. See [SECURITY.md](SECURITY.md).
