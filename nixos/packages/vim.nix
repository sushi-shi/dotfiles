with import <nixpkgs> {};

vim_configurable.customize {
  name = "vim";

  vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
  vimrcConfig.vam.pluginDictionaries = [
    { names = [
        # objects / motions
        "ReplaceWithRegister"
        "vim-commentary"
        "vim-repeat"
        "vim-sort-motion"
        "vim-surround"
        "vim-textobj-user"
      ];
    }
    { name = "vim-stylish-haskell"; ft_regex = "^hs\$"; }
    { names = [ 
        # etc.
        "fzfWrapper" 
        "fzf-vim" 
        "nerdtree" 
      ]; 
    }
  ];
}
