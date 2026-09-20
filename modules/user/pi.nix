{ config, pkgs, lib, inputs, ... }:

let
  # ============================================================
  # settings.json de pi. NO se hace symlink al store porque pi
  # escribe en este archivo en runtime (/settings, pi update,
  # changelog). Se copia en cada activación con cp/install.
  # ============================================================
  piSettings = pkgs.writeText "pi-settings.json" (builtins.toJSON {
    defaultProvider = "compat-omniroute";
    defaultModel = "auto";
    defaultThinkingLevel = "medium";
    packages = [ "npm:@billjr99/pi-openai-compat" ];
  });

  # ============================================================
  # config.json de la extensión @billjr99/pi-openai-compat.
  # apiKey usa !command para leer la llave de un archivo FUERA de
  # la config de Nix (nunca hardcodeada). cachedModels = lista
  # semilla estática (se actualiza pidiendo /compat-refresh).
  # ============================================================
  # En pi.nix, dentro del bloque 'let'
  piCompatConfig = pkgs.writeText "pi-openai-compat-config.json" (builtins.toJSON {
    providers = {
      omniroute = {
        displayName = "OmniRoute Gateway";
        baseUrl = "http://localhost:20128/v1";
        apiKey = "!cat /home/amoreira/.secrets/omniroute-key";
        cachedModels = [ # 👈 La lista de modelos ahora son COMBOS
          # Combos generales
          { id = "auto"; }                    # Equilibrado (pero puede usar modelos de pago)
          { id = "auto/fast"; }               # Prioriza velocidad, no coste

          # Combos específicos para tu necesidad: código gratis
          { id = "auto/coding:free"; }        # ¡El que buscas! Mejor código gratuito
          { id = "auto/coding:cheap"; }       # Código con el coste más bajo (si no hay gratis)
          { id = "auto/coding:fast"; }        # El código más rápido

          # Otros combos útiles para tener a mano
          { id = "auto/reasoning:free"; }     # El mejor razonamiento gratuito
          { id = "auto/smart"; }              # Calidad + exploración para descubrir modelos
        ];
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

    # ~/.config/pi-openai-compat/config.json — permisos estrictos
    # Solo escribe si el archivo NO existe, para que /compat-refresh
    # pueda actualizar el catálogo y persistir entre rebuilds.
    piCompatConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -f "$HOME/.config/pi-openai-compat/config.json" ]; then
        run mkdir -p -m700 "$HOME/.config/pi-openai-compat"
        run install -Dm600 ${piCompatConfig} "$HOME/.config/pi-openai-compat/config.json"
      fi
    '';
  };
}
  # (rebuild forzado para regenerar config.json)
