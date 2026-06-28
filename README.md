# .github

Organization-wide community-health defaults for the
[`melodic-software`](https://github.com/melodic-software) GitHub organization.

GitHub falls back to the files in this special repository for any repo that does
not provide its own. It supplies default issue forms, a pull request template,
the security policy, and the contribution, governance, conduct, and support
policies, so individual repositories inherit a consistent contribution and
disclosure workflow without each one redefining it. `profile/README.md` renders
as the organization's public profile page.

These are the file-based governance defaults that GitHub's API cannot express.
Everything the [GitHub provider](https://github.com/melodic-software/github-iac)
*can* express — repository settings, custom properties, rulesets, and labels — is
managed as Pulumi IaC there, not here.
