{ lib, ... }:
{
  my.apps._.productivity.provides = {
    core.homeManager =
      { config, pkgs, ... }:
      let
        cfg = config.my.apps._.productivity.core;
      in
      {
        options.my.apps._.productivity.core = {
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

          includeCoreTools = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Install productivity utility tools (gtt).";
          };

          extraPackages = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [ ];
            description = "Extra packages added on top of the productivity core set.";
          };
        };

        config = {
          home.packages =
            (lib.optionals cfg.includeOffice [ pkgs.libreoffice-qt6 ])
            ++ (lib.optionals cfg.includeMail [ pkgs.thunderbird ])
            ++ (lib.optionals cfg.includeComms [
              pkgs.slack
              pkgs.zoom-us
            ])
            ++ (lib.optionals cfg.includeBrowser [ pkgs.google-chrome ])
            ++ (lib.optionals cfg.includeCoreTools [ pkgs.gtt ])
            ++ cfg.extraPackages;
        };
      };
  };
}
