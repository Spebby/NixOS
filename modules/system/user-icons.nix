{
  my.userIcons.nixos =
    { lib, config, ... }:
    let
      userOptions = with lib; {
        options.icon = mkOption {
          type = types.nullOr types.path;
          default = null;
        };
      };

      # list of user entries which define icons
      userList =
        with lib;
        filter (entry: entry.icon != null) (
          mapAttrsToList (name: value: {
            inherit name;
            inherit (value) icon;
          }) config.users.users
        );

      createIconLink = entry: "ln -sfn '${entry.icon}' /var/lib/AccountsService/icons/${entry.name}\n";

      makeFacesCommands = map createIconLink userList;
    in
    {
      options.users.users = with lib; with types; mkOption { type = attrsOf (submodule userOptions); };

      config = {
        services.accounts-daemon.enable = lib.mkDefault (makeFacesCommands != [ ]);
        system.activationScripts.makeFacesDir = with lib; strings.concatStrings makeFacesCommands;
      };
    };
}
