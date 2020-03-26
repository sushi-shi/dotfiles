{ config, pkgs, ... }:

{
  # Related packages
  environment.systemPackages = with pkgs; 
    [ autorandr
      dmenu 
      notify-desktop
      xclip
      xmobar
      xorg.xinit
      xorg.xmessage
      xscreensaver
    ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us,ru";
  services.xserver.xkbOptions = "grp:alt_shift_toggle";

  # XMonad
  services.xserver = { 
    desktopManager.xterm.enable = false;

    windowManager.xmonad = { 
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: with haskellPackages; 
        [ xmonad-contrib
          xmonad-extras
          xmonad
        ];
    };

    windowManager.default = "xmonad";
    displayManager = { 
      lightdm.background = let
        image = pkgs.runCommand "background-image" {} ''
          cp ${./data/images/background.png} $out
        '';
      in "${image}";

      lightdm.greeters.mini = { 
        enable = true;
        user = "sheep";
        extraConfig = ''
          [greeter]
          show-password-label = false
          [greeter-theme]
          border-width = 0
          font-size = 13
          window-color = "#000000"
        '';
      };

      sessionCommands = with pkgs; lib.mkAfter ''
        ${xorg.xmodmap}/bin/xmodmap -e 'clear lock'
        ${xorg.xmodmap}/bin/xmodmap -e 'keycode 9 = Caps_Lock NoSymbol Caps_Lock'
        ${xorg.xmodmap}/bin/xmodmap -e 'keycode 66 = Escape NoSymbol Escape'
        ~/.fehbg &
        ${xbanish}/bin/xbanish &
        ${xcompmgr}/bin/xcompmgr &
        ${xbindkeys}/bin/xbindkeys

        ${xscreensaver}/bin/xscreensaver -no-splash &
      '';
    };
  };

  services.xserver.xautolock = {
    enable = true;
    killtime = 11;
    killer = "${pkgs.systemd}/bin/systemctl suspend";
    time = 10;
    locker = "${pkgs.xscreensaver}/bin/xscreensaver-command -lock";
  };

  systemd.services.lock = {
    description = "Lock the screen";
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];
    environment = {
      DISPLAY=":0";
      XAUTHORITY="/home/sheep/.Xauthority";
    };
    script = ''
      ${pkgs.xscreensaver}/bin/xscreensaver-command -lock
      ${pkgs.pulseaudio}/bin/pactl "set-sink-mute @DEFAULT_SINK@ 1"
    '';
  };

}
