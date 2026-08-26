#!/usr/bin/env bash
# ==============================================================================
# DESCRIPCIÓN: Instala las dependencias del sistema para la configuración
#              de Neovim (C/C++, Python, treesitter, lazygit).
# SISTEMAS:    Linux (Debian 13/Ubuntu 24.04+), Windows (WSL/MSYS2)
# USO:        ./install.sh [--check-only]
# ==============================================================================
set -uo pipefail

# ── Constantes ──────────────────────────────────────────────────────
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
)

readonly NPM_GLOBAL_TOOLS=(
  pyright
  tree-sitter-cli
)

readonly PIP_PACKAGES=(
  ruff
)

# ── Funciones de mensajes ──────────────────────────────────────────
Info() {
  echo -e "${GREEN}[INFO]${NC}  $*"
}

Warn() {
  echo -e "${YELLOW}[WARN]${NC}  $*"
}

Error() {
  echo -e "${RED}[ERROR]${NC} $*" >&2
  exit 1
}

# ── Funciones de verificación ──────────────────────────────────────
VerificarComando() {
  local nombre=$1
  local comando=$2
  local version

  if version=$(eval "$comando" 2>/dev/null | head -1); then
    echo -e "  ${GREEN}✓${NC} ${nombre}: ${version}"
    return 0
  fi
  echo -e "  ${RED}✗${NC} ${nombre}: NO ENCONTRADO"
  return 1
}

# ── Funciones de instalación ───────────────────────────────────────
CrearEnlaceSiFalta() {
  local desde=$1
  local hasta=$2

  if [[ ! -e "$hasta" ]] && command -v "$desde" &>/dev/null; then
    Info "Enlace: $hasta -> $desde"
    sudo ln -sf "$desde" "$hasta"
  fi
}

InstalarApt() {
  Info "Actualizando listas de paquetes..."
  sudo apt update -qq

  Info "Instalando paquetes del sistema..."
  sudo apt install -y "${LINUX_APT_PACKAGES[@]}"

  # clangd-19 -> clangd
  CrearEnlaceSiFalta \
    /usr/bin/clangd-19 \
    /usr/bin/clangd

  # clang-format-19 -> clang-format
  CrearEnlaceSiFalta \
    /usr/bin/clang-format-19 \
    /usr/bin/clang-format

  # fdfind -> fd
  CrearEnlaceSiFalta \
    /usr/bin/fdfind \
    /usr/bin/fd
}

InstalarNpmGlobal() {
  if ! command -v node &>/dev/null; then
    Warn "Node.js no encontrado. Instalando..."
    sudo apt install -y nodejs npm
  fi

  # Usar prefijo de usuario para no requerir sudo
  local npm_prefix="$HOME/.local"
  npm config set prefix "$npm_prefix"

  Info "Instalando herramientas npm globales en $npm_prefix..."
  for herramienta in "${NPM_GLOBAL_TOOLS[@]}"; do
    npm install -g "$herramienta"
  done
}

InstalarPipx() {
  if ! command -v pipx &>/dev/null; then
    Warn "pipx no encontrado. Instalando..."
    sudo apt install -y pipx
    pipx ensurepath
  fi

  Info "Instalando herramientas con pipx..."
  for herramienta in "${PIP_PACKAGES[@]}"; do
    pipx install "$herramienta"
  done
}

# ── Detección de plataforma ────────────────────────────────────────
DetectarPlataforma() {
  local sistema

  sistema=$(uname -s 2>/dev/null)

  case "$sistema" in
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

# ── Verificación de todas las herramientas ──────────────────────────
VerificarTodas() {
  local errores=0

  echo ""
  echo -e "${BOLD}=== Verificando herramientas ===${NC}"
  echo ""

  VerificarComando "git"          "git --version"          || ((errores++))
  VerificarComando "curl"         "curl --version | head -1" || ((errores++))
  VerificarComando "rg"           "rg --version | head -1" || ((errores++))
  VerificarComando "fd"           "fd --version"           || ((errores++))
  VerificarComando "cmake"        "cmake --version | head -1" || ((errores++))
  VerificarComando "clangd"       "clangd --version"       || ((errores++))
  VerificarComando "clang-format" "clang-format --version" || ((errores++))
  VerificarComando "node"         "node --version"         || ((errores++))
  VerificarComando "npm"          "npm --version"          || ((errores++))
  VerificarComando "pyright"      "pyright --version"      || ((errores++))
  VerificarComando "ruff"         "ruff --version"         || ((errores++))
  VerificarComando "lazygit"      "lazygit --version | head -1" || ((errores++))
  VerificarComando "tree-sitter"  "tree-sitter --version"  || ((errores++))

  echo ""

  if [[ $errores -eq 0 ]]; then
    echo -e "${GREEN}Todas las herramientas instaladas.${NC}"
  else
    echo -e "${YELLOW}\
${errores} herramienta(s) no encontrada(s).${NC}"
  fi

  # Aviso de PATH para ~/.local/bin
  local local_bin="$HOME/.local/bin"
  if [[ ":$PATH:" != *":$local_bin:"* ]]; then
    echo ""
    Warn "$local_bin no está en PATH."
    echo "  Agrega esto a tu ~/.bashrc:"
    echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
  fi

  return "$errores"
}

# ── Bloque principal ───────────────────────────────────────────────
Main() {
  local plataforma
  plataforma=$(DetectarPlataforma)

  echo ""
  echo -e "${BOLD}=== Instalador de dependencias Neovim ===${NC}"
  echo "  Plataforma detectada: ${plataforma}"
  echo ""

  # Flags de seguridad
  if [[ $EUID -eq 0 ]]; then
    Error "No ejecutes este script como root."
  fi

  # Modo verificación sin instalar
  if [[ "${1:-}" == "--check-only" ]]; then
    VerificarTodas
    exit $?
  fi

  # Instalación según plataforma
  case "$plataforma" in
    linux)
      InstalarApt
      InstalarNpmGlobal
      InstalarPipx
      ;;
    windows)
      Warn "Plataforma Windows detectada (WSL/MSYS2)."
      Warn "Para Windows nativo, usa install.ps1."
      Warn "En WSL, se usa el instalador Linux."
      InstalarApt
      InstalarNpmGlobal
      InstalarPipx
      ;;
    *)
      Error "Plataforma no soportada: $sistema"
      ;;
  esac

  VerificarTodas
}

Main "$@"
