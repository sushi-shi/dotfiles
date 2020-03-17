# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./desktop.nix
      ./networking.nix
      ./packages.nix
      ./shell.nix
      ./user.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  # Bluetooth
  hardware.bluetooth = {
    enable = false;
    powerOnBoot = false;
  };
  
  # Event handler
  programs.xss-lock = {
    enable = true;

    # also a hack but it works
    lockerCommand = "$HOME/dotfiles/scripts/my-suspend";
  };


  # Enable printer
  # (Doesn't work)
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin_3_16_11 ];

  services.upower.enable = true;
  systemd.services.upower.enable = true;

  # TLP daemon
  # TODO: set cpufreq in tlp config
  # services.tlp.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.cpufreq.max = 2800000;

  # Auto upgrade, seems like it isn't working! 
  # system.autoUpgrade.enable = true;

  # Auto clean-up
  nix.optimise.automatic = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 8d";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

