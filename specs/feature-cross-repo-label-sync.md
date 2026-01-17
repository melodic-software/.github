# Feature: Cross-Repo Label Sync

## Feature Description

A GitHub Actions workflow that synchronizes labels from the organization's `.github` repository to all other repositories in the melodic-software organization. This enables consistent labeling across the entire organization, ensuring that all repositories share the same label taxonomy defined in `labels.yaml`.

## User Story

As a **maintainer** of the Melodic Software organization, I want **labels to be automatically synchronized from the central .github repository to all other organization repositories** so that **all repositories have a consistent labeling scheme for issues and PRs, reducing confusion and enabling cross-repo reporting**.

## Problem Statement

Currently, the `label-sync.yaml` workflow only syncs labels to the `.github` repository itself. Other repositories in the organization (medley, citadel, identity-server, membrain, etc.) must manually maintain their labels, leading to:

1. Inconsistent label names and colors across repositories
2. Manual effort to keep labels synchronized
3. Difficulty generating organization-wide reports based on labels
4. New repositories starting with GitHub's default labels instead of the organization's taxonomy

## Solution Statement

Create a new workflow `cross-repo-label-sync.yaml` that:

1. Uses a matrix strategy to iterate over a configurable list of target repositories
2. Leverages EndBug/label-sync to apply labels from `labels.yaml` to each repository
3. Requires a PAT with `repo` scope (stored as `LABEL_SYNC_PAT` org secret) for cross-repo access
4. Triggers on push to `labels.yaml` and supports manual trigger with dry-run option
5. Uses `continue-on-error` to prevent one repo failure from stopping the entire sync
6. Generates a job summary showing success/failure status for each repository

## Relevant Files

### New Files

- `.github/workflows/cross-repo-label-sync.yaml` (main workflow implementing cross-repo sync)

### Modified Files

- `CLAUDE.md` (document the new workflow in the Reusable Workflows table)

## Implementation Plan

### Foundation Phase

1. **Design repository list configuration**
   - Define the list of target repositories as a workflow input with a default JSON array
   - Include: medley, citadel, identity-server, membrain, and placeholders for future repos
   - Use `fromJson()` to parse the repository list for matrix strategy

2. **Configure workflow triggers**
   - Push trigger on `labels.yaml` changes (path filter)
   - `workflow_dispatch` with `dry-run` boolean input
   - Consider schedule trigger for periodic sync (optional)

3. **Set up permissions and secrets**
   - Document requirement for `LABEL_SYNC_PAT` org secret with `repo` scope
   - Use minimal workflow permissions (`contents: read`)
   - PAT provides cross-repo write access for labels

### Core Phase

4. **Implement matrix strategy**
   - Define matrix with `repo` variable from repository list
   - Set `fail-fast: false` to continue on individual failures
   - Use `max-parallel` to limit concurrent API calls (avoid rate limiting)

5. **Implement label sync step**
   - Checkout `.github` repository to access `labels.yaml`
   - Use EndBug/label-sync@v2 with:
     - `config-file: ./labels.yaml`
     - `dry-run: ${{ inputs.dry-run || false }}`
     - `delete-other-labels: false` (preserve repo-specific labels)
     - `token: ${{ secrets.LABEL_SYNC_PAT }}`
   - Target repository via `repository` input (if supported) or environment variable

6. **Handle EndBug/label-sync repository targeting**
   - Research: EndBug/label-sync uses `GITHUB_REPOSITORY` to determine target
   - Solution: Use `gh api` to apply labels via GitHub API, OR
   - Alternative: Create a checkout step with the target repo and run label-sync there
   - Best approach: Use the label-sync action's token to auth to different repos

### Integration Phase

7. **Implement error handling**
   - Add `continue-on-error: true` at the job level
   - Capture step outcomes for reporting
   - Use `if: always()` for summary generation step

8. **Generate job summary**
   - Create summary step that runs `if: always()`
   - Use `$GITHUB_STEP_SUMMARY` to write markdown report
   - Include table with repo name, status (✅/❌), and error message if failed
   - Show total counts: succeeded, failed, skipped

