function fv
  set files  ( fzf )

  if test -e "$files"
    vim -- $files 
  end
end
