{ config, pkgs, ... }: {
  home.packages = [ pkgs.pavucontrol pkgs.networkmanagerapplet ];

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
          "wdisplays"
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
          format-muted = "  MUTE";
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
          format-disconnected = "  Off";
        };
        "tray" = {
          spacing = 10;
        };
        "sway/language" = {
          format = "  {}";
        };
        "backlight" = {
          format = "  {percent}%";
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
          format = "{icon}";
          tooltip-format = "Perfil: {profile}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };
        "battery" = {
          format = "  {capacity}%";
          format-charging = "  {capacity}%";
          states = { warning = 30; critical = 15; };
        };
        "custom/power" = {
          format = "";
          on-click = "wlogout";
          tooltip = false;
        };
        "custom/displays" = {
          format = "󰍹";
          on-click = "wdisplays";
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
}
