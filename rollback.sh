#!/bin/zsh
source "$(dirname "$0")/lib/common.sh"
load_config

BASE_NAME="$DOTFILES_DIR/links"
BACKUP_DIR="$DOTFILES_DIR/backup_originals"

echo "Remove symlinks from \$HOME and restore originals from $BACKUP_DIR?"
echo "Proceed? (y/n)"
read -r resp
[[ "$resp" != [yY] ]] && { echo "Rollback cancelled."; exit 1; }

setopt NULL_GLOB

if [[ -d "$BASE_NAME" ]]; then
    for file in "$BASE_NAME"/.[!.]*; do
        file_name="$(basename "$file")"
        if [[ -L "$HOME/$file_name" ]]; then
            info "Removing link to $file_name"
            rm "$HOME/$file_name"
        fi
    done
fi

if [[ -d "$BACKUP_DIR" ]]; then
    backup_files=("$BACKUP_DIR"/.[!.]*)
    if (( ${#backup_files[@]} == 0 )); then
        info "Backup directory is empty, nothing to restore."
    else
        for bf in "${backup_files[@]}"; do
            if cp -v "$bf" "$HOME/"; then
                :
            else
                warn "Failed to restore $(basename "$bf")"
            fi
        done
    fi
else
    info "No backup directory found at $BACKUP_DIR, nothing to restore."
fi
