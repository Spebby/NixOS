{ __findFile, ... }:
{
  den.aspects.thom = {
    includes = [
      <den/primary-user>
      <my/profiles/common-use>
      <my/profiles/dev/all>
      <my/profiles/art/modelling>
      <my/profiles/theming>
      <my/profiles/desktop-utils>
      <my/profiles/gaming/all>
      <my/profiles/fun>

      <my/apps/creative/core>
      <my/apps/media/core>
      <my/apps/cli/utility>

      <my/apps/productivity/core>
      <my/apps/productivity/writing>
    ];

    nixos = {
      users.users.thom = {
        isNormalUser = true;
        home = "/home/thom";

        extraGroups = [
          "home-manager"
          "gamemode"
          "docker"
        ];
      };

      my.userIcons.thom = ../../assets/icons/thom.png;
    };

    homeManager =
      { lib, config, ... }:
      {
        my.apps._ = {
          git = {
            userName = "Thom";
            userEmail = "thommott@proton.me";
            lazygit.enable = true;
          };

          productivity.core = {
            includeCoreTools = true;
          };

          creative.core = {
            includeAudio = true;
            includeVideo = true;
          };

          dev._.tooling = {
            includeBuildDocs = true;
            includeAiTools.enable = true;
          };

          editors._.zed = {
            settings = {
              ai = false;
              vim_mode = true;
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

        home = {
          sessionVariables = {
            TERMINAL = "kitty";
            EDITOR = lib.mkForce "nvim";
          };
          file = {
            # GPG Signing for Git
            "${config.home.homeDirectory}/.ssh/allowed_signers".text =
              "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJHJvth1usDlafKm6M61C8nTy+YgVe7uizcFmqXqp3A thommott@proton.me";

            # Distrobox Config
            ".config/distrobox/distrobox.conf".text = ''
              # List of environment variables to pass from host to container
              container_envvars="DISPLAY WAYLAND_DISPLAY XAUTHORITY"

              # Optional: Also pass these common GUI variables
              container_envvars+=" QT_QPA_PLATFORM GDK_BACKEND CLUTTER_BACKEND"

              # If using Flatpak or other special cases
              container_envvars+=" DBUS_SESSION_BUS_ADDRESS"
            '';
          };
        };
      };
  };

}
