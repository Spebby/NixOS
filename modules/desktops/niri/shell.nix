# modules/desktops/niri/shell.nix
{
  my.desktops._.niri.provides.shell.homeManager = 
{ lib, config, ... }:
let
  cfg = config.my.desktops._.niri.home;
in
{
    config = lib.mkIf (cfg.enable && cfg.shell.enable && cfg.shell.package != null) {
      home.packages = [ cfg.shell.package ];
    };
  };
}
