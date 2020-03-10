function fish_prompt
  if test "$IN_NIX_SHELL" = "pure"
    set_color $fish_color_cwd
    echo '(nix)$ '
  else
    set_color normal
    echo '$ '
  end
end
