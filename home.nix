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
        { command = "pkill waybar; waybar"; always = true; }
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
    libnotify
  ];

  # ==========================================
  # SISTEMA DE NOTIFICACIONES (MAKO)
  # ==========================================
  services.mako = {
    enable = true;
    font = "Inter 11";
    backgroundColor = "#1e1e2eE6"; # Fondo oscuro translúcido
    textColor = "#cdd6f4";
    borderColor = "#89b4fa"; # Borde azul moderno
    borderRadius = 8;
    borderSize = 2;
    defaultTimeout = 5000; # Las notificaciones desaparecen en 5 segundos
  };

  # ==========================================
  # BLOQUEO DE PANTALLA (SWAYLOCK-EFFECTS)
  # ==========================================
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      clock = true;
      datestr = "%a, %d de %B";
      screenshots = true;
      effect-blur = "7x5";      # Efecto de desenfoque del fondo
      effect-vignette = "0.5:0.5";
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      ring-color = "#89b4fa";   # Anillo azul
      key-hl-color = "#a6e3a1"; # Resalte verde al presionar teclas
      text-color = "#cdd6f4";
      inside-color = "#1e1e2e80";
      inside-clear-color = "#1e1e2e80";
      ring-clear-color = "#f38ba8";
    };
  };
}
