{ config, pkgs, lib, ... }: {
  home.username = "amoreira";
  home.homeDirectory = "/home/amoreira";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  imports = [
    ./modules/user/development.nix
    ./modules/user/engineering.nix
  ];

  # ==========================================
  # PAQUETES COMPARTIDOS DEL USUARIO
  # (Presentes tanto en Sway como en KDE)
  # ==========================================
  home.packages = with pkgs; [
    firefox
    brave
    moonlight-qt
    gnome-network-displays
  ];

  # ==========================================
  # CARPETAS DE USUARIO ESTÁNDAR
  # ==========================================
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = "/home/amoreira/Escritorio";
    documents = "/home/amoreira/Documentos";
    download = "/home/amoreira/Descargas";
    music = "/home/amoreira/Música";
    pictures = "/home/amoreira/Imágenes";
    publicShare = "/home/amoreira/Público";
    templates = "/home/amoreira/Plantillas";
    videos = "/home/amoreira/Vídeos";

    setSessionVariables = true;
  };

  # ==========================================
  # CONFIGURACIÓN DE GIT
  # ==========================================
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ariel Moreira";
        email = "ariel-gmm39@hotmail.com";
      };
      credential = {
        helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
      };
    };
  };
}
