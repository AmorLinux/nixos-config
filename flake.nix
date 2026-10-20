{
  description = "Sistema NixOS - Laptop Base Modular";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # pi (agente de IA) — flake oficial del proyecto, incluye pkgs.pi
    pi = {
      url = "github:earendil-works/pi/v1.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix

          # 👇 overlay oficial de pi para exponer pkgs.pi
          # (doInstallCheck: el bug upstream #10881 que exigía 'esbuild' en el
          # check estaba en v1.2.0 y se corrigió en 1.3.0; sin override)
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              inputs.pi.overlays.default
            ];
          })

          # 👇 Este módulo se aplica desde el inicio
          ({ pkgs, ... }: {
            nixpkgs.config.permittedInsecurePackages = [
              "electron-39.0.10"
              "electron-39.8.10"
            ];
          })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Evita abortar el switch si un archivo gestionado ya existe como
            # huérfano (restos de generaciones antiguas): HM lo mueve a
            # *.backup en vez de fallar con "would be clobbered".
            home-manager.backupFileExtension = "backup";
            # 👇 NUEVO: hace que `inputs` esté disponible DENTRO de home.nix
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.amoreira = import ./home.nix;
          }
        ];
      };
    };
  };
}
