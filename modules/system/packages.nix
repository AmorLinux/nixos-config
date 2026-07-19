{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "ventoy-1.1.12" ];
  environment.systemPackages = with pkgs; [ wget git nano ];
}