9. **Update documentation**
   - Add workflow to CLAUDE.md reusable workflows table
   - Document LABEL_SYNC_PAT secret requirement
   - Document how to add new repositories to the sync list

## Step by Step Tasks

1. Create `.github/workflows/cross-repo-label-sync.yaml` with workflow metadata and triggers
2. Add `workflow_dispatch` input for `dry-run` boolean option
3. Add `workflow_dispatch` input for optional repository list override
4. Define the default repository list as a JSON array in the workflow
5. Create the `sync` job with matrix strategy iterating over repositories
6. Set `fail-fast: false` and `max-parallel: 3` on the matrix strategy
7. Add checkout step to get the `labels.yaml` file from `.github` repo
8. Research and implement correct EndBug/label-sync invocation for cross-repo sync
9. Add `continue-on-error: true` to the label-sync step
10. Create output capture for step success/failure status
11. Add final summary job that depends on sync job
12. Implement job summary markdown generation with repo status table
13. Test workflow syntax with `act` or GitHub's workflow validator
14. Update CLAUDE.md to document the new workflow
15. Create PR with comprehensive description

## Testing Strategy

### Unit Tests

- Not applicable (YAML workflow configuration, no code)

### Integration Tests

1. **Dry-run validation**: Trigger workflow with `dry-run: true` and verify:
   - No labels are actually created/modified in target repos
   - Summary shows expected repositories in pending state
   - Workflow completes successfully

2. **Single repository test**: Run against a test repository first:
   - Create a test repo in the org or use a sandbox
   - Verify labels are created correctly
   - Verify existing labels are updated (color, description)
   - Verify aliases work correctly (rename labels)

3. **Error handling test**: Intentionally include a non-existent repo:
   - Verify workflow continues despite the failure
   - Verify summary shows failure status for that repo
   - Verify other repos still get synced

4. **Manual trigger test**: Use workflow_dispatch with custom repo list:
   - Override default repos with a subset
   - Verify only specified repos are processed

### Edge Cases

1. **Repository doesn't exist**: Matrix job fails, other repos continue
2. **PAT lacks access to repo**: Job fails with auth error, others continue
3. **Rate limiting**: `max-parallel` setting prevents overwhelming API
4. **Large repository list**: Verify matrix job limit (256 max) is respected
5. **Empty repository list**: Workflow should handle gracefully
6. **Labels with special characters**: Ensure YAML parsing handles correctly
7. **Concurrent runs**: Multiple pushes to labels.yaml in quick succession

## Acceptance Criteria

- [ ] Workflow triggers on push to `labels.yaml` in main branch
- [ ] Workflow supports manual trigger via `workflow_dispatch`
- [ ] Dry-run option prevents actual label changes when enabled
- [ ] Matrix strategy iterates over configurable list of repositories
- [ ] One repository failure does not stop sync to other repositories
- [ ] Job summary displays table with each repo's sync status
- [ ] Summary shows ✅ for success, ❌ for failure with error details
- [ ] Summary shows total counts (succeeded, failed, skipped)
- [ ] Workflow uses `LABEL_SYNC_PAT` secret for cross-repo authentication
- [ ] `delete-other-labels` is set to `false` to preserve repo-specific labels
- [ ] Workflow completes within reasonable time (< 10 minutes for ~5 repos)
- [ ] CLAUDE.md is updated with new workflow documentation

## Validation Commands

### YAML Syntax Validation

```bash
# Validate workflow YAML syntax
yamllint .github/workflows/cross-repo-label-sync.yaml

# Or use GitHub's workflow validator (via gh CLI extension)
gh extension install muno92/gh-workflow-validator
gh workflow-validator .github/workflows/cross-repo-label-sync.yaml
```

### Dry Run Test

```bash
# Trigger workflow in dry-run mode via GitHub CLI
gh workflow run cross-repo-label-sync.yaml -f dry-run=true

# Monitor the workflow run
gh run watch
```

### Manual Verification

1. Navigate to Actions tab in melodic-software/.github repository
2. Select "Cross-Repo Label Sync" workflow
3. Click "Run workflow" → Enable "Dry run" → Run
4. Verify job summary shows all target repositories
5. Disable dry-run and run against a single test repo first
6. Verify labels appear correctly in target repository

