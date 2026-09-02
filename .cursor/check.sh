#!/usr/bin/env bash
# Local mirror of the CI hygiene suite for melodic-software/.github.
#
# Runs the same lanes as .github/workflows/ci.yml against the same vendored
# configs, using the tools .cursor/install.sh pins to the CI versions. Every
# lane runs even if an earlier one fails, and a summary is printed at the end so
# a single invocation reproduces the aggregate `ci-status` verdict locally
# (CONTRIBUTING step 3: "Ensure the project builds and its checks pass locally").
#
# Not set -e: lanes are collected, not short-circuited. Exit status is non-zero
# when any lane fails.
set -uo pipefail

cd -- "$(git rev-parse --show-toplevel 2>/dev/null || echo .)" || exit 1

# Fall back onto a per-user bin in case install.sh placed tools there.
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) PATH="$HOME/.local/bin:$PATH" ;;
esac
export PATH

PASSED=()
FAILED=()

record() {
  local name="$1" rc="$2"
  if [[ "$rc" -eq 0 ]]; then
    PASSED+=("$name")
    printf '\033[32m✓ %s\033[0m\n' "$name" >&2
  else
    FAILED+=("$name")
    printf '\033[31m✗ %s\033[0m\n' "$name" >&2
  fi
}

heading() { printf '\n\033[1m── %s ──\033[0m\n' "$1" >&2; }

# --- Lanes with multi-step logic --------------------------------------------

lane_jsonschema() {
  local rc=0 forms=() f
  check-jsonschema --builtin-schema vendor.dependabot .github/dependabot.yml || rc=1
  check-jsonschema --builtin-schema vendor.github-workflows .github/workflows/*.yml || rc=1
  for f in .github/ISSUE_TEMPLATE/*.yml .github/ISSUE_TEMPLATE/*.yaml; do
    [[ -e "$f" ]] || continue
    [[ "$(basename -- "$f")" == config.yml ]] && continue
    forms+=("$f")
  done
  if [[ ${#forms[@]} -gt 0 ]]; then
    check-jsonschema --builtin-schema vendor.github-issue-forms "${forms[@]}" || rc=1
  fi
  check-jsonschema --builtin-schema vendor.github-issue-config \
    .github/ISSUE_TEMPLATE/config.yml || rc=1
  check-jsonschema --schemafile https://json.schemastore.org/claude-code-settings.json \
    .claude/settings.json || rc=1
  return "$rc"
}

lane_shellcheck() {
  local files=() f
  while IFS= read -r -d '' f; do
    files+=("$f")
  done < <(git ls-files -z -- '*.sh' '*.bash')
  if [[ ${#files[@]} -eq 0 ]]; then
    echo "no tracked shell scripts to lint"
    return 0
  fi
  shellcheck --rcfile .shellcheckrc "${files[@]}"
}

# Detect EOL drift the way CI does (re-stage through git's clean filter and see
# if any blob changes), but against a throwaway copy of the current index so the
# caller's real staging area is never touched. Comparing the index tree before
# vs. after renormalization isolates line-ending drift from ordinary content
# edits, so it stays accurate on a dirty working tree (CI runs on a clean one).
lane_eol() {
  local tmp before after drift rc=0
  tmp="$(mktemp)"
  cp -- "$(git rev-parse --git-path index)" "$tmp"
  before="$(GIT_INDEX_FILE="$tmp" git write-tree)"
  GIT_INDEX_FILE="$tmp" git add --renormalize -- .
  after="$(GIT_INDEX_FILE="$tmp" git write-tree)"
  rm -f "$tmp"
  drift="$(git diff --name-only "$before" "$after")"
  if [[ -z "$drift" ]]; then
    echo "index EOL clean"
  else
    echo "EOL drift (fix: git add --renormalize . && git commit):" >&2
    printf '%s\n' "$drift" >&2
    rc=1
  fi
  return "$rc"
}

# --- Run every lane ---------------------------------------------------------

heading markdown
markdownlint-cli2 --config .markdownlint-cli2.jsonc "**/*.md"
record markdown "$?"

heading typos
typos --config _typos.toml .
record typos "$?"

heading editorconfig
ec -config .editorconfig-checker.json
record editorconfig "$?"

heading gitleaks
gitleaks dir --config .gitleaks.toml --no-banner .
record gitleaks "$?"

heading links
lychee --offline --no-progress --config lychee.toml \
  "**/*.md" ".claude/**/*.md" ".github/**/*.md"
record links "$?"

heading actionlint
actionlint -color
record actionlint "$?"

heading jsonschema
lane_jsonschema
record jsonschema "$?"

heading shellcheck
lane_shellcheck
record shellcheck "$?"

heading eol-renormalize
lane_eol
record eol-renormalize "$?"

# --- Summary ----------------------------------------------------------------

printf '\n\033[1m── ci-status ──\033[0m\n' >&2
printf 'passed: %d   failed: %d\n' "${#PASSED[@]}" "${#FAILED[@]}" >&2
if [[ ${#FAILED[@]} -gt 0 ]]; then
  printf 'failing lanes: %s\n' "${FAILED[*]}" >&2
  exit 1
fi
printf '\033[32mall lanes passed\033[0m\n' >&2
