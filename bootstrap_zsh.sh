#!/bin/zsh
BASEDIR=~/jg_dotfiles

if [[ ! -e "$BASEDIR" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k || exit 1
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting || exit 1
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || exit 1
    mkdir "$BASEDIR"
    git clone "https://github.com/hanebambel/dotfiles.git" "$BASEDIR" || exit 1
    zsh -c "$BASEDIR/create_links.sh"
else
    echo "Folder $BASEDIR already exists, doing nothing!"
fi
