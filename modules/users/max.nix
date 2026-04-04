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

          productivity.core = {
            includeBrowser = true;
            includeMail = false;
          };

          math = {
            geogebra.enable = true;
          };
        };

        creative.core = {
          enable = true;
          includeAudio = false;
          includeVideo = false;
        };

        dev._.tooling = {
          includeBuildDocs = false;
          includeAiTools.enable = false;
        };

        emulators.enable = true;
        steam.enable = true;
      };

    # defining this will create a entry for this user for this host.
    den.hosts.x86_64-linux.tink.users.max = { };

  };

  # standalone Home Manager entry for faster user-only switches
  den.homes.x86_64-linux."max@tink" = {
    userName = "max";
    aspect = "max";
  };
}
