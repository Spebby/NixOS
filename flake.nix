{
  description = "Spebby's NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Tooling
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-index-database.follows = "nix-index-database";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Dendritic framework
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    den.url = "github:vic/den/v0.10.0";
    flake-aspects.url = "github:vic/flake-aspects/v0.5.0";

    # Hardware & Boot
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit.follows = "pre-commit-hooks";
    };

    # Desktop: Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-unity-fix.url = "github:nnra6864/HyprlandUnityFix";

    # Desktop: Niri
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        niri-unstable.follows = "niri/niri-stable";
        xwayland-satellite-unstable.follows = "niri/xwayland-satellite-stable";
      };
    };

    # Theming
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM/cfb0e3eb380cfc61e73ad4bce90e4dcbb9400291";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Packages
    nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    nur = {
      url = "git+https://tangled.org/quasigod.xyz/nur";
      inputs.nixpkgs.url = "github:numtide/nixpkgs-unfree?ref=nixos-unstable";
      inputs.flake-parts.follows = "flake-parts";
    };
    blender = {
      url = "github:edolstra/nix-warez?dir=blender";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:Spebby/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshells = {
      url = "github:Spebby/devshells";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #  devshell
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    # Nixpkgs PRs
    amuletMapEditor.url = "github:NixOS/nixpkgs/pull/405548/head";
    hytale.url = "github:NixOS/nixpkgs/pull/479368/head";
  };

  # Ripped from https://tangled.org/quasigod.xyz/nixconfig
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://attic.xuyh0120.win/lantian" # cachyos kernels
      "https://cache.numtide.com" # llm-agents
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } { imports = [ (inputs.import-tree ./modules) ]; };
}
