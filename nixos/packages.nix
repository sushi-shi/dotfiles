{ config, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true; 
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # web 
    firefox tixati w3m youtube-dl

    # social
    tdesktop discord

    # media
    mpv zathura ranger sxiv feh jrnl anki

    # vimHuge gives an access to a system clipboard
    (import ./vim.nix) vimHugeX

    # dev
    man-pages ctags 
    cabal2nix git nix-prefetch-git
    ghc haskellPackages.hasktags
    mysql-workbench

    # utils
    htop tree entr wget psmisc unrar
    unzip fzf gimp imagemagick highlight
    neofetch upower tlp linuxPackages.cpupower
    
    # shell/terminal
    fish alacritty

    # etc
    wine
    libreoffice 
  ];

  programs.fish = {
    enable = true;
  };

  # Set vim to be the default editor, twice.
  environment.variables.EDITOR="vim";
  programs.vim.defaultEditor = true;
}
