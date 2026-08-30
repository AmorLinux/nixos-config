{ config, pkgs, lib, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem (lib.getName pkg) [ "ventoy" ];
  environment.systemPackages = with pkgs; [ wget git nano ];

  # Fuentes que usan Sway, Fuzzel y Waybar
  fonts.packages = with pkgs; [ inter roboto ];
}
