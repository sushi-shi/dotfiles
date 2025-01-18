{
  programs.fish.enable = true;
  programs.fish.shellAliases = {
    "vim"  = "nvim";
    "l."   = "eza -ld .* --group-directories-first";
    "ll"   = "eza -l --group-directories-first --git";
    "la"   = "eza -l --group-directories-first --time=atime";
    "ls"   = "eza --group-directories-first";
    "free" = "free -h";
    "du"   = "du -h";
    "df"   = "df -h";
    "di"   = "df -ih";
    "cp"   = "cp -iv";
    "mv"   = "mv -iv";

    "smv"  = "mv --no-clobber -v";
    "scat" = "cat -v";

    "rm"   = "rm -v";
    "mkd"  = "mkdir -pv";
    "info" = "info --vi-keys";
    "tail" = "less +F";
    "fg"   = "fg 1>/dev/null 2>&1";

    "j"    = "pop";   # j-pop, yes
    "jj"   = "pop 2";
    "jjj"  = "pop 3";
    "jjjj" = "pop 4";
    "stopwatch" = "time read";

    "less" = "less --lesskey-file=$XDG_DATA_HOME/lesskey";
    "man"  = ''man --pager="less --lesskey-file=$XDG_DATA_HOME/lesskey"'';
    "wget" = "wget --hsts-file $XDG_DATA_HOME/wget/wget-hsts";



    cbuild      = "cabal build --enable-tests --enable-benchmarks --write-ghc-environment-files=always -O0";
    ctest       = "cabal test --enable-tests --test-show-details=direct -O0";
    cbench      = "cabal bench --enable-benchmarks -O0";
    crun        = "cabal run -O0";
    cclean      = "cabal clean";
    cupdate     = "cabal update";
    crepl       = "cabal repl --build-depends pretty-simple";
    cdoc        = "cabal haddock --enable-documentation";
    cdochackage = "cabal haddock --enable-documentation --haddock-for-hackage";
    cdist       = "cabal sdist";
  };
  programs.fish.shellAbbrs = {
    "ns"   = "nix-shell --command fish";

    "-"    = "cd -";
    "nr"   = "sudo nixos-rebuild switch";
    "ne"   = "sudo -E vim /etc/nixos"; # sudoedit doesn't open directories
    "nE"   = "vim -R /etc/nixos";

    "hr"   = "home-manager switch";
    "he"   = "vim ~/.config/nixpkgs";
    "hE"   = "vim -R ~/.config/nixpkgs";

    "mnt"  = "udisksctl mount";
    "jc"   = "journalctl";
    "sc"   = "systemctl";

    "v"    = "vim -R";
    "vm"   = "vim"; # vim mutable
    "ve"   = "vim ~/.config/nixpkgs/home/vimrc.vim";
    "vs"   = "sudoedit";
    "ka"   = "killall";
    "r"    = "ranger"; # "joshuto";

    "wd"   = "pwd";  # p is hard to type
    "to"   = "htop"; # any problems with that?
    "ot"   = "opt";
    "cit"   = "choose_images_telegram";

    # Notice spaces.
    "note" = " jrnl Note.";
    "day"  = " jrnl A though of the day.";

    # Spawn a new terminal instance.
    "nc" = "ncmpcpp";

    "rgi"  = "rg --ignore-case";

    # list sizes
    "lss"  = "du -sh * | sort -rh | column -t";

    "yd"   = ''yt-dlp'';
    "yda"  = ''yt-dlp --extract-audio --audio-format "best" --audio-quality 0'';

    "g" = ''git'';
    "gd" = ''git diff'';
    "ga" = ''git add'';
    "gc" = ''git commit'';
    "gt" = ''git checkout'';

    "c" = ''cargo'';
    "cr" = ''cargo run'';
    "cb" = ''cargo build'';
    "ct" = ''cargot test'';

    # query system-wide packages
    "nq"   = ''
      find /run/current-system/sw/bin/ -type l -exec readlink {} \; | sed -E 's|[^-]+-([^/]+)/.*|\1|g' | sort -u
    '';
  };

  programs.fish.shellInit = ''
    bind \co 'fg 1>&2 2>/dev/null ; commandline -f repaint'
    bind \cw backward-kill-word

    set -x DIRENV_LOG_FORMAT ""
    set -x fish_color_error 'e27878'
    set -x fish_color_command '84a0c6'
    set -x fish_color_param '84a0c6'
    set -x fish_color_quote 'e2a478'
    set -x fish_color_operator 'e2a478'
    set -x PATH "/home/sheep/dotfiles/scripts/wrappers:$PATH:/home/sheep/dotfiles/scripts"
    set -x XDG_DATA_HOME $HOME/.local/share
    set FZF_DEFAULT_COMMAND 'fd --type f'
    # set PATH $HOME/dotfiles/scripts $PATH
    eval (direnv hook fish)

    function prefix_line
        set -l cmd (commandline)
        set -l line (commandline -L)
        set cmd[$line] "$argv $cmd[$line]"
        commandline -r $cmd
    end

    # Here we bind control-g to insert "command "
    bind \cg 'prefix_line command'
    # And control-t to insert sudo
    bind \ct 'prefix_line sudo'
    bind \cs 'prefix_line steam-run'
    bind \cb 'prefix_line RUST_BACKTRACE=1'
    starship init fish | source
  '';
}
