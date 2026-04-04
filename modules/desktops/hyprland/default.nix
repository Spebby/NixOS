{
  inputs,
  lib,
  my,
  ...
}:
{
  my.desktops._.hyprland = {
    includes = [
      my.desktops._.base
      my.desktops._.hyprland._.hypr
      my.desktops._.hyprland._.waybar
      my.desktops._.hyprland._.wofi
      my.desktops._.hyprland._.swaync
      my.desktops._.hyprland._.shell
    ];

    nixos =
      { lib, config, ... }:
      let
        cfg = config.my.desktops._.hyprland;
      in
      {
        options.my.desktops._.hyprland = {
          withUWSM = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable UWSM integration for Hyprland sessions.";
          };
        };

        config = {
          programs.hyprland = {
            enable = true;
            inherit (cfg) withUWSM;
          };

          services = {
            pulseaudio.enable = false;
            pipewire = {
              enable = true;
              alsa = {
                enable = true;
                support32Bit = true;
              };
              pulse.enable = true;
            };
          };

          security = {
            pam.services.hyprlock = { };
            rtkit.enable = true;
          };
        };
      };

    homeManager =
      { lib, config, ... }:
      let
        cfg = config.my.desktops._.hyprland.home;
      in
      {
        options.my.desktops._.hyprland.home = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable Home Manager Hyprland desktop configuration bundle.";
          };

          shell = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Use an external shell bundle (e.g. Noctalia) instead of DIY bar/launcher/notifier defaults.";
            };

            package = lib.mkOption {
              type = lib.types.nullOr lib.types.package;
              default = null;
              description = "Optional shell package to install when shell.enable is true.";
            };
          };

          components = {
            hypr.enable = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = null;
              description = "Enable the Hyprland HM configuration module. Null means enabled.";
            };

            waybar.enable = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = null;
              description = "Enable Waybar. Null means enabled unless shell.enable is true.";
            };

            wofi.enable = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = null;
              description = "Enable Wofi launcher config. Null means enabled unless shell.enable is true.";
            };

            swaync.enable = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = null;
              description = "Enable swaync notifications config. Null means enabled unless shell.enable is true.";
            };
          };

          mainMonitor = lib.mkOption {
            type = lib.types.str;
            default = "eDP-1";
            description = "Primary monitor identifier.";
          };

          mainMod = lib.mkOption {
            type = lib.types.str;
            default = "SUPER";
          };

          monitorResolution = lib.mkOption {
            type = lib.types.str;
            default = "2560x1600@165";
            description = "Resolution and refresh rate for the main monitor.";
          };

          monitorScale = lib.mkOption {
            type = lib.types.str;
            default = "1.6";
          };

          terminal = lib.mkOption {
            type = lib.types.str;
            default = "kitty";
            description = "Default terminal emulator.";
          };

          fileManager = lib.mkOption {
            type = lib.types.str;
            default = "thunar";
            description = "Default file manager.";
          };

          menu = lib.mkOption {
            type = lib.types.str;
            default = "wofi";
            description = "Launcher/menu program.";
          };

          env = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "NIXOS_OZONE_WL, 1"
              "OZONE_PLATFORM, wayland"
              "ELECTRON_OZONE_PLATFORM_HINT, wayland"
              "XDG_CURRENT_DESKTOP, Hyprland"
              "XDG_SESSION_DESKTOP, Hyprland"
              "XDG_SESSION_TYPE, wayland"
              "XDG_SCREENSHOTS_DIR, $HOME/Media/screenshots"
              "XDG_PICTURES_DIR, $HOME/Media/screenshots/"
              "XDG_VIDEOS_DIR, $HOME/Media/Videos/"
              "SCREENSHOT_APP, grimblast --notify --freeze copysave"
              "QT_QPA_PLATFORM, wayland"
              "GDK_SCALE, 1.6"
              "GBM_BACKEND, nvidia-drm"
              "__GLX_VENDOR_LIBRARY_NAME, nvidia"
              "AQ_DRM_DEVICES, /dev/dri/card1:/dev/dri/card0"
              "LIBVA_DRIVER_NAME,nvidia"
              "__GL_GSYNC_ALLOWED, 1"
              "__GL_VRR_ALLOWED, 0"
            ];
            description = "Extra environment variables for Hyprland sessions.";
          };

          theme = lib.mkOption {
            type = lib.types.anything;
            default = with my.desktops._.hyprland._.themes._; default;
            description = "Hyprland theme/settings generator function.";
          };

          useWrapper = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Build and use a wrapped Hyprland package from the selected theme.";
          };

          package = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = null;
            description = "Optional Hyprland package override. Takes precedence over useWrapper when set.";
          };
        };

        config = lib.mkIf (cfg.enable && cfg.shell.enable) {
          assertions = [
            {
              assertion = !(cfg.components.waybar.enable or false);
              message = "Set my.desktops._.hyprland.home.components.waybar.enable = false when shell.enable = true, or set it to null for automatic behavior.";
            }
            {
              assertion = !(cfg.components.wofi.enable or false);
              message = "Set my.desktops._.hyprland.home.components.wofi.enable = false when shell.enable = true, or set it to null for automatic behavior.";
            }
            {
              assertion = !(cfg.components.swaync.enable or false);
              message = "Set my.desktops._.hyprland.home.components.swaync.enable = false when shell.enable = true, or set it to null for automatic behavior.";
            }
          ];
        };
      };
  };

  perSystem =
    { lib, pkgs, ... }:
    {
      packages = lib.optionalAttrs pkgs.stdenv.isLinux { myHyprland = pkgs.hyprland; };
    };
}
