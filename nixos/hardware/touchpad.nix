{ config, pkgs, ... }:

{
  services.xserver.libinput = { 
    enable = true;
    naturalScrolling = true;
    disableWhileTyping = true;
    tapping = true;
    accelProfile = "flat";
  };

  # This one usually activates after suspend. Don't.
  services.xserver = { 
    config = ''
      Section "InputClass"
              Identifier "SynPS/2 Synaptics TouchPad"
              MatchProduct "SynPS/2 Synaptics TouchPad"
              Option "Ignore" "on"
      EndSection
    '';
  };

  # Jerky touchpad after reboot
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
      modprobe -r i2c_hid && modprobe i2c_hid
      # touchpad is not available right after loading the kernel module
      sleep 1
      # xinput lists the touchpad as if it were enabled, but it actually isn't
      # manually disabling and enabling helps though
      xinput disable 'SYNA3081:00 06CB:826F Touchpad'
    '';
  };

}
