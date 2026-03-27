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
export PATH="$PATH:/Users/jgabor/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

source ~/.zsh_aliases

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
test -e "${HOME}/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" && source "${HOME}/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

complete -o nospace -C /usr/local/bin/terraform terraform

test -e "$HOME/.config/broot/launcher/bash/br" && source "$HOME/.config/broot/launcher/bash/br"
export PATH="/usr/local/opt/openjdk/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="/Users/jgabor/.local/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/Users/jgabor/.local/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"

export NVM_DIR="$HOME/.nvm"
[ -s "/Users/jgabor/.local/opt/nvm/nvm.sh" ] && \. "/Users/jgabor/.local/opt/nvm/nvm.sh"
[ -s "/Users/jgabor/.local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/Users/jgabor/.local/opt/nvm/etc/bash_completion.d/nvm"

export PATH="/Users/jgabor/jg_dotfiles/scripts:$PATH"