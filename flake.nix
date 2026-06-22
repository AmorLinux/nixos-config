{
  description = "Mi sistema NixOS a medida";

  inputs = {
    # Usaremos la rama inestable para tener las últimas versiones de Wayland y Sway
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home Manager para controlar tus dotfiles y el espacio de usuario
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
          
          # Módulo de Home Manager como parte del sistema
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Aquí vinculamos a tu usuario "amoreira" con su configuración
            home-manager.users.amoreira = import ./home.nix;
          }
        ];
      };
    };
  };
}
