# Feature: Community Health Audit and Standardization

## Feature Description

Comprehensive audit, update, and standardization of all community health files, issue/discussion templates, workflows, workflow-templates, and labels in the Melodic Software organization-level `.github` repository. This ensures all files follow modern 2025-2026 best practices, maintain consistency, and provide an excellent contributor experience across the entire organization.

## User Story

As a **maintainer** of Melodic Software projects, I want **all community health documents, templates, workflows, and labels to be audited, modernized, and standardized** so that **contributors have a consistent, well-documented experience across all repositories, and the organization maintains professional community standards**.

## Problem Statement

Organization `.github` repositories require periodic audits to ensure:
1. Community health files remain current with industry standards (Contributor Covenant updates, security policy best practices)
2. Issue and discussion templates capture all necessary information without being overly burdensome
3. Workflows use current action versions and follow security best practices
4. Labels follow a consistent, well-accepted taxonomy that enables efficient triage
5. All files have proper review dates and remain internally consistent
6. Missing standard files are identified and added

## Solution Statement

Conduct a systematic audit of all files in the `.github` repository against modern best practices, identify gaps and improvements, and implement updates to bring everything to current standards. This includes:
- Verifying all community health files against 2025-2026 best practices
- Auditing templates for completeness, accessibility, and usability
- Ensuring workflows use latest stable action versions
- Standardizing label taxonomy across common industry patterns
- Adding any missing standard files
- Establishing a review cadence for ongoing maintenance

## Relevant Files

### Files to Audit/Update (Existing)

#### Community Health Files (Root Level)
- `CODE_OF_CONDUCT.md` - Verify Contributor Covenant v2.1 is latest, check contact email
- `CONTRIBUTING.md` - Verify development workflow, CLA terms, label documentation
- `SECURITY.md` - Verify response timelines, safe harbor, reporting instructions
- `SUPPORT.md` - Verify support channels, response times
- `GOVERNANCE.md` - Verify roles, contribution ladder, decision-making
- `FUNDING.yaml` - Verify GitHub Sponsors configuration
- `CITATION.cff` - Verify CFF v1.2.0 compliance, metadata accuracy
- `CODEOWNERS` - Verify ownership rules, team references
- `README.md` - Verify structure documentation accuracy
- `CLAUDE.md` - Verify agent instructions remain accurate

#### Issue Templates (.github/ISSUE_TEMPLATE/)
- `config.yaml` - Verify contact links, blank issue setting
- `bug-report.yaml` - Audit fields, labels, validation
- `feature-request.yaml` - Audit fields, labels, validation
- `documentation.yaml` - Audit fields, labels, validation
- `chore.yaml` - Audit fields, labels, validation

#### Discussion Templates (.github/DISCUSSION_TEMPLATE/)
- `general.yaml` - Audit fields, labels
- `ideas.yaml` - Audit fields, labels
- `q-a.yaml` - Audit fields, labels
- `announcements.yaml` - Audit fields, labels (should be maintainer-only)
- `show-and-tell.yaml` - Audit fields, labels

#### PR Template
- `.github/PULL_REQUEST_TEMPLATE.md` - Audit checklist items, deployment considerations

#### Reusable Workflows (.github/workflows/)
- `dotnet-build.yaml` - .NET build with caching and test results
- `release.yaml` - GitHub release creation with artifacts
- `codeql.yaml` - CodeQL security analysis
- `label-sync.yaml` - Sync labels from labels.yaml to this repo
- `cross-repo-label-sync.yaml` - Sync labels to all org repos
- `pr-size-labeler.yaml` - Label PRs by size using effort labels
- `stale.yaml` - Mark/close stale issues and PRs
- `dependabot-automerge.yaml` - Auto-merge Dependabot PRs

#### Workflow Templates (workflow-templates/)
- `dotnet-ci.yaml` + `dotnet-ci.properties.json` - Verify action versions, patterns
- `dotnet-release.yaml` + `dotnet-release.properties.json` - Verify action versions

#### Labels
- `labels.yaml` - Audit taxonomy completeness, color consistency, descriptions

#### Organization Profile
- `profile/README.md` - Verify accuracy, badges, links

### New Files to Consider Adding

- `.github/ISSUE_TEMPLATE/security.yaml` - Redirect security issues properly (or update config.yaml)
- `.github/dependabot.yaml` - Organization-wide Dependabot configuration
- `.github/workflows/stale.yaml` - Automated stale issue management
- `.github/workflows/pr-labeler.yaml` - Automatic PR labeling
- `CHANGELOG.md` - Keep a changelog for the .github repo itself
- `.github/release.yaml` - GitHub auto-generated release notes configuration

## Implementation Plan

### Foundation Phase

