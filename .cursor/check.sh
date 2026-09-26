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

top="$(git rev-parse --show-toplevel)" && cd -- "$top" || exit 1

# Fall back onto a per-user bin in case install.sh placed tools there.
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) PATH="$HOME/.local/bin:$PATH" ;;
esac

PASSED=()
FAILED=()

heading() { printf '\n\033[1m── %s ──\033[0m\n' "$1" >&2; }

# run_lane <name> <cmd...>: run one lane under a heading and record its verdict.
run_lane() {
  local name="$1"
  shift
  heading "$name"
  if "$@"; then
    PASSED+=("$name")
    printf '\033[32m✓ %s\033[0m\n' "$name" >&2
  else
    FAILED+=("$name")
    printf '\033[31m✗ %s\033[0m\n' "$name" >&2
  fi
}

# --- Lanes with multi-step logic --------------------------------------------

# typos skips hidden paths unless they are named. The synced _typos.toml
# cannot set ignore-hidden = false; CI's typos job has the same follow-up.
# Skip index entries that are gone from the worktree: an unstaged deletion is
# still listed, and typos exits 64 when an explicit path is missing.
lane_typos() {
  local hidden=() path
  while IFS= read -r -d '' path; do
    [[ "$path" == .* && -f "$path" ]] && hidden+=("$path")
  done < <(git ls-files -z)
  typos --config _typos.toml . "${hidden[@]}"
}

lane_jsonschema() {
  local rc=0 forms=() f
  check-jsonschema --builtin-schema vendor.dependabot .github/dependabot.yml || rc=1
  check-jsonschema --builtin-schema vendor.github-workflows .github/workflows/*.yml || rc=1
  for f in .github/ISSUE_TEMPLATE/*.yml .github/ISSUE_TEMPLATE/*.yaml; do
    [[ -e "$f" && "$(basename -- "$f")" != config.yml ]] && forms+=("$f")
  done
  if [[ ${#forms[@]} -eq 0 ]]; then
    # Match ci.yml's roster step: an empty set is a failed derivation, not a
    # skipped validation. Skipping here let a deleted-forms change pass locally
    # while CI went red.
    echo "No issue forms (*.yml/*.yaml other than config.yml) found under .github/ISSUE_TEMPLATE/." >&2
    return 1
  fi
  check-jsonschema --builtin-schema vendor.github-issue-forms "${forms[@]}" || rc=1
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
# if any blob changes). `git add --renormalize` reads the working tree
# (https://git-scm.com/docs/git-add --renormalize, implies -u), so running it
# against the caller's dirty tree would treat ordinary pending edits as drift.
# Materialize the current index into a throwaway worktree and renormalize
# there, leaving the caller's index and working tree untouched. CI itself
# runs on a clean checkout, so this extra isolation is local-only.
lane_eol() {
  local tmp gitdir before after drift rc=0
  tmp="$(mktemp -d)" || return 1
  gitdir="$(git rev-parse --absolute-git-dir)" &&
    mkdir -p "$tmp/wt" &&
    cp -- "$(git rev-parse --git-path index)" "$tmp/index" &&
    before="$(GIT_DIR="$gitdir" GIT_INDEX_FILE="$tmp/index" git write-tree)" &&
    GIT_DIR="$gitdir" GIT_INDEX_FILE="$tmp/index" GIT_WORK_TREE="$tmp/wt" git checkout-index --all &&
    GIT_DIR="$gitdir" GIT_INDEX_FILE="$tmp/index" GIT_WORK_TREE="$tmp/wt" git add --renormalize -- . &&
    after="$(GIT_DIR="$gitdir" GIT_INDEX_FILE="$tmp/index" git write-tree)" || rc=1
  rm -rf "$tmp"
  [[ "$rc" -eq 0 ]] || return 1
  if ! drift="$(git diff --name-only "$before" "$after")"; then
    echo "eol-renormalize: git diff failed; cannot tell whether the index has EOL drift" >&2
    return 1
  fi
  if [[ -n "$drift" ]]; then
    echo "EOL drift (fix: git add --renormalize . && git commit):" >&2
    printf '%s\n' "$drift" >&2
    return 1
  fi
  echo "index EOL clean"
}

lane_pr_section_drift() {
  local rc=0
  node --test .github/scripts/pr-section-drift.test.mjs || rc=1
  node .github/scripts/pr-section-drift.mjs || rc=1
  return "$rc"
}

# --- Run every lane ---------------------------------------------------------

run_lane markdown markdownlint-cli2 --config .markdownlint-cli2.jsonc "**/*.md"
run_lane typos lane_typos
run_lane editorconfig ec -config .editorconfig-checker.json
run_lane gitleaks gitleaks dir --config .gitleaks.toml --no-banner .
run_lane links lychee --offline --no-progress --config lychee.toml \
  "**/*.md" ".claude/**/*.md" ".github/**/*.md"
run_lane actionlint actionlint -color
run_lane jsonschema lane_jsonschema
run_lane shellcheck lane_shellcheck
run_lane eol-renormalize lane_eol
run_lane pr-section-drift lane_pr_section_drift

# --- Summary ----------------------------------------------------------------

heading ci-status
printf 'passed: %d   failed: %d\n' "${#PASSED[@]}" "${#FAILED[@]}" >&2
if [[ ${#FAILED[@]} -gt 0 ]]; then
  printf 'failing lanes: %s\n' "${FAILED[*]}" >&2
  exit 1
fi
printf '\033[32mall lanes passed\033[0m\n' >&2
