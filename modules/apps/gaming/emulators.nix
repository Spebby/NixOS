{ lib, ... }:
{
  my.apps._.emulators.homeManager =
    { config, pkgs, ... }:
    let
      cfg = config.my.apps._.emulators;
    in
    {
      options.my.apps._.emulators = {
        includeRmg = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install rmg emulator.";
        };
        includeMelonds = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install melonDS emulator.";
        };
      };

      config = {
        home.packages =
          (lib.optionals cfg.includeRmg [ pkgs.rmg ]) ++ (lib.optionals cfg.includeMelonds [ pkgs.melonds ]);
      };
    };
}
