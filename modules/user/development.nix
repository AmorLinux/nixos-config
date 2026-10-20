{ config, pkgs, inputs, ... }: {
  home.packages = with pkgs; [
  ];
  programs.vscodium = {
    profiles.default = {
      userSettings = {
      };
    };
  };
}
