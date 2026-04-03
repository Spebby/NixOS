{
  lib,
  ...
}:
{
  my.apps._.creative._.core.homeManager =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.my.apps._.creative.core;
    in
    {
      options.my.apps._.creative.core = {
        enable = lib.mkEnableOption "creative and content production applications";

        includeAudio = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install Audacity and Reaper.";
        };

        includeImage = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install Pinta.";
        };

        includeVideo = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Install DaVinci Resolve.";
        };

        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Extra packages added on top of the creative core set.";
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages =
          (lib.optionals cfg.includeAudio [
            pkgs.audacity
            pkgs.reaper
          ])
          ++ (lib.optionals cfg.includeImage [ pkgs.pinta ])
          ++ (lib.optionals cfg.includeVideo [ pkgs.davinci-resolve ])
          ++ cfg.extraPackages;
      };
    };
}
