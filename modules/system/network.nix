{ config, pkgs, ... }: {
  networking.hostName = "nixos-laptop";

  # DNS Quad9 (bloquea malware/dominios maliciosos, sin registro de IPs)
  networking.nameservers = [ "9.9.9.9" "149.112.112.112" ];

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

  services.tailscale.enable = true;
}
