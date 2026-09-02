#!/usr/bin/env bash
# Cloud Agent install step for the melodic-software/.github repository.
#
# This repo ships only community-health files, so its "build" is the same
# lint/hygiene suite CI runs (see .github/workflows/ci.yml). That suite is a set
# of standalone tools; this script installs each one pinned to the exact version
# the CI composite actions use (melodic-software/ci-workflows v0.17.2), so a
# local run of .cursor/check.sh reproduces CI verdicts byte for byte.
#
# Idempotent and safe to re-run: every tool is skipped when the pinned version
# is already present, and each release asset is verified against the same
# SHA-256 the CI action pins before it is trusted (fail closed).
set -euo pipefail

# --- Pins (authority: melodic-software/ci-workflows v0.17.2 action defaults) --
MARKDOWNLINT_VERSION="0.23.2"
TYPOS_VERSION="1.49.0"
TYPOS_SHA256="48bd2d58e02ce713b8c0f1aa239e68ee4f7d8c551013135806e6aed3938d9e10"
EC_VERSION="3.11.1"
EC_SHA256="5a37922963248451e88149251e49f6ae08f69717a3918202a51fe9945e19691e"
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

# verify_sha <file> <sha256> — abort the whole install on mismatch. A hygiene
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

install_typos() {
  local cur
  cur="$(typos --version 2>/dev/null || true)"
  if [[ "$cur" == *"$TYPOS_VERSION"* ]]; then
    log "typos $TYPOS_VERSION present; skipping"
    return 0
  fi
  local url="https://github.com/crate-ci/typos/releases/download/v${TYPOS_VERSION}/typos-v${TYPOS_VERSION}-x86_64-unknown-linux-musl.tar.gz"
  curl -fsSL --proto '=https' --retry 3 --retry-delay 3 -o "$WORK/typos.tgz" "$url"
  verify_sha "$WORK/typos.tgz" "$TYPOS_SHA256"
  tar -xzf "$WORK/typos.tgz" -C "$WORK" ./typos
  install_bin "$WORK/typos" typos
}

install_ec() {
  local cur
  cur="$(ec --version 2>/dev/null || true)"
  if [[ "$cur" == *"$EC_VERSION"* ]]; then
    log "editorconfig-checker $EC_VERSION present; skipping"
    return 0
  fi
  local url="https://github.com/editorconfig-checker/editorconfig-checker/releases/download/v${EC_VERSION}/ec-linux-amd64.tar.gz"
  curl -fsSL --proto '=https' --retry 3 --retry-delay 3 -o "$WORK/ec.tgz" "$url"
  verify_sha "$WORK/ec.tgz" "$EC_SHA256"
  tar -xzf "$WORK/ec.tgz" -C "$WORK" bin/ec-linux-amd64
  install_bin "$WORK/bin/ec-linux-amd64" ec
}

install_gitleaks() {
  local cur
  cur="$(gitleaks version 2>/dev/null || true)"
  if [[ "$cur" == *"$GITLEAKS_VERSION"* ]]; then
    log "gitleaks $GITLEAKS_VERSION present; skipping"
    return 0
  fi
  local url="https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"
  curl -fsSL --proto '=https' --retry 3 --retry-delay 3 -o "$WORK/gitleaks.tgz" "$url"
  verify_sha "$WORK/gitleaks.tgz" "$GITLEAKS_SHA256"
  tar -xzf "$WORK/gitleaks.tgz" -C "$WORK" gitleaks
  install_bin "$WORK/gitleaks" gitleaks
}

install_lychee() {
  local cur
  cur="$(lychee --version 2>/dev/null || true)"
  if [[ "$cur" == *"$LYCHEE_VERSION"* ]]; then
    log "lychee $LYCHEE_VERSION present; skipping"
    return 0
  fi
  local url="https://github.com/lycheeverse/lychee/releases/download/lychee-v${LYCHEE_VERSION}/lychee-x86_64-unknown-linux-gnu.tar.gz"
  curl -fsSL --proto '=https' --retry 3 --retry-delay 3 -o "$WORK/lychee.tgz" "$url"
  verify_sha "$WORK/lychee.tgz" "$LYCHEE_SHA256"
  tar -xzf "$WORK/lychee.tgz" -C "$WORK" --strip-components=1 lychee-x86_64-unknown-linux-gnu/lychee
  install_bin "$WORK/lychee" lychee
}

install_actionlint() {
  local cur
  cur="$(actionlint --version 2>/dev/null || true)"
  if [[ "$cur" == *"$ACTIONLINT_VERSION"* ]]; then
    log "actionlint $ACTIONLINT_VERSION present; skipping"
    return 0
  fi
  local url="https://github.com/rhysd/actionlint/releases/download/v${ACTIONLINT_VERSION}/actionlint_${ACTIONLINT_VERSION}_linux_amd64.tar.gz"
  curl -fsSL --proto '=https' --retry 3 --retry-delay 3 -o "$WORK/actionlint.tgz" "$url"
  verify_sha "$WORK/actionlint.tgz" "$ACTIONLINT_SHA256"
  tar -xzf "$WORK/actionlint.tgz" -C "$WORK" actionlint
  install_bin "$WORK/actionlint" actionlint
}

install_shellcheck() {
  local cur
  cur="$(shellcheck --version 2>/dev/null || true)"
  if [[ "$cur" == *"$SHELLCHECK_VERSION"* ]]; then
    log "shellcheck $SHELLCHECK_VERSION present; skipping"
    return 0
  fi
  local url="https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.gz"
  curl -fsSL --proto '=https' --retry 3 --retry-delay 3 -o "$WORK/sc.tgz" "$url"
  verify_sha "$WORK/sc.tgz" "$SHELLCHECK_SHA256"
  tar -xzf "$WORK/sc.tgz" -C "$WORK" "shellcheck-v${SHELLCHECK_VERSION}/shellcheck"
  install_bin "$WORK/shellcheck-v${SHELLCHECK_VERSION}/shellcheck" shellcheck
}

# markdownlint-cli2 ships as an npm package; install it into the same prefix so
# the `markdownlint-cli2` launcher lands on PATH. Node is provided by the base
# image / cloud bootstrap.
install_markdownlint() {
  local cur
  cur="$(markdownlint-cli2 --version 2>/dev/null || true)"
  if [[ "$cur" == *"$MARKDOWNLINT_VERSION"* ]]; then
    log "markdownlint-cli2 $MARKDOWNLINT_VERSION present; skipping"
    return 0
  fi
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
  local cur
  cur="$(check-jsonschema --version 2>/dev/null || true)"
  if [[ "$cur" == *"$CHECK_JSONSCHEMA_VERSION"* ]]; then
    log "check-jsonschema $CHECK_JSONSCHEMA_VERSION present; skipping"
    return 0
  fi
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
install_typos
install_ec
install_gitleaks
install_lychee
install_actionlint
install_shellcheck
install_markdownlint
install_check_jsonschema
log "toolchain ready"
