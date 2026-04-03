{
  lib,
  ...
}:
{
  my.apps._.cli._.utility.homeManager =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.my.apps._.cli.utility;
    in
    {
      options.my.apps._.cli.utility = {
        enable = lib.mkEnableOption "general-purpose CLI utility bundle";

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

        includeWaylandHelpers = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install Wayland interaction helper CLI tools.";
        };

        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Extra packages added on top of the utility set.";
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages =
          (lib.optionals cfg.includeSystemHelpers [
            pkgs.bc
            pkgs.bottom
            pkgs.btop
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
            pkgs.yt-dlp
          ])
          ++ (lib.optionals cfg.includeWaylandHelpers [
            pkgs.showmethekey
            pkgs.wl-clipboard
            pkgs.wtype
          ])
          ++ cfg.extraPackages;
      };
    };
}
