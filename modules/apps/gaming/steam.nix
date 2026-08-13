{
  my.apps._.steam = {
    nixos = { pkgs, ... }: {
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
        };

        config = {
          home.packages = lib.optionals cfg.includeCliTools [
            pkgs.steam-tui
            pkgs.steamcmd
          ];
        };
      };
  };
}
