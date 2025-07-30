# /home-manager/packages/default.nix

self: _: {
  # set of custom pkgs, either written or updated, that havent entered nixpkgs yet
  cider-2 = self.callPackage ./cider-2.nix { };
}
