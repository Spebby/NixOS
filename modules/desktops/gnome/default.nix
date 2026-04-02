{ my, ... }:
{
  my.desktops._.gnome = {
    includes = [
      my.desktops._.base
      my.desktops._.gnome._.home
      my.desktops._.gnome._.dconf
    ];

    nixos =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        cfg = config.my.desktops._.gnome;
      in
      {
        options.my.desktops._.gnome = {
          usePowerProfile = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable GNOME power-profiles-daemon integration.";
          };

          excludePackages = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = with pkgs; [
              gedit
              epiphany
              geary
              totem
              gnome-connections
              gnome-contacts
              gnome-music
              gnome-weather
            ];
            description = "GNOME packages to exclude from the default desktop install.";
          };
        };

        config = {
          environment.gnome.excludePackages = cfg.excludePackages;

          services = {
            desktopManager.gnome = {
              enable = true;
              extraGSettingsOverrides = ''
                [org.gnome.mutter]
                experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
              '';
            };

            udev.packages = [ pkgs.gnome-settings-daemon ];

            pulseaudio.enable = false;
            pipewire = {
              enable = true;
              alsa = {
                enable = true;
                support32Bit = true;
              };
              pulse.enable = true;
            };

            power-profiles-daemon.enable = cfg.usePowerProfile;
          };

          security.rtkit.enable = true;
        };
      };

    homeManager =
      { lib, config, ... }:
      {
        options.my.desktops._.gnome.home = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable Home Manager GNOME desktop configuration bundle.";
          };

          dconf = {
            managed = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Apply the managed Nix dconf settings for GNOME.";
              };
            };

            extraSettings = lib.mkOption {
              type = lib.types.attrs;
              default = { };
              description = "Extra dconf settings merged on top of the managed GNOME baseline.";
            };

            imports = lib.mkOption {
              type = lib.types.attrsOf lib.types.path;
              default = { };
              description = "Native dconf dump files to import, keyed by dconf path prefix (e.g. /org/gnome/).";
            };
          };
        };
      };
  };
}
