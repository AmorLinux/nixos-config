{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "ventoy-1.1.12" ];
  environment.systemPackages = with pkgs; [ wget git nano ];

  # Fuentes que usan Sway, Fuzzel y Waybar
  fonts.packages = with pkgs; [ inter roboto ];
}
