# min user intended for testing
{ den, __findFile, ... }:
{
  den.aspects.dummy = {
    includes = [
      <den/primary-user>
      <my/profiles/common-use>
      <my/profiles/desktop-utils>
      <my/apps/cli/utility>
      <my/profiles/dev/tools>
    ];

    nixos = {
      users.users.dummy = {
        isNormalUser = true;
        home = "/home/dummy";
        extraGroups = [ "home-manager" ];
      };
    };

    homeManager = {
      my.apps._ = {
        git = {
          userName = "";
          userEmail = "";
        };
        shell.tui = {
          yazi.enable = true;
          zathura.enable = true;
        };
      };
    };
  };
}
