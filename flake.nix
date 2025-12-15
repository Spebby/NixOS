{
  description = "NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:Spebby/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-unity-fix.url = "github:nnra6864/HyprlandUnityFix";

    blender = {
      url = "github:edolstra/nix-warez?dir=blender";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    silentSDDM = {
      url = "github:uiriansan/SilentSDDM/cfb0e3eb380cfc61e73ad4bce90e4dcbb9400291";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    amuletMapEditor.url = "github:NixOS/nixpkgs/pull/405548/head";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      pre-commit-hooks,
      ...
    }@inputs:
    let
      # NEVER CHANGE THIS STRING. IT IS A FAILSAFE PROVIDED BY NIXOS.
      stateVersion = "24.11";
      inherit (nixpkgs) lib;

      defaultSystem = "x86_64-linux";
      hosts = import ./hosts/hosts.nix;

      # Shared pkgs-stable config
      stablePkgsConfig = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "dotnet-sdk-6.0.428"
          "dotnet-runtime-6.0.36"
        ];
      };

      # Build a NixOS system configuration
      mkSystem =
        _: host:
        # See ./hosts/hosts.nix for more context
        nixpkgs.lib.nixosSystem {
          system = host.system or "x86_64-linux";
          specialArgs = {
            inherit inputs stateVersion;
            inherit (inputs) nixos-hardware;
            inherit (host) hostname;
            pkgs-stable = import nixpkgs-stable {
              system = host.system or "x86_64-linux";
              config = stablePkgsConfig;
            };
          };

          modules = [
            (host.config or ./hosts/${host.hostname}/configuration.nix)
          ]
          ++ (host.extraModules or [ ]);
        };

      # Build a home-manager configuration
      mkHome =
        host: user:
        let
          system = host.system or "x86_64-linux";
          hostHMConfig = host.config.home-manager.users.${user} or { };
        in
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          inherit lib;

          modules = [
            ./modules/home-manager
            ./users/home-manager/${user}.nix
            { home.stateVersion = lib.mkDefault stateVersion; }
            hostHMConfig
          ];
          extraSpecialArgs = {
            inherit inputs user stateVersion;
            pkgs-stable = import nixpkgs-stable {
              inherit system;
              config = stablePkgsConfig;
            };
          };
        };

      # Generate all home-manager configurations
      mkHomeConfigurations =
        let
          # Create list of all host-user pairs
          hostUserPairs = lib.flatten (
            lib.mapAttrsToList (_: host: map (user: { inherit host user; }) (host.users or [ ])) hosts
          );
        in
        lib.listToAttrs (
          map (
            { host, user }:
            {
              name = "${user}@${host.hostname}";
              value = mkHome host user;
            }
          ) hostUserPairs
        );

      # Pick the first host as a sane default for nix commands
      firstHostName = builtins.head (builtins.attrNames hosts);
    in
    {
      nixosConfigurations = builtins.mapAttrs mkSystem hosts;
      homeConfigurations = mkHomeConfigurations;

      packages.${defaultSystem}.default =
        self.nixosConfigurations.${firstHostName}.config.system.build.toplevel;

      devShells.${defaultSystem}.default = nixpkgs.legacyPackages.${defaultSystem}.mkShell {
        shellHook = ''
          ${self.checks.${defaultSystem}.pre-commit-check.shellHook}
        '';
      };

      checks.${defaultSystem} = {
        pre-commit-check = pre-commit-hooks.lib.${defaultSystem}.run {
          src = ./.;
          excludes = [
            ".*/submodules/.*"
            "^submodules/.*"
          ];

          hooks = {
            flake-checker.enable = true;
            nixfmt-rfc-style = {
              enable = true;
              settings.width = 100;
            };
            statix = {
              enable = true;
              settings.ignore = [ "flake.lock" ];
            };
            deadnix.enable = false;
            nil.enable = true;
            shellcheck.enable = true;
            shfmt.enable = true;
            typos.enable = true;
          };
        };
      };
    };
}
