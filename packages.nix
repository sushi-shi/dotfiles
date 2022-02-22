{ pkgs, ... }:
{
  imports = [
    ./vim.nix
    ./fish.nix
  ];

  programs.firefox = {
    enable = true;
  };

  programs.mpv = {
    enable = true;
    bindings = {
      "k" = "seek -15";
      "j" = "seek 15";
    };
  };

  services.lorri.enable = true;
  services.mpd.enable = true;
  services.mpd.musicDirectory = "/home/sheep/Music";
  services.dunst.enable = true;


  home.packages = with pkgs; let
    utils = [
      ghc
      spotdl        # spotify-dl (from YouTube)
      yt-dlp        # better youtube-dl
      gallery-dl    # download images from web
      xdot          # graph viewer
      pcre          # pcregrep: Perl regexes
      pass          # GPG encrypted password manager
      gnupg         # GPG itself
      wpa_supplicant_gui # wifi connecter

      gnome3.gnome-sound-recorder # record my beautiful voice

      exa           # ls replacement in Rust

      tealdeer      # better tldr
      file          # types of files
      sysstat       # iostat, pidstat
      atool         # Archive helper

      niv           # Nix autoupdate

      usbutils      # lsusb and similar
      lshw          # list hardware
      mtr           # traceroute, ping
      ntfs3g        # mounting ntfs stuff
      go-mtpfs      # connect Android devices

      graphviz      # Graphs builder

      highlight     # ???
      gron          # greppable JSON
      ripgrep-all   # greppable pdfs, images, subtitles, all

      parallel-full # execute jobs in parallel
    ]; 

    apps = [
      zulip         # OS slack!
      pasystray     # moving PulseAudio sources/sinks

      audio-recorder
      wineWowPackages.base
      zathura
      gimp imagemagick
      cloc

      libreoffice

      lxqt.pavucontrol-qt

      tdesktop

      mpd           # music server
      ncmpcpp       # music player
      sxiv        # Simple X Image Viewer

      torsocks
      jrnl          # diary
      irssi         # IRC Channel

      gnome3.cheese #  webcam
    ];

    unfree = [
      skypeforlinux
      steam
      slack
      google-chrome
      spotify
    ];

    iphone = [
      ifuse 
      libimobiledevice
      usbmuxd
    ];

    x-related = [
      nethogs


      xkb-switch
      xorg.xkbcomp
      xss-lock
      xbindkeys
      xorg.xmodmap
      (pkgs.callPackage ./pkgs/kalker/default.nix {})
      (pkgs.callPackage ./pkgs/termusic/default.nix {})

      slop           # Select rectangle
      feh            # Wallpaper
      rofi-unwrapped # windows switcher
      shotgun        # Screenshots
    ];

    unused = [
      # unfree
      discord
      atlassian-jira
      zoom-us

      # utils
      clipit        # clipboard manager (worked poorly)
      openjdk8      # OS java implementation
      tldr          # man with examples
      youtube-dl
      dhcp
      qt5.qttools   # QT interface (TODO interface to what?)

      # apps
      glade         # gtk3 interface designer
      vlc           # audio player

    ];


  in 
    apps ++ utils ++ x-related ++ iphone ++ unfree;
}
