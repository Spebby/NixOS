{ lib, ... }:
{
  my.apps._.math.homeManager =
    { config, pkgs, ... }:
    let
      cfg = config.my.apps._.math;
    in
    {
      options.my.apps._.math = {
        geogebra = {
          enable = lib.mkEnableOption "GeoGebra math suite";
          package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.geogebra6;
            description = "GeoGebra package to install.";
          };
        };
      };

      config = lib.mkIf cfg.geogebra.enable { home.packages = [ cfg.geogebra.package ]; };
    };
}
