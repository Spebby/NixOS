{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.gnome;
in
{
  options.gnome = {
    enable = lib.mkEnableOption "Enable GNOME Desktop Environment";
    usePowerProfile = lib.mkEnableOption "Enable GNOME's Power Profile Daemon";
  };

  config = lib.mkIf cfg.enable {
    environment = {
      gnome.excludePackages = with pkgs; [
        gedit # text editor
        epiphany # web browser
        geary # email reader
        #evince # document viewer
        totem # video player
        gnome-connections
        gnome-contacts
        # gnome-maps
        gnome-music
        gnome-weather
      ];

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };

    services = {
      #displayManager.gdm.enable = true; #for whatever reason, broken
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
}
