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
      xdotool
    ];

  # Enable the X11 windowing system.

  services.xserver = { 
    enable = true;
    layout = "us,ru";
    xkbOptions = "grp:alt_shift_toggle";

    # Explicitly disable for xmonad to start
    desktopManager.xterm.enable = false;
    windowManager.default = "xmonad";

    windowManager.xmonad = { 
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: with haskellPackages; 
        [ xmonad-contrib
          xmonad-extras
          xmonad
        ];
    };

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

  # Locking after 5 minutes of inactivity
  # Locks only when no sound is playing
  services.xserver.xautolock = {
    enable = true;
    time = 5;
    locker = with pkgs; let
      suspend = writeShellScript "suspend-no-sound" ''
        PATH="$PATH":${psmisc}/bin/:${coreutils}/bin:${systemd}/bin

        sounds=$(fuser /dev/snd/* 2>&1 | wc -l | tr -d '\n')

        # pulseaudio always has one file opened
        if [ "$sounds" = "1" ]; then
            systemctl suspend
        fi
      '';
    in "${suspend}";
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
    '';
  };

}
