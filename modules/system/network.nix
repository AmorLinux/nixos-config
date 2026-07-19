{ config, pkgs, ... }: {
  networking.hostName = "nixos-laptop";
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  # Habilitar el descubrimiento de dispositivos en la red local (fundamental para TVs/Chromecast)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  networking.wireless.iwd.enable = true;
  services.tailscale.enable = true;
}
