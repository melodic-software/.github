#!/usr/bin/env bash
# Placement contract for .cursor/install.sh.
#
# Sources the resolver only. Does not download tools or write a prefix.
set -euo pipefail

here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
script="$here/install.sh"

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

cat > "$tmp/sudo" <<'EOF'
#!/usr/bin/env bash
if [[ -n "${SUDO_LOG:-}" ]]; then
  printf '%s\n' "$*" >> "$SUDO_LOG"
fi
if [[ "${1:-}" == "-n" && "${2:-}" == "true" ]]; then
  exit 0
fi
printf 'unexpected sudo: %s\n' "$*" >&2
exit 99
EOF
chmod +x "$tmp/sudo"

source_install() {
  # shellcheck source=install.sh
  source "$script"
}

assert_workstation() {
  resolve_install_prefix
  if [[ "$BIN_DIR" != "$HOME/.local/bin" ]]; then
    fail "workstation BIN_DIR=$BIN_DIR want $HOME/.local/bin"
  fi
  if [[ "$VENV_DIR" != "$HOME/.local/lib/melodic-hygiene/venv" ]]; then
    fail "workstation VENV_DIR=$VENV_DIR"
  fi
  if [[ ${#SUDO[@]} -ne 0 ]]; then
    fail "workstation selected sudo: ${SUDO[*]}"
  fi
  if [[ -s "$SUDO_LOG" ]]; then
    fail "workstation invoked sudo: $(<"$SUDO_LOG")"
  fi
}

assert_system_unwritable() {
  # Stand in for a /usr/local/bin the current user cannot write.
  prefix_is_writable() { return 1; }
  resolve_install_prefix
  if [[ "$BIN_DIR" != /usr/local/bin ]]; then
    fail "system BIN_DIR=$BIN_DIR"
  fi
  if [[ "$VENV_DIR" != /usr/local/lib/melodic-hygiene/venv ]]; then
    fail "system VENV_DIR=$VENV_DIR"
  fi
  if [[ ${#SUDO[@]} -ne 1 || "${SUDO[0]}" != sudo ]]; then
    fail "system sudo array: ${SUDO[*]-empty}"
  fi
  if [[ "$(<"$SUDO_LOG")" != "-n true" ]]; then
    fail "sudo probe log: $(<"$SUDO_LOG")"
  fi
}

assert_system_writable() {
  prefix_is_writable() { return 0; }
  resolve_install_prefix
  if [[ "$BIN_DIR" != /usr/local/bin ]]; then
    fail "writable system BIN_DIR=$BIN_DIR"
  fi
  if [[ "$VENV_DIR" != /usr/local/lib/melodic-hygiene/venv ]]; then
    fail "writable system VENV_DIR=$VENV_DIR"
  fi
  if [[ ${#SUDO[@]} -ne 0 ]]; then
    fail "writable system selected sudo: ${SUDO[*]}"
  fi
  if [[ -s "$SUDO_LOG" ]]; then
    fail "writable system invoked sudo: $(<"$SUDO_LOG")"
  fi
}

# The production writability check, against real directories. The system-prefix
# cases above replace the function so they do not depend on this machine.
assert_real_writability() {
  local writable locked saw
  writable="$(mktemp -d)"
  locked="$(mktemp -d)"
  chmod a-w "$locked"
  saw=0
  # Predicate: non-zero means "not writable", not a command failure.
  # shellcheck disable=SC2310
  if prefix_is_writable "$writable"; then
    saw=1
  fi
  if [[ "$saw" -ne 1 ]]; then
    fail "writable temp dir reported not writable"
  fi
  saw=0
  # shellcheck disable=SC2310
  if prefix_is_writable "$locked"; then
    saw=1
  fi
  if [[ "$saw" -ne 0 ]]; then
    fail "locked temp dir reported writable"
  fi
  chmod u+w "$locked"
  rm -rf "$writable" "$locked"
}

run_case() {
  source_install
  "$1"
}

base_path="$PATH"
base_home="$HOME"
home="$(mktemp -d "$tmp/home.XXXXXX")"

log="$tmp/sudo-workstation.log"
: > "$log"
unset MELODIC_HYGIENE_SYSTEM
HOME="$home"
PATH="$tmp:$base_path"
SUDO_LOG="$log"
export HOME PATH SUDO_LOG
run_case assert_workstation

log="$tmp/sudo-unwritable.log"
: > "$log"
MELODIC_HYGIENE_SYSTEM=1
PATH="$tmp:$base_path"
SUDO_LOG="$log"
export MELODIC_HYGIENE_SYSTEM PATH SUDO_LOG
run_case assert_system_unwritable

log="$tmp/sudo-writable.log"
: > "$log"
MELODIC_HYGIENE_SYSTEM=1
PATH="$tmp:$base_path"
SUDO_LOG="$log"
export MELODIC_HYGIENE_SYSTEM PATH SUDO_LOG
run_case assert_system_writable

unset MELODIC_HYGIENE_SYSTEM
HOME="$base_home"
PATH="$base_path"
export HOME PATH
run_case assert_real_writability

printf 'ok\n'
