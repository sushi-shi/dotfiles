#!/bin/sh

if ! [ `basename "$PWD"` = dotfiles ]; then
  echo "Should run inside ../dotfiles"
  exit 1
fi

cd dots || exit 1

for dir in $(find . -type d)
do
  mkdir -pv "${HOME}/${dir}" 2>/dev/null
done

for file in $(find . -type f)
do
  ln -fsiv "`readlink -f \"$file\"`" "${HOME}/${file}" 
done

