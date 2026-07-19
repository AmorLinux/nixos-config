{ config, pkgs, ... }: {
  hardware.graphics.enable = true;
  
  # Habilitar el nuevo Plasma Login Manager nativo de KDE
  services.displayManager.plasma-login-manager.enable = true;
  
  # Tu entorno Plasma 6 principal
  services.desktopManager.plasma6.enable = true;
  
  programs.dconf.enable = true;
}