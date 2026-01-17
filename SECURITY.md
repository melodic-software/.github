<!-- Last reviewed: 2026-01-15 -->
<!--https://docs.github.com/en/code-security/how-tos/report-and-fix-vulnerabilities/configure-vulnerability-reporting/adding-a-security-policy-to-your-repository-->

# Security Policy

## Supported Versions

Please check the specific repository's `README.md` or `SECURITY.md` for information on supported versions. If not specified, generally only the **latest release** or **main branch** is supported.

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please report it responsibly.

### How to Report

1. **Do NOT** open a public GitHub issue for security vulnerabilities.
2. Use **GitHub's private vulnerability reporting**: Navigate to the repository's **Security** tab > **Advisories** > **New draft security advisory**.
3. If the repository does not have private reporting enabled, please email **<security@melodicsoftware.com>** (or <info@melodicsoftware.com>).

### What to Include

Please provide as much of the following as possible:

- Type of issue (e.g., SQL injection, XSS, authentication bypass, etc.)
- Full paths of source file(s) related to the issue
- Location of affected source code (branch/commit or direct URL)
- Any special configuration required to reproduce
- Step-by-step instructions to reproduce
- Proof of concept or exploit code (if available, non-destructive)
- Impact assessment, including how an attacker might exploit the issue

### Response Timeline

| Action | Timeframe |
|--------|-----------|
| Acknowledgment | Within 48 hours |
| Initial assessment | Within 7 days |
| Status update | Every 7 days until resolved |
| Fix timeline | Based on severity (Critical: 7 days, High: 30 days, Medium: 90 days, Low: best effort) |

### Safe Harbor

We will not take legal action against security researchers who:

- Act in good faith to avoid privacy violations, data destruction, or service disruption
- Provide us reasonable time to address the issue before public disclosure
- Do not exploit the vulnerability beyond what is necessary to demonstrate it

### Preferred Languages

We prefer all communications to be in English.

## Security Measures

We generally implement:

- **GitHub Secret Scanning**
- **Dependabot Security Updates**
- **Static Code Analysis** (CodeQL or Roslyn Analyzers)
- **Branch Protection**
