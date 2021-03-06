#!/bin/zsh

# change basename if path differs
BASE_NAME=~/jg_dotfiles/links

BACKUP_DIR=~/jg_dotfiles/backup_originals

echo "Createing symlinks for config files"
echo "Proceed? (y/n)"
read resp
if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then

  for file in "$BASE_NAME"/.*
  do
    # handle files
    if [[ -f "$file" ]] || [[ -d "$file" ]]; then
      file_name=$(basename $file)
      #echo $file_name

      if [[ ! -e $BACKUP_DIR ]]; then
        echo "creating backup folder..."
        mkdir $BACKUP_DIR
      fi
      
      # If original still exists, backup it..
      if [[ ! ~/"$file_name" -ef "$file" ]]; then
        echo "backing up $file_name.."
        mv ~/"$file_name" $BACKUP_DIR 
      fi 

      # Create symlink
      if [[ -L ~/"$file_name" ]]; then
        echo "$file_name already linked, skipping.."
      else
        #echo "linking $file_name"
        ln -sv $file ~
      fi # test for link
    fi # test for file or dir
  done
  echo "Done!"
else
  echo "Symlinking cancelled by user"
	return 1
fi

