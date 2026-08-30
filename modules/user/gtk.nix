{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    font-awesome papirus-icon-theme hicolor-icon-theme adwaita-icon-theme
  ];
  gtk = {
    enable = true;
    theme = { name = "adw-gtk3-dark"; package = pkgs.adw-gtk3; };
    iconTheme = { name = "Papirus-Dark"; package = pkgs.papirus-icon-theme; };
    gtk4.theme = { name = "adw-gtk3-dark"; package = pkgs.adw-gtk3; };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
  };
}
