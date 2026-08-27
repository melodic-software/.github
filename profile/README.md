# melodic-software

We build polyglot, .NET-first software with an AI-assisted development workflow.
Our public repositories are currently the engineering platform behind that work:
shared quality standards, CI building blocks, isolated runners, and the agent
tooling we develop with.

## Public projects

- [standards](https://github.com/melodic-software/standards) — shared
  repository-quality configs and engineering/review conventions, distributed to
  consuming repos for consistent human and AI contributions.
- [ci-workflows](https://github.com/melodic-software/ci-workflows) — SHA-pinned,
  configurable composite actions (one per code-quality tool) and reusable GitHub
  Actions workflows, aggregated by consumers into a single status gate.
- [ci-runner](https://github.com/melodic-software/ci-runner) — an official
  Actions runner image plus a native Windows scale-set controller. Each job gets
  a fresh, one-job Docker worker, with GitHub-hosted runners as fallback.
- Marketplaces of reusable, repo-agnostic agent tooling — skills, agents, hooks,
  and MCP servers — one per assistant:
  [claude-code-plugins](https://github.com/melodic-software/claude-code-plugins),
  [codex-plugins](https://github.com/melodic-software/codex-plugins), and
  [cursor-plugins](https://github.com/melodic-software/cursor-plugins).

## How we work

- Shared standards make the expected quality bar explicit for people and agents.
- Reusable workflows enforce that bar consistently across repositories.
- GitHub governance is managed as infrastructure-as-code so settings are
  reviewable and reproducible.
- AI assists implementation and review; automated checks and maintainer judgment
  remain the release gates.

## Getting involved

- Browse the repositories above, and open an issue or pull request where you see
  something to improve.
- Review our [Code of Conduct](https://github.com/melodic-software/.github/blob/main/CODE_OF_CONDUCT.md)
  and [contribution guidelines](https://github.com/melodic-software/.github/blob/main/CONTRIBUTING.md)
  before contributing.
- Found a security issue? Follow our [security policy](https://github.com/melodic-software/.github/blob/main/SECURITY.md)
  and do not report vulnerabilities publicly.

## Contact

<support@melodicsoftware.com>
