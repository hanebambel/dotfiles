#!/bin/zsh
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/jg_dotfiles}"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/hanebambel/dotfiles.git}"

if [[ ! -e "$DOTFILES_DIR" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k || exit 1
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting || exit 1
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || exit 1
    mkdir "$DOTFILES_DIR"
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR" || exit 1
    zsh -c "$DOTFILES_DIR/create_links.sh"
else
    echo "Folder $DOTFILES_DIR already exists, doing nothing!"
fi
