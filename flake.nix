# This can be built with nixos-rebuild --flake .#myhost build
{
  description = "the simplest flake for nixos-rebuild";

  inputs = {
    nixpkgs = {
      # Using the nixos-unstable branch specifically, which is the
      # closest you can get to following the equivalent channel with flakes.
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Outputs can be anything, but the wiki + some commands define their own
  # specific keys. Wiki page: https://nixos.wiki/wiki/Flakes#Output_schema
  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # nixosConfigurations is the key that nixos-rebuild looks for.
    nixosConfigurations = let
      hmModules = [
        {
          #_module.args = {inherit inputs;};
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.admin = import ./home-manager/admin.nix;
          home-manager.users.astral = import ./home-manager/astral.nix;
          home-manager.users.ivy = import ./home-manager/ivy.nix;
        }

        home-manager.nixosModules.home-manager
      ];
    in {
      lap = nixpkgs.lib.nixosSystem {
        # A lot of times online you will see the use of flake-utils + a
        # function which iterates over many possible systems. My system
        # is x86_64-linux, so I'm only going to define that
        system = "x86_64-linux";
        modules = [ ./configurations/lap.nix ] ++ hmModules;
      };
      rpi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./configurations/rpi.nix ] ++ hmModules;
      };
    };

    # defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    # defaultPackage.x86_64-darwin = home-manager.defaultPackage.x86_64-darwin;
    # defaultPackage.aarch64-linux = home-manager.defaultPackage.aarch64-linux;
    # homeConfigurations = {
    #   "ivy" = home-manager.lib.homeManagerConfiguration {
    #     # Note: I am sure this could be done better with flake-utils or something
    #     pkgs = nixpkgs.legacyPackages.aarch64-linux;

    #     modules = [ 
    #       ./home-manager/ivy.nix
    #     ];
    #   };
    # };
  };
}
