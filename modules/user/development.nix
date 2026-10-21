{ config, pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    # --- C# / .NET 10 (LTS, soporte hasta nov 2028) ---
    dotnetCorePackages.sdk_10_0  # SDK 10.0.401
    dotnet-ef                    # CLI de Entity Framework Core (migraciones)
    csharpier                     # Formateador de código C#

    # --- IDE y cliente de BD ---
    jetbrains.rider               # IDE de C# (incluye herramientas de BD estilo DataGrip)
    dbeaver-bin                    # Cliente universal de BD para futuros gestores (MySQL, SQLite, Oracle...)

    # --- Lenguajes / toolchain general ---
    python3
    nodejs
    gcc
    cargo
    rustc
    jdk
    jetbrains.idea                 # IntelliJ IDEA
    android-studio

    # --- Herramientas de API / seguridad / red ---
    burpsuite
    bruno
    docker-compose
    cloudflared
    jq

    # --- IA local (CLI; para el daemon declarativo: services.ollama) ---
    ollama

    # --- Cliente psql: misma versión (18.6) que el contenedor de docker.nix ---
    postgresql

    # --- Supabase CLI: backups SQL, migraciones y gestión de proyectos
    #     (db dump usa pg_dump nativo en linux, no requiere docker) ---
    supabase-cli

    # --- CLI / monitor ---
    htop
    fastfetch
  ];

  # Desactivar telemetría del CLI de dotnet
  home.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  };

  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}; [
        open-vsx.kilocode.kilo-code
      ];
      userSettings = {
      };
    };
  };
}
