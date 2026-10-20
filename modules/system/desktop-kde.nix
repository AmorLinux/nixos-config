{ config, pkgs, ... }: {
  # Activar el entorno de escritorio KDE Plasma
  services.desktopManager.plasma6.enable = true;
  
  # Activar SDDM como gestor de inicio de sesión
  services.displayManager.sddm.enable = true;

  # Habilitar soporte para Flatpak
  services.flatpak.enable = true;

  # Habilitar soporte nativo para AppImage
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # Configurar KWallet para que se desbloquee con la contraseña de inicio de sesión
  security.pam.services.sddm.enableKwallet = true;

  # Deshabilitar Baloo File Indexing
  environment.etc."baloofilerc" = {
    text = ''
      [Basic Settings]
      Indexing-Enabled=false
      IndexNewFiles=false
    '';
  };
}
