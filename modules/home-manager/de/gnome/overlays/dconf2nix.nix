# overlays/dconf2nix.nix
super: { dconf2nix = super.haskellPackages.callPackage ../pkgs/dconf2nix.nix { }; }
