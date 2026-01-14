# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is the **organization-level `.github` repository** for Melodic Software. It contains default community health files that are automatically inherited by all repositories in the organization that don't have their own versions.

## Repository Structure

```
.github/
├── .github/
│   ├── ISSUE_TEMPLATE/           # Issue forms (bug-report, feature-request, documentation, chore, config)
│   ├── DISCUSSION_TEMPLATE/      # Discussion forms (general, ideas, q-a, announcements, show-and-tell)
│   ├── workflows/                # Reusable workflows (release, codeql, dotnet-build, label-sync)
│   └── PULL_REQUEST_TEMPLATE.md  # PR description template
├── workflow-templates/           # Starter workflows for org repos (dotnet-ci, dotnet-release)
├── profile/README.md             # Organization profile displayed on GitHub
├── labels.yml                    # Standard label definitions for GitHub Label Sync
├── CODEOWNERS                    # Default code ownership rules
└── [Community files]             # CODE_OF_CONDUCT, CONTRIBUTING, SECURITY, SUPPORT, GOVERNANCE, etc.
```

## Key Conventions

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

Labels in `labels.yml` follow a namespaced convention:

| Category | Purpose | Examples |
|----------|---------|----------|
| `type:*` | Issue/PR type | bug, feature, enhancement, docs, chore, refactor, security |
| `status:*` | Workflow state | needs-triage, in-progress, ready-for-review, blocked, duplicate |
| `priority:*` | Urgency level | critical, high, medium, low |
| `area:*` | System component | frontend, backend, infrastructure, api, ci-cd, testing |
| `effort:*` | Size estimation | trivial, small, medium, large, epic |
| `scope:*` | Semver impact | breaking, minor, patch |

## Tech Context

This organization primarily builds .NET applications:
- Target: .NET 10, C# 14
- Architecture: Modular Monoliths with Clean Architecture, CQRS, DDD
- The `workflow-templates/dotnet-ci.yml` is the standard CI template for .NET projects

## Editing Templates

When editing YAML-based GitHub templates (issue forms, discussion forms):

### Issue/Discussion Templates

Use GitHub's form schema with `type`, `id`, `attributes`, and `validations` fields:

```yaml
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

## Reusable Workflows

Available reusable workflows in `.github/workflows/`:

| Workflow | Purpose |
|----------|---------|
| `reusable-release.yml` | Create GitHub releases with artifacts |
| `reusable-codeql.yml` | Security analysis with CodeQL |
| `reusable-dotnet-build.yml` | .NET build with caching and test results |
| `label-sync.yml` | Synchronize labels from labels.yml |

Call reusable workflows with:

```yaml
jobs:
  build:
    uses: melodic-software/.github/.github/workflows/reusable-dotnet-build.yml@main
    with:
      input-name: value
```
