{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; 
    [ 
      (vim_configurable.customize { 
        name = "vim";
        vimrcConfig.customRC = ''
          source $HOME/.vimrc
        '';

        vimrcConfig.packages.myVimPackage = with vimPlugins; { 
          start = [ 
            ReplaceWithRegister
            vim-commentary
            vim-repeat
            vim-sort-motion
            vim-surround
            vim-textobj-user
            vim-stylish-haskell
            fzfWrapper fzf-vim nerdtree 
          ];
        };
      })

      vimHugeX # an access to a system clipboard
    ];
}
