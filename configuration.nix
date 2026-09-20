{ config, pkgs, ... }: {
  imports = [
    ./modules/system/users.nix
    ./modules/system/network.nix
    ./modules/system/packages.nix
    ./modules/system/services.nix
    ./modules/system/docker.nix
    ./modules/system/virtualization.nix
    ./modules/system/searx.nix
    
    # --- SELECCIÓN DE ENTORNO DE SISTEMA ---
    # ./modules/system/desktop-sway.nix
    ./modules/system/desktop-kde.nix
  ];

  # --- Aceleración de Hardware (VA-API) ---
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver   # Para GPUs Intel modernas (6ª gen en adelante, usa iHD)
    intel-vaapi-driver   # Para GPUs Intel antiguas (usa i965)
    libva
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.editor = false;
  boot.loader.timeout = 5;

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 
  system.stateVersion = "26.05";
  programs.direnv.enable = true;

}
