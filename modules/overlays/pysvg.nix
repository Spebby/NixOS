{
  nixpkgs.overlays = [
    (final: prev: {
      python3Packages = prev.python3Packages.overrideScope (
        self: super: {
          picosvg = super.picosvg.overrideAttrs (_: {
            doCheck = false;
          });
        }
      );
    })
  ];
}
