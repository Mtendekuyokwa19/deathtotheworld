{
  description = "my first flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, quickshell, noctalia, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations = {
        deathtotheworld = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit self inputs lib system; };
          modules = [ ./configuration.nix ];
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
          pkgs = pkgs;
          extraSpecialArgs = { inherit inputs system; };
          modules = [
            ./home.nix
            # Optional: Add noctalia configuration directly here
            {
              home.packages = [ quickshell.packages.${system}.default ];

              # Create the quickshell config directory structure
              xdg.configFile."quickshell/noctalia-shell" = {
                source =
                  "${noctalia.packages.${system}.default}/share/quickshell";
                recursive = true;
              };

              # Alternative: if noctalia provides a different structure
              # xdg.configFile."quickshell/noctalia-shell/shell.qml".source = 
              #   "${noctalia.packages.${system}.default}/shell.qml";
            }
          ];
        };
      };
    };
}
