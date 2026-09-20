{
  description = "Sistema NixOS - Laptop Base Modular";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # 👇 NUEVO: pi (agente de IA) empaquetado en Nix                                                             
    pi-nix.url = "github:takinbo/pi-nix";   

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 👇 NUEVO: catálogo declarativo de extensiones (se auto-actualiza a diario)
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
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

          # 👇 NUEVO: overlay de pi-nix para exponer pkgs.pi                                                     
          ({ pkgs, ... }: {                                                                                      
            nixpkgs.overlays = [ inputs.pi-nix.overlays.default ];                                               
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
