{ config, pkgs, ... }: {
  time.timeZone = "America/Guayaquil";
  i18n.defaultLocale = "es_MX.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_EC.UTF-8"; LC_IDENTIFICATION = "es_EC.UTF-8";
    LC_MEASUREMENT = "es_EC.UTF-8"; LC_MONETARY = "es_EC.UTF-8";
    LC_NAME = "es_EC.UTF-8"; LC_NUMERIC = "es_EC.UTF-8";
    LC_PAPER = "es_EC.UTF-8"; LC_TELEPHONE = "es_EC.UTF-8"; LC_TIME = "es_EC.UTF-8";
  };
  services.xserver.xkb = { layout = "us"; variant = ""; };
  services.openssh.enable = true;
  services.power-profiles-daemon.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # --- AUDIO (PipeWire + compatibilidad PulseAudio) ---
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
