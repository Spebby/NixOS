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
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [ firefox ];
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
    };

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    services = {
      displayManager = {
        displayManager.gdm = {
          settings = {
            greeter.IncludeAll = true;
          };
        };
        desktopManager = {
          gnome.enable = true;
        };
      };
      udev.packages = [ pkgs.gnome-settings-daemon ];

      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
      };
      pulse.enable = true;
    };

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    security.rtkit.enable = true;
  };
}
