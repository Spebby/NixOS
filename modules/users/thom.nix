{
  den.aspects.thom = {
    includes = [
      <dev/primary-user>
      <my/apps/git>
      <my/apps/stylix>
      <my/shell>
    ];

    nixos = {
      users.users.thom = {
        isNormalUser = true;
        home = "/home/thom";
        icon = ../../assets/icons/thom.png;

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
          userName = "Thom";
          userEmail = "thommott@proton.me";
          lazygit.enable = true;
        };

        home = {
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

          sessionVariables = rec {
            XDG_BOOKS_DIR = "$HOME/Media/Books";
          };
        };
      };

    # defining this will create a entry for this user for this host.
    den.hosts.x86_64-linux.rosso.users.thom = { };
  };
}
