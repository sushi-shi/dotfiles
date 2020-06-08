{
  programs.zathura.enable = true;
  programs.zathura.extraConfig = ''
    set statusbar-h-padding 0
    set statusbar-v-padding 0

    set smooth-scroll "true"
    map j scroll half-down
    map k scroll half-up
    map <C-k> zoom out 
    map <C-j> zoom in 
    map K zoom out
    map J zoom in

    map i recolor
    map r reload

    map <C-d> scroll down
    map <C-u> scroll up
    map <PageDown> scroll half-down
    map <PageUp>   scroll half-up
  '';
}