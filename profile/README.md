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
![Visitors](https://komarev.com/ghpvc/?username=melodic-software&color=1E90FF&style=for-the-badge&label=Visitors)

---

### Stats Dashboard

| **Repositories** | **Stars** | **Organization** | **Language** |
| :---: | :---: | :---: | :---: |
| [![Public Repos](https://img.shields.io/badge/Public_Repos-2-1E90FF?style=flat-square&logo=github)](https://github.com/orgs/melodic-software/repositories) | [![Total Stars](https://img.shields.io/github/stars/melodic-software?style=flat-square&color=1E90FF&label=Total)](https://github.com/melodic-software) | ![Since](https://img.shields.io/badge/Since-2024-512BD4?style=flat-square) | ![C#](https://img.shields.io/badge/C%23-100%25-512BD4?style=flat-square&logo=csharp&logoColor=white) |

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
| ![Clean Architecture](https://img.shields.io/badge/Clean_Architecture-512BD4?style=flat-square) | Dependency inversion for testability | Domain → Application → Infrastructure |
| ![CQRS](https://img.shields.io/badge/CQRS-512BD4?style=flat-square) | Separate read/write concerns | MediatR handlers with distinct models |
| ![DDD](https://img.shields.io/badge/Domain--Driven_Design-512BD4?style=flat-square) | Business logic in the domain | Aggregates, Value Objects, Domain Events |

#### Core Technologies

| **Runtime** | **Frontend** | **Cloud Native** | **Security** |
| :---: | :---: | :---: | :---: |
| ![.NET](https://img.shields.io/badge/.NET%2010-512BD4?style=flat-square&logo=dotnet&logoColor=white) | ![Blazor](https://img.shields.io/badge/Blazor-512BD4?style=flat-square&logo=blazor&logoColor=white) | ![Aspire](https://img.shields.io/badge/Aspire-512BD4?style=flat-square&logo=dotnet&logoColor=white) | ![Duende](https://img.shields.io/badge/Duende_IdentityServer-6E45AF?style=flat-square) |
| **C# 14** | **Interactive Auto** | **YARP & OpenTelemetry** | **STS, BFF Pattern** |

| **Data** | **Messaging** | **Testing** | **DevOps** |
| :---: | :---: | :---: | :---: |
| ![EF Core](https://img.shields.io/badge/EF_Core-512BD4?style=flat-square&logo=dotnet&logoColor=white) | ![MassTransit](https://img.shields.io/badge/MassTransit-1266CC?style=flat-square) | ![xUnit](https://img.shields.io/badge/xUnit-0A7D9C?style=flat-square) | ![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat-square&logo=githubactions&logoColor=white) |
| **SQL Server, PostgreSQL** | **RabbitMQ, Azure Service Bus** | **FluentAssertions, Testcontainers** | **Aspire, Docker** |

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
