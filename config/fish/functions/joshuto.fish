function joshuto
	set TEMP_FILE (mktemp -t tmp.XXXXXX)

  command joshuto --last-dir $TEMP_FILE $argv
  if test -s $TEMP_FILE
    set JOSHUTO_CWD (cat $TEMP_FILE)
    builtin cd -- $JOSHUTO_CWD
  end

  command	rm -f -- $CWD_FILE 
end
