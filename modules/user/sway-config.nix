{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
    wlogout
    wl-clipboard
    grim
    slurp
    brightnessctl
    wdisplays
    kanshi
    swaybg
    mousepad
  ];

  # ==========================================
  # GESTOR DE VENTANAS (SWAY)
  # ==========================================
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

      # Fondo plomito por defecto
      output = {
        "*" = {
          bg = "#1e1e2e solid_color";
          resolution = "1920x1080";
        };
      };

      # Waybar enganchado de forma nativa
      bars = [
        { command = "${pkgs.waybar}/bin/waybar"; }
      ];

      startup = [
        # Retrasamos 2 segundos la red y el bluetooth para que Waybar alcance a dibujar la bandeja
        { command = "sh -c 'sleep 2 && pkill nm-applet; nm-applet --indicator'"; always = true; }
        { command = "sh -c 'sleep 2 && pkill blueman-applet; blueman-applet'"; always = true; }

        # El agente de seguridad y el espacio de trabajo no necesitan retraso
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; always = true; }
        { command = "swaymsg workspace 1"; always = false; }
        { command = "swaybg -i /home/amoreira/Imágenes/fondos_de_pantalla/fondo-2.jpg -m fill"; always = true; }
      ];

      # Evitamos el spam de advertencias al salir
      keybindings = lib.mkOptionDefault {
        "Mod1+Shift+e" = "exec sh -c 'pkill swaynag; swaynag -t warning -m \"¿Realmente deseas salir de la sesión?\" -B \"Sí, salir\" \"swaymsg exit\"'";
        "Mod1+Shift+Return" = "exec kitty";
        "Mod1+Shift+Escape" = "exec pkill swaynag";
        "Mod1+g" = "exec brave";
        "Mod1+e" = "exec thunar";

        # ==========================================
        # CAPTURAS DE PANTALLA (Estilo Fedora)
        # ==========================================
        # Pantalla completa al portapapeles
        "Print" = "exec grim - | wl-copy";

        # Región seleccionada al portapapeles y guarda archivo
        "Shift+Print" = "exec sh -c 'mkdir -p \"$HOME/Imágenes/Capturas_de_pantalla\" && grim -g \"$(slurp)\" - | tee \"$HOME/Imágenes/Capturas_de_pantalla/captura-$(date +%Y%m%d-%H%M%S).png\" | wl-copy'";

        # Guardar archivo con Alt + Print y al portapapeles
        "Mod1+Print" = "exec sh -c 'mkdir -p \"$HOME/Imágenes/Capturas_de_pantalla\" && grim - | tee \"$HOME/Imágenes/Capturas_de_pantalla/captura-$(date +%Y%m%d-%H%M%S).png\" | wl-copy'";

        # Teclas multimedia para el brillo
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
      };
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
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;

      # Colores SIN el símbolo '#' para evitar la pantalla gris
      ring-color = "89b4fa";
      key-hl-color = "a6e3a1";
      text-color = "cdd6f4";
      inside-color = "1e1e2e80";
      inside-clear-color = "1e1e2e80";
      ring-clear-color = "f38ba8";
      text-clear-color = "cdd6f4";
      text-ver-color = "cdd6f4";
      text-wrong-color = "cdd6f4";
    };
  };

  # ==========================================
  # GESTOR DE ENERGÍA Y BLOQUEO AUTOMÁTICO
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
}
