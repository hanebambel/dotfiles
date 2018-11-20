#!/bin/zsh
BASEDIR=~/jg_dotfiles

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

if [[ ! -e "$BASEDIR" ]]; then
    mkdir $BASEDIR
fi
git clone "https://github.com/hanebambel/dotfiles.git" $BASEDIR
zsh -c "$BASEDIR/create_links.sh"
