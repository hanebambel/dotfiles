Prerequisites:
* git
* zsh
* nerd-fonts installed and configured in Terminal (e.g. [Fira Code](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraCode.zip) from  [http://nerdfonts.com](http://nerdfonts.com))

## Quick Install

    zsh -c "$(curl -fsSL https://raw.githubusercontent.com/hanebambel/dotfiles/master/bootstrap_zsh.sh)"

## Updating an existing install

Once installed, pull the latest changes and re-run everything idempotently:

    zsh ~/jg_dotfiles/update.sh

This pulls the repo, refreshes oh-my-zsh + plugins, re-links any new dotfiles, and runs `brew update && brew upgrade && brew bundle`. Safe to run any time.

## Customization

### For forked repos

1. Fork this repo
2. Edit `config.sh` to set your repo URL and preferred install directory
3. Update the curl URL in the install command above to point to your fork
4. Run the install command

### Environment variable overrides

`config.sh` is sourced by all bootstrap, update, and activate scripts. Edit it directly, or export overrides in your shell before running:

| Variable | Default | Used by |
|---|---|---|
| `DOTFILES_DIR` | `~/jg_dotfiles` | All scripts |
| `DOTFILES_REPO` | `https://github.com/hanebambel/dotfiles.git` | `bootstrap_zsh.sh` |

### Anthropic Foundry (manual activation)

`scripts/activate_ifmllm.sh` is a standalone script -- it doesn't read `config.sh` and isn't part of the bootstrap pipeline. Source it on demand to set the Foundry env vars:

    source ~/jg_dotfiles/scripts/activate_ifmllm.sh

It honours these env overrides (with defaults shown):

| Variable | Default |
|---|---|
| `FOUNDRY_KEY_FILE` | `~/.anthropic_foundry_api_key` |
| `ANTHROPIC_FOUNDRY_BASE_URL` | `https://llm.infomotion.de` |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | `azure_ai/claude-opus-4-7[1m]` |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | `azure_ai/claude-sonnet-4-6[1m]` |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | `azure_ai/claude-haiku-4-5` |

To unset everything: `source ~/jg_dotfiles/scripts/deactivate_ifmllm.sh`.

Example: install to a custom directory:

    DOTFILES_DIR=~/my_dotfiles zsh bootstrap_zsh.sh

### Local overrides

Machine-specific shell config can be put into `~/.zshrc_local` -- it is sourced automatically and not tracked by git. Good place for things you want on one notebook but not another (e.g. Java's `PATH`/`JAVA_HOME`, work-specific aliases, machine-local env vars).

### Optional tools

The `.zshrc` conditionally loads these tools only if they are installed:
* NVM (Node Version Manager, via Homebrew)
* Terraform autocomplete
* iTerm2 shell integration
* FZF
* Broot
* Azure CLI completion

### Homebrew

Run `bootstrap_homebrew.sh` separately. It supports both standard and sudoless installation modes, and untaps the deprecated `homebrew/cask-fonts`, `homebrew/cask-versions`, `homebrew/command-not-found`, `homebrew/bundle`, and `homebrew/services` taps on each run.

## Backup & Rollback

Backups of your original config files are stored in `$DOTFILES_DIR/backup_originals/`.

To restore:

    zsh ~/jg_dotfiles/rollback.sh
