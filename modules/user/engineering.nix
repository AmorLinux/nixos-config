{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    arduino rstudio ciscoPacketTracer9 weka
    ventoy libreoffice-qt mpv
    auto-cpufreq parsec-bin file imagemagick
  ];
}
