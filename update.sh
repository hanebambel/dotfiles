#!/bin/zsh
# Idempotent re-run of the bootstrap pipeline. Safe to run any time.
source "$(dirname "$0")/lib/common.sh"
load_config

if [[ -d "$DOTFILES_DIR/.git" ]]; then
    step "Pulling latest dotfiles..."
    git -C "$DOTFILES_DIR" pull --ff-only || warn "git pull failed (continuing)"
fi

step "Refreshing oh-my-zsh, plugins, and symlinks..."
zsh "$DOTFILES_DIR/bootstrap_zsh.sh"

step "Updating Homebrew + packages..."
zsh "$DOTFILES_DIR/bootstrap_homebrew.sh"

info "Done. Restart your shell or 'source ~/.zshrc' to pick up changes."