**Task Group 1: Audit Infrastructure**
1. Review all existing files and document current state (completed in exploration)
2. Research latest versions of referenced standards (Contributor Covenant, CFF, etc.)
3. Identify all action versions and check for updates
4. Document findings in audit checklist format

**Task Group 2: Label Taxonomy Review**
1. Compare current labels against industry standards (GitHub default, CNCF, Microsoft)
2. Identify missing standard labels
3. Review color consistency and accessibility
4. Propose any label additions/changes

### Core Phase

**Task Group 3: Community Health File Updates**
1. Update `CODE_OF_CONDUCT.md` with latest review date, verify v2.1 is current
2. Update `CONTRIBUTING.md` with any workflow changes
3. Update `SECURITY.md` with review date, verify best practices
4. Update `SUPPORT.md` with review date
5. Update `GOVERNANCE.md` with review date
6. Update `CITATION.cff` if any metadata changes needed
7. Update `CODEOWNERS` if team structure changed
8. Update `FUNDING.yaml` if funding options changed

**Task Group 4: Template Improvements**
1. Add consistent `<!-- Last reviewed: YYYY-MM-DD -->` comments to all templates
2. Audit issue templates for:
   - Field completeness
   - Appropriate validations (not too strict)
   - Label consistency with labels.yaml
   - Helpful placeholder text
3. Audit discussion templates for:
   - Field completeness
   - Category appropriateness
   - Label consistency
4. Update PR template with any new checklist items

**Task Group 5: Workflow Modernization**
1. Update all action versions to latest stable:
   - `actions/checkout@v4` (verify latest)
   - `actions/setup-dotnet@v4` (verify latest)
   - `actions/cache@v4` (verify latest)
   - `actions/upload-artifact@v4` (verify latest)
   - `actions/download-artifact@v4` (verify latest)
   - `github/codeql-action/*@v3` (verify latest)
   - `softprops/action-gh-release@v2` (verify latest)
   - `EndBug/label-sync@v2` (verify latest)
   - `dorny/test-reporter@v1` (verify latest)
2. Add any missing security best practices (pinned versions, permissions)
3. Update workflow-templates with same action versions

**Task Group 6: New File Additions**
1. Create `.github/dependabot.yaml` for automated dependency updates
2. Create `.github/release.yaml` for auto-generated release notes configuration
3. Consider `.github/workflows/stale.yaml` for issue hygiene
4. Consider `.github/workflows/pr-labeler.yaml` for automatic labeling

### Integration Phase

**Task Group 7: Labels Finalization**
1. Apply any label taxonomy changes to `labels.yaml`
2. Run label-sync workflow to verify changes
3. Document label usage in CONTRIBUTING.md if not already present

**Task Group 8: Documentation Updates**
1. Update `README.md` with any new files/structure
2. Update `CLAUDE.md` with any new conventions
3. Add review dates to all updated files

**Task Group 9: Validation**
1. Verify all YAML files are syntactically valid
2. Verify all markdown files render correctly
3. Verify all links are valid
4. Verify labels.yaml syncs without errors
5. Test issue/discussion templates in preview mode

## Step by Step Tasks

### Audit Phase
1. Document current action versions in all workflow files
2. Check for newer stable versions of all GitHub Actions
3. Verify Contributor Covenant v2.1 is still the latest version
4. Verify CFF v1.2.0 is still the current format
5. Review GitHub's recommended community health file standards for 2025-2026

### Update Phase - Community Health Files
6. Add/update review date comment in `CODE_OF_CONDUCT.md`
7. Add/update review date comment in `CONTRIBUTING.md`
8. Add review date comment in `SECURITY.md`
9. Verify all contact emails are consistent across files
10. Ensure SECURITY.md mentions private vulnerability reporting

### Update Phase - Templates
11. Audit `bug-report.yaml` for field completeness and usability
12. Audit `feature-request.yaml` for field completeness and usability
13. Audit `documentation.yaml` for field completeness
14. Audit `chore.yaml` for field completeness
15. Audit all discussion templates for consistency
16. Verify `config.yaml` contact links are correct
17. Add review date comments to all template files

### Update Phase - Workflows
18. Update `dotnet-build.yaml` action versions if needed
19. Update `release.yaml` action versions if needed
20. Update `codeql.yaml` action versions if needed
21. Update `label-sync.yaml` action versions if needed
22. Update `workflow-templates/dotnet-ci.yaml` action versions
23. Update `workflow-templates/dotnet-release.yaml` action versions
24. Ensure all workflows have appropriate `permissions` blocks
25. Consider adding SHA pinning for third-party actions

### New Files Phase
26. Create `.github/dependabot.yaml` for GitHub Actions and NuGet updates
27. Create `.github/release.yaml` for release notes categorization
28. Evaluate need for stale issue workflow
29. Evaluate need for PR auto-labeler workflow

