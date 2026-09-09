{ config, pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    policies = {
      # ============ TELEMETRÍA Y DATOS ============
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFormHistory = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      PasswordManagerEnabled = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };

      # ============ EXTENSIONES OBLIGATORIAS ============
      # (Se instalan automáticamente y no se pueden desactivar)
      ExtensionSettings = {
        # Firefox Multi-Account Containers
        "@testpilot-containers" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
          installation_mode = "force_installed";
        };
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Privacy Badger
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };
        # Bitwarden (ya lo tienes como app, pero la extensión es más cómoda)
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };

      # ============ BARRA Y UI ============
      Bookmarks = [
        {
          Name = "NixOS";
          URL = "https://nixos.org";
          Folder = "Barra de marcadores";
        }
      ];

      # ============ PREFERENCIAS AVANZADAS (about:config) ============
      Preferences = {
        # Telemetría
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "browser.ping-centre.telemetry" = false;
        "beacon.enabled" = false;

        # Crash reports
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;

        # Normandy / Studies
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "app.shield.optoutstudies.enabled" = false;

        # Safe Browsing (envía hashes a Google; desactívalo si quieres privacidad extrema)
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;

        # Mozilla "phone home"
        "browser.send_pings" = false;
        "browser.send_pings.require_same_host" = true;
        "network.predictor.enabled" = false;
        "network.prefetch-next" = false;
        "network.dns.disablePrefetch" = true;
        "network.http.speculative-parallel-limit" = 0;

        # Contenedores: crear algunos por defecto
        # (Se pueden gestionar desde la UI de la extensión)

        # Privacidad general
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.firstparty.isolate" = true;
        "privacy.donottrackheader.enabled" = true;
        "browser.contentblocking.category" = "strict";

        # Desactivar "Sponsored" en la nueva pestaña
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # Motor de búsqueda por defecto: DuckDuckGo
        "browser.search.defaultenginename" = "DuckDuckGo";
        "browser.search.order.1" = "DuckDuckGo";
      };
    };

    # Perfiles
    profiles."amoreira" = {
      id = 0;
      name = "Amoreira";
      isDefault = true;

      # Contenedores predefinidos (la extensión los gestiona después)
      containersForce = true;
      containers = {
        "Personal" = {
          id = 1;
          name = "Personal";
          icon = "fingerprint";
          color = "blue";
        };
        "Trabajo" = {
          id = 2;
          name = "Trabajo";
          icon = "briefcase";
          color = "orange";
        };
        "Bancos" = {
          id = 3;
          name = "Bancos";
          icon = "dollar";
          color = "green";
        };
        "Redes" = {
          id = 4;
          name = "Redes sociales";
          icon = "cart";
          color = "pink";
        };
      };

      settings = {
        "browser.startup.homepage" = "about:home";
        "browser.newtabpage.enabled" = true;
        "browser.search.region" = "AR";  # cambia a tu país
        "intl.accept_languages" = "es-AR,es,en-US,en";
      };
    };
  };
}
