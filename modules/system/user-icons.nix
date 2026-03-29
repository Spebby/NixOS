{ lib, config, ... }:
let
  inherit (lib)
    mkOption
    types
    mapAttrsToList
    filterAttrs
    concatStringsSep
    mkIf
    ;
  iconUsers = filterAttrs (_: u: (u.icon or null) != null) config.users.users;
  mkLink = name: u: ''
    ln -sfn ${lib.escapeShellArg (toString u.icon)} /var/lib/AccountsService/icons/${name}
  '';
in
{
  options.users.users = mkOption {
    type = types.attrsOf (
      types.submodule {
        options.icon = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = "AccountsService icon for this user.";
        };
      }
    );
  };
  config = mkIf (iconUsers != { }) {
    services.accounts-daemon.enable = lib.mkDefault true;
    system.activationScripts.userIcons = {
      deps = [ "users" ];
      text = ''
        mkdir -p /var/lib/AccountsService/icons
        ${concatStringsSep "\n" (mapAttrsToList mkLink iconUsers)}
      '';
    };
  };
}
