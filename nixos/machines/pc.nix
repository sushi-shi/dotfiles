{ config, pkgs, ... }:

{ 
  # Use the GRUB 2 boot loader
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";


  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    listenAddresses =
      [ { addr = "192.168.0.100"; port = 22; } ];
    authorizedKeysFiles = [ "/root/.ssh/authorized_keys" ];
  };
  virtualisation.docker = {
    enable = true;
  };

}
