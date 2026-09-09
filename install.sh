#!/usr/bin/env bash
# ==============================================================================
# DESCRIPTION: Installs system dependencies for the Neovim configuration
#              (C/C++, Python, treesitter, lazygit, delta).
# SYSTEMS:     Linux (Debian 13/Ubuntu 24.04+), Windows (WSL/MSYS2)
# USAGE:       ./install.sh [--check-only]
# ==============================================================================
set -uo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Constants ────────────────────────────────────────────────────────
readonly BOLD='\033[1m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

readonly LINUX_APT_PACKAGES=(
  fd-find
  clangd-19
  clang-format-19
  cmake
  git-delta
)

readonly NPM_GLOBAL_TOOLS=(
  pyright
  tree-sitter-cli
)

readonly PIP_PACKAGES=(
  ruff
)

# ── Message helpers ─────────────────────────────────────────────────
info() {
  echo -e "${GREEN}[INFO]${NC}  $*"
}

warn() {
  echo -e "${YELLOW}[WARN]${NC}  $*"
}

error() {
  echo -e "${RED}[ERROR]${NC} $*" >&2
  exit 1
}

# ── Verification helpers ────────────────────────────────────────────
check_command() {
  local name=$1
  local cmd=$2
  local version

  if version=$(eval "$cmd" 2>/dev/null | head -1); then
    echo -e "  ${GREEN}✓${NC} ${name}: ${version}"
    return 0
  fi
  echo -e "  ${RED}✗${NC} ${name}: NOT FOUND"
  return 1
}

# ── Install helpers ─────────────────────────────────────────────────
link_if_missing() {
  local from=$1
  local to=$2

  if [[ ! -e "$to" ]] && command -v "$from" &>/dev/null; then
    info "Link: $to -> $from"
    sudo ln -sf "$from" "$to"
  fi
}

install_apt() {
  info "Updating package lists..."
  sudo apt update -qq

  info "Installing system packages..."
  sudo apt install -y "${LINUX_APT_PACKAGES[@]}"

  # clangd-19 -> clangd
  link_if_missing \
    /usr/bin/clangd-19 \
    /usr/bin/clangd

  # clang-format-19 -> clang-format
  link_if_missing \
    /usr/bin/clang-format-19 \
    /usr/bin/clang-format

  # fdfind -> fd
  link_if_missing \
    /usr/bin/fdfind \
    /usr/bin/fd
}

install_npm_global() {
  if ! command -v node &>/dev/null; then
    warn "Node.js not found. Installing..."
    sudo apt install -y nodejs npm
  fi

  # Use a user prefix to avoid requiring sudo
  local npm_prefix="$HOME/.local"
  npm config set prefix "$npm_prefix"

  info "Installing global npm tools into $npm_prefix..."
  for tool in "${NPM_GLOBAL_TOOLS[@]}"; do
    npm install -g "$tool"
  done
}

install_pipx() {
  if ! command -v pipx &>/dev/null; then
    warn "pipx not found. Installing..."
    sudo apt install -y pipx
    pipx ensurepath
  fi

  info "Installing tools with pipx..."
  for tool in "${PIP_PACKAGES[@]}"; do
    pipx install "$tool"
  done
}

install_lazygit_config() {
  local source="$SCRIPT_DIR/lazygit/config.yml"
  local target_dir="$HOME/.config/lazygit"
  local target="$target_dir/config.yml"

  mkdir -p "$target_dir"

  if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
    warn "$target already exists. Backing up to ${target}.bak"
    mv "$target" "${target}.bak"
  fi

  info "Link: $target -> $source"
  ln -sf "$source" "$target"
}

# ── Platform detection ───────────────────────────────────────────────
detect_platform() {
  local system

  system=$(uname -s 2>/dev/null)

  case "$system" in
    Linux*)
      echo "linux"
      ;;
    MINGW*|MSYS*|CYGWIN*)
      echo "windows"
      ;;
    *)
      echo "unknown"
      ;;
  esac
}

# ── Verify all tools ────────────────────────────────────────────────
check_all() {
  local errors=0

  echo ""
  echo -e "${BOLD}=== Checking tools ===${NC}"
  echo ""

  check_command "git"          "git --version"          || ((errors++))
  check_command "curl"         "curl --version | head -1" || ((errors++))
  check_command "rg"           "rg --version | head -1" || ((errors++))
  check_command "fd"           "fd --version"           || ((errors++))
  check_command "cmake"        "cmake --version | head -1" || ((errors++))
  check_command "clangd"       "clangd --version"       || ((errors++))
  check_command "clang-format" "clang-format --version" || ((errors++))
  check_command "node"         "node --version"         || ((errors++))
  check_command "npm"          "npm --version"          || ((errors++))
  check_command "pyright"      "pyright --version"      || ((errors++))
  check_command "ruff"         "ruff --version"         || ((errors++))
  check_command "lazygit"      "lazygit --version | head -1" || ((errors++))
  check_command "delta"        "delta --version"        || ((errors++))
  check_command "tree-sitter"  "tree-sitter --version"  || ((errors++))

  echo ""

  if [[ $errors -eq 0 ]]; then
    echo -e "${GREEN}All tools installed.${NC}"
  else
    echo -e "${YELLOW}\
${errors} tool(s) not found.${NC}"
  fi

  # PATH warning for ~/.local/bin
  local local_bin="$HOME/.local/bin"
  if [[ ":$PATH:" != *":$local_bin:"* ]]; then
    echo ""
    warn "$local_bin is not in PATH."
    echo "  Add this to your ~/.bashrc:"
    echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
  fi

  return "$errors"
}

# ── Main ─────────────────────────────────────────────────────────────
main() {
  local platform
  platform=$(detect_platform)

  echo ""
  echo -e "${BOLD}=== Neovim dependency installer ===${NC}"
  echo "  Detected platform: ${platform}"
  echo ""

  # Safety guard
  if [[ $EUID -eq 0 ]]; then
    error "Do not run this script as root."
  fi

  # Check-only mode, no install
  if [[ "${1:-}" == "--check-only" ]]; then
    check_all
    exit $?
  fi

  # Install according to platform
  case "$platform" in
    linux)
      install_apt
      install_npm_global
      install_pipx
      install_lazygit_config
      ;;
    windows)
      warn "Windows platform detected (WSL/MSYS2)."
      warn "For native Windows, use install.ps1."
      warn "Under WSL, the Linux installer is used."
      install_apt
      install_npm_global
      install_pipx
      install_lazygit_config
      ;;
    *)
      error "Unsupported platform: $platform"
      ;;
  esac

  check_all
}

main "$@"
