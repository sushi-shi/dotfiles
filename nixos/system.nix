{ config, pkgs, ... }:

{
  
  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Minsk";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  # Changing brightness
  programs.light.enable = true;

  # Enable printer
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin_3_16_11 ];

  services.upower.enable = true;
  systemd.services.upower.enable = true;

  systemd.user.services.nix-env = {
    description = "Re-save current environment";
    script = ''
      nix-env -q > $HOME/dotfiles/nix/neq.txt
    '';
    startAt = "03:15";
  };

}
