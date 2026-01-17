---
description: Audit and update repository README.md to match current contents following .github best practices
allowed-tools: Read, Glob, Grep, Bash(ls:*), Bash(find:*), Bash(tree:*), Bash(wc:*), Write, Edit
argument-hint: [target-readme]
---

# Update README Command

You are tasked with auditing and updating a README.md file to accurately reflect the current repository contents.

## Context

This is a **.github repository** - a special GitHub repository containing:
- Default community health files inherited by all org repositories
- Reusable workflows callable from other repositories
- Workflow templates available to org members
- Organization profile (profile/README.md)
- Automation configurations (dependabot, label sync, etc.)

The root README.md should orient contributors to the repository's PURPOSE and CONTENTS, not duplicate detailed documentation found in individual files.

## Target README

**Target**: $ARGUMENTS

If no argument provided, default to the repository root `README.md`.

## Current Repository State

### Directory Structure
!`tree -L 2 --noreport 2>/dev/null || find . -maxdepth 2 -type d | grep -v ".git" | sort`

### All Markdown and Config Files
!`find . -type f \( -name "*.md" -o -name "*.yaml" -o -name "*.yml" -o -name "*.json" \) | grep -v node_modules | grep -v ".git" | sort`

### Workflow Files
!`ls -1 .github/workflows/ 2>/dev/null || echo "No workflows directory"`

### Current README Content
@README.md

### CLAUDE.md Conventions
@CLAUDE.md

## Workflow Instructions

Execute the following phases in order:

---

### Phase 1: AUDIT

Compare the current README against actual repository contents.

**Tasks:**
1. **File Inventory**: List all files and directories that exist
2. **Documentation Check**: Identify what is documented vs undocumented
3. **Accuracy Check**: Find outdated references (missing files, wrong paths, obsolete descriptions)
4. **Version Check**: Note any version/date discrepancies

**Output format:**
```markdown
## Audit Report

### Undocumented Items
- [file/folder]: [what it is]

### Outdated Documentation
- [item]: [what's wrong]

### Items to Remove
- [documented item that no longer exists]
```

---

### Phase 2: ANALYZE

Based on the audit, determine needed changes.

**Categorize changes:**
- **Additions**: New files/workflows/directories to document
- **Removals**: References to non-existent items
- **Updates**: Descriptions or paths needing correction
- **Reorganization**: Structural improvements

**Output format:**
```markdown
## Change Plan

### Additions
- [item]: [reason]

### Removals
- [item]: [reason]

### Updates
- [item]: [old] → [new]
```

---

### Phase 3: STRUCTURE

Plan the README organization following .github best practices.

**Target characteristics:**
- **Length**: 100-200 lines (scannable in under 2 minutes)
- **Focus**: Orientation, not comprehensive documentation
- **Format**: Tables for structured data, brief descriptions

**Required sections:**
1. Review date comment: `<!-- Last reviewed: YYYY-MM-DD -->`
2. Title with one-sentence purpose
3. Repository structure (tree or table)
4. What's included (tables with concise descriptions)
5. Usage section (quick start for reusable workflows)
6. Review schedule
7. Links to contributing/license

**Avoid:**
- Duplicating content from individual files
- Long prose paragraphs where tables suffice
- Exhaustive documentation (link to detailed docs instead)

---

### Phase 4: WRITE

Produce the updated README following repository conventions.

**Requirements:**
1. Use existing style patterns from the current README
2. Include review date: `<!-- Last reviewed: YYYY-MM-DD -->` with today's date
3. Keep table descriptions under 80 characters
4. Use relative links for internal files
5. Group related items logically
6. Reference conventions from CLAUDE.md (commit messages, labels schema)

---

### Phase 5: VALIDATE

Before finalizing, verify against success criteria:

- [ ] All directories in repository are documented
- [ ] All workflows are listed with accurate descriptions
- [ ] All community health files are referenced
- [ ] File paths are accurate and use correct casing
- [ ] Total line count is 100-200 lines
- [ ] Review date is included and current (today's date)
- [ ] Tables are properly formatted in markdown
- [ ] Links are relative and valid
- [ ] No duplicate content from other files

---

## Output Format

Provide your response with these sections:

### 1. Audit Report
Brief summary of what you found (gaps, outdated items).

### 2. Change Summary
Bullet list of what changed and why (for commit message reference).

### 3. Updated README
The complete, updated README.md content in a code block, ready to save.

### 4. Validation Checklist
Confirmation that all success criteria are met.

---

## Repository Conventions Reference

From CLAUDE.md:
- **Review dates**: `<!-- Last reviewed: YYYY-MM-DD -->` (Markdown) or `# Last reviewed: YYYY-MM-DD` (YAML)
- **Commit messages**: Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`, `ci:`)
- **Labels schema**: Namespaced (`type:*`, `status:*`, `priority:*`, `area:*`, `effort:*`, `scope:*`)
- **Tech context**: .NET 10, C# 14, Clean Architecture
