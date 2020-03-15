{ config, pkgs, ... }:

{
  # Related packages
  environment.systemPackages = with pkgs; [
    autorandr
    dmenu 
    notify-desktop
    xbanish
    xbindkeys
    xcompmgr 
    xmobar
    xorg.xinit
    xorg.xmessage
    xorg.xmodmap 
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
      extraPackages = haskellPackages: with haskellPackages; [
        xmonad-contrib
        xmonad-extras
        xmonad
      ];
    };

    # This one usually activates after Suspend. Don't.
    # After suspend the touchpad still becomes jerky.
    # And sometimes it doesn't activate at all. Sad.
    config = ''
      Section "InputClass"
              Identifier "SynPS/2 Synaptics TouchPad"
              MatchProduct "SynPS/2 Synaptics TouchPad"
              Option "Ignore" "on"
      EndSection
    '';
    windowManager.default = "xmonad";
    displayManager.sessionCommands = pkgs.lib.mkAfter ''
      xmodmap -e 'clear lock'
      xmodmap -e 'keycode 9 = Caps_Lock NoSymbol Caps_Lock'
      xmodmap -e 'keycode 66 = Escape NoSymbol Escape'
      ~/.fehbg &
      xbanish &
      xcompmgr &
      xbindkeys
      xscreensaver -no-splash &
    '';
  };

  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
    disableWhileTyping = true;
    tapping = true;
    accelProfile = "flat";
  };

  # Changing brightness
  programs.light.enable = true;
}
