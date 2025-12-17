{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.cosmic;
in
{
  options.cosmic = {
    enable = lib.mkEnableOption "Enable COSMIC Desktop Environment";
    useCosmicGreeter = lib.mkEnableOption "Enable the COSMIC Greeter";
    use76Schedular = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable COSMIC's custom scheduler";
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        COSMIC_DATA_CONTROL_ENABLED = 1;
      };

      cosmic.excludePackages = with pkgs; [
        cosmic-term
        cosmic-store
      ];

      systemPackages = with pkgs; [
        # Cosmic Extended
        cosmic-ext-ctl
        cosmic-ext-calculator
        cosmic-ext-tweaks
        cosmic-ext-applet-weather
        cosmic-ext-applet-caffeine # prevents screen from going asleep
        cosmic-ext-applet-external-monitor-brightness
        cosmic-ext-applet-minimon
        cosmic-ext-applet-privacy-indicator
        cosmic-ext-applet-sysinfo

        # misc from Cosmic Utils
        examine
        forecast
        oboete
        quick-webapps # webapp manager
        tasks
      ];
    };

    services = {
      desktopManager.cosmic.enable = true;
      displayManager.cosmic-greeter.enable = cfg.useCosmicGreeter;
      system76-scheduler.enable = cfg.use76Schedular;

      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };

      power-profiles-daemon.enable = false;
    };

    security.rtkit.enable = true;

    programs.firefox.preferences = {
      # disable libadwaita theming for Firefox
      "widget.gtk.libadwaita-colors.enabled" = false;
    };

    xdg.portal = {
      config.cosmic = {
        default = [
          "cosmic"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Screenshot" = [ "cosmic" ];
      };

      extraPortals = with pkgs; [
        xdg-desktop-portal-cosmic
        xdg-desktop-portal-gtk
      ];
    };
  };
}
