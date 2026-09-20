{ config, pkgs, lib, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem (lib.getName pkg) [
    "electron"
    "ventoy"
  ];

  # ADB y fastboot con reglas udev (detecta el teléfono sin root)
  environment.systemPackages = with pkgs; [
    wget git nano
    android-tools         # adb y fastboot (instalar APKs)
    swayidle              # Para bloqueo idle
    pulseaudio            # Audio backend
    unrar                 # Descomprimir archivos .rar
  ];
  fonts.packages = with pkgs; [ inter roboto ];
  programs.wireshark = { enable = true; };
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      openssl
    ];
  };
}
