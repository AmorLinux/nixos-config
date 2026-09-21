{ config, pkgs, lib, inputs, ... }:

let
  # ============================================================
  # settings.json de pi. NO se hace symlink al store porque pi
  # escribe en este archivo en runtime (/settings, pi update,
  # changelog). Se copia en cada activación con cp/install.
  # ============================================================
  piSettings = pkgs.writeText "pi-settings.json" (builtins.toJSON {
    defaultProvider = "omniroute"; # ← Ajusta a "omniroute" si lo prefieres
    defaultModel = "auto";      # ← El combo o modelo por defecto
    defaultThinkingLevel = "medium";
    packages = [ "npm:pi-live-models" ]; # ← Extensión de descubrimiento dinámico
  });

  # ============================================================
  # live-models.json de pi-live-models.
  # Define los proveedores cuyo catálogo de modelos se descubrirá
  # dinámicamente. apiKey usa !cat para leer los secretos desde
  # archivos fuera de la config de Nix (nunca hardcodeados).
  # ============================================================
  piLiveModelsConfig = pkgs.writeText "pi-live-models.json" (builtins.toJSON {
    providers = {
      omniroute = {
        baseUrl = "http://localhost:20128/v1";
        api = "openai-completions"; # Protocolo OpenAI-compatible
        apiKey = "!cat /home/amoreira/.secrets/omniroute-key";
        # filters = { exclude = [ "*embedding*" ]; }; # Opcional: filtra modelos
      };
      nvidia = {
        baseUrl = "https://integrate.api.nvidia.com/v1";
        api = "openai-completions";
        apiKey = "!cat /home/amoreira/.secrets/nvidia-nim-key";
      };
    };
  });
in
{
  # Pi solo para el usuario amoreira (se expone vía overlay en flake.nix)
  home.packages = with pkgs; [ pi ];

  home.activation = {
    # ~/.pi/agent/settings.json — copia, no symlink
    piSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "$HOME/.pi/agent"
      run install -Dm644 ${piSettings} "$HOME/.pi/agent/settings.json"
    '';

    # ~/.pi/agent/live-models.json — permisos estrictos
    # Solo escribe si el archivo NO existe, para que puedas
    # añadir más proveedores manualmente sin perderlos en rebuilds.
    piLiveModelsConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -f "$HOME/.pi/agent/live-models.json" ]; then
        run mkdir -p -m700 "$HOME/.pi/agent"
        run install -Dm600 ${piLiveModelsConfig} "$HOME/.pi/agent/live-models.json"
      fi
    '';
  };
}
