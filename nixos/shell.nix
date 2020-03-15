{ pkgs, config, ...}:

{
  environment.shellAliases = {
    # Commands for humans
    "l."="ls -ld .* --color=auto --group-directories-first";
    "lo"="ls -Fhl --color=auto --group-directories-first";
    "ls"="ls --color=auto --group-directories-first";
    "free"="free -h";
    "du"="du -h";
    "df"="df -h"; 
    "cp"="cp -iv";
    "mv"="mv -iv";
    "rm"="rm -v";
    "mkd"="mkdir -pv";

    # Shorter!
    "ns"="nix-shell --command fish";
    "nr"="sudo nixos-rebuild switch";
    "ne"="sudoedit /etc/nixos/*";
    "nl"="vim -R /etc/nixos/*";

    "mnt"="udisksctl mount";
    "jc"="journalctl";
    "sc"="systemctl";

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

    "lss"="du -sh * | sort -rh";
    "ccat"="highlight --out-format=ansi";

    # query system-wide packages
    "nq"=''
      find /run/current-system/sw/bin/ -type l -exec readlink {} \; | sed -E 's|[^-]+-([^/]+)/.*|\1|g' | sort -u
    '';

  };
}
