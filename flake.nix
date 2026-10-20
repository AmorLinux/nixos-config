{
  description = "Sistema NixOS - Laptop Base Modular";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # pi (agente de IA) — flake oficial del proyecto, incluye pkgs.pi
    pi = {
      url = "github:earendil-works/pi/v1.2.0";
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
          # doInstallCheck=false: el check del tag v1.2.0 exige 'esbuild', que
          # el install-lock del tag no incluye (bug upstream #10881, ya
          # corregido en main eliminando ese check). Al subir de versión,
          # probar primero sin este override.
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              inputs.pi.overlays.default
              (final: prev: {
                pi = prev.pi.overrideAttrs (_: { doInstallCheck = false; });
              })
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
            # 👇 NUEVO: hace que `inputs` esté disponible DENTRO de home.nix
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.amoreira = import ./home.nix;
          }
        ];
      };
    };
  };
}
