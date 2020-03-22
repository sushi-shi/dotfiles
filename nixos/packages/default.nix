{ config, pkgs, ... }:

{
  imports = 
    [ 
      ./shell.nix
      ./vim.nix
    ];

  nixpkgs.config = 
    { allowUnfree = true; 
    };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; 
    [ # web 
      firefox tixati w3m youtube-dl

      # social
      tdesktop discord

      # media
      mpv zathura ranger sxiv feh jrnl anki
      gimp imagemagick libreoffice 

      # dev
      man-pages clang-manpages posix_man_pages ctags 
      cabal2nix git nix-prefetch-git
      ghc haskellPackages.hasktags
      mysql-workbench

      # utils
      htop tree entr wget psmisc unrar
      unzip fzf highlight lsof ripgrep lsscsi
      neofetch upower tlp linuxPackages.cpupower
      binutils
      
      # shell/terminal
      fish alacritty tmux

      # etc
      wine
    ];

  environment.variables.EDITOR = "vim";
}
