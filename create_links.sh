#!/bin/zsh

# change basename if path differs
BASE_NAME=~/jg_dotfiles/links

BACKUP_DIR=~/jg_dotfiles/backup_originals

echo "Creating symlinks for config files"
echo "Proceed? (y/n)"
read -r resp
if [[ "$resp" = [yY] ]]; then

  for file in "$BASE_NAME"/.[!.]*
  do
    # handle files and directories
    if [[ -f "$file" ]] || [[ -d "$file" ]]; then
      file_name=$(basename "$file")

      if [[ ! -e "$BACKUP_DIR" ]]; then
        echo "creating backup folder..."
        mkdir "$BACKUP_DIR"
      fi

      # If original still exists, back it up
      if [[ ! ~/"$file_name" -ef "$file" ]]; then
        echo "backing up $file_name.."
        mv ~/"$file_name" "$BACKUP_DIR"
      fi

      # Create symlink
      if [[ -L ~/"$file_name" ]]; then
        echo "$file_name already linked, skipping.."
      else
        ln -sv "$file" ~
      fi # test for link
    fi # test for file or dir
  done
  echo "Done!"
else
  echo "Symlinking cancelled by user"
  exit 1
fi
