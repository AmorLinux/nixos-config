{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [ 
    wlogout wl-clipboard grim slurp brightnessctl 
    wdisplays kanshi swaybg mousepad
  ];

  wayland.windowManager.sway = {
    enable = true;
    extraSessionCommands = "export WLR_NO_HARDWARE_CURSORS=1";
    config = {
      modifier = "Mod1"; terminal = "foot"; menu = "fuzzel";
      gaps = { inner = 4; outer = 0; };
      window = { border = 1; titlebar = false; };
      fonts = { names = [ "Inter" "Roboto" ]; size = 10.0; };
      output."*" = { bg = "#1e1e2e solid_color"; resolution = "1920x1080"; };
      bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];
      startup = [
        { command = "sh -c 'sleep 2 && pkill nm-applet; nm-applet --indicator'"; always = true; }
        { command = "sh -c 'sleep 2 && pkill blueman-applet; blueman-applet'"; always = true; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; always = true; }
        { command = "swaymsg workspace 1"; always = false; }
        { command = "swaybg -i /home/amoreira/Imágenes/fondos_de_pantalla/fondo-2.jpg -m fill"; always = true; }
      ];
      keybindings = lib.mkOptionDefault {
        "Mod1+Shift+e" = "exec sh -c 'pkill swaynag; swaynag -t warning -m \"¿Realmente deseas salir?\" -B \"Sí\" \"swaymsg exit\"'";
        "Mod1+Shift+Return" = "exec kitty";
        "Mod1+g" = "exec brave"; "Mod1+e" = "exec thunar";
        "Print" = "exec grim - | wl-copy";
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
      };
    };
  };

  programs.swaylock = {
    enable = true; package = pkgs.swaylock-effects;
    settings = { clock = true; screenshots = true; effect-blur = "7x5"; ring-color = "89b4fa"; };
  };

  services.swayidle = {
    enable = true;
    events = { before-sleep = "swaylock"; };
    timeouts = [ { timeout = 300; command = "swaylock"; } ];
  };

  programs.wlogout = {
    enable = true;
    layout = [ { label = "lock"; action = "swaylock"; text = "Bloquear"; keybind = "l"; } ];
  };
}
