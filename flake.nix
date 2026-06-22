{
  description = "Mi sistema NixOS a medida - Multi-Host";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      
      # ==========================================
      # PERFIL 1: MÁQUINA VIRTUAL ACTUAL (PC 1)
      # ==========================================
      vm-principal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-vm-principal.nix # <-- Hardware específico de esta máquina
          ./configuration.nix
          
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.amoreira = import ./home.nix;
          }
        ];
      };

      # ==========================================
      # PERFIL 2: NUEVA MÁQUINA VIRTUAL (PC 2)
      # ==========================================
      vm-secundaria = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-vm-secundaria.nix # <-- Marcador de posición para la otra PC
          ./configuration.nix
          
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
