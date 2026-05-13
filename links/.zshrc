# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Detect Homebrew prefix and load its shell environment (PATH, MANPATH, etc.)
if [[ -x "$HOME/.local/Homebrew/bin/brew" ]]; then
  eval "$($HOME/.local/Homebrew/bin/brew shellenv)"
elif [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Path to oh-my-zsh
ZSH=$HOME/.oh-my-zsh

# Theme + p10k config
source ~/.zsh_theme

plugins=(git macos brew docker textmate history-substring-search vscode virtualenv zsh-autosuggestions)

unsetopt AUTO_CD

# Local overrides (machine-specific, not tracked by git)
test -e ~/.zshrc_local && source ~/.zshrc_local

source "$ZSH/oh-my-zsh.sh"

# Azure CLI bash completion
autoload -U +X bashcompinit && bashcompinit
if [[ -n "$HOMEBREW_PREFIX" && -f "$HOMEBREW_PREFIX/etc/bash_completion.d/az" ]]; then
  source "$HOMEBREW_PREFIX/etc/bash_completion.d/az"
fi

# VS Code on PATH (if installed in Applications)
[[ -d "$HOME/Applications/Visual Studio Code.app" ]] && \
  export PATH="$PATH:$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

source ~/.zsh_aliases

# Optional integrations -- each only loads if its file exists
test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"
test -e "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" && \
  source "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

command -v terraform &>/dev/null && complete -o nospace -C "$(command -v terraform)" terraform

test -e "$HOME/.config/broot/launcher/bash/br" && source "$HOME/.config/broot/launcher/bash/br"

# NVM (only if installed via Homebrew)
if [[ -n "$HOMEBREW_PREFIX" && -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]]; then
  export NVM_DIR="$HOME/.nvm"
  \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  [[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]] && \
    \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Dotfiles scripts on PATH
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/jg_dotfiles}"
export PATH="$DOTFILES_DIR/scripts:$PATH"
