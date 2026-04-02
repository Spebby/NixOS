{ __findFile, ... }:
{
  den.aspects.max = {
    includes = [
      <den/primary-user>
      <my/profiles/dev-tools>
      <my/apps/stylix>
    ];

    nixos = {
      users.users.thom = {
        isNormalUser = true;
        home = "/home/max";
        icon = ../../assets/icons/max.png;

        extraGroups = [
          "wheel"
          "networkmanager"
          "home-manager"
          "gamemode"
          "docker"
        ];
      };
    };

    homeManager =
      { config, ... }:
      {
        my.apps._.git = {
          userName = "Max Brockmann";
          userEmail = "max.marika.brock@gmail.com";
          lazygit.enable = true;
        };
      };

    # defining this will create a entry for this user for this host.
    den.hosts.x86_64-linux.tink.users.max = { };
  };
}
