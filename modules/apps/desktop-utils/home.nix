{ lib, ... }:
{
  my.apps._.desktop-utils.provides.home.homeManager =
    { config, pkgs, ... }:
    let
      cfg = config.my.apps._.desktop-utils.home;
    in
    {
      options.my.apps._.desktop-utils.home = {
        includeMissionCenter = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install Mission Center.";
        };

        includeBtop = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install btop system monitor.";
        };

        includeDistroShelf = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install DistroShelf.";
        };

        includeUdisks = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install udisks user utilities.";
        };

        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Extra packages added on top of the desktop utility set.";
        };
      };

      config.home.packages =
        (lib.optionals cfg.includeMissionCenter [ pkgs.mission-center ])
        ++ (lib.optionals cfg.includeBtop [ pkgs.btop ])
        ++ (lib.optionals cfg.includeDistroShelf [ pkgs.distroshelf ])
        ++ (lib.optionals cfg.includeUdisks [ pkgs.udisks ])
        ++ cfg.extraPackages;
    };
}
