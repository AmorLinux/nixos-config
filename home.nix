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
        # Retrasamos 2 segundos la red y el bluetooth para que Waybar alcance a dibujar la bandeja
        { command = "sh -c 'sleep 2 && pkill nm-applet; nm-applet --indicator'"; always = true; }
        { command = "sh -c 'sleep 2 && pkill blueman-applet; blueman-applet'"; always = true; }

        # El agente de seguridad y el espacio de trabajo no necesitan retraso
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; always = true; }
        { command = "swaymsg workspace 1"; always = false; } # <--- Te envía al escritorio 1 al iniciar sesión
      ];

      # EVITAMOS EL SPAM DE ADVERTENCIAS AL SALIR
      keybindings = lib.mkOptionDefault {
        "Mod1+Shift+e" = "exec sh -c 'pkill swaynag; swaynag -t warning -m \"¿Realmente deseas salir de la sesión?\" -B \"Sí, salir\" \"swaymsg exit\"'";
        "Mod1+Shift+Return" = "exec kitty";
        "Mod1+Shift+Escape" = "exec pkill swaynag";
        "Mod1+g" = "exec brave";    # <--- Alt + G para Brave (puedes cambiarlo a firefox si prefieres)
        "Mod1+e" = "exec thunar";   # <--- Alt + E para el Gestor de Archivos
       
        # ==========================================
        # CAPTURAS DE PANTALLA (Estilo Fedora)
        # ==========================================
        # Pantalla completa al portapapeles
        "Print" = "exec grim - | wl-copy";
        
        # Región seleccionada al portapapeles y guarda archivo
        "Shift+Print" = "exec sh -c 'grim -g \"$(slurp)\" - | tee \"$HOME/Imágenes/captura-$(date +%Y%m%d-%H%M%S).png\" | wl-copy'";
        
        # Guardar archivo con Alt + Print y al portapapeles
        "Mod1+Print" = "exec sh -c 'grim - | tee \"$HOME/Imágenes/captura-$(date +%Y%m%d-%H%M%S).png\" | wl-copy'";
        
        # Teclas multimedia para el brillo
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
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
          "pulseaudio#microphone" 
          # "network" 
          "sway/language" 
          "backlight" 
          "cpu" 
          "memory" 
          "temperature" 
          "power-profiles-daemon" 
          "battery" 
          "tray"
          "custom/power"
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
        "custom/power" = {
          format = "";
          on-click = "wlogout";
          tooltip = false;
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
    mousepad
    blueman
    # DESARROLLO E INGENIERÍA
    vscode
    jetbrains.idea-oss # Cambiar a idea-ultimate si tienes licencia
    android-studio
    unityhub
    seahorse # <--- Interfaz gráfica para GNOME Keyring
    polkit_gnome # <--- El agente que dibuja la ventana de contraseñas de administrador
    discord
    zoom-us
    # wlogout # <--- Menú gráfico de energía

    # ----------------------------------------
    # UTILIDADES DE WAYLAND Y ESENCIALES
    # ----------------------------------------
    wl-clipboard    # Soporte para copiar/pegar
    grim            # Motor de captura de pantalla
    slurp           # Selector de región para la captura
    brightnessctl   # Control de brillo de la pantalla
    
    # ----------------------------------------
    # ESCRITORIO REMOTO
    # ----------------------------------------
    moonlight-qt    # Cliente de Moonlight
    # Gestor de archivos
    #  xfce.thunar
    # xfce.thunar-volman       # Para gestionar volúmenes extraíbles
    # xfce.thunar-archive-plugin # Para extraer archivos ZIP/TAR con clic derecho

    # ----------------------------------------
    # LENGUAJES DE PROGRAMACIÓN
    # ----------------------------------------
    jdk             # Java
    python3         # Python
    nodejs          # Node.js (estable)
    cargo rustc     # Rust (Compilador y gestor de paquetes)
    gcc             # C y C++
    dotnet-sdk      # C# y .NET
    
    # ----------------------------------------
    # HERRAMIENTAS DE INGENIERÍA Y CLASES
    # ----------------------------------------
    arduino           # Arduino IDE
    rstudio           # R Studio
    ciscoPacketTracer9 # Cisco Packet Tracer
    weka              # Machine Learning (Java)
    
    # ----------------------------------------
    # UTILIDADES DE SISTEMA Y RED
    # ----------------------------------------
    gparted         # Gestor de particiones y discos
    ventoy          # Creador de USBs booteables
    qbittorrent     # Cliente Torrent
    
    # ----------------------------------------
    # MULTIMEDIA Y OFIMÁTICA
    # ----------------------------------------
    libreoffice-qt  # Suite ofimática (Versión moderna)
    # zathura         # Visor de PDF ultra minimalista (ideal para Sway)
    mpv             # Reproductor de video ligero
    imv           # Visor de imágenes
    qalculate-gtk   # Calculadora avanzada

    # Herramientas esenciales post-auditoría
    auto-cpufreq
    parsec-bin

    # Íconos base del sistema para solucionar íconos faltantes en Fuzzel
    hicolor-icon-theme
    adwaita-icon-theme

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
      
      # Colores SIN el símbolo '#' para evitar la pantalla gris
      ring-color = "89b4fa";      # Anillo azul
      key-hl-color = "a6e3a1";    # Resalte verde al presionar teclas
      text-color = "cdd6f4";
      inside-color = "1e1e2e80";
      inside-clear-color = "1e1e2e80";
      ring-clear-color = "f38ba8";
      # Forzar el texto claro en todos los estados
      text-clear-color = "cdd6f4";
      text-ver-color = "cdd6f4";
      text-wrong-color = "cdd6f4";
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
  # MENÚ DE ENERGÍA (WLOGOUT TRADUCIDO)
  # ==========================================
  programs.wlogout = {
    enable = true;
    layout = [
      { label = "lock"; action = "swaylock"; text = "Bloquear"; keybind = "l"; }
      { label = "logout"; action = "swaymsg exit"; text = "Cerrar Sesión"; keybind = "e"; }
      { label = "suspend"; action = "systemctl suspend"; text = "Suspender"; keybind = "u"; }
      { label = "hibernate"; action = "systemctl hibernate"; text = "Hibernar"; keybind = "h"; }
      { label = "shutdown"; action = "systemctl poweroff"; text = "Apagar"; keybind = "s"; }
      { label = "reboot"; action = "systemctl reboot"; text = "Reiniciar"; keybind = "r"; }
    ];
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

    desktop = "/home/amoreira/Escritorio";
    documents = "/home/amoreira/Documentos";
    download = "/home/amoreira/Descargas";
    music = "/home/amoreira/Música";
    pictures = "/home/amoreira/Imágenes";
    publicShare = "/home/amoreira/Público";
    templates = "/home/amoreira/Plantillas";
    videos = "/home/amoreira/Vídeos"; 

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
    gtk4.theme = null; # <--- Añade esta línea para matar la advertencia
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
    events = {
      before-sleep = "swaylock";
    };
    timeouts = [
      {
        timeout = 300;
        command = "swaylock";
      }
      {
        timeout = 600;
        command = "swaymsg 'output * dpms off'";
        resumeCommand = "swaymsg 'output * dpms on'";
      }
    ];
  };

  # ==========================================
  # CONFIGURACIÓN DE GIT
  # ==========================================
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ariel Moreira";
        email = "ariel-gmm39@hotmail.com";
      };
      credential = {
        helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
      };
    };
  };

  # ==========================================
  # ASOCIACIONES DE ARCHIVOS PREDETERMINADAS
  # ==========================================
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg" = "imv.desktop";
      "image/png"  = "imv.desktop";
      "image/gif"  = "imv.desktop";
      "image/webp" = "imv.desktop";
      "image/bmp"  = "imv.desktop";
      "image/tiff" = "imv.desktop";
      "image/svg+xml" = "imv.desktop";
    };
  };

  # ==========================================
  # VISOR DE PDF (ZATHURA)
  # ==========================================
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard"; # Fuerza el uso del portapapeles estándar
    };
  };
}
