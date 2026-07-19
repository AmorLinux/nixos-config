{ config, pkgs, ... }: {
  home.packages = [ pkgs.libnotify ];
  services.mako = {
    enable = true;
    settings = {
      font = "Inter 11";
      background-color = "#1e1e2eE6";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      border-radius = 8;
      border-size = 2;
      default-timeout = 5000;
    };
  };
}
