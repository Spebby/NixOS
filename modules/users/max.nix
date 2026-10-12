{ __findFile, ... }: {
  den.aspects.max = {
    includes = [
      <den/primary-user>
      <my/apps/profiles/common-use>
      <my/apps/profiles/dev/all>
      <my/apps/profiles/art/all>
      <my/apps/profiles/math>
      <my/apps/profiles/theming>
      <my/apps/profiles/desktop-utils>
      <my/apps/profiles/gaming/all>

      <my/apps/creative/core>
      <my/apps/media/core>
      <my/apps/cli/utility>

      <my/apps/productivity/core>
      <my/apps/editors/vscode>
    ];

    nixos = { pkgs, ... }: {
      programs.zsh.enable = true;

      users.users.max = {
        isNormalUser = true;
        home = "/home/max";
        icon = ../../assets/icons/max.png;
        shell = pkgs.zsh;
      };
    };

    homeManager = { pkgs, ... }: {
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
