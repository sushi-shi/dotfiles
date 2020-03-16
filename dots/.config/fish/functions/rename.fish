function rename
  for file in *
    if test -f "$file"
      set hash (sha256sum "$file" | cut -c 1-24)
      set ext (echo "$file" | sed 's/^.*\.//')
      mv "$file" (echo {$hash}.{$ext}) 
    end
  end
end
