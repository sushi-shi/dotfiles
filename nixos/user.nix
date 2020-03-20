{ pkgs, config, ... }:

{
 # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sheep = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ 
      "wheel"           # sudo  
      "networkmanager" 
      "video"           # light
      "audio"
      "lp"              # printer
    ]; 
  };

  # security.sudo.wheelNeedsPassword = false;
}
