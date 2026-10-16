{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./modules/system/users.nix
    ./modules/system/network.nix
    ./modules/system/packages.nix
    ./modules/system/services.nix
    ./modules/system/virtualization.nix
    ./modules/system/docker.nix
    ./modules/system/searx.nix
    ./modules/system/desktop-cosmic.nix
  ];

  # ==========================================
  # CONFIGURACIÓN DE ARRANQUE (UEFI + GRUB)
  # ==========================================
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    efiSupport = true;
    device = "nodev"; 
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # ==========================================
  # CONFIGURACIÓN DE USUARIO BASE
  # ==========================================
  users.users.amoreira = {
    isNormalUser = true;
    group = "amoreira";
  };
  users.groups.amoreira = {};

  # ==========================================
  # CONFIGURACIÓN DE HARDWARE Y SISTEMA
  # ==========================================
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver   # Para GPUs Intel modernas (6ª gen en adelante)
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Para evitar el aviso de stateVersion
  system.stateVersion = "24.11"; 
}
