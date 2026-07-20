{ config, pkgs, ... }: {
  home.packages = [ pkgs.pavucontrol pkgs.networkmanagerapplet ];
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top"; position = "top"; height = 34; spacing = 6;
      modules-left = [ "sway/workspaces" "sway/window" ];
      modules-center = [ "clock" ];
      modules-right = [ 
        "pulseaudio" "pulseaudio#microphone" "sway/language" 
        "backlight" "cpu" "memory" "temperature" 
        "power-profiles-daemon" "battery" "tray" "custom/power"
      ];
      "sway/workspaces" = { disable-scroll = true; all-outputs = true; };
      "clock" = { format = "{:%H:%M - %d/%m/%Y}"; tooltip-format = "<tt>{calendar}</tt>"; };
      "pulseaudio" = { format = "{icon}  {volume}%"; format-muted = "MUTE"; format-icons = { default = [ "VOL" ]; }; on-click = "pavucontrol"; };
      "pulseaudio#microphone" = { format = "{format_source}"; format-source = "MIC {volume}%"; format-source-muted = "MIC OFF"; on-click = "pavucontrol -t 4"; };
      "tray" = { spacing = 10; };
      "sway/language" = { format = "KB {}" ; };
      "backlight" = { format = "BRI {percent}%"; };
      "cpu" = { format = "CPU {usage}%"; };
      "memory" = { format = "MEM {}%"; };
      "temperature" = { format = "TEMP {temperatureC}°C"; };
      "power-profiles-daemon" = { format = "{icon}"; format-icons = { default = "PWR"; performance = "PERF"; balanced = "BAL"; "power-saver" = "SAV"; }; };
      "battery" = { format = "BAT {capacity}%"; format-charging = "CHG {capacity}%"; states = { warning = 30; critical = 15; }; };
      "custom/power" = { format = "OFF"; on-click = "wlogout"; tooltip = false; };
    };
    style = ''
      * { font-family: "Inter", "Roboto", "Font Awesome 6 Free", sans-serif; font-size: 13px; font-weight: 600; border: none; }
      window#waybar { background-color: transparent; color: #ffffff; }
      #workspaces, #window, #clock, #pulseaudio, #language, #backlight, #cpu, #memory, #temperature, #power-profiles-daemon, #battery, #custom-power { background-color: rgba(20, 20, 20, 0.85); border-radius: 8px; margin-top: 6px; padding: 0 12px; margin-right: 6px; }
      #workspaces button { color: #a6adc8; padding: 0 6px; }
      #workspaces button.focused { background-color: #313244; color: #cdd6f4; }
    '';
  };
}
