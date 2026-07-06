{ config, pkgs, lib, ... }:

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
      modifier = "Mod1";
      terminal = "foot";
      menu = "fuzzel";
      gaps = {
        inner = 4;
        outer = 0;
      };
      window = {
        border = 1;
        titlebar = false;
      };
      fonts = {
        names = [ "Inter" "Roboto" ];
        size = 10.0;
      };
      
      # ¡AQUÍ ESTÁ EL FONDO PLOMITO!
      output = {
        "*" = { 
          bg = "#1e1e2e solid_color";
          resolution = "1920x1080";
         };
      };
      
      # ENGANCHAMOS WAYBAR DE FORMA NATIVA Y SEGURA
      bars = [
        { command = "${pkgs.waybar}/bin/waybar"; }
      ];
      
      startup = [
        { command = "pkill nm-applet; nm-applet --indicator"; always = true; }
        { command = "pkill blueman-applet; blueman-applet"; always = true; } # <--- Ícono de Bluetooth
        { command = "swaymsg workspace 1"; always = false; } # <--- Te envía al escritorio 1 al iniciar sesión
      ];

      # EVITAMOS EL SPAM DE ADVERTENCIAS AL SALIR
      keybindings = lib.mkOptionDefault {
        "Mod1+Shift+e" = "exec sh -c 'pkill swaynag; swaynag -t warning -m \"¿Realmente deseas salir de la sesión?\" -B \"Sí, salir\" \"swaymsg exit\"'";
        "Mod1+Shift+Return" = "exec kitty";
        "Mod1+Shift+Escape" = "exec pkill swaynag";
        "Mod1+g" = "exec brave";    # <--- Alt + G para Brave (puedes cambiarlo a firefox si prefieres)
        "Mod1+e" = "exec thunar";   # <--- Alt + E para el Gestor de Archivos
      };
    };
  };


  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 6;
        
        modules-left = [ "sway/workspaces" "sway/window" ];
        modules-center = [ "clock" ];
        # Agregamos todos los sensores solicitados
        modules-right = [ 
          "pulseaudio"
          "tray" 
          "pulseaudio#microphone" 
          "network" 
          "sway/language" 
          "backlight" 
          "cpu" 
          "memory" 
          "temperature" 
          "power-profiles-daemon" 
          "battery" 
        ];

        # --- Configuración de los módulos ---
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
        "clock" = {
          format = "{:%H:%M - %d/%m/%Y}";
          tooltip-format = "<tt>{calendar}</tt>";
        };
        "pulseaudio" = {
          format = "  {volume}%";
          format-muted = "  MUTE";
          on-click = "pavucontrol"; 
        };
        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = "  {volume}%";
          format-source-muted = "  MIC OFF";
          on-click = "pavucontrol -t 4"; 
        };
        "network" = {
          format-wifi = "  {essid}";
          format-ethernet = "  LAN";
          format-disconnected = "  Off";
        };
        "tray" = {
          spacing = 10;
        };
        "sway/language" = {
          format = "  {}";
        };
        "backlight" = {
          format = "  {percent}%";
        };
        "cpu" = {
          format = "  {usage}%";
        };
        "memory" = {
          format = "  {}%";
        };
        "temperature" = {
          format = "  {temperatureC}°C";
        };
        "power-profiles-daemon" = {
          format = "{profile}";
          tooltip-format = "Perfil de energía: {profile}";
        };
        "battery" = {
          format = "  {capacity}%";
          format-charging = "  {capacity}%";
          states = { warning = 30; critical = 15; };
        };
      };
    };

    style = ''
      * {
        font-family: "Inter", "Roboto", "Font Awesome 6 Free", sans-serif;
        font-size: 13px;
        font-weight: 600;
        border: none;
      }

      window#waybar {
        background-color: transparent;
        color: #ffffff;
      }

      /* Estilo de píldora para absolutamente todos los módulos */
      #workspaces, #window, #clock, #pulseaudio, #network, #language, #backlight, #cpu, #memory, #temperature, #power-profiles-daemon, #battery {
        background-color: rgba(20, 20, 20, 0.85);
        border-radius: 8px;
        margin-top: 6px;
        margin-bottom: 0px;
        padding: 0 12px;
        margin-right: 6px;
      }

      #workspaces {
        padding: 0 4px;
        margin-left: 6px;
      }

      #workspaces button {
        color: #a6adc8;
        border-radius: 6px;
        padding: 0 6px;
        margin: 4px 2px;
      }

      #workspaces button:hover {
        background-color: #f8f9fa; 
        color: #11111b;            
      }

      #workspaces button.focused {
        background-color: #313244;
        color: #cdd6f4;
      }

      #window { margin-right: 0px; }
      
      /* Alertas visuales */
      #battery.warning { color: #f9e2af; }
      #battery.critical { color: #f38ba8; }
      #temperature.critical { color: #f38ba8; }
      #pulseaudio.muted { color: #a6adc8; }
    '';
  };


  # Aquí irán los paquetes exclusivos de tu usuario
  home.packages = with pkgs; [
    htop
    fastfetch
    kitty
    foot
    fuzzel
    libnotify
    firefox
    brave
    pavucontrol
    networkmanagerapplet
    # Paquetes visuales
    font-awesome         # Para los íconos de la Waybar
    papirus-icon-theme   # Para los íconos de las carpetas y apps
    xfce.mousepad
    blueman
    # Gestor de archivos
    #  xfce.thunar
    # xfce.thunar-volman       # Para gestionar volúmenes extraíbles
    # xfce.thunar-archive-plugin # Para extraer archivos ZIP/TAR con clic derecho
  ];

  # ==========================================
  # SISTEMA DE NOTIFICACIONES (MAKO)
  # ==========================================
  services.mako = {
    enable = true;
    settings = {
      font = "Inter 11";
      background-color = "#1e1e2eE6";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      border-radius = 8;
      border-size = 2;
      default-timeout = 5000;
    };
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


  # ==========================================
  # LANZADOR ULTRA-MINIMALISTA (FUZZEL)
  # ==========================================
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Inter:size=14";
        terminal = "foot";
        icon-theme = "Papirus-Dark"; # <--- ¡AQUÍ ESTÁ LA MAGIA!
        prompt = "❯   ";
        width = 40;
        lines = 10;
        inner-pad = 8;
        horizontal-pad = 12;
        vertical-pad = 8;
        # image-size-ratio = 0; # Desactiva íconos para un look más limpio y rápido
      };
      colors = {
        background = "1e1e2eff"; # Fondo plomito oscuro
        text = "cdd6f4ff";       # Texto claro
        match = "89b4faff";      # Coincidencias en azul moderno
        selection = "313244ff";  # Elemento seleccionado
        selection-text = "cdd6f4ff";
        border = "89b4faff";     # Borde azul fino
      };
      border = {
        width = 1;
        radius = 8; # Bordes redondeados idénticos a Waybar y Mako
      };
    };
  };

  # ==========================================
  # TERMINAL PRINCIPAL (FOOT)
  # ==========================================
  programs.foot = {
    enable = true;
    settings = {
      main = {
        # Aquí controlas el tamaño (13 o 14 suele ser muy cómodo)
        font = "monospace:size=13"; 
      };
      "colors-dark" = {
        # Los mismos colores modernos que tienes en el resto del sistema
        background = "141414";
        foreground = "cdd6f4";
        # Opcional: Puedes descomentar la siguiente línea si quieres un poco de transparencia
        # alpha = 0.9;
      };
    };
  };

  # ==========================================
  # CARPETAS DE USUARIO ESTÁNDAR
  # ==========================================
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    # Silencia la advertencia de Home Manager
    setSessionVariables = true;
  };

  # ==========================================
  # TEMAS VISUALES (MODO OSCURO E ÍCONOS)
  # ==========================================
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Forzamos las preferencias oscuras en el puente D-Bus
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # ==========================================
  # GESTOR DE ENERGÍA Y BLOQUEO DE PANTALLA
  # ==========================================
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock";
      }
    ];
    timeouts = [
      {
        timeout = 300; # 5 minutos
        command = "${pkgs.swaylock}/bin/swaylock";
      }
      {
        timeout = 600; # 10 minutos
        command = "swaymsg 'output * dpms off'";
        resumeCommand = "swaymsg 'output * dpms on'";
      }
    ];
  };

}
