{
  inputs,
  lib,
  my,
  config,
  ...
}:
{
  my.desktops._.niri = {
    includes = [
      my.desktops._.base
      my.desktops._.niri._.shell
    ];

    nixos =
      { lib, config, ... }:
      let
        niriCfg = config.my.desktops._.niri;
      in
      {
        options.my.desktops._.niri = {
          package = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = null;
            description = "Optional Niri package override.";
          };
        };

        config = {
          programs.niri.enable = true;
          programs.niri.package = lib.mkIf (niriCfg.package != null) niriCfg.package;
        };
      };

    homeManager =
      { lib, config, ... }:
      let
        cfg = config.my.desktops._.niri.home;
      in
      {
        options.my.desktops._.niri.home = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable Home Manager Niri desktop configuration bundle.";
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
        };

        config = lib.mkIf (cfg.enable && cfg.shell.enable) {
          assertions = [
            {
              assertion = !(cfg.components.waybar.enable or false);
              message = "Set my.desktops._.niri.home.components.waybar.enable = false when shell.enable = true, or set it to null for automatic behavior.";
            }
            {
              assertion = !(cfg.components.wofi.enable or false);
              message = "Set my.desktops._.niri.home.components.wofi.enable = false when shell.enable = true, or set it to null for automatic behavior.";
            }
            {
              assertion = !(cfg.components.swaync.enable or false);
              message = "Set my.desktops._.niri.home.components.swaync.enable = false when shell.enable = true, or set it to null for automatic behavior.";
            }
          ];
        };
      };
  };

  perSystem =
    { pkgs, self', ... }:
    let
      noctaliaExe = lib.getExe self'.packages.myNoctalia;
    in
    {
      packages = lib.optionalAttrs pkgs.stdenv.isLinux {
        myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
          inherit pkgs;
          settings = {
            spawn-at-startup = [ noctaliaExe ];
            xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
            input.keyboard.xkb.layout = "us";
            layout.gaps = 5;
            binds = {
              #"Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
              "Mod+Return".spawn = config.terminals.default or "kitty";

              "Mod+Q".close-window = { };
              "Mod+F".maximize-column = { };
              "Mod+G".fullscreen-window = { };
              "Mod+Shift+F".toggle-window-floating = { };
              "Mod+C".center-column = { };

              "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
              "Mod+V".spawn-sh = "${pkgs.alsa-utils}/bin/amixer sset Capture toggle";

              "Mod+1".focus-workspace = "w0";
              "Mod+2".focus-workspace = "w1";
              "Mod+3".focus-workspace = "w2";
              "Mod+4".focus-workspace = "w3";
              "Mod+5".focus-workspace = "w4";
              "Mod+6".focus-workspace = "w5";
              "Mod+7".focus-workspace = "w6";
              "Mod+8".focus-workspace = "w7";
              "Mod+9".focus-workspace = "w8";
              "Mod+0".focus-workspace = "w9";

              "Mod+Shift+1".move-column-to-workspace = "w0";
              "Mod+Shift+2".move-column-to-workspace = "w1";
              "Mod+Shift+3".move-column-to-workspace = "w2";
              "Mod+Shift+4".move-column-to-workspace = "w3";
              "Mod+Shift+5".move-column-to-workspace = "w4";
              "Mod+Shift+6".move-column-to-workspace = "w5";
              "Mod+Shift+7".move-column-to-workspace = "w6";
              "Mod+Shift+8".move-column-to-workspace = "w7";
              "Mod+Shift+9".move-column-to-workspace = "w8";
              "Mod+Shift+0".move-column-to-workspace = "w9";

              "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
              "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";

              "Mod+Ctrl+H".set-column-width = "-5%";
              "Mod+Ctrl+L".set-column-width = "+5%";
              "Mod+Ctrl+J".set-window-height = "-5%";
              "Mod+Ctrl+K".set-window-height = "+5%";

              "Mod+WheelScrollDown".focus-column-left = { };
              "Mod+WheelScrollUp".focus-column-right = { };
              "Mod+Ctrl+WheelScrollDown".focus-workspace-down = { };
              "Mod+Ctrl+WheelScrollUp".focus-workspace-up = { };

              "Mod+Ctrl+S".spawn-sh = "${lib.getExe pkgs.grim} -l 0 - | ${pkgs.wl-clipboard}/bin/wl-copy";

              "Mod+Shift+E".spawn-sh = "${pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe pkgs.swappy} -f -";

              "Mod+Shift+S".spawn-sh = lib.getExe (
                pkgs.writeShellApplication {
                  name = "screenshot";
                  text = ''
                    ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp} -w 0)" - \
                    | ${pkgs.wl-clipboard}/bin/wl-copy
                  '';
                }
              );

              "Mod+d".spawn-sh = ''
                case "$(${lib.getExe pkgs.wofi} --dmenu --prompt 'Launch' <<'EOF'
                bluetooth
                wifi
                firefox
                discord
                cider
                pavucontrol
                EOF
                )" in
                  bluetooth) ${noctaliaExe} ipc call bluetooth togglePanel ;;
                  wifi) ${noctaliaExe} ipc call wifi togglePanel ;;
                  firefox) firefox ;;
                  discord) vesktop ;;
                  cider) cider-2 ;;
                  pavucontrol) ${lib.getExe pkgs.pavucontrol} ;;
                esac
              '';
            };
          };
        };
      };
    };
}
