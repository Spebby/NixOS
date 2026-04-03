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
          scheduler = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable the system76-scheduler for COSMIC's process priority tuning.";
            };
          };

          wayland = {
            ozoneWl = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Set NIXOS_OZONE_WL=1 so Electron/CEF apps use the Wayland backend.";
            };
            dataControlEnabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Set COSMIC_DATA_CONTROL_ENABLED=1 to enable wlr-data-control clipboard support.";
            };
            extraVariables = lib.mkOption {
              type = lib.types.attrsOf lib.types.str;
              default = { };
              description = "Additional environment variables set alongside the Wayland ones.";
              example = lib.literalExpression ''
                {
                  WLR_NO_HARDWARE_CURSORS = "1";
                  LIBVA_DRIVER_NAME = "radeonsi";
                }
              '';
            };
          };

          geoclue = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable geoclue2 for location-aware apps (e.g. automatic night-light).";
            };
            enableDemoAgent = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable the geoclue2 demo agent (not needed on most systems).";
            };
          };

          xdg = {
            usePortalForOpen = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Route xdg-open through the portal rather than directly calling handlers.";
            };
          };

          packages = {
            excludeCosmicPackages = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
              description = "Packages from the default COSMIC install to exclude.";
              example = lib.literalExpression "[ pkgs.cosmic-edit ]";
            };
            enableExtensions = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Install the curated set of COSMIC extension applets and tools.";
            };
            enableMedia = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Install cosmic-player and pwvucontrol audio tooling.";
            };
            enableBluetooth = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Install overskride Bluetooth manager.";
            };
            enableFileTools = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Install file-roller archive manager and gnome-disk-utility.";
            };
            extraPackages = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
              description = "Extra packages added on top of the COSMIC set.";
            };
          };
        };

        config = {
          xdg.portal.xdgOpenUsePortal = cfg.xdg.usePortalForOpen;

          services = {
            desktopManager.cosmic.enable = true;

            system76-scheduler = lib.mkIf cfg.scheduler.enable { enable = true; };

            geoclue2 = lib.mkIf cfg.geoclue.enable {
              enable = true;
              inherit (cfg.geoclue) enableDemoAgent;
            };
          };

          environment = {
            variables =
              lib.optionalAttrs cfg.wayland.ozoneWl { NIXOS_OZONE_WL = "1"; }
              // lib.optionalAttrs cfg.wayland.dataControlEnabled { COSMIC_DATA_CONTROL_ENABLED = "1"; }
              // cfg.wayland.extraVariables;

            cosmic.excludePackages = cfg.packages.excludeCosmicPackages;

            systemPackages =
              with pkgs;
              lib.optionals cfg.packages.enableExtensions [
                cosmic-ext-ctl
                cosmic-ext-calculator
                cosmic-ext-tweaks
                cosmic-ext-applet-weather
                cosmic-ext-applet-caffeine
                cosmic-ext-applet-external-monitor-brightness
                cosmic-ext-applet-minimon
                cosmic-ext-applet-privacy-indicator
                cosmic-ext-applet-sysinfo
                examine
                forecast
                oboete
                quick-webapps
                tasks
              ]
              ++ lib.optionals cfg.packages.enableMedia [
                cosmic-player
                pwvucontrol
              ]
              ++ lib.optionals cfg.packages.enableBluetooth [ overskride ]
              ++ lib.optionals cfg.packages.enableFileTools [
                gnome-disk-utility
                file-roller
              ]
              ++ cfg.packages.extraPackages;
          };
        };
      };

    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        cfg = config.my.desktops._.cosmic.home;
      in
      {
        options.my.desktops._.cosmic.home = {
          icons = {
            useCosmic = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Force the GTK icon theme to COSMIC icons.";
            };
            name = lib.mkOption {
              type = lib.types.str;
              default = "Cosmic";
              description = "GTK icon theme name (only used when useCosmic is true).";
            };
          };

          cursor = {
            name = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "GTK/Wayland cursor theme name. Null leaves the default.";
              example = "Bibata-Modern-Classic";
            };
            package = lib.mkOption {
              type = lib.types.nullOr lib.types.package;
              default = null;
              description = "Package providing the cursor theme.";
              example = lib.literalExpression "pkgs.bibata-cursors";
            };
            size = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
              description = "Cursor size in pixels. Null leaves the default.";
              example = 24;
            };
          };

          fonts = {
            interface = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "GTK interface font name (e.g. \"Inter 11\"). Null leaves the default.";
            };
            monospace = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "GTK monospace font name. Null leaves the default.";
            };
          };

          qt = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable Qt theming to follow the GTK/COSMIC style.";
            };
            style = lib.mkOption {
              type = lib.types.str;
              default = "kvantum";
              description = "Qt platform theme style name passed to qt6ct.";
            };
          };

          dconf = {
            extraSettings = lib.mkOption {
              type = lib.types.attrs;
              default = { };
              description = ''
                Extra dconf key/value pairs merged into <option>dconf.settings</option>.
                Useful for GNOME-compatible settings consumed by COSMIC (e.g. night-light,
                accessibility, font hinting).
              '';
              example = lib.literalExpression ''
                {
                  "org/gnome/desktop/interface" = {
                    color-scheme = "prefer-dark";
                    font-antialiasing = "rgba";
                  };
                }
              '';
            };
          };

        };

        config = {
          gtk = {
            iconTheme = lib.mkIf cfg.icons.useCosmic {
              name = lib.mkForce cfg.icons.name;
              package = lib.mkForce pkgs.cosmic-icons;
            };

            cursorTheme = lib.mkIf (cfg.cursor.name != null) (
              lib.filterAttrs (_: v: v != null) { inherit (cfg.cursor) name package size; }
            );

            font = lib.mkIf (cfg.fonts.interface != null) { name = lib.mkForce cfg.fonts.interface; };
          };

          qt = lib.mkIf cfg.qt.enable {
            enable = true;
            platformTheme.name = cfg.qt.style;
          };

          dconf.settings = cfg.dconf.extraSettings;
        };
      };
  };
}
