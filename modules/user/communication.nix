{ config, pkgs, ... }: {
  # Comunicación y compartición P2P
  home.packages = with pkgs; [
    discord
    zoom-us
    qbittorrent
  ];
}
