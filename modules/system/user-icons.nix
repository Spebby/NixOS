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
  my.userIcons.nixos = {
    options.my.userIcons = mkOption {
      type = types.attrsOf (types.nullOr types.path);
      default = { };
      description = "Map of username to AccountsService icon path.";
    };

    config =
      let
        iconUsers = filterAttrs (_: u: (u.icon or null) != null) config.my.userIcons;
      in
      mkIf (iconUsers != { }) {
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
