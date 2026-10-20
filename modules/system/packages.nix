{ config, pkgs, lib, ... }: {
  nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem (lib.getName pkg) [
  ];
  environment.systemPackages = with pkgs; [
    seahorse
    audacity
  ];
  fonts.packages = with pkgs; [ inter roboto ];
  programs.wireshark = { enable = true; };
  programs.nix-ld = {
    libraries = with pkgs; [
    ];
  };
}
