# overlays/simple-weather.nix
self: super: {
  gnomeExtensions = super.gnomeExtensions // {
    simple-weather = self.callPackage ../_pkgs/simple-weather.nix { };
  };
}
