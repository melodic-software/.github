#!/usr/bin/env bash
# Cloud Agent install step for the melodic-software/.github repository.
#
# This repo ships only community-health files, so its "build" is the same
# lint/hygiene suite CI runs (see .github/workflows/ci.yml). That suite is a set
# of standalone tools; this script installs each one pinned to the exact version
# the CI composite actions use (melodic-software/ci-workflows v0.29.1), so a
# local run of .cursor/check.sh reproduces CI verdicts byte for byte.
#
# Idempotent and safe to re-run: every tool is skipped when the pinned version
# is already present, and each release asset is verified against the same
# SHA-256 the CI action pins before it is trusted (fail closed).
set -euo pipefail

# --- Pins (authority: melodic-software/ci-workflows v0.29.1 action defaults) --
MARKDOWNLINT_VERSION="0.23.2"
TYPOS_VERSION="1.50.1"
TYPOS_SHA256="edf0545109aee6a22751d04ddecb97c45be47d3aa0409564fb895eeeace91b1e"
EC_VERSION="3.11.2"
EC_SHA256="bc815e5b3b1891a0ee9e1242fe3475312655f8b0f4c4a79510be0a009294571a"
GITLEAKS_VERSION="8.30.1"
GITLEAKS_SHA256="551f6fc83ea457d62a0d98237cbad105af8d557003051f41f3e7ca7b3f2470eb"
LYCHEE_VERSION="0.24.2"
LYCHEE_SHA256="1f4e0ef7f6554a6ed33dd7ac144fb2e1bbed98598e7af973042fc5cd43951c9a"
ACTIONLINT_VERSION="1.7.12"
ACTIONLINT_SHA256="8aca8db96f1b94770f1b0d72b6dddcb1ebb8123cb3712530b08cc387b349a3d8"
SHELLCHECK_VERSION="0.11.0"
SHELLCHECK_SHA256="b7af85e41cc99489dcc21d66c6d5f3685138f06d34651e6d34b42ec6d54fe6f6"
CHECK_JSONSCHEMA_VERSION="0.38.0"

# --- Placement ---------------------------------------------------------------
# /usr/local/bin is already on PATH for the agent shell, so binaries dropped
# there are usable immediately with no profile edits. Fall back to a per-user
# bin only when the system prefix is neither writable nor sudo-reachable.
BIN_DIR="/usr/local/bin"
VENV_DIR="/usr/local/lib/melodic-hygiene/venv"
# Command prefix kept as an array so an empty (no-sudo) value expands to nothing
# and a populated one word-splits safely (.shellcheckrc keeps SC2086 on).
SUDO=()
if [[ ! -w "$BIN_DIR" ]]; then
  if command -v sudo >/dev/null 2>&1 && sudo -n true >/dev/null 2>&1; then
    SUDO=(sudo)
  else
    BIN_DIR="$HOME/.local/bin"
    VENV_DIR="$HOME/.local/lib/melodic-hygiene/venv"
    echo "install: no sudo; using $BIN_DIR (ensure it is on PATH)" >&2
  fi
fi
"${SUDO[@]}" mkdir -p "$BIN_DIR"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

log() { printf 'install: %s\n' "$*" >&2; }

# verify_sha <file> <sha256>: abort the whole install on mismatch. A hygiene
# toolchain that silently installed an unverified binary is worse than a hard
# failure the operator can see and re-run.
verify_sha() {
  local file="$1" want="$2" got
  got="$(sha256sum "$file" | awk '{print $1}')"
  if [[ "$got" != "$want" ]]; then
    log "SHA-256 mismatch for $file: got $got want $want"
    exit 1
  fi
}

install_bin() {
  local src="$1" name="$2"
  chmod +x "$src"
  "${SUDO[@]}" install -m 0755 "$src" "$BIN_DIR/$name"
  log "installed $name -> $BIN_DIR/$name"
}

# ensure <label> <version> <installer> <version-cmd...>: run <installer> unless
# <version-cmd> already reports the pinned version.
ensure() {
  local label="$1" want="$2" installer="$3" cur
  shift 3
  cur="$("$@" 2>/dev/null || true)"
  if [[ "$cur" == *"$want"* ]]; then
    log "$label $want present; skipping"
  else
    "$installer"
  fi
}

# install_release <name> <sha256> <url> <extracted-path> <tar-member-args...>:
# download a release tarball, verify it, extract the member, and install
# $WORK/<extracted-path> as <name>.
install_release() {
  local name="$1" sha="$2" url="$3" extracted="$4"
  shift 4
  curl -fsSL --proto '=https' --retry 3 --retry-delay 3 -o "$WORK/$name.tgz" "$url"
  verify_sha "$WORK/$name.tgz" "$sha"
  tar -xzf "$WORK/$name.tgz" -C "$WORK" "$@"
  install_bin "$WORK/$extracted" "$name"
}

