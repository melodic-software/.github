# Feature: Stale Issue Management

## Feature Description

Automated stale issue and pull request management using `actions/stale@v9` to keep the issue tracker clean and encourage timely resolution of outstanding items. Issues and PRs that remain inactive are automatically labeled as stale with friendly warning messages, then closed if no further activity occurs. Critical work items are exempted to prevent accidental closure of important issues.

## User Story

As a **repository maintainer**, I want **inactive issues and PRs to be automatically marked as stale and eventually closed** so that **the issue tracker remains clean, actionable, and focused on items that are actively being worked on**.

## Problem Statement

Without automated stale management, repositories accumulate inactive issues and PRs over time, making it difficult to:
1. Identify which issues are actually being worked on
2. Prioritize current work against a backlog of potentially outdated requests
3. Maintain an accurate view of project health
4. Encourage contributors to follow up on their submissions

Manual cleanup is time-consuming and inconsistent, leading to abandoned issues languishing indefinitely.

## Solution Statement

Implement a GitHub Actions workflow using `actions/stale@v9` that:
1. Runs daily via cron schedule to check for inactive issues and PRs
2. Marks issues as stale after 60 days of inactivity with a friendly warning comment
3. Closes stale issues after an additional 14 days if no activity occurs
4. Applies shorter timelines for PRs (30 days to stale, 7 days to close) since PRs are more time-sensitive
5. Exempts high-priority and blocked items from stale processing
6. Uses the existing `stale` label from `labels.yml` for consistent labeling
7. Provides helpful messages explaining how to reopen if still relevant

## Relevant Files

### New Files

- `.github/workflows/stale.yml` - GitHub Actions workflow for stale management

### Modified Files

- `CLAUDE.md` - Add documentation about the stale workflow (lines mentioning workflow structure)
- `README.md` - Update repository structure to reference the new workflow (if needed)

### Reference Files (Read-Only)

- `labels.yml` - Contains the existing `stale` label definition (line 225-227)
- `.github/workflows/label-sync.yml` - Example workflow structure to follow (lines 1-43)
- `.github/workflows/reusable-dotnet-build.yml` - Example of workflow permissions and structure (lines 1-116)

## Implementation Plan

### Foundation Phase

1. **Verify Label Exists**: Confirm `stale` label exists in `labels.yml` (already present at line 225-227)
2. **Review Exempt Labels**: Identify labels that should exempt issues from stale processing:
   - `priority:critical` - Blocks release, must never auto-close
   - `priority:high` - Important work, should not auto-close
   - `status:blocked` - Waiting on external dependency
   - `status:on-hold` - Intentionally paused
3. **Design Message Templates**: Create friendly, helpful messages for:
   - Stale warning (issues and PRs)
   - Close notification (issues and PRs)

### Core Phase

4. **Create Workflow File**: Build `.github/workflows/stale.yml` with:
   - Daily cron schedule (`0 0 * * *` - midnight UTC)
   - Workflow dispatch trigger for manual runs
   - Appropriate permissions (issues: write, pull-requests: write)
   - Timeout configuration for safety
   - Review date comment header

5. **Configure Issue Settings**:
   - `days-before-issue-stale: 60` - Mark stale after 60 days
   - `days-before-issue-close: 14` - Close 14 days after stale
   - `stale-issue-message` - Friendly warning message
   - `close-issue-message` - Helpful closure explanation
   - `close-issue-reason: not_planned` - Appropriate close reason

6. **Configure PR Settings**:
   - `days-before-pr-stale: 30` - Mark stale after 30 days (PRs are time-sensitive)
   - `days-before-pr-close: 7` - Close 7 days after stale
   - `stale-pr-message` - PR-specific warning message
   - `close-pr-message` - Helpful PR closure explanation
   - `exempt-draft-pr: true` - Don't mark draft PRs as stale

7. **Configure Exemptions**:
   - `exempt-issue-labels` - Priority and status labels that prevent stale marking
   - `exempt-pr-labels` - Same labels for PRs
   - `exempt-all-milestones: true` - Exempt items with milestones (actively planned)

### Integration Phase

8. **Add Label Management**:
   - Use existing `stale` label from `labels.yml`
   - Consider `labels-to-remove-when-stale` for workflow cleanup

9. **Configure Rate Limiting**:
   - Set `operations-per-run` to reasonable limit (default 30)
   - Enable statistics logging for monitoring

10. **Documentation Updates**:
    - Update CLAUDE.md automation section if needed
    - Ensure workflow follows repository conventions

## Step by Step Tasks

1. Read and verify `stale` label exists in `labels.yml` with correct properties
2. Create `.github/workflows/stale.yml` with review date header comment
3. Configure workflow triggers: daily cron schedule and workflow_dispatch
4. Set appropriate permissions: `issues: write`, `pull-requests: write`
5. Configure `actions/stale@v9` step with all required inputs
6. Set issue timing: 60 days to stale, 14 days to close
7. Set PR timing: 30 days to stale, 7 days to close
8. Write friendly stale-issue-message explaining the situation and how to keep open
9. Write friendly close-issue-message explaining how to reopen
10. Write stale-pr-message specific to pull request context
11. Write close-pr-message explaining PR closure and reopening process
12. Configure exempt-issue-labels: `priority:critical,priority:high,status:blocked,status:on-hold`
13. Configure exempt-pr-labels with same exemptions
14. Enable exempt-draft-pr to protect work-in-progress PRs
15. Enable exempt-all-milestones to protect planned work
16. Set close-issue-reason to `not_planned`
17. Enable statistics logging
18. Validate YAML syntax
19. Test with debug-only mode if desired

