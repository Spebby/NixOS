{ den, my, ... }:
{
  my.desktops._.cosmic = den.lib.parametric {
    includes = [ my.desktops._.base ];

    nixos =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      let
        cfg = config.my.desktops._.cosmic;
      in
      {
        options.my.desktops._.cosmic = {
          useCosmicGreeter = lib.mkEnableOption "Enable the COSMIC Greeter";
          use76Schedular = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable COSMIC's custom scheduler";
          };
        };

        config = {
          xdg.portal.xdgOpenUsePortal = true;
          services = {
            desktopManager.cosmic.enable = true;
            displayManager.cosmic-greeter.enable = cfg.useCosmicGreeter;
            system76-scheduler.enable = cfg.use76Schedular;

            geoclue2 = {
              enable = true;
              enableDemoAgent = false;
            };
          };

          environment = {
            variables = {
              NIXOS_OZONE_WL = "1";
              COSMIC_DATA_CONTROL_ENABLED = 1;
            };

            cosmic.excludePackages = [ ]; # insertConfigOption

            systemPackages = with pkgs; [
              # Cosmic Specific
              cosmic-ext-ctl
              cosmic-ext-calculator
              cosmic-ext-tweaks
              cosmic-ext-applet-weather
              cosmic-ext-applet-caffeine
              cosmic-ext-applet-external-monitor-brightness
              cosmic-ext-applet-minimon
              cosmic-ext-applet-privacy-indicator
              cosmic-ext-applet-sysinfo

              # Misc from COSMIC utils
              examine
              forecast
              oboete
              quick-webapps
              tasks

              # Other usefuls
              pwvucontrol
              overskride
              gnome-disk-utility
              file-roller
              cosmic-player
            ];
          };
        };
      };

    homeManager =
      { pkgs, lib, ... }:
      {
        gtk.iconTheme = {
          name = lib.mkForce "Cosmic";
          package = lib.mkForce pkgs.cosmic-icons;
        };
      };
  };
}
