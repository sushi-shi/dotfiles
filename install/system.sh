#!/bin/sh

if ! [ `basename "$PWD"` = dotfiles ]; then
  echo "Should be run inside ../dotfiles"
  exit 1
fi

for nix in $( find -path './nixos/*' -a -type f -a -exec "basename" '{}' \; )
do
  if [ "$nix" = "hardware-configuration.nix" ]; then
    echo "Are you sure you want to rewrite your hardware configuration? (y/N)"
    read answer
    if ! [ "$answer" = "y" ]; then
      continue
    fi
    echo "You can regenerate yours with nixos-generate-config then."
  elif [ "$nix" = "configuration.nix" ]; then
    echo "If you are using BIOS you should not forget to fix 'configuration.nix'"
    echo "Replacing? (y/N)"
    read answer
    if ! [ "$answer" = "y" ]; then
      continue
    fi
  fi
  sudo ln -fsi "`readlink -f \"$nix\"`" "/etc/nixos/${nix}" 
done

echo "Rebuilding?"
read answer
if [ "$answer" = "y" ]; then
  sudo nixos-rebuild switch
fi
