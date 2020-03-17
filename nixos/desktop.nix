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

    windowManager.default = "xmonad";
    displayManager = {
      lightdm.greeters.mini = {
        enable = true;
        user = "sheep";
        extraConfig = ''
          [greeter]
          show-password-label = false
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

  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
    disableWhileTyping = true;
    tapping = true;
    accelProfile = "flat";
  };

  services.xserver = {
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
  };

  systemd.services.touchpad = {
    description = "Reload drivers for a touchpad";
    wantedBy = [ "post-resume.target" ];
    after = [ "post-resume.target" ];
    environment = {
      DISPLAY=":0";
      XAUTHORITY="/home/sheep/.Xauthority";
    };
    path = with pkgs; [ kmod xorg.xinput ];
    script = ''
      modprobe -r i2c_hid && modprobe  i2c_hid
      sleep 1
      xinput disable 'SYNA3081:00 06CB:826F Touchpad'
    '';
  };

  # Changing brightness
  programs.light.enable = true;
}
