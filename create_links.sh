#!/bin/zsh
source "$(dirname "$0")/lib/common.sh"
load_config

BASE_NAME="$DOTFILES_DIR/links"
BACKUP_DIR="$DOTFILES_DIR/backup_originals"

FORCE=0
[[ "$1" == "--force" ]] && FORCE=1

echo "Creating symlinks for config files"
echo "Proceed? (y/n)"
read -r resp
[[ "$resp" != [yY] ]] && { echo "Symlinking cancelled by user"; exit 1; }

[[ ! -d "$BASE_NAME" ]] && die "No links directory at $BASE_NAME"

shopt -s nullglob 2>/dev/null || setopt NULL_GLOB

for file in "$BASE_NAME"/.[!.]*; do
    [[ -f "$file" || -d "$file" ]] || continue
    file_name="$(basename "$file")"
    target="$HOME/$file_name"

    # Back up only a real (non-symlink) original that isn't already our source.
    if [[ -e "$target" && ! -L "$target" && ! "$target" -ef "$file" ]]; then
        mkdir -p "$BACKUP_DIR"
        info "Backing up $file_name"
        mv "$target" "$BACKUP_DIR/" || warn "backup of $file_name failed"
    fi

    if [[ -L "$target" ]]; then
        if [[ "$target" -ef "$file" ]]; then
            info "$file_name already linked, skipping."
            continue
        fi
        if (( FORCE )); then
            info "Repointing $file_name (was: $(readlink "$target"))"
            rm "$target"
        else
            warn "$file_name is a symlink to a different target; use --force to repoint."
            continue
        fi
    fi

    ln -sv "$file" "$target"
done

echo "Done!"
