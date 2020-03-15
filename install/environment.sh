#!/bin/sh

if ! [ `basename "$PWD"` = dotfiles ]; then
  echo "Should be run inside ../dotfiles"
  exit 1
fi

for dir in $(find . \( -path ./nixos -o -path ./.git -o -path ./install \) -prune -o -type d -a -print)
do
  mkdir -p "${HOME}/${dir}" 2>/dev/null
done

for file in $(find . \( -path ./nixos -o -path ./.git -o -path ./install \) -prune -o -type f -a -print)
do
  ln -fsi "`readlink -f \"$file\"`" "${HOME}/${file}" 
done

