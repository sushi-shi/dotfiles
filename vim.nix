{ config, pkgs, lib, ... }:

with pkgs;
let
  sources = import ./nix/sources.nix;

  eagerPlugins = with vimPlugins; [
    # Enhancing vim language
    ReplaceWithRegister # gr<object>
    fzf-vim fzfWrapper  # :Files, :Rg, :Colors
    vim-abolish         # :%S/badjob/goodjob/g
    vim-commentary      # gc<motion>
    vim-easy-align      # ga<object><char>
    vim-repeat          # .
    vim-sort-motion     # gs<motion>
    vim-surround        # ys<object><char>
    vim-matchup         # new motions: g%, [%, ]%, z%
    vim-textobj-user

    # Status line
    vim-airline        # New status line
    vim-airline-themes # 'minimalist' theme
    vim-bufferline     # Show open buffers

    # Language pack
    # NOTE: Solidity is slow
    vim-polyglot


    # Language server
    # NOTE: It leaks and slows down after a while
    coc-nvim
    coc-prettier
  ];

  lazyPlugins  = with vimPlugins; [
    # Themes
    iceberg-vim
    nord-vim
    vim-colors-solarized
    vim-colorschemes
  ];

  haskellPlugins = with vimPlugins; [
    haskell-vim
    vim-stylishask
    # vim-textobj-haskell # <action>ah
  ] ++ map mkPlugin [
    "vim-haskellFold"
  ];


  mkPlugin = name: vimUtils.buildVimPlugin {
    pname = name;
    version = "0.0.0";
    src = builtins.fetchTarball {
      url = sources.${name}.url;
      sha256 = sources.${name}.sha256;
    };
  };

  nivLazyPlugins = map mkPlugin [
    # Themes
    "gruvbox"
    "happy_hacking.vim"
    "happy_rusting.vim"
    "vim-farout"
  ];

  nivEagerPlugins = map mkPlugin [
    "venn.nvim"        # :VBox for drawing
    "nvim-gdb"
    "rust.vim"         # I use rust.vim mostly for rustfmt only TODO
    "vim-ingo-library" # library to be used for other (which?) plugins
    "bclose.vim"       # Closes buffer, leaves the window

    "indentLine"       # Beautiful indentation
    "vim-smoothie"     # Smooth-scrolling for <C-d> <C-u>
    "quick-scope"      # Help navigating with f/t

    "vim-move"         # <A-j> <A-k>
    "vim-signature"    # Signatures for navigation marks
    "vim-textobj-line" # <action>al

    "vim-indent-object"
    "vim-textobj-entire" # <action>ae, <action>ie
    # Usecase:
    #     Paste some text into a new buffer (<C-w>n"*P) -- note that the initial empty line is left as the last line.
    #     Edit the text (:%s/foo/bar/g etc)
    #     Then copy the resulting text to another application ("*yie)


    "sideways.vim"    # move arguments in functions
    "splitjoin.vim"   # context aware splits and joins
    "ranger.vim"
  ];

  nivUnusedPlugins = map mkPlugin [
    "ale"
    "vim-ripgrep"
    "switch.vim" # Conflicts with sort for now
    "vimspector"

    "startuptime.vim"
    "firenvim"
    "vimroom"          # <leader>V
    "vim-bookmarks"
    "vim-haskell"
    "vim-hoogle"
  ];


  nvim = neovim.override {
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = "source ~/.config/nvim/init.vim";
      packages.myVimPackage = {
        start = eagerPlugins ++ nivEagerPlugins ++ lazyPlugins ++ nivLazyPlugins ++ haskellPlugins;
        opt = [];
      };
    };
  };

in
{
  home.packages = [
    nvim
    xsel   # X clipboard
    nodejs # coc-nvim


    # ccls   # c++ language server
    # cpplint # c linter which is annoying
    llvm
  ];
}

