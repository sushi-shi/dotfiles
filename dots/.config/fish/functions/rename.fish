function rename
  for file in *
    if test -f "$file"
      set hash (sha256sum "$file" | cut -c 1-24)
      set ext (echo "$file" | sed 's/^.*\.//')
      mv "$file" (echo {$hash}.{$ext}) 2>/dev/null && chmod 666 "$file"
    end
  end
end
