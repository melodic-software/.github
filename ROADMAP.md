<!-- Last reviewed: 2026-01-14 -->
# Roadmap

This document tracks future enhancements, technical debt, and improvement opportunities for the Melodic Software `.github` repository.

## Current Status

The `.github` repository is **well-established** with comprehensive coverage:
- Community health files (CODE_OF_CONDUCT, CONTRIBUTING, SECURITY, SUPPORT, GOVERNANCE)
- Issue and discussion templates
- Reusable workflows and starter templates
- Label management system
- Dependabot configuration
- Organization profile

## Planned Enhancements

### High Priority

| Enhancement | Description | Spec |
|-------------|-------------|------|
| Cross-Repo Label Sync | Extend label-sync to synchronize labels across all org repos (requires PAT) | [spec](specs/enhancement-cross-repo-label-sync.md) |
| Stale Issue Management | Auto-label and close inactive issues/PRs after configurable period | [spec](specs/enhancement-stale-management.md) |
| PR Size Labeler | Automatically label PRs by size (trivial/small/medium/large/epic) | [spec](specs/enhancement-pr-size-labeler.md) |

### Medium Priority

| Enhancement | Description | Spec |
|-------------|-------------|------|
| Organization Rulesets | Centralized branch protection rules at org level | Pending |
| Welcome Bot | Auto-comment greeting for first-time contributors | Pending |
| Branch Cleanup | Auto-delete merged branches (repo setting, not workflow) | N/A |

### Low Priority

| Enhancement | Description | Spec |
|-------------|-------------|------|
| Lock Threads | Auto-lock resolved issues after configurable period | Pending |
| Changelog Generator | Auto-generate CHANGELOG from commits/PRs | Pending |

## Technical Decisions

### Label Sync Architecture

**Decision**: Labels are managed via `EndBug/label-sync` action, currently syncing to `.github` repo only.

**Context**: GitHub does not automatically inherit labels from `.github` repos like it does with community health files. Organization default labels are only applied once at repo creation and don't stay in sync.

**Current State**: The label-sync workflow syncs 49 labels to the `.github` repo. Other repos must either:
1. Have the workflow added individually
2. Wait for cross-repo sync enhancement (requires PAT with repo scope)

**Why it matters**: Consistent labels enable better triage, filtering, and automation across all repos.

See [ADR-001](docs/adr/001-label-sync-strategy.md) for full decision record.

## Completed

| Enhancement | Completed | Notes |
|-------------|-----------|-------|
| Label taxonomy standardization | 2026-01-14 | 49 namespaced labels with aliases |
| Label sync workflow | 2026-01-14 | Fixed config-file path issue |
| Community health audit | 2026-01-14 | All files modernized |

## Review Schedule

- **Quarterly**: Community health files, label taxonomy
- **Monthly**: GitHub Actions versions, security updates
- **As-needed**: When GitHub introduces new features

## How to Propose Enhancements

1. Create a spec file in `specs/` following the existing format
2. Add entry to this ROADMAP.md
3. Open a PR for discussion
4. Once approved, implement and update status

## References

- [Community Health Audit Spec](specs/feature-community-health-audit.md)
- [Labels Configuration](labels.yml)
- [CLAUDE.md](CLAUDE.md) - AI assistant instructions
