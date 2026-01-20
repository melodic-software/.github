<!-- Last reviewed: 2026-01-20 -->

<div align="center">

# Melodic Software

**Building software that sings.**

Engineering-led. Quality-focused. Future-ready.

Where code finds its rhythm — crafting maintainable .NET systems through modular architecture, clean patterns, and deliberate design.

---

[![GitHub Org Stars](https://img.shields.io/github/stars/melodic-software?style=for-the-badge&logo=github&label=Org%20Stars&color=1E90FF)](https://github.com/melodic-software)
[![.NET](https://img.shields.io/badge/.NET%2010-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)](https://dotnet.microsoft.com/)
[![Discussions](https://img.shields.io/badge/Discussions-Join-1E90FF?style=for-the-badge&logo=github&logoColor=white)](https://github.com/orgs/melodic-software/discussions)
[![Clone Medley](https://img.shields.io/badge/Clone_Medley-1E90FF?style=for-the-badge&logo=github&logoColor=white)](https://github.com/melodic-software/medley)
![Visitors](https://komarev.com/ghpvc/?username=melodic-software&color=1E90FF&style=for-the-badge&label=Visitors)

---

### Stats Dashboard

| **Repositories** | **Stars** | **Contributors** | **Updated** |
| :---: | :---: | :---: | :---: |
| [![Public Repos](https://img.shields.io/badge/Public_Repos-2-1E90FF?style=flat-square&logo=github)](https://github.com/orgs/melodic-software/repositories) | [![Total Stars](https://img.shields.io/github/stars/melodic-software?style=flat-square&color=1E90FF&label=Total)](https://github.com/melodic-software) | [![Contributors](https://img.shields.io/github/contributors/melodic-software/medley?style=flat-square&color=1E90FF)](https://github.com/melodic-software/medley/graphs/contributors) | ![Updated](https://img.shields.io/badge/Last_Update-January_2026-512BD4?style=flat-square) |

---

[About](#about) | [Tech](#tech-stack) | [Philosophy](#engineering-philosophy) | [Start](#getting-started) | [Projects](#featured-repositories) | [Status](#project-status) | [Contribute](#contributing--community) | [Roadmap](#whats-next) | [Support](#support-the-project) | [Connect](#connect)

</div>

---

## About

Melodic Software is the independent software studio of **Kyle Sexton**, focused on crafting maintainable systems that scale gracefully. The studio specializes in **Modular Monolith** architectures, leveraging the full power of the **.NET ecosystem** to build robust solutions without the premature complexity of microservices.

Like a well-composed piece of music, great software requires harmony between its components — each module playing its part while contributing to a cohesive whole.

---

<div align="center">

### Tech Stack

*Building on the cutting edge of the Microsoft ecosystem*

#### Architectural Patterns

| **Pattern** | **Purpose** | **Implementation** |
| :---: | :--- | :--- |
| ![Modular Monolith](https://img.shields.io/badge/Modular_Monolith-512BD4?style=flat-square) | Bounded contexts with deployment simplicity | Module-per-folder with explicit boundaries |
| ![Vertical Slice](https://img.shields.io/badge/Vertical_Slice-512BD4?style=flat-square) | Feature-organized code | REPR pattern, minimal layering for simple features |
| ![Clean Architecture](https://img.shields.io/badge/Clean_Architecture-512BD4?style=flat-square) | Dependency inversion for testability | Domain → Application → Infrastructure |
| ![CQRS](https://img.shields.io/badge/CQRS-512BD4?style=flat-square) | Separate read/write concerns | MediatR handlers with distinct models |
| ![DDD](https://img.shields.io/badge/Domain--Driven_Design-512BD4?style=flat-square) | Business logic in the domain | Aggregates, Value Objects, Domain Events |

#### Core Technologies

| **Runtime** | **Frontend** | **Cloud Native** | **Security** |
| :---: | :---: | :---: | :---: |
| ![.NET](https://img.shields.io/badge/.NET%2010-512BD4?style=flat-square&logo=dotnet&logoColor=white) | ![Blazor](https://img.shields.io/badge/Blazor-512BD4?style=flat-square&logo=blazor&logoColor=white) | ![Aspire](https://img.shields.io/badge/Aspire-512BD4?style=flat-square&logo=dotnet&logoColor=white) | ![Duende](https://img.shields.io/badge/Duende_IdentityServer-6E45AF?style=flat-square) |
| **C# 14** | **Interactive Auto** | **YARP & OpenTelemetry** | **STS, BFF Pattern** |

| **Data** | **Messaging** | **Real-time** | **Testing** | **DevOps** |
| :---: | :---: | :---: | :---: | :---: |
| ![EF Core](https://img.shields.io/badge/EF_Core-512BD4?style=flat-square&logo=dotnet&logoColor=white) | ![MassTransit](https://img.shields.io/badge/MassTransit-1266CC?style=flat-square) | ![SignalR](https://img.shields.io/badge/SignalR-512BD4?style=flat-square&logo=dotnet&logoColor=white) | ![xUnit](https://img.shields.io/badge/xUnit-0A7D9C?style=flat-square) | ![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat-square&logo=githubactions&logoColor=white) |
| **SQL Server** | **Azure Service Bus, RabbitMQ** | **WebSockets** | **Shouldly, NSubstitute, Testcontainers** | **Aspire, Docker** |

<details>
<summary><b>💡 Why These Technology Choices?</b></summary>
<div align="left">

### Architectural Decisions

**Right-Sized Architecture**
- Simple apps get pure vertical slices (REPR pattern / Fast Endpoints style) — no unnecessary layers
- Complex domains get the full stack: Modular Monolith + Clean Architecture + DDD + vertical slices
- The goal is always the simplest architecture that solves the actual problem

**Modular Monolith over Microservices**
- Microservices add distributed systems complexity without corresponding business benefits at our scale
- Monolith maintains single deployment unit while allowing modular organization
- Easy to split into microservices later if business needs truly require it

**Clean Architecture (When Warranted)**
- Separates business logic from infrastructure concerns
- Domain layer remains independent and testable
- Overkill for simple CRUD apps — use vertical slices instead

**DDD (Selectively)**
- Applied only in complex domains where business rules justify the investment
- Not every bounded context needs aggregates and domain events
- Simple modules can use straightforward data access patterns

**CQRS (Not Everywhere)**
- Applied only where read/write patterns truly diverge
- Most features work fine with simple CRUD
- Prevents premature architectural complexity

**.NET 10 + C# 14**
- Strong typing with modern language features (records, patterns, nullable reference types)
- Mature ecosystem with production-proven patterns
- Performance characteristics required for real-time applications
- Superior to scripted languages for enterprise systems at scale

**Blazor over Traditional SPA Frameworks**
- Single language (C#) from backend to frontend
- No JavaScript framework fatigue
- Server and client logic in same codebase when beneficial
- Type safety across entire stack

**Entity Framework Core**
- ORM eliminates repetitive SQL boilerplate
- Migrations provide infrastructure-as-code for database schema
- LINQ provides type-safe queries
- Fully async/await support

**Docker + GitHub Actions**
- Infrastructure as code for reproducible builds
- GitHub Actions integrated directly in version control
- No vendor lock-in to external CI/CD platforms
- Fast feedback loops on every commit

</div>
</details>

</div>

---

## Engineering Philosophy

High standards ensure the codebase remains clean and adaptive.

| Principle | Description |
|-----------|-------------|
| **Orchestrated Architecture** | The choice of architecture depends on the size, scale, and scope of a project. Main applications use modular monolith, clean architecture, vertical slice architecture, or a combination of the three. |
| **Compile-Time Guardrails** | Custom Roslyn analyzers enforce architectural rules *while coding* — catching dissonance before it reaches production. |
| **Trunk-Based Cadence** | Small, frequent changes to `main` using feature flags and short-lived branches. A steady rhythm of continuous delivery. |
| **Architecture as Code** | Automated tests verify layer dependencies and domain isolation. |

---

## Getting Started

Ready to join the ensemble? Here's how to get started in **three measures**:

<div align="center">

| **Step** | **Action** | **Description** |
| :---: | :--- | :--- |
| **1** | [Explore the Reference](https://github.com/melodic-software/medley) | Browse Medley to see patterns in action |
| **2** | Clone & Run | `git clone https://github.com/melodic-software/medley.git && cd medley && dotnet run` |
| **3** | [Join the Discussion](https://github.com/orgs/melodic-software/discussions) | Ask questions, share ideas, connect with the community |

</div>

> **Prerequisites**: [.NET 10 SDK](https://dotnet.microsoft.com/download), [Docker Desktop](https://www.docker.com/products/docker-desktop/) (for Aspire)

### Project Structure at a Glance

```
Medley/
├── src/
│   ├── Modules/                    # Bounded contexts (Users, Orders, Products, etc.)
│   │   ├── Users/
│   │   │   ├── Domain/            # Business rules & aggregates
│   │   │   ├── Application/       # Use cases & handlers
│   │   │   └── Infrastructure/    # Data access & external services
│   │   └── ...other modules
│   ├── Shared/                     # Cross-cutting concerns
│   │   ├── Constants/
│   │   ├── Middleware/
│   │   └── Extensions/
│   ├── Web/                        # Blazor UI & API endpoints
│   │   ├── Components/            # Blazor interactive components
│   │   ├── Pages/                 # Routable pages
│   │   └── Endpoints/             # Minimal API routes
│   └── AppHost/                    # .NET Aspire orchestration
├── tests/
│   ├── Unit/                       # Domain & application logic tests
│   ├── Integration/                # Database & external service tests
│   └── ArchTests/                  # Architectural constraint verification
└── docs/                           # Architecture decisions & guides
```

Each module is **self-contained** with its own domain, application, and infrastructure layers.
The Web project orchestrates them through dependency injection and vertical slices.

*Every composition starts with a single note — start exploring today.*

---

## Featured Repositories

<table>
<tr>
<td width="50%">

### [Medley](https://github.com/melodic-software/medley)

> **The Flagship Composition**

A reference implementation of a Modular Monolith using .NET 10, Blazor, and .NET Aspire. Demonstrates best practices with Clean Architecture, vertical slices, CQRS, and Domain-Driven Design working in harmony.

[![Stars](https://img.shields.io/github/stars/melodic-software/medley?style=flat-square&color=1E90FF)](https://github.com/melodic-software/medley)
[![Issues](https://img.shields.io/github/issues/melodic-software/medley?style=flat-square)](https://github.com/melodic-software/medley/issues)

</td>
<td width="50%">

### [.github](https://github.com/melodic-software/.github)

> **Community Standards**

The central home for engineering guidelines — Code of Conduct, Contributing Guide, Issue Templates, and reusable workflows that keep all projects in sync.

[![Stars](https://img.shields.io/github/stars/melodic-software/.github?style=flat-square&color=1E90FF)](https://github.com/melodic-software/.github)
[![Issues](https://img.shields.io/github/issues/melodic-software/.github?style=flat-square)](https://github.com/melodic-software/.github/issues)

</td>
</tr>
</table>

---

## Project Status

Current state of repositories across the organization:

| **Repository** | **Status** | **Activity** | **Build** |
| :--- | :---: | :---: | :---: |
| [Medley](https://github.com/melodic-software/medley) | 🟡 In Development | [![Commits](https://img.shields.io/github/commit-activity/m/melodic-software/medley?style=flat-square&color=1E90FF)](https://github.com/melodic-software/medley/commits) | [![Build](https://img.shields.io/github/actions/workflow/status/melodic-software/medley/dotnet-build.yaml?style=flat-square&label=CI)](https://github.com/melodic-software/medley/actions) |
| [.github](https://github.com/melodic-software/.github) | 🟢 Active | [![Commits](https://img.shields.io/github/commit-activity/m/melodic-software/.github?style=flat-square&color=1E90FF)](https://github.com/melodic-software/.github/commits) | [![Build](https://img.shields.io/github/actions/workflow/status/melodic-software/.github/markdown-lint.yaml?style=flat-square&label=Lint)](https://github.com/melodic-software/.github/actions) |

<div align="center">

**Legend**: 🟢 Active (stable, maintained) | 🟡 In Development (work in progress) | 🔴 Archived

</div>

---

## Contributing & Community

*Every great composition benefits from collaboration.*

### Ways to Contribute

| **Type** | **Description** | **Get Started** |
| :--- | :--- | :---: |
| 💻 **Code** | Bug fixes, features, optimizations | [Open Issues](https://github.com/melodic-software/medley/issues) |
| 📖 **Documentation** | Improve guides, fix typos, add examples | [Contributing Guide](https://github.com/melodic-software/.github/blob/main/CONTRIBUTING.md) |
| 🐛 **Issues** | Report bugs, suggest features | [New Issue](https://github.com/melodic-software/medley/issues/new/choose) |
| 💬 **Discussions** | Ask questions, share knowledge | [Join Discussions](https://github.com/orgs/melodic-software/discussions) |
| 👀 **Review** | Review PRs, provide feedback | [Pull Requests](https://github.com/melodic-software/medley/pulls) |

### Community Guidelines

*The best ensembles welcome every instrument.*

<div align="center">

[![Code of Conduct](https://img.shields.io/badge/Code_of_Conduct-Contributor_Covenant-1E90FF?style=flat-square)](https://github.com/melodic-software/.github/blob/main/CODE_OF_CONDUCT.md)
[![Security](https://img.shields.io/badge/Security-Policy-1E90FF?style=flat-square)](https://github.com/melodic-software/.github/blob/main/SECURITY.md)
[![Support](https://img.shields.io/badge/Support-Guidelines-1E90FF?style=flat-square)](https://github.com/melodic-software/.github/blob/main/SUPPORT.md)
[![Governance](https://img.shields.io/badge/Governance-Model-1E90FF?style=flat-square)](https://github.com/melodic-software/.github/blob/main/GOVERNANCE.md)

</div>

---

## Achievement Badges

<div align="center">

[![License](https://img.shields.io/badge/License-MIT-0e8a16?style=flat-square)](https://github.com/melodic-software/medley/blob/main/LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor_Covenant-v3.0-1E90FF?style=flat-square)](https://www.contributor-covenant.org/version/3/0/code-of-conduct/)
[![Conventional Commits](https://img.shields.io/badge/Conventional_Commits-1.0.0-FE5196?style=flat-square)](https://www.conventionalcommits.org/)
[![SemVer](https://img.shields.io/badge/SemVer-2.0.0-3F4551?style=flat-square)](https://semver.org/)

[![Secret Scanning](https://img.shields.io/badge/Secret_Scanning-Enabled-0e8a16?style=flat-square&logo=github)](https://docs.github.com/en/code-security/secret-scanning)
[![Dependabot](https://img.shields.io/badge/Dependabot-Enabled-0e8a16?style=flat-square&logo=dependabot)](https://docs.github.com/en/code-security/dependabot)
[![CodeQL](https://img.shields.io/badge/CodeQL-Enabled-1D417D?style=flat-square&logo=github)](https://codeql.github.com/)
[![Roslyn Analyzers](https://img.shields.io/badge/Roslyn_Analyzers-Enabled-512BD4?style=flat-square)](https://learn.microsoft.com/en-us/dotnet/fundamentals/code-analysis/overview)

</div>

---

## Recent Activity

<!--
  AUTOMATION NOTE: This section is currently manual.
  To auto-update via GitHub Actions, create: .github/workflows/update-profile-readme.yml

  Suggested workflow updates:
  - Pull latest releases from Medley & .github repos monthly
  - Update "Last Updated" timestamp
  - Fetch commit activity and interesting PRs

  Example data sources:
  - GitHub API: repos/{owner}/{repo}/releases
  - GitHub API: repos/{owner}/{repo}/commits?since=2026-01-01
  - GitHub API: repos/{owner}/{repo}/pulls?state=closed&sort=updated
-->

| **Date** | **Repository** | **Update** |
| :---: | :--- | :--- |
| 2026-01 | [.github](https://github.com/melodic-software/.github) | Enhanced profile README with expanded sections |
| 2026-01 | [.github](https://github.com/melodic-software/.github) | Added reusable workflow templates |
| 2026-01 | [Medley](https://github.com/melodic-software/medley) | Initial project scaffolding and Aspire setup |
| 2024-12 | [.github](https://github.com/melodic-software/.github) | Established community health files |

<!-- MAINTENANCE NOTE: Update this table manually or automate via GitHub Actions -->

---

## Support the Project

*Your support keeps the music playing.*

### Ways to Help

| **Method** | **Description** |
| :--- | :--- |
| ⭐ **Star** | Star repositories to show support and increase visibility |
| 📢 **Share** | Tell others about Melodic Software and its projects |
| 🐛 **Report** | Submit bug reports and feature requests |
| 💖 **Sponsor** | Support ongoing development through GitHub Sponsors |

<div align="center">

[![Sponsor Melodic Software](https://img.shields.io/badge/Sponsor_Melodic_Software-EA4AAA?style=for-the-badge&logo=githubsponsors&logoColor=white)](https://github.com/sponsors/melodic-software)

</div>

---

## What's Next

The roadmap includes:

- First public release of Medley reference architecture
- NuGet packages for reusable building blocks
- Technical blog posts on modular monolith patterns

*Stay tuned — composing something special.*

More detailed roadmaps and release plans will be shared as projects mature. Watch this space or star the repositories to follow along.

---

<div align="center">

## Connect

[![Website](https://img.shields.io/badge/Website-melodicsoftware.com-1E90FF?style=for-the-badge&logo=googlechrome&logoColor=white)](https://melodicsoftware.com)
[![Email](https://img.shields.io/badge/Email-info@melodicsoftware.com-1E90FF?style=for-the-badge&logo=gmail&logoColor=white)](mailto:info@melodicsoftware.com)
[![Sponsor](https://img.shields.io/badge/Sponsor-EA4AAA?style=for-the-badge&logo=githubsponsors&logoColor=white)](https://github.com/sponsors/melodic-software)

---

<sub>*Building software that sings, one commit at a time.*</sub>

</div>
