<!-- Last reviewed: 2026-01-16 -->
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

*No high-priority items currently pending.*

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

**Decision**: Labels are managed via two complementary workflows for different scopes.

**Context**: GitHub does not automatically inherit labels from `.github` repos like it does with community health files. Organization default labels are only applied once at repo creation and don't stay in sync.

**Current State**: Two workflows handle label synchronization:

1. `label-sync.yaml` - Syncs 45 labels to the `.github` repository using `EndBug/label-sync@v2`
2. `cross-repo-label-sync.yaml` - Syncs labels to all specified org repositories using `srealmoreno/label-sync-action@v2` with a matrix strategy and `LABEL_SYNC_PAT` secret

The matrix approach processes one repository at a time to avoid GitHub API rate limits.

**Why it matters**: Consistent labels enable better triage, filtering, and automation across all repos.

See [ADR-001](docs/adr/001-label-sync-strategy.md) for full decision record.

## Completed

| Enhancement | Completed | Notes |
|-------------|-----------|-------|
| Dependabot Auto-Merge | 2026-01-16 | Reusable workflow for auto-merging patch/minor updates |
| YAML Extension Migration | 2026-01-16 | Migrated all `.yml` files to `.yaml` (official YAML spec) |
| Cross-Repo Label Sync | 2026-01-15 | Matrix strategy workflow with `LABEL_SYNC_PAT` |
| Stale Issue Management | 2026-01-15 | Daily workflow using `actions/stale@v9` |
| PR Size Labeler | 2026-01-15 | Maps to `effort:*` labels using `codelytv/pr-size-labeler` |
| Label taxonomy standardization | 2026-01-14 | 45 namespaced labels with aliases |
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
- [Labels Configuration](labels.yaml)
- [CLAUDE.md](CLAUDE.md) - AI assistant instructions
