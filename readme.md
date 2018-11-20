Preqeqs:
* git
* zsh
* nerd-fonts installed and configured in Terminal (e.g. [Fura Code](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraCode.zip) from  [http://nerdfonts.com](http://nerdfonts.com))

To install:

    zsh -c "$(curl -fsSL https://raw.githubusercontent.com/hanebambel/dotfiles/master/bootstrap_zsh.sh)"

Local overrides can be put into ~/.zshrc_local

Backups are made of local config files in ~/jg_dotfiles/backup_originals
To restore call

    zsh ~/jg_dotfiles/rollback.sh

