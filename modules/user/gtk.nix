{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    font-awesome papirus-icon-theme hicolor-icon-theme adwaita-icon-theme
  ];
  gtk = {
    enable = true;
    theme = { name = "Adwaita-dark"; package = pkgs.gnome-themes-extra; };
    iconTheme = { name = "Papirus-Dark"; package = pkgs.papirus-icon-theme; };
    gtk4.theme = null; # Silencia la advertencia de Home Manager
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
  };
}
