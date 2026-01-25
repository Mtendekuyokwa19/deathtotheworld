{
  description = "my first flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
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
    # jj.url="github:martinvo"
    jj.url = "github:jj-vcs/jj";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, quickshell, noctalia, ... }:
    let
      lib = nixpkgs.lib;

      androidSdk = pkgs.androidenv.androidPkgs.androidsdk;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit self inputs lib system; };

          modules =
            [ ./configuration.nix ]; # Points to your system's config file
        };
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          pkgs.flutter
          androidSdk
          pkgs.jdk17
          libsecret
          pkg-config
        ];
        ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
        GRADLE_OPTS =
          "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/34.0.0/aapt2";
        shellHook = ''
                   export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig";
          export WAYLAND_DISPLAY="''${WAYLAND_DISPLAY:-wayland-1}"
                     export XDG_SESSION_TYPE=wayland
                     export QT_QPA_PLATFORM=wayland
                     export GDK_BACKEND=wayland
                     export MOZ_ENABLE_WAYLAND=1
                     

                      # XWayland fallback for apps that need it
                      export DISPLAY="''${DISPLAY:-:0}"
                      
                      # Flutter configuration
                      export CHROME_EXECUTABLE="${pkgs.chromium}/bin/chromium"
                      export PKG_CONFIG_PATH="${pkgs.libsecret}/lib/pkgconfig:${pkgs.gtk3}/lib/pkgconfig:$PKG_CONFIG_PATH"
                      export LD_LIBRARY_PATH="${pkgs.libsecret}/lib:${pkgs.gtk3}/lib:$
        '';
      };

      homeConfigurations = {
        deathtotheworld = home-manager.lib.homeManagerConfiguration {
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
