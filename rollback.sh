#!/bin/zsh

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/jg_dotfiles}"
BASE_NAME="$DOTFILES_DIR/links"
BACKUP_DIR="$DOTFILES_DIR/backup_originals"

for file in "$BASE_NAME"/.[!.]*
do
    file_name=$(basename "$file")

    if [[ -L ~/"$file_name" ]]; then
        echo "removing link to $file_name"
        rm ~/"$file_name"
    fi
done

if [[ -d "$BACKUP_DIR" ]]; then
    cp -v "$BACKUP_DIR"/.[!.]* ~
else
    echo "No backup directory found at $BACKUP_DIR, nothing to restore."
fi
