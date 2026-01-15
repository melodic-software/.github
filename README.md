<!-- Last reviewed: 2026-01-15 -->

# Melodic Software - GitHub Community Defaults

This repository contains default community health files for the [Melodic Software](https://github.com/melodic-software) organization.

## Purpose

Files located here are automatically inherited by all repositories in the organization that don't have their own versions. This ensures a consistent contributor experience across all projects.

## Repository Structure

```
.github/
├── .github/
│   ├── ISSUE_TEMPLATE/           # Issue forms (bug, feature, docs, chore)
│   ├── DISCUSSION_TEMPLATE/      # Discussion forms (general, ideas, Q&A)
│   ├── workflows/                # Reusable and automation workflows
│   ├── PULL_REQUEST_TEMPLATE.md  # PR description template
│   ├── dependabot.yml            # Automated dependency updates
│   └── release.yml               # Auto-generated release notes config
├── workflow-templates/           # Starter workflows for org repos
├── docs/adr/                     # Architecture decision records
├── specs/                        # Feature specifications
├── .claude/commands/             # Claude Code custom commands
├── profile/README.md             # Organization profile
├── labels.yml                    # Standard label definitions
├── CODEOWNERS                    # Default code ownership
├── CITATION.cff                  # Citation metadata
└── [Community Health Files]      # CODE_OF_CONDUCT, CONTRIBUTING, etc.
```

## Included Defaults

### Community Health Files

| File | Description |
|------|-------------|
| [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) | Contributor Covenant v3.0 - community behavior standards |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Contribution guidelines, workflow, and commit standards |
| [SECURITY.md](SECURITY.md) | Security policy and vulnerability reporting |
| [SUPPORT.md](SUPPORT.md) | Support channels and how to get help |
| [GOVERNANCE.md](GOVERNANCE.md) | Project governance and decision-making |
| [ROADMAP.md](ROADMAP.md) | Project roadmap and planned features |
| [FUNDING.yml](FUNDING.yml) | Sponsor button configuration |
| [CITATION.cff](CITATION.cff) | Citation metadata for academic references |
| [CODEOWNERS](CODEOWNERS) | Default code ownership rules |
| [LICENSE](LICENSE) | Proprietary license |

### Issue Templates

| Template | Description |
|----------|-------------|
| `bug-report.yml` | Report bugs with severity, environment, and steps |
| `feature-request.yml` | Propose features with acceptance criteria |
| `documentation.yml` | Report docs issues or request improvements |
| `chore.yml` | Request maintenance work or dependency updates |

### Discussion Templates

| Template | Description |
|----------|-------------|
| `general.yml` | Open discussions with category selection |
| `ideas.yml` | Feature ideas with voting support |
| `q-a.yml` | Questions with topic categorization |
| `announcements.yml` | Maintainer announcements |
| `show-and-tell.yml` | Community project showcases |

### Workflows

#### Reusable Workflows

| Workflow | Description |
|----------|-------------|
| `reusable-release.yml` | GitHub release creation with artifacts |
| `reusable-codeql.yml` | CodeQL security analysis |
| `reusable-dotnet-build.yml` | .NET build with caching and test results |

#### Automation Workflows

| Workflow | Description |
|----------|-------------|
| `label-sync.yml` | Sync labels from `labels.yml` to this repo |
| `cross-repo-label-sync.yml` | Sync labels to all organization repositories |
| `pr-size-labeler.yml` | Label PRs by size using effort labels |
| `stale.yml` | Mark/close stale issues and PRs |

### Workflow Templates

| Template | Description |
|----------|-------------|
| `dotnet-ci.yml` | Standard .NET CI pipeline with NuGet caching |
| `dotnet-release.yml` | Release workflow with NuGet packaging |

### Automation Files

| File | Description |
|------|-------------|
| [dependabot.yml](.github/dependabot.yml) | Automated dependency updates (Actions, NuGet) |
| [release.yml](.github/release.yml) | Auto-generated release notes configuration |

## Labels

Labels are defined in [`labels.yml`](labels.yml) and organized by category:

| Category | Purpose | Examples |
|----------|---------|----------|
| `type:*` | Issue/PR type | bug, feature, docs, chore |
| `status:*` | Workflow state | needs-triage, in-progress, blocked |
| `priority:*` | Urgency level | critical, high, medium, low |
| `area:*` | System component | frontend, backend, api, ci-cd |
| `effort:*` | Size estimation | trivial, small, medium, large |
| `scope:*` | Semver impact | breaking, minor, patch |

### Special Labels

- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `dependencies` - Dependency updates
- `breaking-change` - Breaking changes
- `stale` - No recent activity
- `needs-reproduction` - Bug needs reproduction case
- `awaiting-response` - Waiting for author response

## Usage

### For Organization Repositories

These files are automatically inherited by all public repositories in the organization. To override any file, create a version in the target repository.

### Using Reusable Workflows

```yaml
jobs:
  build:
    uses: melodic-software/.github/.github/workflows/reusable-dotnet-build.yml@main
    with:
      dotnet-version: '10.0.x'
      run-tests: true
```

### Using Workflow Templates

1. Go to your repository's **Actions** tab
2. Click **New workflow**
3. Find "Melodic .NET CI" or "Melodic .NET Release" under organization templates
4. Click **Configure** to add the workflow

## Review Schedule

- **Quarterly**: Community health files review
- **Monthly**: GitHub Actions version check for security updates
- **Annually**: Label taxonomy review
- **As-needed**: When GitHub introduces new features

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on contributing to this repository.

## License

This repository is proprietary. See [LICENSE](LICENSE) for details.
