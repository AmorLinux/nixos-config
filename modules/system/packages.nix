{ config, pkgs, lib, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem (lib.getName pkg) [
  ];

  environment.systemPackages = with pkgs; [
    seahorse
    audacity
    unityhub

    # CLI básicos
    wget git nano
    unrar                 # Descomprimir archivos .rar
    android-tools         # adb y fastboot (permisos vía uaccess de systemd 258, sin reglas extra)
  ];

  fonts.packages = with pkgs; [ inter roboto ];
  programs.wireshark = { enable = true; };

  # nix-ld: permite ejecutar AppImages y binarios dinámicos propietarios
  # descargados (Unity Hub, testhost de NuGet, herramientas externas...)
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      openssl
    ];
  };
}
