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

  home.sessionVariables = {
    _JAVA_AWT_WM_MONREPARENTING = "1";
  };


  home.packages = with pkgs; let
    utils = [
      # Tool for checking EPUB files
      epubcheck


      # Tool to mirror websites.
      # I learned about it here: https://serverfault.com/questions/73962/wget-recursive-download-but-i-dont-want-to-follow-all-links
      # And I used it to mirror /u/ and /dt/ on dobrochan:
      # ```sh
      # httrack "https://old.dobrochan.net/archive/u/1.html" \
      # -O uni \
      # "-*" \
      # "+https://old.dobrochan.net/archive/u/*.html"
      # ```
      httrack

      protontricks
      protonup-ng

      ghidra

      libheif
      xplr
      ccls
      # sqlx-cli
      postgresql_15
      # wine
      (wine.override { wineBuild = "wine64"; })

      # dbeaver       # Database viewer
      bash-completion
      texlive.combined.scheme-full
      # grcov         # Parse files reporting test coverage
      onboard       # Virtual keyboard
      jmtpfs        # Connect android devices via MTP
      calibre       # Convert one text format into another easily
      starship      # Sexy prompt for any shell
      jq            # Format JSON, echo '{ henlo: 'henlo' } | jq
      anki-bin      # There is also anki package, but it is outdated
      ffsend        # Share files from CLI
      difftastic    # Smart diff utility
      wget
      paprefs       # multiple outputs
      entr          # run command on file update
      (ffmpeg.override {
        withXcb = true;
      })
      sd            # better sed
      gromit-mpx    # on-screen drawing
      yt-dlp        # better youtube-dl
      gallery-dl    # download images from web
      xdot          # graph viewer
      pcre          # pcregrep: Perl regexes
      pass          # GPG encrypted password manager
      gnupg         # GPG itself
      wpa_supplicant_gui # wifi connecter

      gnome-sound-recorder # record my beautiful voice

      eza           # for of exa; ls replacement in Rust

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

      pasystray     # moving PulseAudio sources/sinks
      parallel-full # execute jobs in parallel
      ncdu          # disk usage analyzer
      torsocks
    ];

    apps = [
      tdesktop

      signal-desktop # Secure telegram
      kalker         # command line calculator

      audio-recorder
      zathura
      gimp imagemagick
      tokei         # count lines of code

      lxqt.pavucontrol-qt

      mpd           # music server
      ncmpcpp       # music player
      nsxiv         # Simple X Image Viewer

      fontconfig    # Possibly needed by sxiv
      freetype      # Possibly needed by sxiv
    ];

    games = [
      steam-run-native
      gzdoom
    ];

    unfree = [
      haguichi
      logmein-hamachi
    ];

    iphone = [
      ifuse
      libimobiledevice
      usbmuxd
    ];

    x-related = [
      cheese #  webcam
      nethogs

      xkb-switch
      xorg.xkbcomp
      xorg.libXft
      xss-lock
      xbindkeys
      xorg.xmodmap

      slop           # Select rectangle
      feh            # Wallpaper
      rofi-unwrapped # windows switcher
      shotgun        # Screenshots
    ];

    unused = [
      steam
      spotify
      jrnl          # diary

      teams-for-linux

      wineWowPackages.base
      libreoffice
      ghc
      (pkgs.callPackage ./pkgs/joshuto/default.nix {})
      (pkgs.callPackage ./pkgs/termusic/default.nix {})

      # games
      brogue
      wesnoth

      # unfree
      slack
      tixati
      skypeforlinux
      discord
      atlassian-jira
      zoom-us

      # utils
      ripgrep-all   # greppable pdfs, images, subtitles, all
      clipit        # clipboard manager (worked poorly)
      openjdk8      # OS java implementation
      tldr          # man with examples
      youtube-dl
      dhcp
      qt5.qttools   # QT interface (TODO interface to what?)
      spotdl        # spotify-dl (from YouTube)

      # apps
      zulip          # OS slack!
      irssi         # IRC Channel
      tor-browser-bundle-bin # torproject.org is banned
      glade         # gtk3 interface designer
      vlc           # audio player

    ];


  in
    apps ++ utils ++ x-related ++ iphone ++ unfree ++ games;
}
