# Configuración declarativa de Kilo Code (global)
# El archivo real vive en ~/.config/kilo/kilo.jsonc
{ config, lib, pkgs, ... }:

let
  kiloConfig = {
    "$schema" = "https://app.kilo.ai/config.json";

    auto_collapse_reasoning = true;
    terminal_command_display = "expanded";

    permission = {
      read = {
        "*" = "allow";
        "*.env" = "ask";
        "*.env.*" = "ask";
        "*.env.example" = "allow";
      };
      edit = "ask";
      glob = "allow";
      grep = "allow";
      list = "allow";
      bash = {
        "*" = "ask";
        # --- lectura segura ---
        "cat *" = "allow";
        "head *" = "allow";
        "tail *" = "allow";
        "less *" = "allow";
        "ls *" = "allow";
        "tree *" = "allow";
        "pwd *" = "allow";
        "echo *" = "allow";
        "wc *" = "allow";
        "which *" = "allow";
        "type *" = "allow";
        "file *" = "allow";
        "diff *" = "allow";
        "du *" = "allow";
        "df *" = "allow";
        "date *" = "allow";
        "uname *" = "allow";
        "whoami *" = "allow";
        "printenv *" = "allow";
        "man *" = "allow";
        # --- búsqueda ---
        "grep *" = "allow";
        "rg *" = "allow";
        "ag *" = "allow";
        "uniq *" = "allow";
        "cut *" = "allow";
        "tr *" = "allow";
        "jq *" = "allow";
        # --- git de SOLO lectura ---
        "git status*" = "allow";
        "git log*" = "allow";
        "git diff*" = "allow";
        "git branch*" = "allow";
        "git show*" = "allow";
        # --- redirects: siempre preguntar ---
        "*>*" = "ask";
      };
      external_directory = "ask";
      question = "allow";
      webfetch = "allow";
      websearch = "allow";
      doom_loop = "ask";
      codesearch = "allow";
    };

    disabled_providers = [ ];

    provider = {
      omniroute = {
        name = "omniroute";
        npm = "@ai-sdk/openai-compatible";
        options = {
          baseURL = "http://localhost:20128/v1";
        };
        models = {
          free-dev = {
            name = "free-dev";
            reasoning = true;
            modalities = { input = [ "text" "image" ]; };
          };
        };
      };
    };
  };

  kiloConfigFile = pkgs.writeText "kilo-config.jsonc" (builtins.toJSON kiloConfig);
in
{
  home.activation.kiloConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run install -Dm644 ${kiloConfigFile} "$HOME/.config/kilo/kilo.jsonc"
  '';
}
