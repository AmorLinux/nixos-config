{ config, pkgs, ... }:

{
  home.username = "amoreira";
  home.homeDirectory = "/home/amoreira";

  # Importante: Esto debe coincidir con la versión de tu sistema
  home.stateVersion = "24.05"; 

  # Dejamos que Home Manager se gestione a sí mismo
  programs.home-manager.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    extraSessionCommands = ''
      export WLR_RENDERER=pixman
      export WLR_NO_HARDWARE_CURSORS=1
    '';

    config = {
      modifier = "Mod4"; # Usa la tecla Windows/Super como tecla principal
      terminal = "kitty"; # Definimos la terminal por defecto
      
      # Estructura visual limpia y moderna
      gaps = {
        inner = 8;
        outer = 4;
      };
      window = {
        border = 2;
        titlebar = false; # Interfaz sin distracciones
      };
      
      # Tipografía clara para la barra y la interfaz
      fonts = {
        names = [ "Inter" "Roboto" ];
        size = 10.0;
      };
    };
  };


  # Aquí irán los paquetes exclusivos de tu usuario
  home.packages = with pkgs; [
    htop
    fastfetch
    kitty
    wofi
  ];
}
