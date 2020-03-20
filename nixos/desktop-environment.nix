{ config, pkgs, ... }:

{
  # Related packages
  environment.systemPackages = with pkgs; [
    autorandr
    dmenu 
    notify-desktop
    xbanish
    xclip
    xbindkeys
    xcompmgr
    xmobar
    xorg.xinit
    xorg.xmessage
    xorg.xmodmap
    xscreensaver
  ];

  # Event handler
  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.xscreensaver}/bin/xscreensaver-command -suspend";
  };

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
      extraPackages = haskellPackages: with haskellPackages; [
        xmonad-contrib
        xmonad-extras
        xmonad
      ];

    };

    windowManager.default = "xmonad";
    displayManager = {
      lightdm.greeters.mini = {
        enable = true;
        user = "sheep";
        extraConfig = ''
          [greeter]
          show-password-label = false
          [greeter-theme]
          background-image = "/home/sheep/greeting.jpg"
        '';
      };

      sessionCommands = with pkgs; lib.mkAfter ''
        xmodmap -e 'clear lock'
        xmodmap -e 'keycode 9 = Caps_Lock NoSymbol Caps_Lock'
        xmodmap -e 'keycode 66 = Escape NoSymbol Escape'
        ~/.fehbg &
        xbanish &
        xcompmgr &
        xbindkeys

        xscreensaver -no-splash &
        # an ugly hack
        $HOME/dotfiles/scripts/xscreensaver-sleep &
      '';
    };
  };

}
