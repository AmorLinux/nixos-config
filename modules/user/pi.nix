{ config, pkgs, lib, inputs, ... }:

let
  piSettings = pkgs.writeText "pi-settings.json" (builtins.toJSON {
    defaultProvider = "omniroute";
    defaultModel = "auto/best-coding";
    defaultThinkingLevel = "medium";
    packages = [ "npm:pi-omniroute-sync" ];
  });
in
{
  home.packages = with pkgs; [ pi ];

  home.activation = {
    piSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "$HOME/.pi/agent"
      run install -Dm644 ${piSettings} "$HOME/.pi/agent/settings.json"
    '';
  };
}
