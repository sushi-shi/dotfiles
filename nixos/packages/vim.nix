{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vimHugeX # an access to a system clipboard

    (vim_configurable.customize {
      name = "vim";

      vimrcConfig.pathogen.knownPlugins = vimPlugins;
      vimrcConfig.pathogen.pluginNames = [
        # objects / motions
        "ReplaceWithRegister"
        "vim-commentary"
        "vim-repeat"
        "vim-sort-motion"
        "vim-surround"
        "vim-textobj-user"
        "vim-stylish-haskell"
        "fzfWrapper" "fzf-vim" "nerdtree" 
      ];
    })
  ];
}
