#!/bin/zsh
# Bootstrap entry point. Designed to work both locally and via curl-pipe:
#   zsh -c "$(curl -fsSL .../bootstrap_zsh.sh)"
# In the curl-pipe case, $0 is "zsh" and the repo isn't cloned yet, so we
# can't source lib/common.sh until after the clone.

set -e

# ── inline defaults (mirror config.sh so curl-pipe works without it) ─────────

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/jg_dotfiles}"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/hanebambel/dotfiles.git}"
ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$ZSH_DIR/custom}"

step() { printf '\n==> %s\n' "$*"; }
info() { printf '    %s\n' "$*"; }

# ── oh-my-zsh ─────────────────────────────────────────────────────────────────

if [[ ! -d "$ZSH_DIR" ]]; then
    step "Installing oh-my-zsh..."
    RUNZSH=no CHSH=no \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    info "oh-my-zsh already installed."
fi

# ── plugins & theme (clone if missing) ────────────────────────────────────────

clone_if_missing() {
    local dest="$1" repo="$2" extra="$3"
    if [[ ! -d "$dest" ]]; then
        step "Cloning $(basename "$dest")..."
        # shellcheck disable=SC2086
        git clone $extra "$repo" "$dest"
    else
        info "$(basename "$dest") already present."
    fi
}

clone_if_missing "$ZSH_CUSTOM_DIR/themes/powerlevel10k" \
    https://github.com/romkatv/powerlevel10k.git "--depth=1"
clone_if_missing "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" \
    https://github.com/zsh-users/zsh-syntax-highlighting.git ""
clone_if_missing "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" \
    https://github.com/zsh-users/zsh-autosuggestions.git ""

# ── dotfiles repo ─────────────────────────────────────────────────────────────

if [[ ! -d "$DOTFILES_DIR" ]]; then
    step "Cloning dotfiles to $DOTFILES_DIR..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
    step "Updating dotfiles in $DOTFILES_DIR..."
    git -C "$DOTFILES_DIR" pull --ff-only || info "(pull skipped/failed -- continuing)"
fi

# ── symlinks (now that the repo is on disk) ───────────────────────────────────

step "Linking config files..."
zsh "$DOTFILES_DIR/create_links.sh"
