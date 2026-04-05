{
  my,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktops._.gnome.home;
  mkDconfLoadCmd = path: file: ''
    dconf load ${lib.escapeShellArg path} < ${lib.escapeShellArg (toString file)}
  '';
in
{
  my.desktops._.gnome.provides.home = {
    includes = [ my.desktops._.gnome._.dconf ];

    homeManager = lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        gnome-tweaks

        gnomeExtensions.app-menu-is-back
        gnomeExtensions.appindicator
        gnomeExtensions.blur-my-shell
        gnomeExtensions.clipboard-indicator
        gnomeExtensions.compact-top-bar
        gnomeExtensions.hibernate-status-button
        gnomeExtensions.media-controls
        gnomeExtensions.vitals
        gnomeExtensions.xwayland-indicator
      ];

      home.activation.importGnomeDconf = lib.hm.dag.entryAfter [ "writeBoundary" ] (
        lib.concatStringsSep "\n" (lib.mapAttrsToList mkDconfLoadCmd cfg.dconf.imports)
      );
    };
  };
}
