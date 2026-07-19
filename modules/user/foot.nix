{ config, pkgs, ... }: {
  programs.foot = {
    enable = true;
    settings = {
      main = { font = "monospace:size=13"; };
      "colors-dark" = { background = "141414"; foreground = "cdd6f4"; };
    };
  };
}
