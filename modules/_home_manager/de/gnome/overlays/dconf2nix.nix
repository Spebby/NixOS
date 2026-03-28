# overlays/dconf2nix.nix
_final: prev: { dconf2nix = prev.haskellPackages.callPackage ../pkgs/dconf2nix.nix { }; }
