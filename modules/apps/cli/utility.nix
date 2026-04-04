{ lib, ... }:
{
  my.apps._.cli._.utility.homeManager =
    { config, pkgs, ... }:
    let
      cfg = config.my.apps._.cli.utility;
    in
    {
      options.my.apps._.cli.utility = {
        includeSystemHelpers = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install system helper CLI tools.";
        };

        includeMediaHelpers = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install media-oriented helper CLI tools.";
        };

        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Extra packages added on top of the utility set.";
        };
      };

      config = {
        home.packages =
          (lib.optionals cfg.includeSystemHelpers [
            pkgs.bc
            pkgs.bottom
            pkgs.fastfetch
            pkgs.fzf
            pkgs.netcat-gnu
            pkgs.ripgrep
            pkgs.unzip
            pkgs.wget
            pkgs.zip
          ])
          ++ (lib.optionals cfg.includeMediaHelpers [
            pkgs.ffmpegthumbnailer
            pkgs.mediainfo
            pkgs.playerctl
            pkgs.ueberzugpp
          ])
          ++ cfg.extraPackages;
      };
    };
}
