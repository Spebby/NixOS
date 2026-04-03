{
  lib,
  ...
}:
{
  my.apps._.media._.core.homeManager =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.my.apps._.media.core;
    in
    {
      options.my.apps._.media.core = {
        enable = lib.mkEnableOption "core media and capture applications";

        includePlayback = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install mpv and VLC for local/network playback.";
        };

        includeRecording = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install OBS Studio.";
        };

        includeEditing = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install LosslessCut.";
        };

        includeMusicClients = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Install Spotify and Cider.";
        };

        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Extra packages added on top of the media core set.";
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages =
          (lib.optionals cfg.includePlayback [
            pkgs.mpv
            pkgs.vlc
          ])
          ++ (lib.optionals cfg.includeRecording [ pkgs.obs-studio ])
          ++ (lib.optionals cfg.includeEditing [ pkgs.losslesscut-bin ])
          ++ (lib.optionals cfg.includeMusicClients [
            pkgs.spotify
            pkgs.cider-2
          ])
          ++ cfg.extraPackages;
      };
    };
}
