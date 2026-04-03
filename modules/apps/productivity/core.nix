{
  lib,
  ...
}:
{
  my.apps._.productivity._.core.homeManager =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.my.apps._.productivity.core;
    in
    {
      options.my.apps._.productivity.core = {
        enable = lib.mkEnableOption "core productivity applications";

        includeBrowser = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Install Google Chrome.";
        };

        includeComms = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install communication and meeting clients (Slack, Zoom).";
        };

        includeMail = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install Thunderbird.";
        };

        includeOffice = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install LibreOffice (Qt build).";
        };

        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Extra packages added on top of the productivity core set.";
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages =
          (lib.optionals cfg.includeOffice [ pkgs.libreoffice-qt6 ])
          ++ (lib.optionals cfg.includeMail [ pkgs.thunderbird ])
          ++ (lib.optionals cfg.includeComms [
            pkgs.slack
            pkgs.zoom-us
          ])
          ++ (lib.optionals cfg.includeBrowser [ pkgs.google-chrome ])
          ++ cfg.extraPackages;
      };
    };
}
