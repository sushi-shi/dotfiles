{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
  };

  home.packages = with pkgs; let
    unfree = [
      discord
      # zoom-us
      steam

      slack
      atlassian-jira

      clipit
      google-chrome

      audio-recorder
      openjdk8
      wineWowPackages.base
      zathura
      gimp imagemagick
      glade
      cloc

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

    utils = [
      ghc
      youtube-dl
      gallery-dl
      xdot
      pcre
      dhcp
      pass
      gnupg
      wpa_supplicant_gui # wifi connecter

      gnome3.gnome-sound-recorder # record my beautiful voice

      exa           # ls replacement in Rust

      tldr          # man with examples
      file          # types of files
      sysstat       # iostat, pidstat
      atool         # Archive helper

      niv           # Nix autoupdate

      usbutils      # lsusb and similar
      lshw          # list hardware
      mtr           # traceroute, ping
      ntfs3g        # mounting ntfs stuff
      go-mtpfs      # connect Android devices
      qt5.qttools   # QT interface

      graphviz      # Graphs builder

      highlight     # ???
      gron          # greppable JSON
      ripgrep-all   # greppable pdfs, images, subtitles, all

      parallel-full # execute jobs in parallel
    ]; 

    apps = [
      libreoffice
      vlc 

      lxqt.pavucontrol-qt

      tdesktop

      mpd           # music server
      ncmpcpp       # music player
      # (zathura.override {
      # })
      sxiv        # Simple X Image Viewer

      torsocks
      jrnl        # diary
      irssi         # IRC Channel

      gnome3.cheese #  webcam
    ];
  in 
    apps ++ utils ++ x-related ++ unfree;
}
