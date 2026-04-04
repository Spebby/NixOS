{ lib, config, ... }:
let
  cfg = config.my.desktops._.hyprland.home;
in
{
  my.desktops._.hyprland.provides.shell.homeManager = {
    config = lib.mkIf (cfg.enable && cfg.shell.enable && cfg.shell.package != null) {
      home.packages = [ cfg.shell.package ];
    };
  };
}
