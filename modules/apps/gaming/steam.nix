{
  my.apps._.steam = {
    nixos =
      { lib, pkgs, ... }:
      {
        programs.steam = {
          extraPackages = [ pkgs.steamtinkerlaunch ];
        };
      };

    homeManager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.my.apps._.steam;
      in
      {
        options.my.apps._.steam = {
          includeCliTools = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Install steam-tui and steamcmd.";
          };

          includeLutris = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Install Lutris game launcher.";
          };
        };

        config = {
          home.packages =
            (lib.optionals cfg.includeCliTools [
              pkgs.steam-tui
              pkgs.steamcmd
            ])
            ++ (lib.optionals cfg.includeLutris [ pkgs.lutris ]);
        };
      };
  };
}
