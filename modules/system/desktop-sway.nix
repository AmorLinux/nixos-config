{ config, pkgs, ... }: {
  # --- Configuración del Sistema para Sway ---
  hardware.graphics.enable = true;
  programs.sway.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = {};

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --remember --cmd sway";
        user = "greeter";
      };
    };
  };
  boot.consoleLogLevel = 3;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [ thunar-archive-plugin thunar-volman ];
  };

  services.gvfs.enable = true; 
  services.tumbler.enable = true; 
  services.udisks2.enable = true; 
  programs.dconf.enable = true;   
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  # --- CONFIGURACIÓN CONDICIONAL DE HOME MANAGER ---
  # Si este módulo de Sway está activo en system, cargamos su configuración visual de usuario
  home-manager.users.amoreira = {
    imports = [
      ../../modules/user/foot.nix
      ../../modules/user/fuzzel.nix
      ../../modules/user/mako.nix
      ../../modules/user/waybar.nix
      ../../modules/user/sway-config.nix
      ../../modules/user/gtk.nix
      ../../modules/user/sway-extras.nix
    ];
  };
}