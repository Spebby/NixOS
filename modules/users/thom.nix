{
  den.aspects.thom = {
    includes = [
      <dev/primary-user>
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
      {
        inputs,
        config,
        lib,
        pkgs,
        ...
      }:
      let
        allowedSigners = "${builtins.getEnv "HOME"}/.ssh/allowed_signers";
      in
      {
        home = {
          file = {
            # GPG Signing for Git
            "${allowedSigners}".text =
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
            TERMINAL = lib.mkDefault (config.terminals.default or "kitty");
          };

          stylix = lib.mkForce {
            polarity = "dark";
            base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

            image = pkgs.fetchurl {
              url = "https://codeberg.org/lunik1/nixos-logo-gruvbox-wallpaper/raw/branch/master/png/gruvbox-dark-rainbow.png";
              sha256 = "036gqhbf6s5ddgvfbgn6iqbzgizssyf7820m5815b2gd748jw8zc";
            };
            imageScalingMode = "fill";
          };
        };

        programs = {
          git = {
            settings = {
              user = {
                name = "Thom Mott";
                email = "thommott@proton.me";
              };
              gpg.ssh.allowedSignersFile = allowedSigners;
              init.defaultBranch = "main";
              push.autoSetupRemote = true;
            };
            signing = {
              key = "~/.ssh/NixOS.pub";
              signByDefault = true;
            };
          };
          difftastic.enable = true;
          gpg.enable = true; # TODO: move these into git module.
        };

        services.gpg-agent = {
          enable = true;
          enableSshSupport = true;
          pinetry.package = pkgs.pinetry-gtk2; # Hyprland quirk
        };
      };

    # defining this will create a entry for this user for this host.
    den.hosts.x86_64-linux.rosso.users.thom = { };
  };
}
