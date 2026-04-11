{ lib, ... }:
{
  my.apps._.productivity.provides.figma.homeManager =
    { config, pkgs, ... }:
    let
      cfg = config.my.apps._.productivity.figma;
    in
    {
      options.my.apps._.productivity.figma = {
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.figma-linux;
          description = "Figma package to install.";
        };
      };

      config.home.packages = [ cfg.package ];
    };
}
