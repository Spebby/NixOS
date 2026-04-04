{ lib, ... }:
{
  my.services.provides.plex.nixos =
    { config, pkgs, ... }:
    let
      cfg = config.my.services.plex;
    in
    {
      options.my.services.plex = {
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.plex;
          description = "Plex Media Server package to run.";
        };

        dataDir = lib.mkOption {
          type = lib.types.str;
          default = "/var/lib/plex";
          description = "Plex Media Server data directory.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "plex";
          description = "User account running Plex Media Server.";
        };

        group = lib.mkOption {
          type = lib.types.str;
          default = "plex";
          description = "Group for Plex Media Server process and files.";
        };

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Open Plex service ports in the firewall.";
        };
      };

      config.services.plex = {
        enable = true;
        inherit (cfg)
          package
          dataDir
          user
          group
          openFirewall
          ;
      };
    };
}
