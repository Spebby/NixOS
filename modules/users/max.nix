{ den, __findFile, ... }:
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
      (den.provides.user-shell "zsh")
    ];

    nixos =
      { pkgs, ... }:
      {
        programs.zsh.enable = true;

        users.users.max = {
          isNormalUser = true;
          home = "/home/max";
          shell = pkgs.zsh;

          extraGroups = [
            "home-manager"
            "gamemode"
            "docker"
          ];
        };
        my.userIcons.max = ../../assets/icons/max.png;
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
        };
      };
  };
}
