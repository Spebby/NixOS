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

      <my/apps/productivity/core>
    ];

    nixos = {
      users.users.max = {
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
        my.apps._ = {
          git = {
            userName = "Max Brockmann";
            userEmail = "max.marika.brock@gmail.com";
            lazygit.enable = true;
          };

          productivity._.core = {
            includeBrowser = true;
            includeMail = false;
          };

          math = {
            geogebra.enable = true;
          };
        };

        creative._.core = {
          includeAudio = false;
          icnludeVideo = false;
        };

        dev._.tooling = {
          includeNode = false;
          includeBuildDocs = false;
        };
      };

    # defining this will create a entry for this user for this host.
    den.hosts.x86_64-linux.tink.users.max = { };
  };
}
