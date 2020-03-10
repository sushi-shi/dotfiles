{ pkgs, config, ... }:

{
 # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sheep = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ 
      "wheel" 
      "networkmanager" 
      "video"
      "audio"
      "lp"
      "plugdev"
    ]; 
  };
}
