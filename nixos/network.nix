{ pkgs, config, ... }:

{
  # Don't waste your time, you!
  networking.hosts = {
    "0.0.0.0" = [ 
      "steamcommunity.com" "www.steamcommunity.com"  
      "twitch.tv" "www.twitch.tv"
      "youtube.com" "www.youtube.com"
      "dobrochan.ru" "www.dobrochan.ru"  
      "dobrochan.com" "www.dobrochan.com"  
      "dobrochan.net" "www.dobrochan.net"  
      "nowere.net" "www.nowere.net"  
      "linux.org.ru" "www.linux.org.ru"
      "reddit.com" "www.reddit.com"
      "opennet.ru" "www.opennet.ru"
      "news.ycombinator.com" "news.www.ycombinator.com"

      "facebook.com" "www.facebook.com"
      "api.facebook.com" "fbcdn.net" "www.fbcdn.net"
    ];
  };
}
