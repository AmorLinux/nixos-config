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
      modifier = "Mod4";
      terminal = "kitty";
      gaps = {
        inner = 8;
        outer = 4;
      };
      window = {
        border = 2;
        titlebar = false;
      };
      fonts = {
        names = [ "Inter" "Roboto" ];
        size = 10.0;
      };
      
      # Apagamos la barra por defecto de Sway
      bars = [];
      
      # Lanzamos Waybar al iniciar Sway
      startup = [
        { command = "waybar"; always = true; }
      ];
    };
  };


programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top"; # La barra superior luce más moderna
        height = 34;
        spacing = 6;
        modules-left = [ "sway/workspaces" "sway/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "memory" "cpu" ];
      };
    };

    style = ''
      * {
        font-family: "Inter", "Roboto", sans-serif;
        font-size: 13px;
        font-weight: 600;
        border: none;
      }

      /* Fondo de la barra transparente para que los módulos floten */
      window#waybar {
        background-color: transparent;
        color: #ffffff;
      }

      /* Estilo base para los módulos con bordes redondeados */
      #workspaces, #window, #clock, #network, #memory, #cpu {
        background-color: rgba(20, 20, 20, 0.85);
        border-radius: 8px;
        margin-top: 6px;
        margin-bottom: 0px;
        padding: 0 12px;
      }

      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        color: #a6adc8;
        border-radius: 6px;
        padding: 0 6px;
        margin: 4px 2px;
      }

      #workspaces button.focused {
        background-color: #313244;
        color: #cdd6f4;
      }

      #window {
        margin-left: 6px;
      }

      #clock, #network, #memory, #cpu {
        margin-right: 6px;
      }
    '';
  };


  # Aquí irán los paquetes exclusivos de tu usuario
  home.packages = with pkgs; [
    htop
    fastfetch
    kitty
    wofi
  ];
}
