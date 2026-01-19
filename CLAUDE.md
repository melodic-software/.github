# CLAUDE.md

<!-- Last reviewed: 2026-01-19 -->

- Org-level `.github` repo with default community health files inherited by all melodic-software repos
- Tech stack: .NET 10, C# 14, Modular Monoliths, Clean Architecture, CQRS, DDD
- Add review date to all files: `<!-- Last reviewed: YYYY-MM-DD -->` (MD) or `# Last reviewed: YYYY-MM-DD` (YAML)
- Commits: Conventional Commits format (`feat:`, `fix:`, `docs:`, `chore:`, `ci:`)
- Branches: `<type>/<short-description>`, squash merge to `main`
- Labels: namespaced (`type:*`, `status:*`, `priority:*`, `area:*`, `effort:*`, `scope:*`)
- Issue/discussion templates: YAML forms with `type`, `id`, `attributes`, `validations`
- Labels file: `name`, `color` (hex without #), `description`
- Workflow templates require matching `.properties.json` metadata file
- Reusable workflows: `release`, `codeql`, `dotnet-build`, `dependabot-automerge`, `label-sync`, `cross-repo-label-sync`, `pr-size-labeler`, `stale`, `markdown-lint`
- Standards: Contributor Covenant v3.0, CFF v1.2.0, Conventional Commits, SemVer
