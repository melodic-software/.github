# Feature: PR Size Labeler

## Feature Description

Automatically label pull requests based on the number of lines changed to provide immediate visibility into PR complexity. This automation maps PR sizes to existing `effort:*` labels, enabling teams to quickly identify and prioritize code reviews while encouraging smaller, more reviewable pull requests.

## User Story

As a code reviewer, I want pull requests to be automatically labeled by size so that I can prioritize reviews and quickly identify PRs that may need to be broken down.

## Problem Statement

Without automatic PR size labeling, reviewers must manually assess PR complexity before deciding on review priority. Large PRs often go unnoticed until deep in review, wasting time on changes that should be broken into smaller pieces. Manual size estimation is inconsistent across team members.

## Solution Statement

Implement a GitHub Actions workflow using the CodelyTV/pr-size-labeler action that automatically applies effort labels based on lines changed. The workflow will:
- Trigger on PR open and synchronize events
- Map line counts to existing effort labels (trivial, small, medium, large, epic)
- Exclude auto-generated files from line counts (lock files, designer files)
- Provide optional warnings for oversized PRs

## Relevant Files

### New Files

- `.github/workflows/pr-size-labeler.yaml` - Main workflow that triggers on pull_request events and applies size-based labels

### Modified Files

None - this feature adds a new workflow without modifying existing files. The existing `effort:*` labels in `labels.yaml` are already defined and will be reused.

## Implementation Plan

### Foundation Phase

1. Verify existing labels are compatible with the PR size labeler:
   - Confirm `effort:trivial`, `effort:small`, `effort:medium`, `effort:large`, `effort:epic` exist in `labels.yaml`
   - Document the size-to-label mapping that will be used

2. Determine file exclusion patterns for .NET projects:
   - `package-lock.json` - npm lock file
   - `yarn.lock` - yarn lock file
   - `*.Designer.cs` - Visual Studio designer files
   - `*.g.cs` - Source-generated files
   - `*.min.js` / `*.min.css` - Minified assets

### Core Phase

3. Create the workflow file `.github/workflows/pr-size-labeler.yaml`:
   - Set up workflow triggers for `pull_request` events (`opened`, `synchronize`)
   - Configure permissions for `pull-requests: write`, `contents: read`
   - Use `codelytv/pr-size-labeler@v1` action with appropriate version pinning

4. Configure size thresholds to map to effort labels:
   - `xs` (< 10 lines) → `effort:trivial`
   - `s` (10-100 lines) → `effort:small`
   - `m` (100-500 lines) → `effort:medium`
   - `l` (500-1000 lines) → `effort:large`
   - `xl` (> 1000 lines) → `effort:epic`

5. Configure file exclusions using `files_to_ignore`:
   - Lock files: `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `*.lock`
   - .NET generated: `*.Designer.cs`, `*.g.cs`, `*.generated.cs`
   - Build artifacts: `*.min.js`, `*.min.css`

### Integration Phase

6. Add optional XL warning message to encourage smaller PRs without blocking merges

7. Add review date comment per repository conventions

8. Test workflow with various PR sizes to validate behavior

## Step by Step Tasks

1. Read `labels.yaml` to confirm effort labels exist with exact names: `effort:trivial`, `effort:small`, `effort:medium`, `effort:large`, `effort:epic` [VERIFIED - see labels.yaml:169-186]

2. Create `.github/workflows/pr-size-labeler.yaml` with:
   ```yaml
   name: PR Size Labeler
   on:
     pull_request:
       types: [opened, synchronize]
   permissions:
     pull-requests: write
     contents: read
   ```

3. Add job configuration:
   ```yaml
   jobs:
     label-size:
       name: Label PR Size
       runs-on: ubuntu-latest
       timeout-minutes: 5
   ```

4. Add labeler step with size thresholds mapped to effort labels:
   - `xs_label: 'effort:trivial'` with `xs_max_size: '10'`
   - `s_label: 'effort:small'` with `s_max_size: '100'`
   - `m_label: 'effort:medium'` with `m_max_size: '500'`
   - `l_label: 'effort:large'` with `l_max_size: '1000'`
   - `xl_label: 'effort:epic'`

5. Configure `files_to_ignore` with multi-line YAML for auto-generated files:
   ```yaml
   files_to_ignore: |
     "package-lock.json"
     "yarn.lock"
     "pnpm-lock.yaml"
     "*.lock"
     "*.Designer.cs"
     "*.g.cs"
     "*.generated.cs"
     "*.min.js"
     "*.min.css"
   ```

6. Add informative `message_if_xl` for PRs exceeding 1000 lines

7. Add `# Last reviewed: 2026-01-14` header comment

