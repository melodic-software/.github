# Feature: Markdown Linting

## Feature Description

Add automated markdown linting validation to the organization's `.github` repository using `markdownlint-cli2`. This ensures all markdown documentation follows consistent formatting standards, improving readability and maintainability across the organization's community health files, templates, and documentation.

## User Story

As a repository maintainer, I want automated markdown linting so that documentation follows consistent quality standards and formatting issues are caught before they enter the main branch.

## Problem Statement

Currently, markdown files in the repository lack automated quality validation. This can lead to:

- Inconsistent formatting across documentation files
- Trailing whitespace and extra blank lines accumulating
- Heading hierarchy issues that affect document structure
- Poor accessibility for screen readers and markdown parsers
- Inconsistent style that creates friction in code reviews

## Solution Statement

Implement markdown linting using `markdownlint-cli2` with:

1. **Configuration file** (`.markdownlint-cli2.jsonc`) - Single source of truth for linting rules
2. **GitHub Actions workflow** (`.github/workflows/markdown-lint.yaml`) - Automated validation on PRs and pushes
3. **npm package configuration** (`package.json`) - Local development scripts for running linting
4. **Initial remediation** - Fix existing linting errors in all markdown files

This solution follows the unified tooling architecture where the same configuration is used by CLI, VS Code extension, and GitHub Actions.

## Relevant Files

### New Files

- `.markdownlint-cli2.jsonc` (markdownlint configuration - single source of truth)
- `.github/workflows/markdown-lint.yaml` (GitHub Actions workflow for CI validation)
- `package.json` (npm scripts for local linting)
- `.gitignore` (add node_modules exclusion if not present)

### Modified Files

- `.github/dependabot.yaml` (add npm ecosystem for markdownlint updates)
- `CLAUDE.md` (document markdown linting workflow and conventions)
- `README.md` (add markdown linting to workflows section)
- All `*.md` files (fix existing linting errors)

## Implementation Plan

### Foundation Phase

1. **Create `.markdownlint-cli2.jsonc` configuration file:**
   - Enable all default rules (`"default": true`)
   - Disable MD013 (line length) - common for documentation with tables and links
   - Configure MD033 to allow specific HTML elements if needed (e.g., `<br>`, `<details>`, `<summary>`)
   - Enable `gitignore: true` to automatically respect `.gitignore`
   - Add ignores for `node_modules/**` and any generated files

2. **Create `package.json` for npm scripts:**
   - Add `lint:md` script for validation
   - Add `lint:md:fix` script for auto-fixing
   - Pin `markdownlint-cli2` to stable version (^0.20.0)
   - Set `engines.node` to `>=20.0.0`
   - Mark as `private: true` (not for publishing)

3. **Add `node_modules/` to `.gitignore`:**
   - Check if already present
   - Add if missing

### Core Phase

4. **Create GitHub Actions workflow `.github/workflows/markdown-lint.yaml`:**
   - Trigger on `pull_request` with path filter for `**.md` files
   - Trigger on `push` to `main` with path filter for `**.md` files
   - Use `actions/checkout@v5` for code checkout
   - Use `DavidAnson/markdownlint-cli2-action@v26` for linting
   - Configure appropriate permissions (`contents: read`)
   - Add timeout of 5 minutes
   - Add review date comment per repository conventions

5. **Update `.github/dependabot.yaml`:**
   - Add `npm` package ecosystem entry
   - Configure weekly updates (same schedule as GitHub Actions)
   - Apply appropriate labels (`type:chore`, `area:ci-cd`, `dependencies`)
   - Group npm dependencies together

### Integration Phase

6. **Run initial linting to identify existing issues:**
   - Execute `npx markdownlint-cli2 "**/*.md"` to get baseline
   - Document count of errors by rule

7. **Fix existing markdown linting errors:**
   - Run auto-fix: `npx markdownlint-cli2 "**/*.md" --fix`
   - Manually fix remaining "unfixable" errors
   - Re-run linting to verify all errors resolved

8. **Update documentation:**
   - Add markdown linting section to `CLAUDE.md` under Automation Files
   - Update `README.md` to list markdown-lint workflow in Automation Workflows table

9. **Final validation:**
   - Run linting locally to ensure clean state
   - Verify workflow file syntax with actionlint (if available)
   - Test by creating a PR with the changes

## Step by Step Tasks

1. Create `.markdownlint-cli2.jsonc` in repo root with:

   ```jsonc
   {
     "gitignore": true,
     "config": {
       "default": true,
       "MD013": false,
       "MD033": {
         "allowed_elements": ["br", "details", "summary"]
       }
     }
   }
   ```

2. Create `package.json` in repo root with lint scripts and markdownlint-cli2 dependency

3. Verify `.gitignore` contains `node_modules/`; add if missing

4. Create `.github/workflows/markdown-lint.yaml` following existing workflow patterns (see `label-sync.yaml`, `stale.yaml` for conventions)

5. Update `.github/dependabot.yaml` to add npm ecosystem with weekly schedule

6. Run `npm install` to install dependencies

7. Run `npm run lint:md` to identify all existing linting errors

8. Run `npm run lint:md:fix` to auto-fix fixable errors

9. Manually fix remaining errors following the intelligent fixing approach

10. Update `CLAUDE.md` to document the markdown linting configuration

