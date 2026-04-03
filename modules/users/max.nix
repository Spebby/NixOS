{ __findFile, ... }:
{
  den.aspects.max = {
    includes = [
      <den/primary-user>
      <my/profiles/common-use>
      <my/profiles/dev/all>
      <my/profiles/art/all>
      <my/profiles/math>
      <my/profiles/theming>
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
