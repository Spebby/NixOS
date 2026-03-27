{ self, inputs, ... }:
{

  flake.nixosModules.rossoConfiguration =
    { pkgs, lib, ... }:
    {
      imports = [
        self.nixosModules.rossoHardware
        self.nixosModules.niri
      ];

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

    };
}
