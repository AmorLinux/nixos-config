{ config, pkgs, ... }: {
  users.users."amoreira" = {
    isNormalUser = true;
    description = "Ariel Moreira";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
}
