{
  my.apps._.steam = {
    nixos =
      { lib, pkgs, ... }:
      {
        programs.steam = {
          enable = lib.mkForce true;
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
          enable = lib.mkEnableOption "Steam helper tools for user profile";
          includeCliTools = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Install steam-tui and steamcmd.";
          };
        };

        config = lib.mkIf cfg.enable {
          home.packages = lib.optionals cfg.includeCliTools [
            pkgs.steam-tui
            pkgs.steamcmd
          ];
        };
      };
  };
}
