{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    kitty gparted qalculate-gtk seahorse
  ];
}