install_typos() {
  install_release typos "$TYPOS_SHA256" \
    "https://github.com/crate-ci/typos/releases/download/v${TYPOS_VERSION}/typos-v${TYPOS_VERSION}-x86_64-unknown-linux-musl.tar.gz" \
    typos ./typos
}

install_ec() {
  install_release ec "$EC_SHA256" \
    "https://github.com/editorconfig-checker/editorconfig-checker/releases/download/v${EC_VERSION}/ec-linux-amd64.tar.gz" \
    bin/ec-linux-amd64 bin/ec-linux-amd64
}

install_gitleaks() {
  install_release gitleaks "$GITLEAKS_SHA256" \
    "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz" \
    gitleaks gitleaks
}

install_lychee() {
  install_release lychee "$LYCHEE_SHA256" \
    "https://github.com/lycheeverse/lychee/releases/download/lychee-v${LYCHEE_VERSION}/lychee-x86_64-unknown-linux-gnu.tar.gz" \
    lychee --strip-components=1 lychee-x86_64-unknown-linux-gnu/lychee
}

install_actionlint() {
  install_release actionlint "$ACTIONLINT_SHA256" \
    "https://github.com/rhysd/actionlint/releases/download/v${ACTIONLINT_VERSION}/actionlint_${ACTIONLINT_VERSION}_linux_amd64.tar.gz" \
    actionlint actionlint
}

install_shellcheck() {
  install_release shellcheck "$SHELLCHECK_SHA256" \
    "https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.gz" \
    "shellcheck-v${SHELLCHECK_VERSION}/shellcheck" "shellcheck-v${SHELLCHECK_VERSION}/shellcheck"
}

# markdownlint-cli2 ships as an npm package; install it into the same prefix so
# the `markdownlint-cli2` launcher lands on PATH. Node is provided by the base
# image / cloud bootstrap.
install_markdownlint() {
  if ! command -v npm >/dev/null 2>&1; then
    log "npm not found; cannot install markdownlint-cli2"
    exit 1
  fi
  local prefix
  prefix="$(dirname "$BIN_DIR")"
  # sudo resets PATH via secure_path, dropping the nvm-provided node/npm; carry
  # the current PATH through so both resolve during the privileged install.
  "${SUDO[@]}" env "PATH=$PATH" npm install -g --prefix "$prefix" \
    --no-audit --no-fund "markdownlint-cli2@${MARKDOWNLINT_VERSION}" >/dev/null 2>&1
  log "installed markdownlint-cli2 -> $BIN_DIR/markdownlint-cli2"
}

# check-jsonschema is a Python tool; install it into a dedicated venv and expose
# only its launcher on PATH so it never perturbs the system interpreter.
install_check_jsonschema() {
  if ! command -v python3 >/dev/null 2>&1; then
    log "python3 not found; cannot install check-jsonschema"
    exit 1
  fi
  # The default image ships python3 without the venv/ensurepip module; add it
  # once (idempotent) so the isolated tool environment can be created.
  if ! python3 -c 'import ensurepip' >/dev/null 2>&1; then
    if [[ ${#SUDO[@]} -gt 0 ]] && command -v apt-get >/dev/null 2>&1; then
      log "installing python3-venv (ensurepip missing)"
      "${SUDO[@]}" env DEBIAN_FRONTEND=noninteractive apt-get install -y python3-venv >/dev/null 2>&1 ||
        { "${SUDO[@]}" apt-get update >/dev/null 2>&1 &&
          "${SUDO[@]}" env DEBIAN_FRONTEND=noninteractive apt-get install -y python3-venv >/dev/null 2>&1; }
    fi
  fi
  "${SUDO[@]}" mkdir -p "$(dirname "$VENV_DIR")"
  "${SUDO[@]}" python3 -m venv "$VENV_DIR"
  "${SUDO[@]}" "$VENV_DIR/bin/pip" install --quiet --upgrade pip
  "${SUDO[@]}" "$VENV_DIR/bin/pip" install --quiet "check-jsonschema==${CHECK_JSONSCHEMA_VERSION}"
  "${SUDO[@]}" ln -sf "$VENV_DIR/bin/check-jsonschema" "$BIN_DIR/check-jsonschema"
  log "installed check-jsonschema -> $BIN_DIR/check-jsonschema"
}

log "installing pinned hygiene toolchain into $BIN_DIR"
ensure typos "$TYPOS_VERSION" install_typos typos --version
ensure editorconfig-checker "$EC_VERSION" install_ec ec --version
ensure gitleaks "$GITLEAKS_VERSION" install_gitleaks gitleaks version
ensure lychee "$LYCHEE_VERSION" install_lychee lychee --version
ensure actionlint "$ACTIONLINT_VERSION" install_actionlint actionlint --version
ensure shellcheck "$SHELLCHECK_VERSION" install_shellcheck shellcheck --version
ensure markdownlint-cli2 "$MARKDOWNLINT_VERSION" install_markdownlint markdownlint-cli2 --version
ensure check-jsonschema "$CHECK_JSONSCHEMA_VERSION" install_check_jsonschema check-jsonschema --version
log "toolchain ready"
