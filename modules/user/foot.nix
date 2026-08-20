{ config, pkgs, ... }: {
  programs.foot = {
    enable = true;
    settings = {
      main = { font = "monospace:size=13"; };
      colors = { background = "141414"; foreground = "cdd6f4"; };
    };
  };
}
