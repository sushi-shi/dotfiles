{ config, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true; 
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     firefox tixati w3m wine
     anki

     man-pages ctags 
     cabal2nix git nix-prefetch-git
     ghc haskellPackages.hasktags

     htop tree entr wget psmisc unrar
     mpv zathura ranger sxiv feh jrnl
     unzip fzf gimp imagemagick

     (import ./vim.nix) vimHugeX
     
     linuxPackages.cpupower tlp
     fish alacritty
     tdesktop discord
     libreoffice gimp
     neofetch 
     youtube-dl
     upower
     mysql-workbench
  ];

  programs.fish = {
    enable = true;
  };

  # Set vim to be the default editor, twice.
  environment.variables.EDITOR="vim";
  programs.vim.defaultEditor = true;
}
