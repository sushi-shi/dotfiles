{ pkgs, config, ...}:

{
  
  programs.fish = 
    { enable = true;
    };

  environment.shellAliases = 
    { # Commands for humans
      "l."="ls -ld .* --color=auto --group-directories-first";
      "ll"="ls -hl --color=auto --group-directories-first";
      "ls"="ls --color=auto --group-directories-first";
      "free"="free -h";
      "du"="du -h";
      "df"="df -h"; 
      "di"="df -ih";
      "cp"="cp -iv";
      "mv"="mv -iv";
      "rm"="rm -v";
      "mkd"="mkdir -pv";
      "info"="info --vi-keys";
      "top"="htop";
      "tail"="less +F";
      "vr"="vim -R";

      # Shorter!
      "ns"="nix-shell --command fish";
      "nr"="sudo nixos-rebuild switch";
      "ne"="sudoedit /etc/nixos/**";
      "nE"="vim -R /etc/nixos/**";

      "mnt"="udisksctl mount";
      "jc"="journalctl";
      "sc"="systemctl";

      "v"="vim";
      "sv"="sudoedit";
      "ka"="killall";
      "g"="git";

      # Almost deserve to be scripts, but not quite
      "yd"=''
        youtube-dl --yes-playlist -o $HOME'/Videos/%(playlist_title)s/%(title)s.%(ext)s'
        '';
      "yda"=''
        youtube-dl --yes-playlist -x --audio-quality 0
      '';

      # list sizes
      "lss"="du -sh * | sort -rh | column -t";

      # query system-wide packages
      "nq"=''
        find /run/current-system/sw/bin/ -type l -exec readlink {} \; | sed -E 's|[^-]+-([^/]+)/.*|\1|g' | sort -u
      '';
    };
}
