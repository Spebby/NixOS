# /home-manager/modules/hyprland/swaync/default.nix
{ config, ... }:

let
  # fixme: NOT PLATFORM AGNOSTIC
  BACKLIGHT_DEVICE = "amdgpu_bl1";

  scIcon = "";
  ssIcon = "";
in
{
  services.swaync = {
    enable = true;
    style = ./style.css;

    # https://man.archlinux.org/man/swaync.5.en
    settings = {
      positionX = "right";
      positionY = "top";

      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 10;
      control-center-radius = 1;
      control-center-width = 350;
      fit-to-screen = true;

      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      notification-window-width = 350;

      keyboard-shortcuts = true;
      transition-time = 200;

      timeout = 10;
      timeout-low = 5;
      timeout-critical = 5;

      hide-on-clear = false;
      hide-on-action = true;
      scripts-fail-notify = true;

      layer-shell = true;
      layer = "overlay";
      control-center-layer = "overlay";
      cssPriority = "user";

      widgets = [
        "title"
        "menubar"
        "dnd"
        "notifications"
        "inhibitors"
        "mpris"
        "volume"
        "backlight"
        "buttons-grid"
      ];
      widget-config = {
        title = {
          text = "󰂚  :: Notifications";
          clear-all-button = true;
          button-text = "󰎟 ";
        };
        dnd = {
          text = "󰂛  Do Not Disturb";
        };
        label = {
          max-lines = 1;
          text = "Notification Center";
        };
        mpris = {
          image-size = 96;
          blur = true;
        };
        volume = {
          label = "󰕾 ";
        };
        menubar = {
          "menu#power-buttons" = {
            label = "";
            position = "right";
            actions = [
              {
                label = "   Reboot";
                command = "systemctl reboot";
              }
              {
                label = "   Lock";
                command = "hyprlock";
              }
              {
                label = "   Logout";
                command = "loginctl terminate-session \$XDG_SESSION_ID";
              }
              {
                label = "   Shut down";
                command = "systemctl poweroff";
              }
            ];
          };
          "menu#powermode-buttons" = {
            label = "";
            position = "right";
            actions = [
              {
                label = "  Performance";
                command = "powerprofilesctl set performance";
              }
              {
                label = "  Balanced";
                command = "powerprofilesctl set balanced";
              }
              {
                label = "󰡳  Power-saver";
                command = "powerprofilesctl set power-saver";
              }
            ];
          };
          "menu#screenshot-buttons" = {
            label = "${ssIcon}";
            position = "left";
            actions = [
              {
                label = "${ssIcon}   Entire screen";
                command = "swaync-client -cp && sleep 1 && hyprshot -m output";
              }
              {
                label = "${ssIcon}   Select a region";
                command = "swaync-client -cp && sleep 1 && $SCREENSHOT_APP area";
              }
              {
                label = "${ssIcon}   Open screenshot menu";
                command = "swaync-client -cp && rofi-screenshot";
              }
              {
                label = "${ssIcon}   Open screenshot folder";
                command = "exo-open $HYPRSHOT_DIR";
              }
            ];
          };
          "menu#screencast-buttons" = {
            label = "${scIcon}";
            position = "left";
            actions = [
              {
                label = "${scIcon}   Entire screen";
                command = "swaync-client -cp && sleep 1 && recording.sh toggle fullscreen";
              }
              {
                label = "${scIcon}   Select a region";
                command = "swaync-client -cp && sleep 1 && recording.sh toggle region";
              }
              {
                label = "${scIcon}   Stop";
                command = "swaync-client -cp && recording.sh stop";
              }
              {
                label = "${scIcon}   Open screencast folder";
                command = "$XDG_VIDEOS_DIR/Screencasts";
              }
            ];
          };
        };
        backlight = {
          label = "󰃟 ";
          subsystem = "backlight";
          device = "${BACKLIGHT_DEVICE}";
        };
        buttons-grid = {
          actions = [
            {
              # You can simplify command w/ `rfkill toggle all`
              # But this doesn't mimic Airplane Mode's behaviour.
              label = "󰀝";
              type = "toggle";
              command = "sh -c '[[ $SWAYNC_TOGGLE_STATE != true ]] && rfkill unblock all || rfkill block all'";
              update-command = "sh -c '[[ $(nmcli radio wifi) != \"enabled\" ]] && echo true || echo false'";
            }
            {
              label = "󰔏";
              command = "hyprshade toggle redshift";
            }
            {
              label = "󰌵";
              command = "hyprshade toggle dim";
            }
            {
              label = "󰊠";
              command = "hyprshade toggle grayscale";
            }
            {
              label = "󰏘";
              command = "hyprshade toggle vibrance";
            }
            #{
            #  label = "󰌁";
            #  command = "hyprshade toggle invert";
            #}
          ];
        };
      };
    };
  };

  home.file.".config/swaync/colours.css".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/stylix/colours.css";
}
