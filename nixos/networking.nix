{ pkgs, config, ... }:

{
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  networking.wireless = {
    enable = true;
    networks = {
      "Toodles!" = {
        psk = "iw4fdythi9doh1";
      };
      "TP-LINK_2CCC" = {
        psk = "77044099";
      };
    };
    extraConfig = ''
      ctrl_interface=/run/wpa_supplicant
      ctrl_interface_group=wheel
    '';
  };
  networking.hosts = {
    "0.0.0.0" = [ 
      "steamcommunity.com" "www.steamcommunity.com"  
      "twitch.tv" "www.twitch.tv"
      # "youtube.com" "www.youtube.com"
      "dobrocan.ru" "www.dobrochan.ru"  
      "dobrocan.com" "www.dobrochan.com"  
      "dobrocan.net" "www.dobrochan.net"  
      "nowere.net" "www.nowere.net"  
      "linux.org.ru" "www.linux.org.ru"
      "reddit.com" "www.reddit.com"
      "opennet.ru" "www.opennet.ru"
      "news.ycombinator.com" "news.www.ycombinator.com"
    ];
  };
}
