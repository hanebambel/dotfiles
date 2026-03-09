#!/bin/zsh

echo "Install SpaceVim? (y/n)"
read -r resp
if [[ "$resp" = [yY] ]]; then
    curl -sLf https://spacevim.org/install.sh | bash
else
    echo "SpaceVim installation skipped."
fi
