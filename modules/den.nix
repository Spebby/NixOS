{
  inputs,
  den,
  lib,
  ...
}:
let
  stateVersion = "24.11";
  rossoSystem = "x86_64-linux";
  tinkSystem = "x86_64-linux";

  stableConfig = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "dotnet-sdk-6.0.428"
      "dotnet-runtime-6.0.36"
    ];
  };

  mkStablePkgs =
    system:
    import inputs.nixpkgs-stable {
      inherit system;
      config = stableConfig;
    };
in
{
  imports = [ inputs.den.flakeModule ];

  den = {
    default = {
      includes = [
        den.provides.define-user
        den.provides.home-manager
        (
          args:
          lib.optionalAttrs (args ? host) {
            ${args.host.class}.networking.hostName = args.host.hostName;
          }
        )
      ];

      nixos = {
        system.stateVersion = stateVersion;
        nixpkgs.overlays =
          (import ./_overlays/amulet.nix { inherit inputs; }).nixpkgs.overlays
          ++ (import ./_overlays/hytale.nix { inherit inputs; }).nixpkgs.overlays
          ++ (import ./_overlays/pysvg.nix).nixpkgs.overlays;
      };

      homeManager = {
        imports = [
          inputs.stylix.homeModules.stylix
          inputs.hyprland-unity-fix.nixosModules.hyprlandUnityFixModule
        ];

        home.stateVersion = stateVersion;
      };
    };

    hosts.${rossoSystem} = {
      rosso = { };
      tink = { };
    };

    homes.${rossoSystem} = {
      "thom@rosso" = {
        userName = "thom";
        aspect = "thom";
      };
      "max@rosso" = {
        userName = "max";
        aspect = "max";
      };
      "max@tink" = {
        userName = "max";
        aspect = "max";
      };
    };

    aspects = {
      rosso.nixos =
        { host, ... }:
        {
          _module.args = {
            inherit inputs stateVersion;
            hostname = host.hostName;
            pkgs-stable = mkStablePkgs rossoSystem;
          };

          imports = [
            inputs.nixos-hardware.nixosModules.common-cpu-amd
            inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
            inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
            inputs.nixos-hardware.nixosModules.common-gpu-amd
            inputs.nixos-hardware.nixosModules.common-pc-laptop
            inputs.nixos-hardware.nixosModules.common-pc-ssd
            ./_hosts/common
            ./_hosts/sddm/default.nix
            ./_hosts/sddm/rosso.nix
            ./_hosts/rosso/configuration.nix
          ];
        };

      tink.nixos =
        { host, ... }:
        {
          _module.args = {
            inherit inputs stateVersion;
            hostname = host.hostName;
            pkgs-stable = mkStablePkgs tinkSystem;
          };

          imports = [
            ./_hosts/common
            ./_hosts/sddm/default.nix
            ./_hosts/sddm/tink.nix
            ./_hosts/tink/configuration.nix
          ];
        };

      thom.homeManager =
        { pkgs, ... }:
        {
          _module.args = {
            inherit inputs stateVersion;
            pkgs-stable = mkStablePkgs pkgs.stdenv.hostPlatform.system;
          };

          imports = [ ./../users/home-manager/thom.nix ];
        };

      max.homeManager =
        { pkgs, ... }:
        {
          _module.args = {
            inherit inputs stateVersion;
            pkgs-stable = mkStablePkgs pkgs.stdenv.hostPlatform.system;
          };

          imports = [ ./../users/home-manager/max.nix ];
        };
    };
  };

  flake.nixosModules = {
    host-common = import ./_hosts/common;
    silent-sddm = import ./_hosts/sddm/default.nix;
    silent-sddm-rosso = import ./_hosts/sddm/rosso.nix;
    silent-sddm-tink = import ./_hosts/sddm/tink.nix;

    rossoConfiguration = import ./_hosts/rosso/configuration.nix;
    tinkConfiguration = import ./_hosts/tink/configuration.nix;

    rosso = {
      imports =
        map (name: inputs.nixos-hardware.nixosModules.${name}) [
          "common-cpu-amd"
          "common-cpu-amd-pstate"
          "common-cpu-amd-zenpower"
          "common-gpu-amd"
          "common-pc-laptop"
          "common-pc-ssd"
        ]
        ++ [
          ./_hosts/common
          ./_hosts/sddm/default.nix
          ./_hosts/sddm/rosso.nix
          ./_hosts/rosso/configuration.nix
        ];
    };

    tink = {
      imports = [
        ./_hosts/common
        ./_hosts/sddm/default.nix
        ./_hosts/sddm/tink.nix
        ./_hosts/tink/configuration.nix
      ];
    };
  };
}
