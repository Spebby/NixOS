{
  lib,
  my,
  config,
  ...
}:
let
  cfg = config.my.desktops._.niri.home;
in
{
  my.desktops._.niri = {
    includes = [
      my.desktops._.base
      my.desktops._.niri._.shell
    ];

    nixos =
      { lib, config, ... }:
      let
        niriCfg = config.my.desktops._.niri;
      in
      {
        options.my.desktops._.niri = {
          package = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = null;
            description = "Optional Niri package override.";
          };
        };

        config = {
          programs.niri.enable = true;
          programs.niri.package = lib.mkIf (niriCfg.package != null) niriCfg.package;
        };
      };

    homeManager = {
      options.my.desktops._.niri.home = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable Home Manager Niri desktop configuration bundle.";
        };

        shell = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Use an external shell bundle (e.g. Noctalia) instead of DIY bar/launcher/notifier defaults.";
          };

          package = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = null;
            description = "Optional shell package to install when shell.enable is true.";
          };
        };

        components = {
          waybar.enable = lib.mkOption {
            type = lib.types.nullOr lib.types.bool;
            default = null;
            description = "Enable Waybar. Null means enabled unless shell.enable is true.";
          };

          wofi.enable = lib.mkOption {
            type = lib.types.nullOr lib.types.bool;
            default = null;
            description = "Enable Wofi launcher config. Null means enabled unless shell.enable is true.";
          };

          swaync.enable = lib.mkOption {
            type = lib.types.nullOr lib.types.bool;
            default = null;
            description = "Enable swaync notifications config. Null means enabled unless shell.enable is true.";
          };
        };
      };

      config = lib.mkIf (cfg.enable && cfg.shell.enable) {
        assertions = [
          {
            assertion = !(cfg.components.waybar.enable or false);
            message = "Set my.desktops._.niri.home.components.waybar.enable = false when shell.enable = true, or set it to null for automatic behavior.";
          }
          {
            assertion = !(cfg.components.wofi.enable or false);
            message = "Set my.desktops._.niri.home.components.wofi.enable = false when shell.enable = true, or set it to null for automatic behavior.";
          }
          {
            assertion = !(cfg.components.swaync.enable or false);
            message = "Set my.desktops._.niri.home.components.swaync.enable = false when shell.enable = true, or set it to null for automatic behavior.";
          }
        ];
      };
    };
  };

  my.desktops._.niri.provides.shell.homeManager = {
    config = lib.mkIf (cfg.enable && cfg.shell.enable && cfg.shell.package != null) {
      home.packages = [ cfg.shell.package ];
    };
  };
}
