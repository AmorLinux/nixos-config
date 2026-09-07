{ config, pkgs, ... }: {
  # --- SEARXNG: meta-buscador self-hosted (solo loopback) ---
  services.searx = {
    enable = true;
    package = pkgs.searxng;

    settings = {
      server = {
        port = 8888;
        bind_address = "127.0.0.1";
        secret_key = "631a37dcbc23b59e65c9bfe5768ac29f456c7e0f7cda0ccb576ba39ed9c1a351";
      };
      search = {
        safe_search = 0;
        autocomplete = "";
      };
      ui = {
        default_locale = "es";
        default_theme = "simple";
      };
    };
  };
}