### Labels Phase
30. Review `labels.yaml` for completeness against standard taxonomies
31. Verify color accessibility (contrast ratios)
32. Add any missing standard labels (e.g., `stale`, `needs-reproduction`)
33. Ensure label descriptions are clear and actionable

### Documentation Phase
34. Update `README.md` to reflect any new files
35. Update `CLAUDE.md` with any new conventions or files
36. Verify `profile/README.md` badges and links are current

### Validation Phase
37. Validate all YAML syntax
38. Validate all markdown rendering
39. Test issue template preview in GitHub
40. Test discussion template preview in GitHub
41. Run label-sync in dry-run mode

## Testing Strategy

### Unit Tests
- Not applicable (configuration/documentation files, no code)

### Integration Tests
- YAML syntax validation for all `.yaml` files
- Markdown rendering validation for all `.md` files
- Link validation for all internal and external links
- Label sync dry-run execution

### Edge Cases
- Template rendering with all field combinations
- Label sync behavior with new/modified/deleted labels
- Workflow trigger conditions (push, PR, workflow_dispatch)
- CODEOWNERS pattern matching verification

## Acceptance Criteria

### Community Health Files
- [ ] All community health files have `<!-- Last reviewed: YYYY-MM-DD -->` comments
- [ ] CODE_OF_CONDUCT.md uses latest Contributor Covenant version
- [ ] SECURITY.md includes private vulnerability reporting instructions
- [ ] All contact emails are consistent across files
- [ ] FUNDING.yaml is correctly configured

### Templates
- [ ] All issue templates have consistent structure and labels
- [ ] All issue templates have appropriate required/optional field validations
- [ ] All discussion templates have appropriate labels
- [ ] config.yaml disables blank issues and has correct contact links
- [ ] PR template includes all relevant checklist items

### Workflows
- [ ] All GitHub Actions are on latest stable versions
- [ ] All workflows have appropriate `permissions` blocks
- [ ] All workflows follow security best practices
- [ ] Workflow templates match reusable workflow configurations

### Labels
- [ ] labels.yaml covers all standard label categories
- [ ] Labels have consistent naming convention (`category:value`)
- [ ] Labels have accessible color choices
- [ ] Labels have clear, actionable descriptions
- [ ] Label categories: type, status, priority, area, effort, scope, special

### Documentation
- [ ] README.md accurately describes repository structure
- [ ] CLAUDE.md reflects current conventions
- [ ] profile/README.md has current information and working links

### New Files
- [ ] dependabot.yaml created for automated updates
- [ ] release.yaml created for release notes configuration

## Validation Commands

### YAML Validation
```bash
# Validate all YAML files (requires yq or yamllint)
find . -name "*.yaml" -o -name "*.yaml" | xargs -I {} yamllint {}
```

### Markdown Validation
```bash
# Validate all markdown files (requires markdownlint-cli)
markdownlint "**/*.md" --ignore node_modules
```

### Link Validation
```bash
# Validate links in markdown files (requires lychee or markdown-link-check)
lychee --exclude-mail "**/*.md"
```

### Label Sync Dry Run
```bash
# Trigger label-sync workflow in dry-run mode via GitHub Actions UI
# Or use gh CLI:
gh workflow run label-sync.yaml -f dry-run=true
```

### Manual Verification
1. Navigate to repository Settings > General > Features to verify issue/discussion templates
2. Create new issue (don't submit) to preview each template
3. Create new discussion (don't submit) to preview each template
4. Verify profile README displays correctly at github.com/melodic-software

## Notes

### Future Enhancements
- Consider adding `.github/workflows/welcome.yaml` for first-time contributor greeting
- Consider adding `.github/workflows/auto-assign.yaml` for reviewer assignment
- Consider adding `.github/CONTRIBUTING_TEMPLATE/` for repo-specific contribution guides
- Evaluate GitHub Copilot workspace integration files

### Related Standards
- [Contributor Covenant](https://www.contributor-covenant.org/) - Code of Conduct
- [Citation File Format](https://citation-file-format.github.io/) - CITATION.cff
- [Conventional Commits](https://www.conventionalcommits.org/) - Commit messages
- [Keep a Changelog](https://keepachangelog.com/) - Changelog format
- [Semantic Versioning](https://semver.org/) - Version numbering

### Review Schedule
- Quarterly review of community health files
- Monthly review of action versions for security updates
- Annual review of label taxonomy
- As-needed review when GitHub introduces new features

### Technical Debt
- Consider migrating from EndBug/label-sync to GitHub's native label management when available
- Consider using GitHub's reusable workflow features more extensively
- Evaluate GitHub Projects integration for label-based automation

### Dependencies
- GitHub Actions runners (ubuntu-latest)
- .NET 10 SDK for workflow templates
- GitHub API access for label sync
- GitHub Discussions feature enabled for org
