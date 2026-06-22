{ config, pkgs, ... }:

{
  home.username = "amoreira";
  home.homeDirectory = "/home/amoreira";

  # Importante: Esto debe coincidir con la versión de tu sistema
  home.stateVersion = "24.05"; 

  # Dejamos que Home Manager se gestione a sí mismo
  programs.home-manager.enable = true;

  # Aquí irán los paquetes exclusivos de tu usuario
  home.packages = with pkgs; [
    htop
    neofetch
  ];
}
