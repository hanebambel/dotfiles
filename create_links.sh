#!/bin/sh
BASE_NAME=~/jg_dotfiles/links
BACKUP_DIR=backup_originals

for file in "$BASE_NAME"/.*
do
  if [ -f "$file" ]; then
    file_name=$(basename $file)
    echo $file_name
    
    # If original still exists, backup it..
    if [ -f ~/"$file_name" ]; then
      echo "backing up $file_name.."
      mv ~/"$file_name" $BACKUP_DIR 
    fi

    # Create symlink
    if [ -L ~/"$file_name" ]; then
      echo "$file_name already linked, skipping.."
    else
      echo "linking $file_name"
      ln -sv $file ~
    fi

  fi
done

