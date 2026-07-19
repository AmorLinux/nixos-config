{ config, pkgs, lib, ... }: {
  home.username = "amoreira";
  home.homeDirectory = "/home/amoreira";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    gnome-network-displays
  ];

  imports = [
    ./modules/user/development.nix
    ./modules/user/engineering.nix
  ];

  xdg.userDirs = {
    enable = true; createDirectories = true;
    desktop = "/home/amoreira/Escritorio"; documents = "/home/amoreira/Documentos";
    download = "/home/amoreira/Descargas"; pictures = "/home/amoreira/Imágenes";
    setSessionVariables = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = { name = "Ariel Moreira"; email = "ariel-gmm39@hotmail.com"; };
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
    };
  };
}
