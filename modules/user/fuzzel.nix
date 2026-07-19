{ config, pkgs, ... }: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Inter:size=14"; terminal = "foot";
        icon-theme = "Papirus-Dark"; prompt = "❯   ";
        width = 40; lines = 10; inner-pad = 8;
        horizontal-pad = 12; vertical-pad = 8;
      };
      colors = {
        background = "1e1e2eff"; text = "cdd6f4ff"; match = "89b4faff";
        selection = "313244ff"; selection-text = "cdd6f4ff"; border = "89b4faff";
      };
      border = { width = 1; radius = 8; };
    };
  };
}
