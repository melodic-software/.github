# Chore: Repository Consistency Audit

## Chore Description

Audit the `.github` repository to ensure all files follow consistent patterns, references are synchronized, and documentation accurately reflects the current state. This repeatable chore catches drift between documentation and implementation, conflicting information across files, and inconsistent formatting conventions. Running this audit periodically maintains repository quality and prevents documentation rot.

## Relevant Files

### Files to Audit/Update

#### Review Date Consistency
- `GOVERNANCE.md` - Review date: 2026-01-14 (older than others)
- `CODE_OF_CONDUCT.md` - Review date: 2026-01-14 (older than others)
- `SECURITY.md` - Review date: 2026-01-15
- `SUPPORT.md` - Review date: 2026-01-15
- `CONTRIBUTING.md` - Review date: 2026-01-15
- `README.md` - Review date: 2026-01-15
- `ROADMAP.md` - Review date: 2026-01-16
- `profile/README.md` - Review date: 2026-01-15
- All issue templates (.github/ISSUE_TEMPLATE/*.yaml) - Review date: 2026-01-14
- All discussion templates (.github/DISCUSSION_TEMPLATE/*.yaml) - Review date: 2026-01-14
- All workflows (.github/workflows/*.yaml) - Various review dates
- `labels.yaml` - Review date: 2026-01-15
- `FUNDING.yaml` - Review date: 2026-01-14
- `.github/dependabot.yaml` - Review date: 2026-01-14
- `.github/release.yaml` - Review date: 2026-01-14
- `workflow-templates/dotnet-ci.yaml` - Review date: 2026-01-14
- `workflow-templates/dotnet-release.yaml` - (needs to be checked)

#### Cross-Reference Sync
- `CLAUDE.md` - Documents repository structure, workflows, labels
- `README.md` - Documents repository structure, workflows, templates
- `ROADMAP.md` - References completed features, specs, labels.yaml
- `docs/adr/001-label-sync-strategy.md` - References workflow filenames, specs

#### Workflow Action Versions (check for consistency)
- `.github/workflows/dotnet-build.yaml` - Uses v5/v6 versions
- `.github/workflows/release.yaml` - Uses v6/v7 versions
- `.github/workflows/codeql.yaml` - Uses v4/v5/v6 versions
- `.github/workflows/label-sync.yaml` - Uses v4 versions
- `.github/workflows/cross-repo-label-sync.yaml` - Uses v4 version
- `workflow-templates/dotnet-ci.yaml` - Uses v4 versions (older than reusable)

## Step by Step Tasks

### 1. Verify File Extension Consistency

**Check**: Confirm all YAML files use `.yaml` extension (not `.yml`).

- [x] All files already use `.yaml` extension (confirmed in git status - shows renames from .yml to .yaml)
- Note: ADR-001 still references `labels.yml` and `label-sync.yml` filenames (outdated)

### 2. Audit Review Dates

**Action**: Update all review dates to be consistent and current where changes have been made.

Files needing review date updates:
- Files modified in current branch should have review dates updated to 2026-01-16
- All templates (issue/discussion) currently at 2026-01-14 should be reviewed for accuracy

### 3. Fix Documentation Cross-References

**ADR-001 (docs/adr/001-label-sync-strategy.md)**:
- Line 23-28: Code block shows `label-sync.yml` - should be `label-sync.yaml`
- Line 40: References `enhancement-cross-repo-label-sync.md` - file is named `feature-cross-repo-label-sync.md`
- Line 95-98: Related links reference `.yml` extensions - should be `.yaml`

**ROADMAP.md**:
- Line 47: References `EndBug/label-sync@v2` - verify this is still accurate
- Line 47: References `srealmoreno/label-sync-action@v2` - correct

**stale.yaml workflow**:
- Line 30: Comment says "use lowercase to match labels.yml" - should be `labels.yaml`

**cross-repo-label-sync.yaml workflow**:
- Line 4: Comment says "Syncs labels from labels.yml" - should be `labels.yaml`

### 4. Verify README Structure References

**README.md vs CLAUDE.md Repository Structure**:

README.md structure (lines 13-30):
```
.github/
├── .github/
│   ├── ISSUE_TEMPLATE/           # Issue forms (bug, feature, docs, chore)
│   ├── DISCUSSION_TEMPLATE/      # Discussion forms (general, ideas, Q&A)
│   ├── workflows/                # Reusable and automation workflows
│   ...
```

CLAUDE.md structure (lines 17-30):
```
.github/
├── .github/
│   ├── ISSUE_TEMPLATE/           # Issue forms (bug-report, feature-request, documentation, chore, config)
│   ├── DISCUSSION_TEMPLATE/      # Discussion forms (general, ideas, q-a, announcements, show-and-tell)
│   ├── workflows/                # Reusable workflows (release, codeql, dotnet-build, label-sync)
│   ...
```

**Action**: Ensure both files list the same items with consistent descriptions:
- Issue templates: Both should list `bug-report, feature-request, documentation, chore` (config is config.yaml, not a form)
- Discussion templates: Both should list `general, ideas, q-a, announcements, show-and-tell`
- Workflows: Both should list all automation and reusable workflows

### 5. Verify Workflow Version Consistency

**Reusable workflows** (in .github/workflows/):
| Workflow | checkout | setup-dotnet | cache | upload-artifact | download-artifact |
|----------|----------|--------------|-------|-----------------|-------------------|
| dotnet-build.yaml | v6 | v5 | v5 | v6 | - |
| release.yaml | v6 | - | - | - | v7 |
| codeql.yaml | v6 | v5 | - | - | - |
| label-sync.yaml | v6 | - | - | - | - |

**Workflow templates** (in workflow-templates/):
| Template | checkout | setup-dotnet | cache | upload-artifact |
|----------|----------|--------------|-------|-----------------|
| dotnet-ci.yaml | v4 | v4 | v4 | v4 |
| dotnet-release.yaml | (needs check) | (needs check) | (needs check) | (needs check) |

**Action**: Update workflow-templates to match or exceed reusable workflow versions

### 6. Verify Labels References

**labels.yaml** defines 49 labels in these categories:
- type:* (11 labels)
- status:* (9 labels)
- priority:* (4 labels)
- area:* (10 labels)
- effort:* (5 labels)
- scope:* (3 labels)
- special (7 labels)

**README.md labels section** (lines 103-124):
- Lists categories: type, status, priority, area, effort, scope
- Lists special labels: good first issue, help wanted, dependencies, breaking-change, stale, needs-reproduction, awaiting-response
- Count matches labels.yaml

**CLAUDE.md labels section** (lines 55-66):
- Lists categories matching README
- Missing some special labels (only lists partial special labels)

**CONTRIBUTING.md labels section** (lines 84-95):
- Lists categories with examples
- Should match other documentation

**Action**: Ensure all label documentation references are consistent

### 7. Verify Spec Files Status

**Specs in specs/ directory**:
- `feature-community-health-audit.md` - Appears to be completed work (from initial setup)
- `feature-cross-repo-label-sync.md` - Completed (workflow exists)
- `feature-pr-size-labeler.md` - Completed (workflow exists)
- `feature-stale-issue-management.md` - Completed (workflow exists)

**ROADMAP.md completed section** references:
- Dependabot Auto-Merge - 2026-01-16 (completed)
- YAML Extension Migration - 2026-01-16 (completed)
- Cross-Repo Label Sync - 2026-01-15 (completed)
- Stale Issue Management - 2026-01-15 (completed)
- PR Size Labeler - 2026-01-15 (completed)

**Action**: Verify spec files reflect completed status or archive them

### 8. Verify Contact Email Consistency

Contact emails used across files:
- `info@melodicsoftware.com` - Used in: CODE_OF_CONDUCT, CONTRIBUTING, GOVERNANCE, SUPPORT
- `security@melodicsoftware.com` - Mentioned in SECURITY.md (with fallback to info@)

**Action**: Verify all contact email references are consistent

### 9. Audit Workflow Descriptions in README

**README.md Reusable Workflows table** (lines 72-78):
| Workflow | Description |
|----------|-------------|
| release.yaml | GitHub release creation with artifacts |
| codeql.yaml | CodeQL security analysis |
| dotnet-build.yaml | .NET build with caching and test results |
| dependabot-automerge.yaml | Auto-merge Dependabot PRs for patch/minor updates |

**README.md Automation Workflows table** (lines 82-87):
| Workflow | Description |
|----------|-------------|
| label-sync.yaml | Sync labels from `labels.yaml` to this repo |
| cross-repo-label-sync.yaml | Sync labels to all organization repositories |
| pr-size-labeler.yaml | Label PRs by size using effort labels |
| stale.yaml | Mark/close stale issues and PRs |

**Action**: Verify all workflows are listed and descriptions are accurate

### 10. Check Spec File References

**feature-community-health-audit.md**:
- Line 65-67: References `reusable-dotnet-build.yaml`, `reusable-release.yaml`, `reusable-codeql.yaml`
- Actual filenames: `dotnet-build.yaml`, `release.yaml`, `codeql.yaml` (without "reusable-" prefix)

**Action**: Update spec references to match actual filenames or note that specs may be historical

## Validation Commands

Run these commands to verify completion:

### Check for .yml files (should find none)
```bash
find . -name "*.yml" -type f | grep -v node_modules
```

### Verify review dates are present in all files
```bash
# Markdown files
grep -l "Last reviewed:" *.md .github/*.md docs/**/*.md specs/*.md profile/*.md 2>/dev/null

# YAML files
grep -l "Last reviewed:" *.yaml .github/*.yaml .github/ISSUE_TEMPLATE/*.yaml .github/DISCUSSION_TEMPLATE/*.yaml .github/workflows/*.yaml workflow-templates/*.yaml 2>/dev/null
```

### Check for .yml references in documentation
```bash
grep -r "\.yml" *.md docs/**/*.md specs/*.md .github/workflows/*.yaml --include="*.md" --include="*.yaml" 2>/dev/null
```

### Validate YAML syntax
```bash
# If yamllint is available
find . -name "*.yaml" -type f | xargs yamllint 2>/dev/null || echo "yamllint not installed"
```

### Check workflow action versions
```bash
grep -h "uses:" .github/workflows/*.yaml workflow-templates/*.yaml | sort | uniq
```

## Notes

### Repeatable Audit Process

This chore is designed to be run periodically (monthly or quarterly) to catch drift. Key areas to check each time:

1. **Review Dates**: Are they current? Has the file been modified since the review date?
2. **Cross-References**: Do links and file references still point to existing files?
3. **Action Versions**: Are GitHub Actions at consistent, recent versions?
4. **Documentation Sync**: Do README, CLAUDE.md, and CONTRIBUTING.md agree?
5. **Labels**: Does label documentation match labels.yaml?
6. **Workflows**: Are all workflows documented in README?

### Known Technical Debt

1. **Spec files**: Consider archiving completed specs or moving to `docs/specs/completed/`
2. **ADR format**: ADR-001 may need updating to reflect current state
3. **Workflow template versions**: Templates lag behind reusable workflows

### Related Files

- `.claude/commands/update-readme.md` - Command to audit README specifically
- `ROADMAP.md` - Tracks planned and completed enhancements
- `docs/adr/001-label-sync-strategy.md` - Documents label sync decisions
