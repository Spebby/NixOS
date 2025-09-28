# /flake.nix

{
  # This may not be the best way of doing this; at some point it may make more sense to move system to be controlled by the systems, but this makes more sense for the moment.
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

    # Theming Manager
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

    # Cosmic Desktop
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      hosts = import ./hosts/hosts.nix;
      makeSystem = import ./lib/makeSystem.nix { inherit inputs stateVersion; };
      makeHome = import ./lib/makeHome.nix { inherit inputs lib stateVersion; };

      defaultSystem = "x86_64-linux";
    in
    {
      # Previously "name: makeSystem", but unused and deadnix complained.
      nixosConfigurations = builtins.mapAttrs (_: makeSystem) hosts;
      homeConfigurations = builtins.foldl' (
        acc: host:
        acc
        // builtins.foldl' (
          userAcc: user:
          let
            hostHMConfig = host.config.home-manager.users.${user} or { };
          in
          userAcc
          // {
            "${user}@${host.hostname}" = makeHome {
              inherit inputs user;
              pkgs = import nixpkgs {
                inherit (host) system;
                config = {
                  allowUnfree = true;
                };
              };
              pkgs-stable = import nixpkgs-stable {
                inherit (host) system;
                config = {
                  allowUnfree = true;
                  # msbuild requires this eol stuff
                  permittedInsecurePackages = [
                    "dotnet-sdk-6.0.428"
                    "dotnet-runtime-6.0.36"
                  ];
                };
              };
              hostModules = [ hostHMConfig ];
            };
          }
        ) acc (host.users or [ ])
      ) { } (builtins.attrValues hosts);

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
            # Official hooks from cachix/pre-commit-hooks.nix
            flake-checker.enable = true;
            nixfmt-rfc-style = {
              enable = true;
              settings.width = 100;
            };
            statix = {
              enable = true;
              settings.ignore = [ "flake.lock" ];
            };
            deadnix.enable = true;
            nil.enable = true; # Nix LSP diagnostics

            # Optional: Other useful hooks
            shellcheck.enable = true;
            shfmt.enable = true;
            typos.enable = true;
          };
        };
      };
    };
}
