{ config, pkgs, ... }: {
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
        formats = [ "html" "json" ];
      };
      ui = {
        default_locale = "es";
        default_theme = "simple";
      };
      engines = [
        # --- MOTORES WEB GENERALES QUE SÍ FUNCIONAN (NO DESACTIVAR) ---
        # (bing, mojeek, duckduckgo web, yandex, encyclosearch, fynd, ayo, wolframalpha, etc. quedan activos por defecto)
        
        # --- MOTORES QUE BLOQUEAN BOTS O ESTÁN EN 0% (DESACTIVADOS) ---
        { name = "google"; disabled = true; }
        { name = "google images"; disabled = true; }
        { name = "duckduckgo"; disabled = true; } # El general (20%), no el "web" (90%)
        { name = "duckduckgo images"; disabled = true; }
        { name = "brave"; disabled = true; }
        { name = "brave.images"; disabled = true; }
        { name = "brave.videos"; disabled = true; }
        { name = "startpage"; disabled = true; }
        { name = "startpage images"; disabled = true; }
        { name = "qwant"; disabled = true; }
        { name = "presearch"; disabled = true; }
        { name = "presearch videos"; disabled = true; }
        { name = "yahoo"; disabled = true; }
        { name = "doggle"; disabled = true; }
        { name = "fastbot"; disabled = true; }
        { name = "fireball"; disabled = true; }
        { name = "gabanza"; disabled = true; }
        { name = "infospace"; disabled = true; }
        { name = "privacywall"; disabled = true; }
        { name = "searchtoday"; disabled = true; }
        { name = "tineye"; disabled = true; }
        { name = "tusksearch"; disabled = true; }
        { name = "vuhuv"; disabled = true; }
        { name = "yep"; disabled = true; }
        { name = "zapmeta"; disabled = true; }
        { name = "gmx"; disabled = true; }
        { name = "mwmbl"; disabled = true; }
        { name = "yacy"; disabled = true; }

        # --- MOTORES DE WIKIPEDIA Y DERIVADOS (LENTOS O FALLAN) ---
        { name = "wikipedia"; disabled = true; }
        { name = "wikidata"; disabled = true; }
        { name = "wikibooks"; disabled = true; }
        { name = "wikiquote"; disabled = true; }
        { name = "wikisource"; disabled = true; }
        { name = "wikispecies"; disabled = true; }
        { name = "wikiversity"; disabled = true; }
        { name = "wikivoyage"; disabled = true; }

        # --- MOTORES DE IDIOMAS EXTRANJEROS (INÚTILES PARA TI) ---
        { name = "baldu"; disabled = true; }
        { name = "sogou"; disabled = true; }
        { name = "360search"; disabled = true; }
        { name = "naver"; disabled = true; }
        { name = "seznam"; disabled = true; }
        { name = "wikimini"; disabled = true; }
        { name = "abcnyheter"; disabled = true; }

        # --- OTROS (LENTOS O INÚTILES) ---
        { name = "openlibrary"; disabled = true; }
        { name = "mymemory translated"; disabled = true; }
        { name = "lingva"; disabled = true; }
        { name = "mozhli"; disabled = true; }
        
        # --- TODO LO DEMÁS (YOUTUBE, GITHUB, STACKOVERFLOW, MDN, BING IMAGES, FLICKR, PEXELS, SEARCHMYSITE, WIBY, ETC.) SE QUEDA ACTIVO ---
      ];
    };
  };
}
