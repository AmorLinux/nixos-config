{ config, pkgs, lib, inputs, ... }:

let
  piSettings = pkgs.writeText "pi-settings.json" (builtins.toJSON {
    defaultProvider = "omni";
    defaultModel = "auto/best-coding";
    defaultThinkingLevel = "medium";
    packages = [ "npm:pi-omniroute-sync" "npm:pi-web-access@0.38.0" ];
  });
in
{
  home.packages = with pkgs; [ pi ];

  # Fuente de verdad en el repo: ~/nixos-config/pi-config/
  # (los ficheros quedan como symlinks de solo lectura hacia el nix store)
  home.file = {
    ".pi/agent/skills" = {
      source = ../../pi-config/skills;
      recursive = true;
      force = true;
    };
    ".pi/agent/extensions/permission-gate.ts" = {
      source = ../../pi-config/extensions/permission-gate.ts;
      force = true;
    };
    ".pi/agent/web-search.json" = {
      source = ../../pi-config/web-search.json;
      force = true;
    };
  };

  home.activation = {
    piSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "$HOME/.pi/agent"
      run install -Dm644 ${piSettings} "$HOME/.pi/agent/settings.json"
    '';
  };
}
