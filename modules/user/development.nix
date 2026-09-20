{ config, pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    htop fastfetch python3 nodejs gcc dotnet-sdk
    cargo rustc jdk jetbrains.idea android-studio unityhub

    # ❌ Quita vscodium de aquí
    discord zoom-us qbittorrent dbeaver-bin
    jq
    burpsuite
    bruno
    docker-compose
  ];

  # ✅ Usa programs.vscodium en lugar de programs.vscode
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;

    # Nueva estructura de perfiles
    profiles.default = {
      extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}; [
        open-vsx.kilocode.kilo-code
      ];

      userSettings = {
        # Opcional: tu provider de Kilo Code declarativo
        # "kilocode.apiProvider" = "openai";
        # "kilocode.openAiBaseUrl" = "http://localhost:20128/v1";
        # "kilocode.openAiModelId" = "combo-dev";
      };
    };
  };
}
