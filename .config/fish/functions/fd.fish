function fd
  set dir (find * -type d -print 2> /dev/null | fzf) 

  if test -d "$dir"
    cd "$dir"
  end
end
