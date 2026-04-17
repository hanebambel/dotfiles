#!/bin/zsh
# ============================================================
# Dotfiles Configuration
# ============================================================
# Edit these values before running bootstrap_zsh.sh.
# All values have sensible defaults -- only change what you need.
#
# You can also override any of these by exporting the variable
# in your shell before running the bootstrap script, e.g.:
#   DOTFILES_DIR=~/my_dotfiles zsh bootstrap_zsh.sh
# ============================================================

# Where this repo is (or will be) cloned to
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/jg_dotfiles}"

# Git URL used by bootstrap_zsh.sh to clone the repo
export DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/hanebambel/dotfiles.git}"

# Anthropic Foundry settings (used by scripts/activate_ifmllm.sh)
# export ANTHROPIC_FOUNDRY_BASE_URL="https://llm.infomotion.de"
# export FOUNDRY_KEY_FILE="$HOME/.anthropic_foundry_api_key"
