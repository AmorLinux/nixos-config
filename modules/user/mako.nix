{ config, pkgs, ... }: {
  home.packages = [ pkgs.libnotify ];
  services.mako = {
    enable = true;
    font = "Inter 11";
    backgroundColor = "#1e1e2eE6";
    textColor = "#cdd6f4";
    borderColor = "#89b4fa";
    borderRadius = 8;
    borderSize = 2;
    defaultTimeout = 5000;
  };
}