### Post-Sync Verification

```bash
# List labels in a target repository to verify sync
gh label list --repo melodic-software/medley

# Compare with source labels
gh label list --repo melodic-software/.github
```

## Notes

### Implementation Detail: EndBug/label-sync Repository Targeting

The EndBug/label-sync action by default operates on the repository where the workflow runs. To sync to a different repository, we need to:

1. **Option A (Recommended)**: The action respects the `GITHUB_TOKEN` or custom token's target. Use the GitHub API directly or modify the repository context.

2. **Option B**: Use the GitHub CLI (`gh label`) with a loop instead of the action. This provides more control over targeting.

3. **Option C**: For each repo in the matrix, checkout that repo and run label-sync with `GITHUB_TOKEN` replaced by PAT.

Research indicates EndBug/label-sync v2 syncs to the repo specified by `$GITHUB_REPOSITORY` context. To override this:
- The `token` input authenticates to GitHub API
- The target repo is implicit from the workflow context
- May need to use `gh api` calls directly for cross-repo sync

**Final approach**: Use a combination of checkout with the target repo and label-sync, OR call the GitHub Labels API directly using `gh api` for maximum control.

### Future Enhancements

- Add Slack/Teams notification on sync completion
- Support label deletion sync (opt-in, dangerous)
- Auto-discover repositories in org instead of hardcoded list
- Add label diff preview in dry-run mode
- Support repo-specific label additions (merge mode)

### Related Features

- `label-sync.yaml` - Existing workflow for `.github` repo only
- `labels.yaml` - Source of truth for organization labels
- Future: Label-based automation workflows (auto-assign, project boards)

### Security Considerations

- `LABEL_SYNC_PAT` must have `repo` scope for private repos or `public_repo` for public only
- PAT should be scoped to organization (not user account)
- Consider using GitHub App instead of PAT for better auditability
- Never log the PAT value; use secret masking
- Limit PAT to specific repositories if possible

### Repository List (Initial)

```yaml
repos:
  - medley
  - citadel
  - identity-server
  - membrain
  # Add new repos here as they are created
```

### Dependencies

- srealmoreno/label-sync-action@v2 (natively supports multi-repo sync)
- GitHub CLI (gh) - pre-installed on ubuntu-latest
- `LABEL_SYNC_PAT` organization secret with Issues: Read and write permission
- GitHub Actions runners (ubuntu-latest)

### PAT Creation Steps (Fine-grained Token)

To create or regenerate the `LABEL_SYNC_PAT` token:

1. **Navigate to PAT creation page**
   - Go to: https://github.com/settings/personal-access-tokens/new

2. **Configure token basics**
   - **Token name**: `Cross-Repo Label Sync`
   - **Description**: `PAT for syncing labels from .github repo to all organization repositories`
   - **Resource owner**: Select `melodic-software` (organization)
   - **Expiration**: `366 days` (maximum allowed by org policy)

3. **Configure repository access**
   - Select: **All repositories**
   - This applies to all current and future repositories in the organization

4. **Add permissions**
   - Click **+ Add permissions**
   - Search for `Issues`
   - Check **Issues** checkbox
   - Change access level from "Read-only" to **Read and write**
   - Note: **Metadata (Required)** will be auto-added as Read-only

5. **Generate and save token**
   - Click **Generate token**
   - **Copy the token immediately** (you won't see it again!)

6. **Add as repository secret**
   - Go to: https://github.com/melodic-software/.github/settings/secrets/actions
   - Click **New repository secret**
   - **Name**: `LABEL_SYNC_PAT`
   - **Value**: Paste the token
   - Click **Add secret**

7. **Test the workflow**
   - Go to: https://github.com/melodic-software/.github/actions/workflows/cross-repo-label-sync.yaml
   - Click **Run workflow** → **Run workflow**
   - Verify all target repositories sync successfully

### Token Renewal Reminder

The token expires after 366 days. Set a calendar reminder for ~350 days to regenerate before expiration. When renewing:
1. Create new token following steps above
2. Update the `LABEL_SYNC_PAT` organization secret with new value
3. Delete the old token from https://github.com/settings/tokens
