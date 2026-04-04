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
  mkAccountServiceLink = name: u: ''
    ln -sfn ${lib.escapeShellArg (toString u.icon)} /var/lib/AccountsService/icons/${name}
  '';
  mkFaceLink =
    name: u:
    let
      homeDir = u.home or "/home/${name}";
    in
    ''
      if [ -d ${lib.escapeShellArg homeDir} ]; then
        ln -sfn ${lib.escapeShellArg (toString u.icon)} ${lib.escapeShellArg "${homeDir}/.face"}
      fi
    '';
in
{
  my.user-icons.nixos = {
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
          ${concatStringsSep "\n" (mapAttrsToList mkAccountServiceLink iconUsers)}
          ${concatStringsSep "\n" (mapAttrsToList mkFaceLink iconUsers)}
        '';
      };
    };
  };
}
