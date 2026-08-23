# Contributing

Thanks for your interest in contributing to a melodic-software project.

A specific repository may override this org-wide default with its own `CONTRIBUTING.md` carrying project-specific details; where it does, that file takes precedence.

## Ground rules

- Be respectful — all interaction is governed by our [Code of Conduct](CODE_OF_CONDUCT.md).
- Open an issue before significant work so we can discuss the approach.
- Keep changes focused: one logical change per pull request.

## Workflow

1. Branch from the default branch using `<type>/<description>` (for example, `feat/add-widget`).
2. Make your change, with tests where applicable.
3. Ensure the project builds and its checks pass locally.
4. Open a pull request, fill out the template, and link the related issue. Title it using [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) with one of the standard types — `<type>[optional scope]: <description>`, for example `feat(api): add pagination`. The title becomes the squash-merge commit subject on the default branch. Where the repository enforces this, a `pr-title` check reports on your pull request and must pass before merge.
5. Address review feedback. Pull requests are squash-merged once approved and their checks pass.

## Reporting security issues

Do not open public issues for vulnerabilities — see [SECURITY.md](SECURITY.md).
