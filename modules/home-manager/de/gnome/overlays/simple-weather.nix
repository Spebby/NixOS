# overlays/simple-weather.nix
self: super: {
  gnomeExtensions = super.gnomeExtensions // {
    simple-weather = self.callPackage ../pkgs/simple-weather.nix { };
  };
}