11. Update `README.md` to add markdown-lint workflow to the Automation Workflows table

12. Run final validation: `npm run lint:md` should exit with code 0

## Testing Strategy

### Unit Tests

Not applicable - this is a configuration and GitHub Actions workflow. The underlying `markdownlint-cli2` tool is tested by its maintainers.

### Integration Tests

1. **Local Linting Test:**
   - Run `npm run lint:md` on clean codebase
   - Verify exit code 0 (no errors)
   - Introduce a deliberate error (e.g., trailing space)
   - Verify linting catches the error
   - Remove the error

2. **Auto-Fix Test:**
   - Add trailing spaces to a test file
   - Run `npm run lint:md:fix`
   - Verify spaces are removed
   - Discard changes

3. **GitHub Actions Test:**
   - Create a test PR modifying a markdown file
   - Verify workflow triggers
   - Verify workflow passes on compliant changes
   - Optionally: Add a deliberate error to verify failure detection

4. **Configuration Test:**
   - Verify `.markdownlint-cli2.jsonc` is read correctly
   - Test that disabled rules (MD013) don't produce errors
   - Test that enabled rules produce appropriate errors

### Edge Cases

1. **Empty markdown file:** Should pass linting (no content to lint)
2. **Files in `.gitignore`:** Should be automatically excluded
3. **Files in `node_modules/`:** Should be excluded
4. **Non-markdown files:** Should be ignored (not processed)
5. **Nested code blocks:** Should handle markdown-within-markdown correctly (see CONTRIBUTING.md examples)
6. **HTML in markdown:** Allowed elements (br, details, summary) should not trigger MD033

## Acceptance Criteria

- [ ] `.markdownlint-cli2.jsonc` exists with appropriate rules configuration
- [ ] `package.json` exists with `lint:md` and `lint:md:fix` scripts
- [ ] `node_modules/` is in `.gitignore`
- [ ] `.github/workflows/markdown-lint.yaml` exists and follows repo conventions
- [ ] Workflow triggers on PRs modifying `**.md` files
- [ ] Workflow triggers on push to main modifying `**.md` files
- [ ] `.github/dependabot.yaml` includes npm ecosystem configuration
- [ ] All existing markdown files pass linting (zero errors)
- [ ] `CLAUDE.md` documents markdown linting workflow
- [ ] `README.md` lists markdown-lint workflow in automation section
- [ ] Workflow file includes review date comment
- [ ] `npm run lint:md` executes successfully
- [ ] `npm run lint:md:fix` executes successfully
- [ ] GitHub Actions workflow passes on the implementing PR

## Validation Commands

- Run `npm install` to install dependencies
- Run `npm run lint:md` to verify all markdown files pass linting
- Run `npm run lint:md:fix` to auto-fix any issues (should report "no changes needed" if already clean)
- Run `npx markdownlint-cli2 --help` to verify CLI is available
- Manual verification: Create a test PR with a markdown change, confirm workflow runs
- Manual verification: Add a deliberate error, confirm workflow fails
- Manual verification: Check Actions tab for "Markdown Lint" workflow

## Notes

### Implementation Decisions

1. **Configuration File Format:** Using `.markdownlint-cli2.jsonc` (JSON with comments) for:
   - Human-readable with inline documentation
   - Single source of truth for all tools (CLI, VS Code, CI)
   - Supports all markdownlint-cli2 options

2. **Disabled Rules:**
   - `MD013` (line length): Disabled because documentation often contains long URLs, tables, and code examples that shouldn't be wrapped
   - Other rules enabled by default for maximum quality enforcement

3. **Allowed HTML Elements:**
   - `<br>`: For intentional line breaks
   - `<details>`/`<summary>`: For collapsible sections (GitHub-supported)

4. **Action Version:** Using `DavidAnson/markdownlint-cli2-action@v26` (latest stable major version) for automatic minor/patch updates with stability

5. **Workflow Naming:** Using `markdown-lint.yaml` with `.yaml` extension to match existing workflow conventions in this repo

### Future Enhancements

1. **VS Code Integration:** Add `.vscode/settings.json` with markdownlint extension configuration for auto-fix on save
2. **Pre-commit Hook:** Add husky/lint-staged for local pre-commit validation
3. **Reusable Workflow:** Convert to reusable workflow for org-wide adoption
4. **Auto-fix in CI:** Consider adding auto-fix with commit for trivial errors (not recommended for most use cases)

### Dependencies

- `markdownlint-cli2` npm package (MIT license, actively maintained by David Anson)
- `DavidAnson/markdownlint-cli2-action` GitHub Action (MIT license)
- Node.js 20+ (for npm scripts)

### Related Features

- `label-sync.yaml` - Follows similar workflow patterns
- `stale.yaml` - Example of automation workflow with review date comment
- `dependabot.yaml` - Will be updated to include npm ecosystem
- `code-quality:markdown-linting` skill - Provides guidance for using the linting tools

### References

- [markdownlint-cli2 GitHub](https://github.com/DavidAnson/markdownlint-cli2)
- [markdownlint Rules Documentation](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md)
- [markdownlint-cli2-action GitHub](https://github.com/DavidAnson/markdownlint-cli2-action)
- [code-quality:markdown-linting skill](references from installed plugin)
