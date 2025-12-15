{ config, lib, ... }:

let
  cfg = config.cosmic;
in
{
  options.cosmic = {
    enable = lib.mkEnableOption "Enable COSMIC Desktop Environment";
    useCosmicGreeter = lib.mkEnableOption "Enable the COSMIC Greeter";
    use76Schedular = lib.mkEnableOption "Enable COSMIC's custom scheduler";
  };

  config = lib.mkIf cfg.enable {
    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        COSMIC_DATA_CONTROL_ENABLED = 1;
      };
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
  };
}
