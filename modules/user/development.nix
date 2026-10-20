{ config, pkgs, inputs, ... }: {
  # Entorno de desarrollo C# / .NET + herramientas de bases de datos
  home.packages = with pkgs; [
    # --- C# / .NET 10 (LTS, soporte hasta nov 2028) ---
    dotnetCorePackages.sdk_10_0  # SDK 10.0.401
    dotnet-ef                    # CLI de Entity Framework Core (migraciones)
    csharpier                     # Formateador de código C#

    # --- IDE y cliente de BD ---
    jetbrains.rider               # IDE de C# (incluye herramientas de BD estilo DataGrip)
    dbeaver-bin                    # Cliente universal de BD para futuros gestores (MySQL, SQLite, Oracle...)

    # --- Cliente psql: misma versión (18.6) que el contenedor de docker.nix ---
    postgresql
  ];

  # Desactivar telemetría del CLI de dotnet
  home.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  };

  programs.vscodium = {
    profiles.default = {
      userSettings = {
      };
    };
  };
}
