# CLAUDE.md

<!-- Last reviewed: 2026-01-16 -->

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is the **organization-level `.github` repository** for Melodic Software. It contains default community health files that are automatically inherited by all repositories in the organization that don't have their own versions.

## Repository Structure

```
.github/
├── .github/
│   ├── ISSUE_TEMPLATE/           # Issue forms (bug-report, feature-request, documentation, chore)
│   ├── DISCUSSION_TEMPLATE/      # Discussion forms (general, ideas, q-a, announcements, show-and-tell)
│   ├── workflows/                # Reusable workflows (release, codeql, dotnet-build, label-sync)
│   ├── PULL_REQUEST_TEMPLATE.md  # PR description template
│   ├── dependabot.yaml           # Automated dependency updates
│   └── release.yaml              # Auto-generated release notes configuration
├── workflow-templates/           # Starter workflows for org repos (dotnet-ci, dotnet-release)
├── profile/README.md             # Organization profile displayed on GitHub
├── labels.yaml                   # Standard label definitions for GitHub Label Sync
├── CODEOWNERS                    # Default code ownership rules
└── [Community files]             # CODE_OF_CONDUCT, CONTRIBUTING, SECURITY, SUPPORT, GOVERNANCE, etc.
```

## Key Conventions

### Review Dates

All files should include a review date comment at the top:
- Markdown files: `<!-- Last reviewed: YYYY-MM-DD -->`
- YAML files: `# Last reviewed: YYYY-MM-DD`

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):
- `feat:` new feature
- `fix:` bug fix
- `docs:` documentation only
- `chore:` maintenance tasks
- `ci:` CI/CD changes

### Branching

Trunk-based development with short-lived feature branches:
- Branch naming: `<type>/<short-description>` (e.g., `feat/add-template`, `fix/typo-in-conduct`)
- All changes via Pull Requests, squash merge to `main`

## Labels Schema

Labels in `labels.yaml` follow a namespaced convention:

| Category | Purpose | Examples |
|----------|---------|----------|
| `type:*` | Issue/PR type | bug, feature, enhancement, docs, chore, refactor, security |
| `status:*` | Workflow state | needs-triage, in-progress, ready-for-review, blocked, duplicate |
| `priority:*` | Urgency level | critical, high, medium, low |
| `area:*` | System component | frontend, backend, infrastructure, api, ci-cd, testing |
| `effort:*` | Size estimation | trivial, small, medium, large, epic |
| `scope:*` | Semver impact | breaking, minor, patch |

Special labels: `good first issue`, `help wanted`, `dependencies`, `breaking-change`, `stale`, `needs-reproduction`, `awaiting-response`

## Tech Context

This organization primarily builds .NET applications:
- Target: .NET 10, C# 14
- Architecture: Modular Monoliths with Clean Architecture, CQRS, DDD
- The `workflow-templates/dotnet-ci.yaml` is the standard CI template for .NET projects

## Editing Templates

When editing YAML-based GitHub templates (issue forms, discussion forms):

### Issue/Discussion Templates

Use GitHub's form schema with `type`, `id`, `attributes`, and `validations` fields:

```yaml
# Last reviewed: YYYY-MM-DD
- type: textarea | dropdown | input | checkboxes | markdown
  id: unique-id
  attributes:
    label: Field Label
    description: Help text
    placeholder: Example text
  validations:
    required: true | false
```

### Labels File

Uses GitHub Label Sync format (name, color as hex without #, description):

```yaml
- name: "category:label"
  color: "hex-color"
  description: "Label description"
```

### Workflow Templates

Require a corresponding `.properties.json` file with metadata:

```json
{
  "name": "Display Name",
  "description": "Template description",
  "iconName": "octicon-name",
  "categories": ["Category1", "Category2"],
  "filePatterns": ["pattern"]
}
```

## Automation Files

### dependabot.yaml

Configures automated dependency updates:
- GitHub Actions: Weekly updates (Mondays)
- NuGet packages: Weekly updates with grouping

### release.yaml

Configures auto-generated release notes:
- Categories based on labels (Breaking Changes, Features, Bug Fixes, etc.)
- Excludes dependabot PRs and invalid/duplicate issues

## Reusable Workflows

Available reusable workflows in `.github/workflows/`:

| Workflow | Purpose |
|----------|---------|
| `release.yaml` | Create GitHub releases with artifacts |
| `codeql.yaml` | Security analysis with CodeQL |
| `dotnet-build.yaml` | .NET build with caching and test results |
| `dependabot-automerge.yaml` | Auto-merge Dependabot PRs for patch/minor updates |
| `label-sync.yaml` | Synchronize labels from labels.yaml to .github repo |
| `cross-repo-label-sync.yaml` | Sync labels to all org repos (requires `LABEL_SYNC_PAT` secret) |
| `pr-size-labeler.yaml` | Label PRs by size using effort labels |
| `stale.yaml` | Mark/close stale issues and PRs |

Call reusable workflows with:

```yaml
jobs:
  build:
    uses: melodic-software/.github/.github/workflows/dotnet-build.yaml@main
    with:
      input-name: value
```

## Review Schedule

- **Quarterly**: Community health files (CODE_OF_CONDUCT, CONTRIBUTING, SECURITY, etc.)
- **Monthly**: GitHub Actions version check for security updates
- **Annually**: Label taxonomy review
- **As-needed**: When GitHub introduces new features

## Standards Reference

- [Contributor Covenant v3.0](https://www.contributor-covenant.org/version/3/0/) - Code of Conduct
- [CFF v1.2.0](https://citation-file-format.github.io/) - Citation format
- [Conventional Commits](https://www.conventionalcommits.org/) - Commit messages
- [Semantic Versioning](https://semver.org/) - Version numbering
