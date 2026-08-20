{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    arduino rstudio ciscoPacketTracer9 weka
    ventoy libreoffice-qt mpv
    parsec-bin file imagemagick
  ];
  # Nota: auto-cpufreq fue quitado porque conflictúa con power-profiles-daemon
  # (que ya está habilitado en modules/system/services.nix).
}
