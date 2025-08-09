{
  description = "my first flake";

  inputs = {
    nixpkgs.url =
      "nixpkgs/nixos-25.05"; # Specify the Nixpkgs input from a specific channel
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        deathtotheworld = lib.nixosSystem {
          inherit system;

          modules = [
            ./configuration.nix

            { nixpkgs.config.allowUnfree = true; }
          ]; # Points to your system's config file
        };
      };
      homeConfigurations = {
        mtende = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          modules = [ ./home.nix ];
        };
      };
    };
}

