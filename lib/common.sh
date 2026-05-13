# Shared helpers for the dotfiles scripts.
# Sourced, not executed. Works under both bash and zsh.

step()  { printf '\n==> %s\n' "$*"; }
info()  { printf '    %s\n' "$*"; }
warn()  { printf '    [!] %s\n' "$*"; }
die()   { printf '    [x] %s\n' "$*" >&2; exit 1; }

# Resolve the dotfiles root from this lib's own location, so callers don't
# need to set $DOTFILES_DIR before sourcing.
if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
    _COMMON_SH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    _COMMON_SH_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
fi
DOTFILES_ROOT="$(cd "$_COMMON_SH_DIR/.." && pwd)"

load_config() {
    local config="$DOTFILES_ROOT/config.sh"
    if [[ -f "$config" ]]; then
        source "$config"
    else
        warn "config.sh not found at $config"
    fi
}

detect_homebrew_prefix() {
    if [[ -x "$HOME/.local/Homebrew/bin/brew" ]]; then
        export HOMEBREW_PREFIX="$HOME/.local"
    elif [[ -x "/opt/homebrew/bin/brew" ]]; then
        export HOMEBREW_PREFIX="/opt/homebrew"
    elif [[ -x "/usr/local/bin/brew" ]]; then
        export HOMEBREW_PREFIX="/usr/local"
    else
        export HOMEBREW_PREFIX=""
    fi
}
