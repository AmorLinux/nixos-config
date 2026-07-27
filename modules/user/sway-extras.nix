{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    kitty
    gparted
    qalculate-gtk
    seahorse
    blueman
  ];

  # ==========================================
  # VISOR DE PDF (ZATHURA)
  # ==========================================
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
    };
  };

  # ==========================================
  # VISOR DE IMÁGENES (IMV) Y ATAJOS
  # ==========================================
  programs.imv = {
    enable = true;
    settings = {
      binds = {
        # Convierte cualquier imagen a PNG en memoria y la pasa a wl-copy
        "c" = "exec magick \"$imv_current_file\" png:- | wl-copy -t image/png";
      };
    };
  };

  # ==========================================
  # ASOCIACIONES DE ARCHIVOS PREDETERMINADAS
  # ==========================================
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg" = "imv.desktop";
      "image/png"  = "imv.desktop";
      "image/gif"  = "imv.desktop";
      "image/webp" = "imv.desktop";
      "image/bmp"  = "imv.desktop";
      "image/tiff" = "imv.desktop";
      "image/svg+xml" = "imv.desktop";
    };
  };

  # ==========================================
  # CORRECCIÓN DE ÍCONOS REBELDES Y LIMPIEZA
  # ==========================================
  xdg.desktopEntries = {
    # Arreglamos el administrador principal (Ventana Grande)
    blueman-manager = {
      name = "Bluetooth Manager";
      genericName = "Bluetooth Manager";
      exec = "blueman-manager";
      icon = "blueman";
      terminal = false;
      categories = [ "Settings" "HardwareSettings" ];
    };

    # Escondemos la herramienta de adaptadores para que no salga en Fuzzel
    blueman-adapters = {
      name = "Adaptadores Bluetooth";
      exec = "blueman-adapters";
      noDisplay = true;
    };
  };
}
