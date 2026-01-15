<!-- Last reviewed: 2026-01-14 -->
# ADR-001: Label Synchronization Strategy

## Status

Accepted

## Context

GitHub organizations need consistent labels across repositories for:
- Efficient issue triage and filtering
- Automation based on labels (release notes, workflows)
- Clear communication of issue/PR status, priority, and type

**Key insight**: Unlike community health files (CODE_OF_CONDUCT, CONTRIBUTING, etc.), labels are NOT automatically inherited from the `.github` repository. GitHub's "organization default labels" are only applied once at repository creation and never sync afterward.

## Decision

We will use `EndBug/label-sync` action to manage labels declaratively via `labels.yml`.

### Current Configuration

```yaml
# .github/workflows/label-sync.yml
- uses: EndBug/label-sync@v2.3.3
  with:
    config-file: ./labels.yml
    dry-run: ${{ inputs.dry-run || false }}
    delete-other-labels: false
```

### Scope

**Phase 1 (Current)**: Sync labels to `.github` repo only
- Uses default `GITHUB_TOKEN`
- No additional secrets required
- Serves as source of truth for label definitions

**Phase 2 (Future)**: Sync labels across all org repos
- Requires PAT with `repo` scope
- Matrix strategy to iterate over repos
- See [enhancement spec](../../specs/enhancement-cross-repo-label-sync.md)

## Rationale

### Why EndBug/label-sync?

1. **Declarative**: Labels defined in YAML, version controlled
2. **Aliases**: Can rename labels while preserving issue associations
3. **Dry-run**: Can preview changes before applying
4. **Selective deletion**: `delete-other-labels: false` preserves repo-specific labels

### Why not organization default labels?

Organization default labels have limitations:
- Only applied at repo creation (no ongoing sync)
- No version control
- No alias/rename support
- Limited to 9 labels in the UI

### Why `./labels.yml` path?

The action requires an explicit `./` prefix to recognize local files. Without it, `labels.yml` is treated as a remote URL, causing failures.

```yaml
# CORRECT
config-file: ./labels.yml

# INCORRECT - treated as remote URL
config-file: labels.yml
```

## Consequences

### Positive

- Single source of truth for labels in `labels.yml`
- Aliases enable migration from old label names (e.g., `bug` → `type:bug`)
- Dry-run mode for safe testing
- Clear audit trail via git history

### Negative

- Currently only syncs to `.github` repo (limited value)
- Cross-repo sync requires additional setup (PAT, secrets)
- Teams must manually run workflow or push to `labels.yml` to sync

### Neutral

- `delete-other-labels: false` means repos can have additional custom labels
- Labels not in `labels.yml` are preserved, not deleted

## Related

- [labels.yml](../../labels.yml) - Label definitions
- [label-sync.yml](../../.github/workflows/label-sync.yml) - Sync workflow
- [ROADMAP.md](../../ROADMAP.md) - Future enhancements
- [Cross-repo sync spec](../../specs/enhancement-cross-repo-label-sync.md)
