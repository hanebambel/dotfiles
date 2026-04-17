# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="agnoster-jan"
source ~/.zsh_theme

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git macos brew docker textmate history-substring-search lol vscode virtualenv zsh-autosuggestions)

unsetopt AUTO_CD

#load local overrides
test -e ~/.zshrc_local && source ~/.zshrc_local

source "$ZSH/oh-my-zsh.sh"

autoload -U +X bashcompinit && bashcompinit
test -e /usr/local/etc/bash_completion.d/az && source /usr/local/etc/bash_completion.d/az

# Customize to your needs...
export PATH="$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin"
export PATH="$PATH:$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

source ~/.zsh_aliases

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
test -e "${HOME}/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" && source "${HOME}/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

command -v terraform &>/dev/null && complete -o nospace -C "$(command -v terraform)" terraform

test -e "$HOME/.config/broot/launcher/bash/br" && source "$HOME/.config/broot/launcher/bash/br"
# Java (only if installed)
if [ -d "$HOME/.local/opt/openjdk@17" ]; then
  export PATH="$HOME/.local/opt/openjdk@17/bin:$PATH"
  export JAVA_HOME="$HOME/.local/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
elif [ -d "/usr/local/opt/openjdk" ]; then
  export PATH="/usr/local/opt/openjdk/bin:$PATH"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# NVM (only if installed)
export NVM_DIR="$HOME/.nvm"
if [ -s "$HOME/.local/opt/nvm/nvm.sh" ]; then
  \. "$HOME/.local/opt/nvm/nvm.sh"
  [ -s "$HOME/.local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOME/.local/opt/nvm/etc/bash_completion.d/nvm"
fi

# Dotfiles scripts
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/jg_dotfiles}"
export PATH="$DOTFILES_DIR/scripts:$PATH"