{ config, pkgs, ... }: {
  # Enable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;

  # Opcionalmente, puedes añadir paquetes extra que quieras que estén presentes
  # cuando uses COSMIC, o configuraciones específicas de Wayland/Portal.
  # COSMIC ya maneja sus propios portales y sesión.
}
