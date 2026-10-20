{ config, pkgs, ... }: {
  # Enable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;

  # Habilitar el anillo de claves para evitar el prompt "Unlock login keyring"
  services.gnome.gnome-keyring.enable = true;
}
