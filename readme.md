Prerequisites:
* git
* zsh
* nerd-fonts installed and configured in Terminal (e.g. [Fira Code](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraCode.zip) from  [http://nerdfonts.com](http://nerdfonts.com))

## Quick Install

    zsh -c "$(curl -fsSL https://raw.githubusercontent.com/hanebambel/dotfiles/master/bootstrap_zsh.sh)"

## Customization

### For forked repos

1. Fork this repo
2. Edit `config.sh` to set your repo URL and preferred install directory
3. Update the curl URL in the install command above to point to your fork
4. Run the install command

### Environment variable overrides

All scripts respect these environment variables (with defaults shown):

| Variable | Default | Used by |
|---|---|---|
| `DOTFILES_DIR` | `~/jg_dotfiles` | All scripts |
| `DOTFILES_REPO` | `https://github.com/hanebambel/dotfiles.git` | `bootstrap_zsh.sh` |
| `FOUNDRY_KEY_FILE` | `~/.anthropic_foundry_api_key` | `scripts/activate_ifmllm.sh` |
| `ANTHROPIC_FOUNDRY_BASE_URL` | `https://llm.infomotion.de` | `scripts/activate_ifmllm.sh` |

Example: install to a custom directory:

    DOTFILES_DIR=~/my_dotfiles zsh bootstrap_zsh.sh

### Local overrides

Machine-specific shell config can be put into `~/.zshrc_local` -- it is sourced automatically and not tracked by git.

### Optional tools

The `.zshrc` conditionally loads these tools only if they are installed:
* Java (OpenJDK 17 via Homebrew)
* NVM (Node Version Manager)
* Terraform autocomplete
* iTerm2 shell integration
* FZF
* Broot

### Homebrew

Run `bootstrap_homebrew.sh` separately. It supports both standard and sudoless installation modes.

## Backup & Rollback

Backups of your original config files are stored in `$DOTFILES_DIR/backup_originals/`.

To restore:

    zsh ~/jg_dotfiles/rollback.sh
