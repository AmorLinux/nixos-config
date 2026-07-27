{
  description = "Sistema NixOS - Laptop Base";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
          # El hardware real de tu VMware actual
          ./hardware-configuration.nix
          
          # Tu configuración general del sistema
          ./configuration.nix
          
          # La integración de Home Manager para tu usuario
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.amoreira = import ./home.nix;
          }
        ];
      };
    };
  };
}
