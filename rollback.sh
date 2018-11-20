#!/bin/zsh

# change basename if path differs
BASE_NAME=~/jg_dotfiles/links

BACKUP_DIR=~/jg_dotfiles/backup_originals

for file in "$BASE_NAME"/.*
do
    file_name=$(basename $file)

    if [[ -L ~/"$file_name" ]]; then
        echo "removing link to $file_name"
        rm ~/"$file_name"
    fi
done

cp $BACKUP_DIR/.* ~
