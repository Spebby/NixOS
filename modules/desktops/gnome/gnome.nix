{ my, ... }:
{
  my.desktops._.gnome = {
    includes = [ my.desktops._.base ];

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
  };
}
