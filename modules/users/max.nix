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
      <my/profiles/desktop-utils>
      <my/profiles/gaming/all>

      <my/apps/creative/core>
      <my/apps/media/core>
      <my/apps/cli/utility>

      <my/apps/productivity/core>
      <my/apps/editors/vscode>
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
      { pkgs, ... }:
      {
        my.apps._ = {
          git = {
            userName = "Max Brockmann";
            userEmail = "max.marika.brock@gmail.com";
            lazygit.enable = true;
          };

          productivity.core = {
            includeMail = false;
            extraPackages = with pkgs; [ google-chrome ];
          };

          math = {
            geogebra.enable = true;
          };

          creative.core = {
            includeAudio = false;
            includeVideo = false;
          };

          dev._.tooling = {
            includeBuildDocs = false;
            includeAiTools.enable = false;
          };

          editors._.zed = {
            settings = {
              ai = false;
              vim_mode = false;
            };
          };

          media.core = {
            includeMusicClients = true;
          };

          shell.tui = {
            yazi.enable = true;
            zathura.enable = true;
          };
        };
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