## Testing Strategy

### Unit Tests

Not applicable - this is a GitHub Actions workflow using a third-party action. Unit testing would be the responsibility of the upstream action maintainer.

### Integration Tests

1. **Small PR Test**: Create a PR with < 10 lines of code changes, verify `effort:trivial` label is applied
2. **Medium PR Test**: Create a PR with 100-500 lines of code changes, verify `effort:medium` label is applied
3. **Ignored Files Test**: Create a PR that only modifies `package-lock.json`, verify the actual code change count is used (not including lock file)
4. **Label Update Test**: Push additional commits to an existing PR that crosses a size threshold, verify label is updated (e.g., from `effort:small` to `effort:medium`)
5. **XL Warning Test**: Create a PR with > 1000 lines, verify `effort:epic` label is applied and warning message appears

### Edge Cases

1. **Empty PR**: PR with no file changes (possible via branch manipulations) - should not fail
2. **Only Ignored Files**: PR containing only lock file updates - should apply smallest label or handle gracefully
3. **Large Single File**: PR with all changes in one file vs distributed - size calculation should be consistent
4. **File Deletions**: PR that only deletes files - consider if `ignore_file_deletions` should be enabled
5. **Mixed Additions/Deletions**: PR with large deletions but small additions - default counts both, which may inflate perceived size

## Acceptance Criteria

- [ ] Workflow file exists at `.github/workflows/pr-size-labeler.yaml`
- [ ] Workflow triggers on `pull_request` events (opened, synchronize)
- [ ] PRs with < 10 lines receive `effort:trivial` label
- [ ] PRs with 10-100 lines receive `effort:small` label
- [ ] PRs with 100-500 lines receive `effort:medium` label
- [ ] PRs with 500-1000 lines receive `effort:large` label
- [ ] PRs with > 1000 lines receive `effort:epic` label
- [ ] Lock files are excluded from line count calculation
- [ ] .NET designer/generated files are excluded from line count calculation
- [ ] Minified JS/CSS files are excluded from line count calculation
- [ ] XL PRs display a warning message but do not block merge
- [ ] File includes review date comment following repository conventions
- [ ] Workflow uses appropriate permissions (least privilege)

## Validation Commands

- Run `yamllint .github/workflows/pr-size-labeler.yaml` to verify YAML syntax (if yamllint available)
- Run `actionlint .github/workflows/pr-size-labeler.yaml` to validate GitHub Actions syntax (if actionlint available)
- Manual verification: Create a test PR with a few lines, confirm `effort:trivial` label appears
- Manual verification: Create a test PR modifying only `package-lock.json` plus a few code lines, confirm line count excludes lock file
- Manual verification: Push commits to existing PR to cross a size boundary, confirm label updates

## Notes

### Implementation Decisions

1. **Action Choice**: Using `codelytv/pr-size-labeler@v1` (major version tag) rather than specific patch version for automatic security updates, balanced against stability. Consider pinning to specific SHA for maximum reproducibility.

2. **Threshold Mapping**: The requested thresholds (< 10, 10-100, 100-500, 500-1000, > 1000) align with CodelyTV's default XS/S/M/L/XL boundaries, making configuration straightforward.

3. **Label Reuse**: Mapping to existing `effort:*` labels rather than creating new `size/*` labels reduces label proliferation and aligns PR size with existing effort estimation semantics.

4. **File Exclusions**: The pattern list focuses on .NET ecosystem generated files plus common lock files. Additional patterns may be needed based on specific project requirements.

### Future Enhancements

1. **Fail on XL**: Consider enabling `fail_if_xl: 'true'` in the future if team wants to enforce small PR policy more strictly
2. **Ignore Deletions**: Consider `ignore_file_deletions: 'true'` if large cleanup PRs should not be penalized
3. **Custom Message**: The XL warning message could link to team documentation about PR best practices
4. **Reusable Workflow**: If this proves useful, could be converted to a reusable workflow for org-wide adoption

### Dependencies

- Requires `codelytv/pr-size-labeler` GitHub Action (MIT license, well-maintained with 9.1k+ users)
- Existing labels must be synced to repositories before this workflow will work correctly (use `label-sync.yaml` workflow)

### Related Features

- `label-sync.yaml` - Ensures effort labels exist in repositories
- `release.yaml` - Auto-generated release notes may categorize by effort labels
