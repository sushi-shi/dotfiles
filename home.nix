{ config, pkgs, lib, ... }:
{
  imports = [
    ./packages.nix
  ];

  # Copy everything from `./config` into `~/.config`
  xdg.configFile."." = {
    source = ./config;
    recursive = true;
  };

  # Copy everything from `./home` into `~` and prepend `.` to it.
  home.username = "sheep";
  home.homeDirectory = "/home/sheep";
  home.file = with lib.attrsets; let
    files  = builtins.readDir prefix;
    prefix = ./home;
    each   = name: value: nameValuePair ("." + name) (config (prefix + ("/" + name)) value);

    config = name: value:
      if value == "directory"
        then { source = name; recursive = true; }
        else { text = builtins.readFile name;   };
    in mapAttrs' each files;

  # .Xresources
  xresources.properties = {
    "*background" = "#282828";
    "*foreground" = "#e2a478";
    "*font"       = "Hasklig";
  };


  programs.home-manager = {
    enable = true;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
}