## Testing Strategy

### Unit Tests

Not applicable - this is a workflow configuration file with no custom code.

### Integration Tests

- **YAML Validation**: Validate workflow syntax with yamllint
- **Action Configuration**: Verify all required inputs have valid values
- **Label References**: Confirm all referenced labels exist in `labels.yml`
- **Dry Run**: Run workflow with `debug-only: true` to verify behavior without making changes

### Edge Cases

1. **Issue with Multiple Labels**: Ensure exemption works when issue has both stale-eligible and exempt labels
2. **PR with Draft Status**: Verify draft PRs are properly exempted
3. **Items with Milestones**: Confirm milestone-assigned items are exempted
4. **Recently Updated Items**: Verify stale label removal when item receives activity
5. **Rate Limiting**: Confirm workflow handles large backlogs without API rate limit issues
6. **Cross-Repo Behavior**: Note this workflow only affects the `.github` repository itself (org-wide requires additional setup)

## Acceptance Criteria

- [ ] Workflow file `.github/workflows/stale.yml` exists with correct structure
- [ ] Workflow runs daily at midnight UTC via cron schedule
- [ ] Workflow can be triggered manually via workflow_dispatch
- [ ] Issues are marked stale after 60 days of inactivity
- [ ] Issues are closed 14 days after being marked stale
- [ ] PRs are marked stale after 30 days of inactivity
- [ ] PRs are closed 7 days after being marked stale
- [ ] Issues/PRs with `priority:critical` label are exempt
- [ ] Issues/PRs with `priority:high` label are exempt
- [ ] Issues/PRs with `status:blocked` label are exempt
- [ ] Issues/PRs with `status:on-hold` label are exempt
- [ ] Draft PRs are exempt from stale processing
- [ ] Items with milestones are exempt from stale processing
- [ ] Stale warning message is friendly and explains how to keep open
- [ ] Close message explains how to reopen if still relevant
- [ ] Workflow uses existing `stale` label from `labels.yml`
- [ ] Close reason is set to `not_planned` for issues
- [ ] YAML syntax is valid
- [ ] Workflow has appropriate permissions block

## Validation Commands

### YAML Syntax Validation

```bash
# Validate workflow YAML syntax
yamllint .github/workflows/stale.yml

# Alternative: use yq to parse
yq eval '.name' .github/workflows/stale.yml
```

### Label Verification

```bash
# Verify stale label exists in labels.yml
grep -A2 'name: "stale"' labels.yml

# Verify exempt labels exist
grep 'priority:critical\|priority:high\|status:blocked\|status:on-hold' labels.yml
```

### Workflow Dry Run

```bash
# Trigger workflow with debug mode enabled (via GitHub CLI)
gh workflow run stale.yml

# Or manually enable debug-only in the workflow for first run
```

### Manual Verification

1. Navigate to Actions tab in GitHub repository
2. Verify "Stale Issues" workflow appears in workflow list
3. Manually trigger workflow run via "Run workflow" button
4. Review workflow run logs for expected behavior
5. Verify no errors in action execution
6. Check that existing issues are processed correctly (in debug mode first)

## Notes

### Future Enhancements

- **Organization-Wide Deployment**: This workflow only affects the `.github` repository. To apply stale management across all org repos, consider:
  - Creating a reusable workflow that other repos can call
  - Using a GitHub App for org-wide issue management
  - Implementing a scheduled workflow that iterates over org repos (requires PAT)

- **Customizable Timing**: Consider adding workflow_dispatch inputs to allow manual overrides of timing values for testing or special circumstances

- **Statistics Dashboard**: The workflow outputs closed and staled lists - these could be aggregated into a dashboard or notification system

- **Notification Integration**: Could add Slack/Discord notifications when items are about to be closed

### Related Features

- `label-sync.yml` - Ensures the `stale` label exists with correct properties
- `dependabot.yml` - Automated dependency PRs may need special handling (consider exempting `dependencies` label)

### Technical Considerations

- **Rate Limiting**: The default `operations-per-run: 30` may need adjustment for repositories with large backlogs. Increase cautiously to avoid hitting GitHub API limits.

- **Timing**: Running at midnight UTC means different local times for contributors. Consider this when evaluating "days" of inactivity.

- **Stale Label Case Sensitivity**: The action's default stale label is `Stale` (capitalized), but `labels.yml` defines `stale` (lowercase). Configure `stale-issue-label` and `stale-pr-label` to use lowercase to match the existing label.

### Dependencies

- GitHub Actions runners (ubuntu-latest)
- `actions/stale@v9` action
- Existing `stale` label in `labels.yml`
- Repository issues and pull-requests write permissions
