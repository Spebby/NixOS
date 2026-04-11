{ lib, ... }:
{
  my.apps._.hardware-tools.homeManager =
    { config, pkgs, ... }:
    let
      cfg = config.my.apps._.hardware-tools;
    in
    {
      options.my.apps._.hardware-tools = {
        includeVia = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install VIA keyboard configurator.";
        };

        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Extra packages added on top of the hardware utilities set.";
        };
      };

      config = {
        home.packages = (lib.optionals cfg.includeVia [ pkgs.via ]) ++ cfg.extraPackages;
      };
    };
}
