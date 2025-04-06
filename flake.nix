# /flake.nix

{
  # This may not be the best way of doing this; at some point it may make more sense to move system to be controlled by the systems, but this makes more sense for the moment.
  description = "NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # Dots
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Theming Manager
    stylix = {
      url = "github:danth/stylix/release-24.11";
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

    # I am stupid, so I will be doing nixvim... just not yet
  };

  outputs =
    {
      self,
      nixpkgs,
      pre-commit-hooks,
      home-manager,
      ...
    }@inputs:
    let
      # In the future, I'd like to make this dynamic discovery. But for the moment, that's really dumb when there's only 1 system and 2 users.
      inherit (nixpkgs) lib;
      stateVersion = "24.11";
      hosts = import ./hosts/hosts.nix;
      makeSystem = import ./lib/makeSystem.nix { inherit inputs stateVersion; };
      makeHome = import ./lib/makeHome.nix { inherit inputs stateVersion lib; };

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
              pkgs = nixpkgs.legacyPackages.${host.system};
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
            nixfmt-rfc-style.enable = true;
            statix.enable = true;
            deadnix.enable = true;
            nil.enable = true; # Nix LSP diagnostics

            # Optional: Other useful hooks
            shellcheck.enable = true;
            shfmt.enable = true;
            typos.enable = true;
          };

          # Settings for specific hooks
          settings = {
            nixfmt.width = 100; # Line width
            statix.ignore = [ "flake.lock" ]; # Files to ignore
          };
        };
      };
    };
}
