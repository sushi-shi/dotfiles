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

  # Auto clean-up
  nix.optimise.automatic = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 8d";

  services.mysql.enable = true;
  services.mysql.package = pkgs.mysql;
  services.mysql.initialDatabases = [
    { name = "music"; schema = "${./data/nfgh.sql}";}
  ];
  services.mysql.bind = "localhost";
  services.mysql.ensureUsers = [
    { 
      name = "sheep"; 
      ensurePermissions = {"*.*" = "ALL PRIVILEGES";} ; 
    }
  ];

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "sheep" ];
}
