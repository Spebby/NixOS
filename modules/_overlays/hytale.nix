{ inputs, ... }:

{
  nixpkgs.overlays = [
    (
      self: super:
      let
        hytalePkgs = import inputs.hytale {
          inherit (self) system;
          config.allowUnfree = true;
        };
      in
      {
        inherit (hytalePkgs) hytale-launcher;
      }
    )
  ];
}
