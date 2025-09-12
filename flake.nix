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
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [ prisma-engines prisma ];
        shellHook = ''
          export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig";
          export PRISMA_SCHEMA_ENGINE_BINARY="${pkgs.prisma-engines}/bin/schema-engine"
          export PRISMA_QUERY_ENGINE_BINARY="${pkgs.prisma-engines}/bin/query-engine"
          export PRISMA_QUERY_ENGINE_LIBRARY="${pkgs.prisma-engines}/lib/libquery_engine.node"
          export PRISMA_FMT_BINARY="${pkgs.prisma-engines}/bin/prisma-fmt"
        '';
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

