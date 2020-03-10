{ pkgs, config, ...}:

{
  environment.shellAliases = {
    "l."="ls -ld .* --color=auto --group-directories-first";
    "lo"="ls -Fhl --color=auto --group-directories-first";
    "cl!"="clear ; clear";
    "free"="free -h";
    "df"="df -h"; 
    "yd"=''
      youtube-dl --yes-playlist -o $HOME'/Videos/%(playlist_title)s/%(title)s.%(ext)s'
      '';
    "yda"=''
      youtube-dl --yes-playlist -x --audio-quality 0
    '';
    "lss"="du -sh * | sort -rh";

    "ns"="nix-shell --command fish";
    "nr"="sudo nixos-rebuild switch";
    "sv"="sudoedit";

    "pw"=''
      upower \
        -i (upower -e | grep 'BAT') \
        | grep -E "state|to\ full|percentage"
      '';
    "tmp"=''
      paste (cat /sys/class/thermal/thermal_zone*/type | psub) (cat /sys/class/thermal/thermal_zone*/temp | sed 's/^0$'/0000/ | psub)  | column -t -s \t | sed "s/...\$/°C/"
    '';
  };
}
