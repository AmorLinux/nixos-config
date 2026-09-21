{ config, pkgs, lib, inputs, ... }:

let
  piSettings = pkgs.writeText "pi-settings.json" (builtins.toJSON {
    defaultProvider = "omniroute";
    defaultModel = "auto/best-coding";
    defaultThinkingLevel = "medium";
    packages = [ "npm:pi-omniroute-sync" ];  # ← cambia esto
  });

  piOmniSyncSettings = pkgs.writeText "pi-omniroute-sync-settings.json" (builtins.toJSON {
    serverUrl = "http://localhost:20128";
    apiKey = "!cat /home/amoreira/.secrets/omniroute-key";
  });
in
{
  home.packages = with pkgs; [ pi ];

  home.activation = {
    piSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "$HOME/.pi/agent"
      run install -Dm644 ${piSettings} "$HOME/.pi/agent/settings.json"
    '';

    piOmniSyncSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -f "$HOME/.pi/agent/extensions/pi-omniroute-sync/settings.json" ]; then
        run mkdir -p -m700 "$HOME/.pi/agent/extensions/pi-omniroute-sync"
        run install -Dm600 ${piOmniSyncSettings} "$HOME/.pi/agent/extensions/pi-omniroute-sync/settings.json"
      fi
    '';
  };
}
