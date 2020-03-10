#!/bin/sh

# update .nix
find -name '*.cabal' | entr -s 'cabal2nix . > default.nix' &>/dev/null &

# build a program
# `touch` is used for waiting with another script for the program to compile
# find -name '*.hs'    | entr -s 'nix-build release.nix --quiet && touch CHANGELOG.md' &>/dev/null &

# generate new tags
find -name '*.hs'    | entr -s 'hasktags --ctags .' &>/dev/null &

# run hoogle
# hoogle generate &>/dev/null & && hoogle server &>/dev/null &

# ghcid to run them all
nix-shell --pure --run 'ghcid'

killall entr
